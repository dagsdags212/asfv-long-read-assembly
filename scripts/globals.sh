#!/usr/bin/env bash

# Absolute path of project
ROOT=$(dirname $(dirname $(realpath "$0")))

# Sequencing project accession
PRJNA=PRJNA857442

# Reference genome accession
ASM=ON963982.1

# Downloaded genome filepath
SWINE_REF=${ROOT}/data/genomes/swine_ref.fna

# Path to raw reads
RAW_READS=${ROOT}/data/reads/raw

# Path to trimmed reads
TRIMMED_READS=${ROOT}/data/reads/trimmed
