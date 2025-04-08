#!/bin/bash
#SBATCH --job-name=VAGrENT
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=20GB
#SBATCH --time=02:00:00
#SBATCH --output=VAGrENT_%A_%a.out
#SBATCH --error=VAGrENT_%A_%a.err
#SBATCH --partition=cpu

# Load Apptainer (Singularity)
module load singularity/4.1.2

# Paths
singularity_container=/home/ng_piscuoglio/pipeline/usr/singularity/VAGrENT/VAGrENT_3.7.0.sif

# Run the container
singularity exec \
    -B /home/ng_piscuoglio/pipeline/ \
    "$singularity_container" \
    Admin_EnsemblReferenceFileGenerator.pl \
    --database homo_sapiens_core_80_38 \
    --ftp ftp://ftp.ensembl.org/pub/release-80/fasta/homo_sapiens/cdna/ \
    --assembly GRCh38 \
    --species human \
    --ccds /home/ng_piscuoglio/pipeline/ref/genomes/hg38/annotation/CCDS2Sequence.current.txt \
    --output /home/ng_piscuoglio/pipeline/ref/genomes/hg38/cache




#--fasta /home/ng_piscuoglio/pipeline/ref/genomes/hg38/Homo_sapiens_assembly38_gsa.fasta \
#--features /home/ng_piscuoglio/pipeline/ref/genomes/hg38/annotation/gencode.v33.primary_assembly.annotation.gtf \
#--fai /home/ng_piscuoglio/pipeline/ref/genomes/hg38/Homo_sapiens_assembly38_gsa.fasta.fai \
#--features /home/ng_piscuoglio/pipeline/ref/genomes/hg38/annotation/gencode.v33.primary_assembly.annotation.gtf \
#--data_version homo_sapiens_core_80_38 \
#--transcripts \
#--trans_list /home/ng_piscuoglio/pipeline/ref/genomes/hg38/cache/transctiptsIDs.txt \
#--database homo_sapiens_core_80_38 \