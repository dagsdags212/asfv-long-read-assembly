#!/usr/bin/env bash

mkdir -p output/medaka

run_medaka() {
  local assembly=output/flye/assembly.fasta
  local reads=output/unmapped.complete.fastq.gz

  # Map reads back to generated assembly
  mini_align -r ${assembly} -i ${reads} -t 8 -p output/medaka/basecalls

  # Generate sequence consensus
  medaka_consensus -i output/medaka/basecalls -d ${assembly} -o output/medaka -t 8
}
