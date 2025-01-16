#!/usr/bin/env bash

# print commands and exit on error
set -eu

# Load variables
source scripts/globals.sh

# Retrieve read and reference data
source scripts/01_download_data.sh

# Perform adapter trimming
source scripts/02_trim_reads.sh

# Map reads to reference and remove host contaminants
source scripts/03_map_and_filter.sh

# Run de novo assembler
source scripts/04_assemble.sh

# Run the entire pipeline
run_pipeline() {
  download_data
  run_porechop
  index_ref
  run_minimap
  sam2bam
  concat_bam_files
  filter_aligned_reads
  bam2fastq
  run_flye_assembler
}

run_flye_assembler