# Creates a Python virtualenv with everything needed to run ESPERR
esperr-virtualenv :
	virtualenv esperr-virtualenv
	./esperr-virtualenv/bin/pip install --upgrade distribute
	./esperr-virtualenv/bin/pip install --upgrade -r esperr-requirements.txt
