#!/usr/bin/env bash

# Perform de novo assembly with flye
run_flye_assembler() {
  local reads=output/samtools/filtered_reads.fastq
  mkdir -p output/flye
  flye --nano-hq ${reads} --genome-size 200000 --meta -o output/flye
}
