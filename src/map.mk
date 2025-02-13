BASENAME = all_reads

# Path to filtered reads.
FILTERED_READS = output/02_${BASENAME}.trimmed.filtered.fastq

# Path to swine reference genome.
SWINE_REF = refs/GCF_000003025.6_Sscrofa11.1_genomic.fna

# Path to target SAM file.
SAM = output/03_complete_aln.sam

# Path to target unmapped SAM file.
UNMAPPED_SAM = output/04_unmapped.sam

# Path to target unmapped FASTQ file.
UNMAPPED_FQ = output/05_unmapped.fq


usage:
	@echo ""
	@echo "map.mk: perform host-read filtering with minimap2 and samtools"
	@echo ""
	@echo "Commands:"
	@echo ""
	@echo "  run       an alias for 'filter'"
	@echo "  filter    filter unmapped reads and convert to FASTQ format"
	@echo "  clean     remove all output generated by this program"
	@echo ""

run: filter

# Swine reference genome must exist.
${SWINE_REF}:
	@[ -z ${REF} ] || echo "Error: swine reference file not found" && exit -1

${SWINE_REF}.fai: ${SWINE_REF}
	samtools faidx $<

# Align filtered reads to swine genome.
${SAM}: ${SWINE_REF}.fai ${FILTERED_READS}
	# Create directory for BAM file
	mkdir -p $(dir $@)

	# Perform read mapping with minimap2.
	minimap2 -a -x map-ont $^ > $@

${UNMAPPED_SAM}: ${SAM}
	samtools view -S -f 4 $< > $@

${UNMAPPED_SAM}.gz: ${UNMAPPED_SAM}
	bgzip $< > $@
	samtools index $<

${UNMAPPED_FQ}: ${UNMAPPED_SAM}
	samtools fastq $< > $@

filter: ${UNMAPPED_FQ}
	ls -lh $<

stats: ${UNMAPPED_SAM}
	samtools flagstats $<

filter!:
	rm -f ${UNMAPPED_FQ}

clean: 
	rm -f ${SAM}
	rm -f ${UNMAPPED_SAM}
	rm -f ${UNMAPPED_FQ}

.PHONY: filter filter! stats run
