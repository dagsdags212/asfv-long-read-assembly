#!/usr/bin/env bash

count_reads() {
  local target=data/reads/$1
  for fq in $(find ${target} -type f -name "*fastq*"); do
    echo ${fq} has $(grep -E "^@[[:alnum:]]{1,8}" ${fq} | wc -l) reads
  done
}

echo "==========================="
echo "Read counts BEFORE trimming"
echo "==========================="
count_reads raw

echo "=========================="
echo "Read counts AFTER trimming"
echo "=========================="
count_reads trimmed

# Running this script would produce the following output:
#
# ===========================
# Read counts BEFORE trimming
# ===========================
# data/reads/raw/SRR31340506/SRR31340506.fastq has 169057 reads
# data/reads/raw/SRR31340507/SRR31340507.fastq has 159080 reads
# data/reads/raw/SRR31340509/SRR31340509.fastq has 117509 reads
# data/reads/raw/SRR31340505/SRR31340505.fastq has 119025 reads
# data/reads/raw/SRR20073667/SRR20073667.fastq has 1422 reads
# data/reads/raw/SRR31340513/SRR31340513.fastq has 126623 reads
# data/reads/raw/SRR31340508/SRR31340508.fastq has 117438 reads
# data/reads/raw/SRR31340510/SRR31340510.fastq has 272869 reads
# data/reads/raw/SRR31340511/SRR31340511.fastq has 270246 reads
# data/reads/raw/SRR31340512/SRR31340512.fastq has 191110 reads
#
# ==========================
# Read counts AFTER trimming
# ==========================
# data/reads/trimmed/SRR31340507.trimmed.fastq has 158095 reads
# data/reads/trimmed/SRR31340509.trimmed.fastq has 116751 reads
# data/reads/trimmed/SRR31340508.trimmed.fastq has 116314 reads
# data/reads/trimmed/SRR31340513.trimmed.fastq has 126125 reads
# data/reads/trimmed/SRR31340505.trimmed.fastq has 117365 reads
# data/reads/trimmed/SRR31340512.trimmed.fastq has 190793 reads
# data/reads/trimmed/SRR20073667.trimmed.fastq has 1422 reads
# data/reads/trimmed/SRR31340510.trimmed.fastq has 273697 reads
# data/reads/trimmed/SRR31340511.trimmed.fastq has 270719 reads
# data/reads/trimmed/SRR31340506.trimmed.fastq has 170238 reads
