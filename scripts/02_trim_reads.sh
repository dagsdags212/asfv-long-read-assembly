#!/usr/bin/env bash

# Search for adapters and trim
run_porechop() {
  local target=trimmed
  mkdir -p ${target}
  parallel -j 4 -a data/accessions.txt \
    "porechop -i ${RAW_READS}/{}.fastq --discard_middle -v 2 >${TRIMMED_READS}/{}.trimmed.fastq"
}
