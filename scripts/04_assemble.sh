#!/usr/bin/env bash

# Perform de novo assembly with flye
run_flye_assembler() {
  mkdir -p output/flye
  flye --nano-hq output/unmapped.complete.fastq.gz \
    --genome-size 200000 --meta -o output/flye
}
