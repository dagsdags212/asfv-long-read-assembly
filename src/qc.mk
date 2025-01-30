# Path to concatenated fastq files.
READS = input/all_reads.fastq

# Path to trimmed reads.
TRIMMED_READS = output/01_all_reads.trimmed.fastq

# Path to filterd reads.
FILTERED_READS = output/02_all_reads.trimmed.filtered.fastq


usage:
	@echo ""
	@echo "qc.mk: perform adapter trimming and quality filtering"
	@echo ""
	@echo "Commands:"
	@echo ""
	@echo "  run       perform trimming and filtering in one command"
	@echo "  trim      perform automatic adapter trimming with porechop"
	@echo "  filter    perform filtering of low quality reads with chopper"
	@echo "  clean     delete all files generated by this program"

run: trim filter

${READS}:
	mkdir -p $(dir $@)
	cat reads/*.fastq > $@

# Perform adapter trimming.
${TRIMMED_READS}: ${READS}
	mkdir -p $(dir $@)
	# Trim adapters with porechop.
	porechop -i $< --discard_middle -v 2 --format fastq > $@

# Perform quality filtering.
${FILTERED_READS}: ${TRIMMED_READS}
	# Filter low quality reads with chopper.
	chopper -i $< -q 10 -l 500 > $@

# Generate trimmed reads.
trim: ${TRIMMED_READS}
	ls -lh $<

# Generate filtered reads.
filter: ${FILTERED_READS}
	ls -lh $<

# Delete trimmed reads.
trim!:
	rm -f ${TRIMMED_READS}

# Delete filtered reads.
filter!:
	rm -f ${FILTERED_READS}

# Delete all output.
clean: trim! filter!

.PHONY: trim trim! filter filter! clean run
