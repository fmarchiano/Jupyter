#!/bin/bash
#SBATCH --job-name=BRASS_ed2
#SBATCH --array=0-57
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2GB
#SBATCH --time=7-00:00:00
#SBATCH --output=bin_logs/BRASS_ed2_%A_%a.out
#SBATCH --error=bin_logs/BRASS_ed2_%A_%a.err
#SBATCH --partition=cpu

module load singularity/4.1.2

singularity_container=/home/ng_piscuoglio/pipeline/usr/singularity/cpgbigwig/cgpbigwig.sif
input_dir=/mnt/longterm/ng_piscuoglio/data/pnrr_pdac_wgs/brass_files
output_dir=/mnt/longterm/ng_piscuoglio/data/pnrr_pdac_wgs/brass_files/depth

mkdir -p "$output_dir"

# Create an array of .bw files
bw_files=("$input_dir"/*.bw)

# Get the .bw file for this task
bw="${bw_files[$SLURM_ARRAY_TASK_ID]}"
name=$(basename "$bw" .bw)  # Extract the base name without the .bw extension

echo "Processing $name, -i $bw -o $output_dir/$name.bed"

# Run the container
singularity exec \
    -B /home/ng_piscuoglio \
    -B /mnt/longterm/ng_piscuoglio/data/pnrr_pdac_wgs \
    "$singularity_container" \
    detectExtremeDepth -b "$bw" -o "$output_dir/$name.bed"