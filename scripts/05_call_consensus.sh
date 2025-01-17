#!/usr/bin/env bash

# Name of current script
FILENAME=$(basename "$0")

run_medaka() {
  rm -rf output/medaka
  mkdir -p output/medaka
  local assembly=output/flye/assembly.fasta
  local reads=output/samtools/filtered_reads.fastq

  echo "[${FILENAME}] Generating consensus from base calls"
  # Generate sequence consensus
  medaka_consensus -i ${reads} -d ${assembly} -o output/medaka -t 8
}
