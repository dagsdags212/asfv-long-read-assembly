#!/usr/bin/env bash

# Generate a samtools index for the reference file
index_ref() {
  echo "Indexing reference file: ${REF}"
  samtools faidx ${REF}
}

# Map reads against the reference genome
run_minimap() {
  mkdir -p output/minimap
  parallel -j 2 -a data/accessions.txt \
    minimap2 -a -x map-ont -o output/minimap/{}.sam ${REF} ${TRIMMED_READS}/{}.trimmed.fastq
}

# Convert SAM to BAM
sam2bam() {
  mkdir -p output/samtools
  parallel -j 4 -a data/accessions.txt \
    samtools view -b -h -o output/samtools/{}.bam output/minimap/{}.sam
}

# Concatenate all BAM files into a single master BAM file
concat_bam_files() {
  local target=output/complete.bam
  samtools merge ${target} output/samtools/*.bam
}

# Extract unmapped reads and store into a separate BAM file
filter_aligned_reads() {
  samtools -b -f 4 output/complete.bam >output/unmapped.complete.bam
}

# Convet unmapped BAM file to FASTQ format
bam2fastq() {
  local target=output/unmapped.complete.fastq.gz
  samtools bam2fq output/unmapped.complete.bam >${target}
}
