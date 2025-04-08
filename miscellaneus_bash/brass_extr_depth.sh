#!/bin/bash
#SBATCH --job-name=BRASS_ed1
#SBATCH --array=48-58
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=20GB
#SBATCH --time=7-00:00:00
#SBATCH --output=bin_logs/BRASS_ed1_%A_%a.out
#SBATCH --error=bin_logs/BRASS_ed1_%A_%a.err
#SBATCH --partition=cpu

# Load Apptainer (Singularity)
module load singularity/4.1.2

# Paths
singularity_container=/home/ng_piscuoglio/pipeline/usr/singularity/cpgbigwig/cgpbigwig.sif
input_dir=/mnt/longterm/ng_piscuoglio/data/pnrr_pdac_wgs/bam
output_dir=/mnt/longterm/ng_piscuoglio/data/pnrr_pdac_wgs/brass_files

# Build an array of all BAM files matching your pattern
bam_files=("$input_dir"/P*B.bam)

# Get the BAM file for this task
bam="${bam_files[$SLURM_ARRAY_TASK_ID]}"
name=$(basename "$bam" .bam)

# Run the container
singularity exec \
    -B /home/ng_piscuoglio \
    -B /mnt/longterm/ng_piscuoglio/data/pnrr_pdac_wgs \
    "$singularity_container" \
    bam2bw -i "$bam" -o "$output_dir/$name.bw"
