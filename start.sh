
#!/bin/bash

#mainly to debug locally
if [ -z $SCA_WORKFLOW_DIR ]; then export SCA_WORKFLOW_DIR=`pwd`; fi
if [ -z $SCA_TASK_DIR ]; then export SCA_TASK_DIR=`pwd`; fi
if [ -z $SCA_SERVICE_DIR ]; then export SCA_SERVICE_DIR=`pwd`; fi

#clean up previous job (just in case)
rm -f finished

module unload python
module load anaconda2

source activate mindboggle


echo "starting main"

(

nohup time python $SCA_SERVICE_DIR/main.py > stdout.log 2> stderr.log

#check for output files
if [ -s spectrum.json ];
then
	echo 0 > finished
else
	echo "files missing"
	echo 1 > finished
	exit 1
fi
) &