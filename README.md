# Quantum Chemical Calculations — Computational Chemistry Assignments

DFT-based molecular modeling of a monosaccharide and dipeptide reaction mechanism using **Gaussian 16** on a remote HPC cluster, accessed via SSH.

---

## Projects

### Assignment 1 — Conformational Analysis of L-Lyxose

Geometry optimization and frequency analysis of the three conformational forms of L-Lyxose at the **B3LYP/6-311+G(d,p)** level of theory.

| Structure | Form |
|---|---|
| α-L-Lyxose | Pyranose ring, axial anomeric OH |
| β-L-Lyxose | Pyranose ring, equatorial anomeric OH |
| Linear L-Lyxose | Open-chain (acyclic) form |

**Key steps:**
- Input geometries built and visualized in **Chemcraft**, exported as `.xyz`
- Gaussian input (`.gjf`) files prepared with `opt freq` keywords
- Jobs submitted to HPC via `sbatch g16.sh`
- Output `.log` files retrieved and analyzed in Chemcraft
- Verified true minima: all real vibrational frequencies (no imaginary)
- Compared total energies to determine most stable conformer

---

### Assignment 2 — Dipeptide Formation Reaction Mechanism

Mapping the potential energy surface for peptide bond formation (condensation) between two amino acid pairs.

| Reaction | System |
|---|---|
| Gly + Ala → GlyAla + H₂O | Glycine–Alanine |
| Ser + Ala → SerAla + H₂O | Serine–Alanine |

**Key steps:**
- Reactant and product geometries optimized (`opt freq`)
- Transition state (TS) located with `opt=(ts,calcfc,noeigentest)`
- TS confirmed by **exactly one imaginary frequency**
- Dihedral angle (φ/ψ) profiles extracted and plotted from Chemcraft
- Activation energy (Eₐ) and reaction enthalpy (ΔH) calculated
- IRC (Intrinsic Reaction Coordinate) run to confirm TS connects reactants to products

---

## Workflow

```
Local machine (Chemcraft)          HPC Cluster
        │                               │
  Build geometry (.xyz)                 │
  Write .gjf input file                 │
        │                               │
        └──── scp file.gjf user@hpc ───►│
                                        │  vi g16.sh   (edit job script)
                                        │  sbatch g16.sh (submit job)
                                        │  cat slurm-XXXX.out (check status)
                                        │  grep "Normal termination" file.log
                                        │
        ◄──── scp user@hpc:file.log ────┘
        │
  Open .log in Chemcraft
  Analyze geometry, frequencies, energies
```

---

## HPC / Linux Commands Used

See [`commands.md`](commands.md) for full reference with explanations.

Quick summary:

```bash
# Transfer files to/from cluster
scp molecule.gjf username@hpc.university.edu:~/gaussian/

# Edit job submission script
vi g16.sh

# Submit job to SLURM queue
sbatch g16.sh

# Monitor job
squeue -u username

# Check if calculation completed successfully
grep "Normal termination" molecule.log

# Search for specific data in output
grep "SCF Done" molecule.log          # total energy
grep "Zero-point" molecule.log        # ZPE correction
grep "Frequencies" molecule.log       # vibrational frequencies
grep "Imaginary" molecule.log         # check for TS confirmation

# Read output file
cat molecule.log
```

---

## Software & Methods

| Tool | Purpose |
|---|---|
| Gaussian 16 | DFT calculations |
| Chemcraft | Geometry building, visualization, analysis |
| SSH terminal | Remote access to HPC cluster |
| SLURM | Job scheduler on HPC |
| SCP | File transfer to/from cluster |

**Level of theory:** B3LYP/6-311+G(d,p)

---
