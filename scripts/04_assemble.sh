#!/usr/bin/env bash

# Name of current script
FILENAME=$(basename "$0")

# Perform de novo assembly with flye
run_flye_assembler() {
  echo "[${FILENAME}] Performing de novo assembly with flye"
  local reads=output/samtools/filtered_reads.fastq
  mkdir -p output/flye
  flye --nano-hq ${reads} --genome-size 0.2m --meta --threads 12 --iterations 5 -o output/flye
}
