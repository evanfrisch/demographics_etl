# demographics_etl.py
#######
# This class provides capabilities to extract, transform,
# and load data from student, staff, and school geographic
# data files that it downloads from the web.
######
import pandas as pd
import numpy as np
import os
import datetime
import urllib
import shutil
import logging
import pyodbc
import pypyodbc
import sqlalchemy as sa
import keyring
import yaml
import pprint as pp
import time

class DemographicsETL():
    def __init__(self,config_file_path,log_folder_name):
        """
        Initialize ETL process by preparing logging,
        reading in configuration file, and
        creating a data files folder, if it does not yet
        exist.
        """
        pd.options.mode.chained_assignment = None
        self.setup_logging(folder_name=log_folder_name)
        config_map = self.load_configuration(config_file_path)
        self.create_folder(folder_name=self.datafiles_folder)

    def load_configuration(self,file_path):
        """
        Load data from the configuration file from the specified path
        into instance variables.

        Keyword arguments:
        file_path - the path to the configuration file from
                    the current folder.
        """
        try:
            logging.info("Using configuration file {}".format(file_path))
            file = open(file_path)
            config_map = yaml.load(file)
            file.close()

            # Set instance variables with settings from configuration file.
            self.datafiles_folder = config_map['Data Folder Name']
            self.database_name = config_map['Database']['Name']
            self.database_driver = config_map['Database']['Driver']
            self.database_server = config_map['Database']['Server']
            self.database_username = config_map['Database']['Username']
            self.database_schema = config_map['Database']['Schema']
            self.student_demographics_url = config_map['Student Demographics URL']
            self.staff_demographics_url = config_map['Staff Demographics URL']
            self.school_geography_url = config_map['School Geography URL']
            self.source_staff_table = config_map['Source Staff Table Name']
            self.staging_student_table = config_map['Staging Student Table Name']
            self.staging_staff_table = config_map['Staging Staff Table Name']
            self.staging_school_geography_table = config_map['Staging School Geography Table Name']
            self.school_district_ids = config_map['School District IDs']
            self.n_less_than_10 = config_map['Replacement for n<10']
            self.more_than_95 = config_map['Replacement for >95%']
        except IOError:
            logging.error("Unable to read configuration from file. Exiting program.")
            exit(1)
        except KeyError as key:
            logging.error("Key missing from configuration from file: {}. Exiting program.".format(key))
            exit(1)
        except:
            logging.error("Unknown configuration file error. Exiting program.")
            exit(1)
        logging.info('Configuration has been loaded.')
        return config_map

    def setup_logging(self,folder_name):
        """
        Create a folder to store the log, if one does not yet exist,
        then initialize the logger for logging to both the console
        and the file in the log folder.

        Keyword arguments:
        folder_name - the name of the folder for storing the log file
        """
        # Create folder to store log file if folder does not exist already
        self.create_folder(folder_name)
        # Configure logger with more verbose format to write to log file
        log_file_path = folder_name+'/'+'demographics_etl.log'
        logging.basicConfig(level=logging.DEBUG,
                        format='%(asctime)s %(name)-12s %(levelname)-8s %(message)s',
                        datefmt='%m-%d-%Y %H:%M:%S',
                        filename=log_file_path,
                        filemode='w')
        # Create the logger
        console = logging.StreamHandler()
        # Write to console any messages that are info or higher priority
        console.setLevel(logging.INFO)
        # Specify simpler format to write to console
        formatter = logging.Formatter('%(levelname)-8s %(message)s')
        # Assign the format for console
        console.setFormatter(formatter)
        # Add the handler to the root logger
        logging.getLogger('').addHandler(console)
        # Start logging
        logging.info('Starting demographics_etl.py.')
        logging.info("Logging has been set up with log file located at {}.".format(log_file_path))

    def create_folder(self,folder_name):
        """
        Create the specified folder if it does not yet exists.

        Keyword arguments:
        folder_name - the name of the folder to create
        """
        # Create folder to store files if folder does not already exist
        os.makedirs(folder_name,exist_ok=True)

    def download_data(self):
        """
        Download student and staff demographic data and school
        geographic data from URLs defined in instance variables,
        assigned based on the configuration file settings.
        """
        self.engine = self.connect_database()
        self.student_demographics_file = self.staff_demographics_file = ''
        if self.student_demographics_url:
            self.student_demographics_file = self.download_file(self.student_demographics_url)
        if self.staff_demographics_url:
            self.staff_demographics_file = self.download_file(self.staff_demographics_url)
        if self.school_geography_url:
            self.school_geography_file = self.download_file(self.school_geography_url)

    def download_file(self,url):
        """
        Download the file from the url provided and save it locally to the folder for data files
        using its original file name. Any existing file with that file name and location will be
        overwritten.

        Keyword arguments:
        url - the URL of the file to download
        """
        output_filepath = self.datafiles_folder + '/' + url[url.rfind("/")+1:]
        # Download the file from the url and save it to the data files folder.
        try:
            with urllib.request.urlopen(url) as response, open(output_filepath, 'wb') as output_file:
                shutil.copyfileobj(response, output_file)
        except:
            logging.error("Unable to download file from {}. Exiting program.".format(url))
            exit(1)
        logging.info("Downloaded file to {}".format(output_filepath))
        return output_filepath

    def connect_database(self):
        """
        Acquire the database password using keyring and prepare a connection to the database
        used for storing demographic information.
        """
        # Get password from keyring
        password = keyring.get_password(self.database_name, self.database_username)

        # Connect to the database
        params = urllib.parse.quote_plus("DRIVER={{{0}}};SERVER={1};DATABASE={2};UID={3};PWD={4};autocommit=True;".format(self.database_driver,
                                            self.database_server,self.database_name, self.database_username,password))

        try:
            engine = sa.create_engine("mssql+pyodbc:///?odbc_connect={}".format(params))
            logging.info("Prepared connection to {} database.".format(self.database_name))
        except:
            logging.error("Unable to prepare connection to {} database. Exiting program.".format(self.database_name))
            exit(1)
        return engine

    def extract_data(self):
        """
        Call methods to extract student and staff demographic information
        and school geographic information from downloaded source files.
        """
        self.extract_student_demographics_data()
        self.extract_staff_demographics_data()
        self.extract_school_geography_data()

    def extract_student_demographics_data(self):
        """
        Extract data from student demographics file, a tab-delimited text file,
        to a Pandas dataframe for further processing.
        """
        try:
            self.student_demographics_df = pd.read_table(self.student_demographics_file, sep='\t', header=0, index_col=False)
        except:
            logging.error("Unable to read file from {}. Exiting program.".format(self.student_demographics_file))
            exit(1)
        logging.info("Extracted student demographics data from file {file}. {df} rows of data found.".format(file=self.student_demographics_file,
            df = self.student_demographics_df.shape[0]))

    def extract_staff_demographics_data(self):
        """
        Extract data from staff demographics file, which is an Access database,
        to a Pandas dataframe for further processing.
        """
        connection_string = "DRIVER={{Microsoft Access Driver (*.mdb, *.accdb)}};DBQ={0}/{1}".format(os.getcwd().replace('\\','/'),self.staff_demographics_file)

        logging.info("Attempting to connect to staff demographics Access database with the following connection: {}".format(connection_string))
        connection = pypyodbc.connect(connection_string)

        quoted_district_ids = ','.join(map("'{}'".format, self.school_district_ids))
        query = (r"SELECT SchoolYear,codist,cert,sex,hispanic,race,hdeg,certfte,certflag,recno,prog,act,bldgn,asspct,assfte,yr "
                 r"FROM [{source_table}] "
                 r"WHERE act = '27' " # Activity code 27 means a teaching assignment
                 r"AND assfte > 0 " # Must be at least part of the staff member's assignment FTE
                 r"AND codist IN ({district_ids});".format(source_table=self.source_staff_table,district_ids=quoted_district_ids))

        try:
            self.staff_demographics_df = pd.read_sql(query, connection)
        except:
            logging.error("Unable to extract staff data from {}. Exiting program.".format(self.staff_demographics_file))
            exit(1)
        logging.info("Extracted staff demographics data. {} rows of data found.".format(self.staff_demographics_df.shape[0]))

    def extract_school_geography_data(self):
        """
        Extract data from school geography file, a comma-separated values (CSV) file,
        to a Pandas dataframe for further processing.
        """
        try:
            self.school_geography_df = pd.read_table(self.school_geography_file, sep=',', header=0, index_col=False)
        except:
            logging.error("Unable to read file from {}. Exiting program.".format(self.school_geography_file))
            exit(1)
        logging.info("Extracted school geography data from file {file}. {df} rows of data found.".format(file=self.school_geography_file,
            df = self.school_geography_df.shape[0]))

    def filter_student_demographics_data(self):
        """
        Filter student demographics dataframe to limit its contents to schools in the
        specified school districts, which are defined based on the configuration
        file settings.
        """
        self.student_demographics_df = self.student_demographics_df[self.student_demographics_df.CountyDistrictNumber.isin(self.school_district_ids)]
        logging.info("Filtered student demographics data to limit data to specified school districts. {} rows of data found.".format(self.student_demographics_df.shape[0]))

    def clean_data(self):
        """
        Call methods to clean student and staff demographic information,
        replacing values and changing data types as needed.
        """
        self.clean_student_demographics()
        self.clean_staff_demographics()

    def clean_student_demographics(self):
        """
        Replace non-numeric values in the student demographics source file
        with numeric values specified in the configuration file.
        """
        self.student_demographics_df.replace(to_replace='N<10',value=self.n_less_than_10,inplace=True)
        self.student_demographics_df.replace(to_replace='>95%',value=self.more_than_95,inplace=True)
        logging.info("Cleaned student data.")

    def clean_staff_demographics(self):
        """
        Convert the data type of the county district ID and remove leading
        and trailing whitespace from all text fields.
        """
        # Change county district id (codist) from a string to an integer
        self.staff_demographics_df['codist'] = self.staff_demographics_df['codist'].astype(int)
        # Remove leading or trailing whitespace
        self.staff_demographics_df = self.staff_demographics_df.apply(lambda x: x.str.strip() if x.dtype == "object" else x)
        logging.info("Cleaned staff data.")

    def stage_data(self,df,table):
        """
        Store data contained in a dataframe to a staging table in the
        database.

        Keyword arguments:
        df - the dataframe containing data to store in a staging table
        table - the database table where the data is to be stored
        """
        # Load data to staging table.

        # Add batch load timestamp.
        df['loadDatetime']=datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")[:-3]

        if not df.empty:
            try:
                df.to_sql(table, self.engine, schema=self.database_schema, if_exists='append', index=False, chunksize=1000)
            except pyodbc.Error as exception:
                error_number, error_message = exception.args[0], exception.args[1]
                logging.error("Unable to connect to database: [{0}] {1} Exiting program.".format(error_number, error_message))
                exit(1)
            except:
                logging.error("Unable to connect to database. Exiting program.")
                exit(1)

    def stage_student_data(self):
        """Store the student demographic data to a staging table in database."""
        self.stage_data(df=self.student_demographics_df,table=self.staging_student_table)
        logging.info("Loaded {} rows of student data to staging table.".format(self.student_demographics_df.shape[0]))

    def stage_staff_data(self):
        """Store the staff demographic data to a staging table in database."""
        self.stage_data(df=self.staff_demographics_df,table=self.staging_staff_table)
        logging.info("Loaded {} rows of staff data to staging table.".format(self.staff_demographics_df.shape[0]))

    def stage_school_geography_data(self):
        """Store the school demographic data to a staging table in database."""
        self.stage_data(df=self.school_geography_df,table=self.staging_school_geography_table)
        logging.info("Loaded {} rows of school geography data to staging table.".format(self.school_geography_df.shape[0]))

    def load_dimensions(self):
        """
        Use the data in the staging tables in the database to populate
        dimension tables with any records not yet present.
        """
        dimension_procs = ['usp_LoadDimSchool','usp_LoadDimSchoolYear','usp_LoadDimRace','usp_LoadDimGender']
        for proc in dimension_procs:
            self.load_data_from_staging(proc_name=proc)
        logging.info("Loaded dimension tables from staging.")

    def load_facts(self):
        """
        Use the data in the staging tables in the database to populate
        a fact table with any records not yet present.
        """
        self.load_data_from_staging(proc_name='usp_LoadFactStaff')
        logging.info("Loaded staff fact table from staging.")

    def refresh_snapshots(self):
        """
        Use the data in the student staging table in the database to
        refresh snapshot tables containing the latest student information
        for race, Hispanic ethnicity, and gender.
        """
        dimension_procs = ['usp_RefreshStudentRaceSnapshot','usp_RefreshStudentGenderSnapshot','usp_RefreshStudentHispanicSnapshot']
        for proc in dimension_procs:
            self.load_data_from_staging(proc_name=proc)
        logging.info("Refreshed snapshot tables from staging.")

    def load_data_from_staging(self,proc_name):
        """
        Call the specified stored procedure to load data from
        a staging table into a fact or snapshot table.

        Keyword arguments:
        df - the dataframe containing data to store in a staging table
        table - the database table where the data is to be stored
        """
        try:
            connection = self.engine.raw_connection()
            connection.autocommit = False
            cursor = connection.cursor()

            sp_call = "{0} {1}".format('EXEC', proc_name)
            cursor.execute(sp_call)
            rows_affected = cursor.fetchone()[0]
            cursor.commit()

            logging.info("Executed stored procedure: {0}".format(sp_call))
            logging.info("Inserted {} rows.".format(rows_affected))
        except:
            logging.error("Unable to load data from staging. Exiting program.")
            exit(1)

    def retrieve_data(self,view_name):
        """
        Return a dataframe containing the data from the specified view.

        Keyword arguments:
        view_name - the name of a view containing data to retrieve
        """
        try:
            logging.info("Entered retrieve data.")
            self.engine = self.connect_database()
            connection = self.engine.raw_connection()
            logging.info("Set connection.")

            cursor = connection.cursor()
            logging.info("Set cursor.")
            cursor.execute("SET NOCOUNT ON;SELECT * FROM {0}; SET NOCOUNT OFF".format(view_name))
            logging.info("Executed cursor.")

            data = cursor.fetchall()
            logging.info("Fetched data.")
            cols = [column[0] for column in cursor.description]

            df = pd.pandas.DataFrame.from_records(data = data, columns = cols)
            logging.info("Retrieved {} rows to dataframe.".format(df.shape[0]))

            connection.close()
            return df
        except:
            logging.error("Unable to retrieve data from database. Exiting program.")
            exit(1)

    def start_timing(self):
        """Start a timer needed to calculate the duration of execution."""
        self.start_time = time.time()

    def stop_timing(self):
        """Stop a timer needed to calculate the duration of execution."""
        end_time = time.time()
        logging.info("Loading took {} seconds.".format(round(end_time-self.start_time,1)))
