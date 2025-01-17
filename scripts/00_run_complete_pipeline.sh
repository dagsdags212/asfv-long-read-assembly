#!/usr/bin/env bash

ROOT=$(dirname $(dirname $(realpath "$0")))

# print commands and exit on error
set -eu

# Load variables
source ${ROOT}/scripts/globals.sh

# Retrieve read and reference data
source ${ROOT}/scripts/01_download_data.sh

# Perform adapter trimming
source ${ROOT}/scripts/02_trim_reads.sh

# Map reads to reference and remove host contaminants
source ${ROOT}/scripts/03_map_and_filter.sh

# Run de novo assembler
source ${ROOT}/scripts/04_assemble.sh

# Generate consensus sequence
source ${ROOT}/scripts/05_call_consensus.sh

# Run the entire pipeline
run_pipeline() {
  download_data
  trim_adapters
  map_and_filter
  run_flye_assembler
  run_medaka
}

# Run the entire pipeline
run_pipeline
