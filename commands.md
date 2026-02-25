# HPC & Linux Command Reference

Notes ofs running Gaussian 16 jobs on a remote HPC cluster.

---

## Connecting to the Cluster

```bash
ssh username@hpc.university.edu.tr
```


---

## File Operations

### `cat` — print file contents to terminal

```bash
cat molecule.log              # read entire output file
cat g16.sh                    # check your job script before submitting
cat slurm-12345.out           # read SLURM job output/errors
```

Useful to quickly check if a calculation finished or threw an error.

### `cp`, `mv`, `mkdir` — copy, move, make directory

```bash
mkdir gaussian
mkdir gaussian/lyxose
cp alpha.gjf gaussian/lyxose/
```

### `ls` — list files

```bash
ls                            # list current directory
ls -lh                        # with file sizes (human readable)
ls *.log                      # list all .log files
```

---

## Editing Files with `vi`

`vi` is a terminal text editor — useful for writing or editing job scripts directly on the cluster.

```bash
vi g16.sh                     # open file for editing
```

### Essential vi commands

| Mode / Command | What it does |
|---|---|
| `i` | Enter **insert mode** — now you can type |
| `Esc` | Exit insert mode, go back to normal mode |
| `:wq` | **Save and quit** (write + quit) |
| `:q!` | Quit **without saving** (force quit) |
| `:w` | Save without quitting |
| `dd` | Delete current line |
| `G` | Jump to end of file |
| `gg` | Jump to beginning of file |

**Typical workflow:**
1. `vi g16.sh` — open the file
2. `i` — enter insert mode
3. Edit the job name, memory, number of cores, input filename
4. `Esc` — exit insert mode
5. `:wq` + Enter — save and close

---

## Searching with `grep`

`grep` searches for a string inside a file. Essential for checking Gaussian output.

```bash
# Did the job finish successfully?
grep "Normal termination" molecule.log

# Get the final SCF energy (total energy)
grep "SCF Done" molecule.log

# Get zero-point energy correction
grep "Zero-point" molecule.log

# Check vibrational frequencies (for TS: look for 1 imaginary)
grep "Frequencies" molecule.log

# Look for imaginary frequency (negative number = imaginary)
grep "Frequencies" molecule.log | head -5

# Get thermochemical summary
grep "Sum of electronic" molecule.log

# Check how many optimization steps were taken
grep "Step number" molecule.log | tail -1
```

### Useful grep flags

```bash
grep -i "error" molecule.log       # case-insensitive
grep -n "SCF Done" molecule.log    # show line numbers
grep -c "SCF Done" molecule.log    # count how many times it appears
grep -A 3 "Frequencies" molecule.log  # show 3 lines after match
```

---

## Submitting Jobs with SLURM

### `sbatch` — submit a job script to the queue

```bash
sbatch g16.sh
```

SLURM returns a job ID, e.g. `Submitted batch job 48291`

### Monitoring jobs

```bash
squeue -u username             # see your jobs in the queue
squeue -u username -l          # with more detail (state, time)
scancel 48291                  # cancel job with that ID
```

Job states:
- `PD` — Pending (waiting for resources)
- `R` — Running
- `CG` — Completing

### Checking job output

```bash
cat slurm-48291.out            # SLURM output log (stdout/stderr)
tail -20 molecule.log          # last 20 lines of Gaussian output
```

---

## File Transfer with `scp`

`scp` is used to copy files between your local machine and the cluster. Run this from your **local** terminal (not on the cluster).

```bash
# Upload: local → cluster
scp molecule.gjf username@hpc.university.edu:~/gaussian/

# Download: cluster → local
scp username@hpc.university.edu:~/gaussian/molecule.log ./

# Upload entire folder
scp -r assignment1/ username@hpc.university.edu:~/gaussian/

# Download entire folder
scp -r username@hpc.university.edu:~/gaussian/results/ ./
```

---

## Typical Gaussian Calculation Workflow

```bash
# 1. Upload input file
scp lyxose_alpha.gjf user@hpc:~/gaussian/

# 2. SSH into cluster
ssh user@hpc

# 3. Edit job script if needed
vi g16.sh
# (change %chk= and input filename inside the script)

# 4. Submit job
sbatch g16.sh

# 5. Monitor
squeue -u username

# 6. After job finishes — check success
grep "Normal termination" lyxose_alpha.log

# 7. Check energy
grep "SCF Done" lyxose_alpha.log | tail -1

# 8. For frequency jobs — check for imaginary frequencies
grep "Frequencies" lyxose_alpha.log | head -3

# 9. Exit cluster and download results
exit
scp user@hpc:~/gaussian/lyxose_alpha.log ./
```
