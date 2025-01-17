#!/usr/bin/env bash

ROOT=$(dirname $(dirname $(realpath "$0")))

source ${ROOT}/scripts/globals.sh

create_reads_dir() {
  mkdir -p ${RAW_READS}
  mkdir -p ${TRIMMED_READS}
}

concat_raw_reads() {
  local target=${RAW_READS}/all_reads.raw.fastq.gz
  if [ ! -f "${target}" ]; then
    echo "Concatenating FASTQ files"
    cat ${RAW_READS}/*.fastq.gz >${target}
  else
    echo "Concatenated FASTQ file already exists: ${target}"
  fi
}

# Search for adapters and trim
run_porechop() {
  local target=${TRIMMED_READS}/all_reads.trimmed.fastq.gz
  echo "Performing adapter trimming and quality control"
  porechop -i ${RAW_READS}/all_reads.raw.fastq.gz --discard_middle -v 2 --format fastq.gz >${target}
}

trim_adapters() {
  create_reads_dir
  concat_raw_reads
  run_porechop
}
