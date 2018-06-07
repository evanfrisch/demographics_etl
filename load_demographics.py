# load_demographics.py
#######
# This program performs extraction, transformation, and loading (ETL)
# of teacher and student demographic data and school geography for
# selected school districts in southern King County, Washington.
# The program also refreshes existing student data snapshots.
######
from demographics_etl import DemographicsETL
from arguments_processor import ArgumentsProcessor

# Read in command line arguments for configuration file name
# and name of folder to store log file.
options = ArgumentsProcessor()
config_option = options.config or "config.yaml"
log_option = options.log or "logs"

# Instantiate ETL object.
loader = DemographicsETL(config_file_path=config_option, log_folder_name=log_option)
# Run the necessary steps of the ETL process.
loader.start_timing()
loader.download_data()
loader.extract_data()
loader.filter_student_demographics_data()
loader.clean_data()
loader.stage_student_data()
loader.stage_staff_data()
loader.stage_school_geography_data()
loader.load_dimensions()
loader.load_facts()
loader.refresh_snapshots()
loader.stop_timing()

exit(0)
