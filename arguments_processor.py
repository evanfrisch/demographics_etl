# arguments_processor.py
#######
import argparse

class ArgumentsProcessor():
    def __init__(self):
        """
        Initialize command line arguments processor, assigning
        instance variables for configuration file name and
        name of folder for storing log files.
        """
        parser = argparse.ArgumentParser()
        parser.add_argument("--config", help="the name of the configuration file to use")
        parser.add_argument("--log", help="the name of the folder for storing log files")

        try:
            args = parser.parse_args()
        except argparse.ArgumentError:
            print("Argument error. Exiting program.")
            exit(1)
        except:
            print("Exiting program.")
            exit(1)

        self.config = args.config
        self.log = args.log
