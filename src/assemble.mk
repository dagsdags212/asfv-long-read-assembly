READS ?= output/05_unmapped.fq

# Path to swine reference genome.
SWINE_REF ?= refs/GCF_000003025.6_Sscrofa11.1_genomic.fna

# Path to target assemble file.
CONTIGS ?= output/flye/assembly.fasta

# Path to target consensus file.
CONSENSUS ?= output/medaka/consensus.fasta

# Number of CPUs.
THREADS ?= 10

usage:
	@echo ""
	@echo "assemble.mk: de novo assembly with Flye"
	@echo ""
	@echo "Commands:"
	@echo ""
	@echo "  run          generate assembly and consensus"
	@echo "  assemble     invoke sequence assembly"
	@echo "  consensus    polish draft assembly"
	@echo ""

run: assemble consensus

${CONTIGS}: ${READS}
	# Create output directory for flye.
	mkdir -p $(dir $@)

	# Run flye assembly.
	flye --nano-hq $< --genome-size 0.2m --meta --threads ${THREADS} --iterations 5 -o $(dir $@)
	
	# Link contig file to root of output directory.
	ln -s $(abspath $@) $(abspath $(dir $@))/06_assembly.fa

${CONSENSUS}: ${CONTIGS} ${READS}
	# Create output directory for medaka.
	mkdir -p $(dir $@)

	# Run consensus calling.
	medaka_consensus -i ${READS} -d ${CONTIGS} -o $(dir $@) -t ${THREADS}

	# Link consensus file to root of output directory.
	ln -s $(abspath $@) $(abspath $(dir $@))/07_consensus.fa

assemble: ${CONTIGS}
	ls -lh $<

consensus: ${CONSENSUS}
	ls -lh $<

stats:
	seqkit stats ${CONTIGS} ${CONSENSUS}

run!:
	rm -rf $(dir ${CONTIGS})
	rm -rf $(dir ${CONSENSUS})

.PHONY: usage run run! stats
