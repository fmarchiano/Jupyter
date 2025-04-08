#!/bin/bash
#SBATCH --job-name=BRASS_ed3
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2GB
#SBATCH --time=01:00:00
#SBATCH --output=bin_logs/BRASS_ed3_%A_%a.out
#SBATCH --error=bin_logs/BRASS_ed3_%A_%a.err
#SBATCH --partition=cpu

input_dir=/mnt/longterm/ng_piscuoglio/data/pnrr_pdac_wgs/brass_files/depth
output_dir=/mnt/longterm/ng_piscuoglio/data/pnrr_pdac_wgs/brass_files/merged

mkdir -p "$output_dir"

cd "$input_dir"
ls -1 *.1.bed | cut -f 1 -d '.' | xargs -I {} bash -c 'cat {}.merged.*.bed | sort -k1,1 -k2,2n > $output_dir/{}.bed'

cd "$output_dir"
bedtools multiinter -i *.bed > intersect.bed
perl -ane 'next if($F[3] < 3); printf qq{%s\t%d\t%d\n}, @F[0..2];' < intersect.bed \
| bedtools merge -i stdin -d 250 \
| perl -ane 'next if($F[2]-$F[1] < 500); print $_;' \
| bgzip -c > depth_mask.bed.gz

tabix -p bed depth_mask.bed.gz