# Copyright (C) 2026 Berkem Toprak Elmacı
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License.

#!/bin/bash
#SBATCH --job-name=g16_calc
#SBATCH --output=slurm-%j.out
#SBATCH --error=slurm-%j.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=8G
#SBATCH --time=24:00:00

# Gaussian 16 job submission script
# Usage: sbatch g16.sh
#
# Before submitting:
#   vi g16.sh
#   i                     (insert mode)
#   edit INPUT and CHKFILE below
#   Esc → :wq             (save and quit)
#   sbatch g16.sh

# ----Edit-these----
INPUT="molecule.gjf"
CHKFILE="molecule.chk"
# ------------------

module load gaussian/g16

export GAUSS_SCRDIR=$TMPDIR

echo "Job started: $(date)"
echo "Input: $INPUT"
echo "Running on: $(hostname)"

g16 < $INPUT > ${INPUT%.gjf}.log

grep "Normal termination" ${INPUT%.gjf}.log && echo "SUCCESS" || echo "FAILED — check .log file"
