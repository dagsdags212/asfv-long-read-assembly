# Path to draft assembly.
ASM ?= output/06_draft_assembly.fa
#ASM ?= output/06_consensus.fa

# Path of fasta file containing refseq sequences.
FA = input/refseqs.fa

# Path to target alignment file.
ALN = output/07_mafft_aln.fa

# Path to target iqtree output.
TREE = output/iqtree/$(basename ${ALN}).iqtree

# Number of CPU cores.
THREADS ?= 8

# Nucleotide substitution model.
MODEL ?= GTR+F+R3


usage:
	@echo ""
	@echo "phylo.mk: align reference sequences for tree generation"
	@echo ""
	@echo "Commands:"
	@echo ""
	@echo "  run      align + tree"
	@echo "  align    perform multiple sequence alignment"
	@echo "  tree     generate a phylogenetic tree from an MSA"
	@echo ""

run: align tree

${FA}: ${ASM}
	cat $(shell find refs -name "*.fa") > ${FA}
	cat ${ASM} >> ${FA}

${ALN}: ${FA}
	mafft --thread ${THREADS} ${FA} > ${ALN}

align: ${ALN}
	ls -lh ${ALN}

${TREE}: ${ALN}
	# Create outpit directory for iqtree.
	mkdir -p $(dir $@)

	# Run bootstrap inference.
	iqtree -s ${ALN} -m ${MODEL} -B --nmax 1000 \
		-nt ${THREADS} -s $(dir $@) -pre $(basename $<)

tree: ${TREE}
	ls -lh $(dir $<)

align!:
	rm -f ${ALN}

tree!:
	rm -rf $(dir ${TREE})

clean: align! tree!

.PHONY: align align! clean
