#!/run/current-system/sw/bin/bash

# Create the scratch directory for the job
SCRATCH_DIR="/scratch/job-$SLURM_JOB_ID"
mkdir -p "$SCRATCH_DIR"

# Set the SCRATCH environment variable
echo "export SCRATCH=$SCRATCH_DIR"
