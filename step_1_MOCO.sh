#!/bin/bash
# Motion Correction (SPM12)
#
# Define Input

PATH_IN=/mnt/c/Users/apizz/Desktop/DCBT/Project/Data/Data/
PATH_OUT=/mnt/c/Users/apizz/Desktop/DCBT/Project/Data/moco
myscript=/mnt/c/Users/apizz/Desktop/DCBT/Project/Data/scripts

# SUB={01,02,03,04,05,06,07,08,09,10}
SUB=01
basename=_ses-1_task-rest_acq-fullbrain_run-1_bold
# ---------------------------------------------------------------------------
echo "Starting MOCO.sh"
echo "Data folder: " $PATH_IN

# Create output folder
if [ ! -d ${PATH_OUT} ]; then
  mkdir -p ${PATH_OUT};
fi

cd ${PATH_IN} 	# remain in this folder
echo pwd

for i in $SUB
do
  gunzip ${PATH_IN}sub-$i${basename}
  echo "sub-$i$basename.nii"
  echo "moco.m (matlab script)"
done

/mnt/c/'Program Files'/MATLAB/R2022a/bin/matlab.exe -nodesktop -nosplash -r "run moco.m"
