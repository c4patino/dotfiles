#!/usr/bin/env bash

# Delete the scratch directory for the job
SCRATCH_DIR="/scratch/job-$SLURM_JOB_ID"
rm -rf "$SCRATCH_DIR"
