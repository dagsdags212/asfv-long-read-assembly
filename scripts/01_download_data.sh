#!/usr/bin/env bash

# Name of current script
FILENAME=$(basename "$0")

DATADIR=data
GENOMESDIR=${DATADIR}/genomes
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
    echo "[${FILENAME}] Retrieving run info for ${PRJNA}"
    esearch -db sra -query ${PRJNA} |
      efetch -format runinfo >${target}
  else
    echo "[${FILENAME}] Run info for ${PRJNA} already downloaded"
  fi
}

# Extract list of accessions from run info
extract_accessions() {
  local target=${ACCESSIONS}
  if [ ! -f "${target}" ]; then
    echo "[${FILENAME}] Extracting accessions from runinfo"
    cat ${RUNINFO} |
      cut -d, -f1 |
      tail -n +2 >${ACCESSIONS}
  else
    echo "[${FILENAME}] Accession list already exists"
  fi
}

# download all reads and store in separated directories
download_reads() {
  # fetch reads from SRA
  cat ${ACCESSIONS} |
    parallel -- fastq-dump --origfmt --split-3 -O ${RAW_READS} {}
}

# Retrieve the swine reference file from NCBI
download_swine_ref() {
  local target=data/genomes/swine_ref.fna
  if [ ! -f "${target}" ]; then
    echo "[${FILENAME}] Downloading swine reference genome (${GCF})"
    datasets download genome accession ${GCF} --filename swine_ref.zip
    unzip swine_ref.zip -d ref/
    mv ref/ncbi_dataset/data/GCF_000003025.6/GCF_000003025.6_Sscrofa11.1_genomic.fna ${target}
    rm -rf ref
  else
    echo "[${FILENAME}] Reference genome already downloaded"
  fi
}

download_assembly() {
  echo "[${FILENAME}] Downloading ASFV assembly (${ASM})"
  local target=data/genomes/${ASM}.fa
  efetch -db nuccore -id ${ASM} -format fasta >${target}
}

download_genomes() {
  local target=data/genomes/genomes.fa
  if [ ! -f "${target}" ]; then
    echo "[${FILENAME}] Fetching RefSeq genomes"
    efetch -db nuccore -input data/refseq.accessions.txt -format fasta >${target}
    # Append assembly
    efetch -db nuccore -id ${ASM} -format fasta >>${target}
  else
    echo "[${FILENAME}] Refseq genomes already downloaded"
  fi
}

# Run to download sequencing reads and the reference file
download_data() {
  init
  fetch_runinfo
  extract_accessions
  # download_reads[${FILENAME}]
  download_swine_ref
  download_assembly
  download_genomes
}
