#!/bin/bash

#return code 0 = running
#return code 1 = finished successfully
#return code 2 = failed

##now wait for running to go away
#progress_url={$SCA_PROGRESS_URL}/{$SCA_PROGRESS_KEY}

if [ -f finished ]; then
    code=`cat finished`
    if [ $code -eq 0 ]; then
        echo "finished successfully"
        exit 1 #success!
    else
        echo "finished with code:$code"
        exit 2 #failed
    fi
fi

if [ -f jobid ]; then
    jobid=`cat jobid`
    if [ -z $jobid ]; then
        echo "jobid is empty.. failed to submit?"
        exit 2
    fi
    jobstate=`qstat -f $jobid | grep job_state | cut -b17`
    if [ -z $jobstate ]; then
        echo "Job removed before completing - maybe timed out?" 
        exit 2
    fi
    if [ $jobstate == "Q" ]; then
        eststart=`showstart $jobid | grep start`
        echo "Waiting in the queue $eststart"
        [ -n "$PROGRESS_URL" ] && curl -s -X POST -H "Content-Type: application/json" -d "{\"msg\":\"Waiting in the PBS queue : $eststart\"}" $PROGRESS_URL > /dev/null
        exit 0
    fi
    if [ $jobstate == "R" ]; then
	subid=$(cat jobid | cut -d '.' -f 1)
	logname="LBspectrum.o$subid"
	tail -1 $logname
        exit 0
    fi
    if [ $jobstate == "H" ]; then
        echo "Job held.. waiting"
        exit 0 
    fi

    #assume failed for all other state
    echo "Jobs failed - PBS job state: $jobstate"
    exit 2
fi

if [ -f slurmjobid ]; then
    jobid=`cat slurmjobid`
    jobstate=`squeue -h -j $jobid --Format=statecompact`
    if [ -z $jobstate ]; then
        echo "Job removed before completing - maybe timed out?" 
        exit 2
    fi
    if [ $jobstate == "PD" ]; then
        eststart=`squeue -h -o "%S" -j $jobid`
        echo "Waiting in the queue -- start_time $eststart"
        #curl -X POST -H "Content-Type: application/json" -d "{\"msg\":\"Waiting in the PBS queue : $eststart\"}" $PROGRESS_URL
        exit 0
    fi
    if [ $jobstate == "R" ]; then
	logname="slurm-$jobid.out"
	tail -1 $logname
        exit 0
    fi
    if [ $jobstate == "F" ]; then
        echo "Job failed"
        exit 2
    fi

    #assume failed for all other state
    echo "unknown state: $jobstate"
    exit 2
fi

echo "can't determine the status - maybe not yet started?"
exit 3

