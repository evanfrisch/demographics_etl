# Demographics ETL

Demographics ETL is designed to extract, transform, and load student
and teacher demographic data and school geographic data from files
maintained by the State of Washington Office of Superintendent of
Public Instruction and the King County government, storing data in a
relational database to support analysis of the data by school.

## Getting Started

These instructions will help you to prepare your system to run this
program. You will need a relational database, such as SQL Server, to
store data.

### Prerequisites

It is recommended that you install Python using the Anaconda package
environment manager. The Anaconda installer can be found here:
https://www.anaconda.com/download/

This program has been run successfully on a Windows system using
Microsoft SQL Server 2016. While it should be possible to run it on
another operating system, this has not yet been tested, and some
differences in setup may be required.

Choose the Python 3.6 version of the installer for your operating
system (Windows, Linux, or macOS). Follow the instructions to
complete the installation of Python 3.6.

Windows users should open the ODBC Data Source Administrator and go
to the Drivers tab. This tab should list Microsoft Access Driver
(*.mdb, *.accdb). If that driver is not listed, install the Microsoft
Access Database Engine 2016 Redistributable from the following source:
https://www.microsoft.com/en-us/download/details.aspx?id=54920

Then, verify that the driver is present in the Drivers tab in ODBC
Data Source Administrator.

### Installing

If you have installed Anaconda as recommended above, it is
recommended that you use Conda to create a virtual environment in
the folder where you have installed the program. Creating and using
a virtual environment helps to ensure that the program has the
appropriate versions of Python and the packages that it needs without
interfering with other Python programs that may be installed on the
same system, which may have different requirements. To create a
virtual environment using Conda, enter the following command:
```
conda create --name demographics_etl python=3.6
```

Type "y" when prompted to proceed.

After the creation of the virtual environment is complete, Windows
users should type the following to make the virtual environment
active:
```
activate demographics_etl
```

If you are using Bash (on Linux or macOS), you should instead type:
```
source activate demographics_etl
```

After you have made the virtual environment active, type the
following command to install the packages specified in
requirements.txt while in the folder where you have installed
the program:
```
pip install -r requirements.txt
```

When you are done, Windows users should use the following command
to make the virtual environment inactive:
```
deactivate
```

Bash users should instead type the following to exit the virtual
environment:
```
source deactivate
```

## Preparing the database

This program has scripts that have been tested on SQL Server 2016,
although they may also run on other SQL databases with minimal
modifications.

Create a database called demographics (or a name that you prefer)
and run the scripts provided in the scripts folder.

Create a database user called demographics_user (or a name that
you prefer) that the program will be able to use for loading data.

Use keyring at the command line to store the password of the database
user safely. The command below calls keyring to store a password for
demographics_user in the database named demographics:
```
keyring set demographics demographics_user
```

When prompted, enter the password for the demographics_user.

## Configuring the program

The program uses a configuration file in the YAML format. By default,
this is called config.yaml and is found in the same folder as the
Python program.

It is recommended to make a copy of the provided configuration file
before modifying it.

To edit the configuration file, replace any values provided that
need to be changed for your database or system configuration or to
account for changes in URLs or other settings provided.

The student demographics file may contain values such as N<10 or
&gt;95% in fields that are otherwise numeric. The configuration file
provides settings called Replacement for n<10 and Replacement for
&gt;95% to allow you to specify the numeric values that should replace
these non-numeric expressions.

## Running the program

From the folder where the program is installed, activate the virtual
environment as described above, if you are using one. Then, enter the
command below to run the ETL process using the default configuration
file config.yaml and the default logging location, the logs folder:
```
python load_demographics.py
```

To specify the configuration file and the logging location to use,
enter the command with optional arguments as shown below, replacing
myconfig.yaml and mylogs with the names of your configuration file
and logs folder respectively:
```
python load_demographics.py --config myconfig.yaml --log mylogs
```

To view optional command line arguments, enter this command:
```
python load_demographics.py --help
```

## Author

* **Evan Frisch**

## License

This project is licensed under the MIT License - see the
[LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* The Community Center for Education Results (CCER) and The Road Map Project provided the inspiration for this program.
* Thanks to contributors to all of the open source libraries used by this program.
