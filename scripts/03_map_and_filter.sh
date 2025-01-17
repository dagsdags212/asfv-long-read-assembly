#!/usr/bin/env bash

# Name of current script
FILENAME=$(basename "$0")

# Generate a samtools index for the reference file
index_swine_ref() {
  echo "[${FILENAME}] Indexing reference file: ${SWINE_REF}"
  samtools faidx ${SWINE_REF}
}

# Map reads against the reference genome
run_minimap() {
  local target=output/minimap/aln.trimmed.sam
  mkdir -p output/minimap
  echo "[${FILENAME}] Aligning trimmed reads to the swine reference genome"
  minimap2 -a -x map-ont ${SWINE_REF} ${TRIMMED_READS}/all_reads.trimmed.fastq.gz >${target}
}

# Extract unmapped reads and store into a separate BAM file
filter_unampped_reads() {
  local target=output/samtools/aln.unmapped.sam
  echo "[${FILENAME}] Extracting unmapped reads"
  samtools view -S -f 4 output/minimap/aln.trimmed.sam >${target}
  samtools index ${target}
}

# Convert unmapped BAM file to FASTQ format
sam2fastq() {
  echo "[${FILENAME}] Converting BAM to FASTQ"
  local target=output/samtools/aln.unmapped.sam
  samtools fastq ${target} >output/samtools/filtered_reads.fastq
}

map_and_filter() {
  #index_swine_ref
  run_minimap
  filter_unampped_reads
  sam2fastq
}
