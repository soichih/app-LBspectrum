#!/bin/bash

#mainly to debug locally
if [ -z $WORKFLOW_DIR ]; then export WORKFLOW_DIR=`pwd`; fi
if [ -z $TASK_DIR ]; then export TASK_DIR=`pwd`; fi
if [ -z $SERVICE_DIR ]; then export SERVICE_DIR=`pwd`; fi

rm -f finished

if [ $ENV == "IUHPC" ]; then
	#clean up previous job (just in case)
	rm -f finished
	#jobid=`qsub $SERVICE_DIR/submit.pbs`
	if [ $HPC == "KARST" ]; then
		#looks like preempt queue has small limit on how many jobs I can queue
		#jobid=`qsub -q preempt $SERVICE_DIR/submit.pbs`
		qsub $SERVICE_DIR/submit.pbs > jobid
	fi
	if [ $HPC == "CARBONATE" ]; then
		qsub $SERVICE_DIR/submit.pbs > jobid
	fi
	exit $?
fi

if [ $ENV == "VM" ]; then
	nohup time $SERVICE_DIR/submit.pbs > stdout.log 2> stderr.log &
	echo $! > pid
fi

if [ $ENV == "SLURM" ]; then
    
cat <<EOT > _run.sh
#!/bin/bash
srun singularity run docker://kitchell/lb_spectrum
if [ -s 'spectrum.json' ];
then
	echo 0 > finished
else
	echo "spectrum.json missing"
	echo 1 > finished
	exit 1
fi
EOT
    chmod +x _run.sh
    jobid=$(sbatch -c 6 _run.sh | cut -d' ' -f4)
    echo $jobid > slurmjobid
    echo "submitted $jobid"
    exit
fi
