#!/usr/bin/env bash

DATADIR=data
READSDIR=${DATADIR}/reads
RAW_READS=${READSDIR}/raw
TRIMMED_READS=${READSDIR}/trimmed
RUNINFO=${DATADIR}/runinfo.csv
ACCESSIONS=${DATADIR}/accessions.txt

init() {
  mkdir -p ${DATADIR}
  mkdir -p ${RAW_READS}
  mkdir -p ${TRIMMED_READS}
}

# Retrieve run info from an project ID
fetch_runinfo() {
  local target=${RUNINFO}
  if [ ! -f "${target}" ]; then
    echo "Retrieving run info for ${PRJNA}"
    esearch -db sra -query ${PRJNA} |
      efetch -format runinfo >${target}
  else
    echo "Run info for ${PRJNA} already downloaded"
  fi
}

# Extract list of accessions from run info
extract_accessions() {
  local target=${ACCESSIONS}
  if [ ! -f "${target}" ]; then
    echo "Extracting accessions from runinfo"
    cat ${RUNINFO} |
      cut -d, -f1 |
      tail -n +2 >${ACCESSIONS}
  else
    echo "Accession list already exists"
  fi
}

# download all reads and store in separated directories
download_reads() {
  # create directory for each accession
  cat ${ACCESSIONS} |
    parallel -j 3 -- mkdir -p ${RAW_READS}/{}
  # fetch reads from SRA
  cat ${ACCESSIONS} |
    parallel -- fastq-dump --origfmt --split-3 -O ${RAW_READS}/{} {}
}

# Retrieve the swine reference file from NCBI
download_swine_ref() {
  mkdir -p ref
  datasets download genome accession GCF_000003025.6 --filename swine_ref.zip
  unzip swine_ref.zip -d ref/
  mv ref/ncbi_dataset/data/GCF_000003025.6/GCF_000003025.6_Sscrofa11.1_genomic.fna data/ref.fna
  rm -rf ref
}

# Run to download sequencing reads and the reference file
download_data() {
  init
  fetch_runinfo
  extract_accessions
  download_reads
  download_swine_ref
}
