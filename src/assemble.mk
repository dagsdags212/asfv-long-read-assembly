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
	@echo "  run          invoke sequence assembly"
	@echo "  consensus    polish draft assembly"
	@echo ""

${CONTIGS}: ${READS}
	# Create output directory for flye.
	mkdir -p $(dir $@)

	# Run flye assembly.
	flye --nano-hq $< --genome-size 0.2m --meta --threads ${THREADS} --iterations 5 -o $(dir $@)
	
	# Link contig file to root of output directory.
	ln -s ${CONTIGS} output/06_assembly.fa

${CONSENSUS}: ${CONTIGS} ${READS}
	# Create output directory for medaka.
	mkdir -p $(dir $@)

	# Run consensus calling.
	medaka_consensus -i ${READS} -d ${CONTIGS} -o $(dir $@) -t ${THREADS}

	# Link consensus file to root of output directory.
	ln -s $@ output/07_consensus.fa

run: ${CONTIGS} ${CONSENSUS}
	ls -lh ${CONTIGS} ${CONSENSUS}

stats:
	seqkit stats ${CONTIGS} ${CONSENSUS}

run!:
	rm -rf $(dir ${CONTIGS})
	rm -rf $(dir ${CONSENSUS})

.PHONY: usage run run! stats
