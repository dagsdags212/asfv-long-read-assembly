#!/usr/bin/env bash

run_medaka() {
  rm -rf output/medaka
  mkdir -p output/medaka
  local assembly=output/flye/assembly.fasta
  local reads=output/samtools/filtered_reads.fastq

  # Generate sequence consensus
  medaka_consensus -i ${reads} -d ${assembly} -o output/medaka -t 8
}
