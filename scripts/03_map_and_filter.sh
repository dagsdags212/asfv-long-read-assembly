#!/usr/bin/env bash

# Generate a samtools index for the reference file
index_swine_ref() {
  echo "Indexing reference file: ${SWINE_REF}"
  samtools faidx ${SWINE_REF}
}

# Map reads against the reference genome
run_minimap() {
  echo "Aligning reads to the swine reference genome"
  mkdir -p output/minimap
  minimap2 -a -x map-ont ${SWINE_REF} ${TRIMMED_READS}/all_reads.trimmed.fastq.gz >output/minimap/aln.sam
}

# Extract unmapped reads and store into a separate BAM file
filter_unampped_reads() {
  echo "Extracting unmapped reads"
  samtools view -S -f 4 output/minimap/aln.sam >output/samtools/aln.unmapped.sam
}

# Convert unmapped BAM file to FASTQ format
sam2fastq() {
  echo "Converting BAM to FASTQ"
  local target=output/samtools/aln.unmapped.sam
  samtools fastq ${target} >output/samtools/filtered_reads.fastq
}

map_and_filter() {
  #index_swine_ref
  run_minimap
  filter_unampped_reads
  sam2fastq
}
