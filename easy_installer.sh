#!/usr/bin/env bash
# **********************************************************************
# *

# Note: To proceed, you must have installed Python 2.7 previously. This tool will then:
# 1. clone the fprime github repository to your chosen location. 
# 2. Install a new virtual environment in the fprime directory. 
# 3. 

# First, we need to detect the operating system the user is operating on. 

get_os(){
	echo "Determining operating system..."
	if [[ "$OSTYPE" == "linux-gnu" ]]; then
		OPERATING_SYSTEM=$OSTYPE
		# Linux GNU Operating System
		echo "Success: Found Linux-GNU-Based Operating System: \"$OSTYPE\"."
	elif [[ "$OSTYPE" == "darwin"* ]]; then
		OPERATING_SYSTEM=$OSTYPE
		# Mac OSX Operating System
		echo "Success: Found Macintosh-Based Operating System: \"$OSTYPE\"."
	elif [[ "$OSTYPE" == "cygwin" ]]; then
		OPERATING_SYSTEM=$OSTYPE
		# Linux emulation on Windows (CygWin) Operating System
		echo "Success: Found Linux-Based Operating System: \"$OSTYPE\"."
	elif [[ "$OSTYPE" == "msys" ]]; then
		OPERATING_SYSTEM=$OSTYPE
		# Windows (MinGW) Operating System
		echo "Success: Found Windows-Based Operating System: \"$OSTYPE\"."
	else
		echo "Operating system $OSTYPE is not recognized."
	fi
}


get_os

if [[ OPERATING_SYSTEM == "darwin"* ]]; then
	# First, install Homebrew. 
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

	# Install Python using Homebrew.
	brew install python


	git clone --verbose --progress https://github.com/nasa/fprime.git

fi