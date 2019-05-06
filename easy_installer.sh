#!/usr/bin/env bash
# **********************************************************************
# *

# Note: To proceed, you must have installed Python 2.7 previously. This tool will then:
# 1. clone the fprime github repository to your chosen location. 
# 2. Install a new virtual environment in the fprime directory. 
# 3. 

# First, we need to detect the operating system the user is operating on. 

function get_os(){
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

function get_homebrew(){
	# Check for homebrew, and install or update homebrew if necessary. 
	echo "Checking for Homebrew..."
	command -v brew
	if [[ $? != 0 ]] ; then
		# Install Homebrew
		echo "No Homebrew found, installing..."
		ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
		echo "Homebrew installation successful. "
	else
		echo "Homebrew found! Updating..."
		brew update
		echo "Homebrew update successful."
		echo "Upgrading dependencies and packages..."
		brew upgrade
		echo "Upgrades successful. Cleaning up..."
		brew cleanup
		echo "Finished work involving homebrew."
	fi
}

function get_python(){
	# Check for Python and Install/Update Python/Pip using if necessary.
	PYTHON_VERSION=$(python --version 2>&1)
	PIP_VERSION=$(pip3 -V 2>&1)

	if [[ "$PYTHON_VERSION" = *"command not found"* ]]; then
		# No python found, so install Python 2 and Python 3. 
		echo "No Python found, installing..."
		brew install python
		PYTHON_VERSION=$(python --version 2>&1)
		echo "Python installation successful. Installed version: ${PYTHON_VERSION}"

		if [[ "$PIP_VERSION" = *"command not found"* ]]; then
			echo "Downloading the get-pip.py python utility..."
			curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
			echo "Installing pip, wheel, and setuptools..."
			python get-pip.py --user
			echo "Success! Your current python environment contains:"
		fi
	else
		# Python found for both python 2 and python 3. 
		echo "Python version(s) found! You are using version: ${PYTHON_VERSION}."
		echo "Pip found! You are using version: ${PIP_VERSION}"
		echo "Your current python environment contains:"
	fi
}

function mk_virtualenv(){
	pip3 install virtualenv
	PY_ENV_NAME="${PWD}/$1"
	echo "Creating new python environment at location: \"$1\"."
	mkdir $1
	virtualenv --python=python2.7 $1
	echo "Success! Created new python environment at: $1"
}

function line_break(){
	echo ""
	echo ""
}

function get_xcode(){
	XCODE_VERSION=$(xcode-select --version 2>&1)
	echo $XCODE_VERSION
	if [[ $XCODE_VERSION != *"xcode-select version"* ]]; then
		echo "It looks like you haven't installed xcode yet. Installing now..."
		sudo xcode-select --install
		sudo xcode-select --switch /Library/Developer/CommandLineTools
		sudo installer -verbose -pkg /Library/Developer/CommandLineTools/macOS_SDK_headers_for_macOS_* -target /
		echo "Finished unpacking and installing xcode developer command line tools (xcode-select)."
	else
		echo "Great! You have xcode developer command line tools already properly configured!"
	fi
}

# Detect the current operating system and report it to the user. 
get_os
PYENV_BASENAME=".pyenv"



if [[ "$OSTYPE" = *"darwin"* ]]; then
	get_xcode
	echo $(line_break)

	ls $PYENV_BASENAME
	if [[ $? != 0 ]]; then
		echo "------- Homebrew Setup -------"
		get_homebrew
		echo "------- Python Setup -------"
		get_python
		echo "------- Virtual Python Environment Setup -------"
		mk_virtualenv $PYENV_BASENAME
	else
		echo -n 1 "Potential environment detected in directory \"${PYENV_BASENAME}\"--remove and rebuild? [y/n]: "
		read CHOICE
		if [[ $CHOICE = "y" ]]; then
			# Remove the old pyenv environment directory. 
			echo "Removing old \"${PYENV_BASENAME}\" directory..."
			rm -r $PYENV_BASENAME
			echo "Removed old \"${PYENV_BASENAME}\" directory--rebuilding..."

			# Execute environment build activities. 
			echo "------- Homebrew Setup -------"
			get_homebrew

			echo "------- Python Setup -------"
			get_python

			echo "------- Virtual Python Environment Setup -------"
			mk_virtualenv $PYENV_BASENAME
		else
			exit
		fi
	fi

	echo $(line_break)

	export PYTHON_BASE=$PWD/${PYENV_BASENAME}

	echo "Activating virtual environment \"${PYTHON_BASE}\"..."
	echo "export PYTHON_BASE=${PYTHON_BASE}" >> $PYTHON_BASE/bin/activate
	source "${PYTHON_BASE}/bin/activate"
	echo "Success! Virtual environment activated."

	echo $(line_break)

	echo "Installing numpy..."
	$PYTHON_BASE/bin/pip install numpy
	echo "Success! Numpy installed."

	echo $(line_break)

	echo "Installing python dependencies for building F-prime..."
	$PYTHON_BASE/bin/pip install -r ./mk/python/pip_required_build.txt
	echo "Complete! F-prime Python dependencies installed."

	echo $(line_break)

	echo "Installing python GUI dependencies for F-prime..."
	$PYTHON_BASE/bin/pip install -r ./mk/python/pip_required_gui.txt
	echo "Complete! Python dependencies for the F-prime GUI installed."
	echo "All dependencies installed successfully."

	echo $(line_break)

	# Troubleshooting:
	# 1. If you run into a "library not found: -lssl" error, cd to here: 
	# 	/Library/Developer/CommandLineTools/Packages 
	# ...and open this folder. You will see a file named something like 
	# 	macOS_SDK_headers_for_macOS_10.14
	# ...open this and install the files. Your missing dependencies were here. 
	# 1.a Before trying the above step, try running:
	#	xcode-select --install 
	# This may also fix your problem. If not, also try:
	# 	xcode-select --switch /Library/Developer/CommandLineTools

fi

exit