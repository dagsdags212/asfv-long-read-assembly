
usage:
	@echo ""
	@echo "pipeline.mk: run different steps of the analysis"
	@echo ""
	@echo "Commands:"
	@echo ""
	@echo "  run            run the entire pipeline"
	@echo "  fetch          retrieve all data (reads and sequences) associated with the study"
	@echo "  qc             perform adapter trimming and quality filtering"
	@echo "  map            perform host read filtering and extract unmapped reads as FASTQ file"
	@echo "  assemble       generate draft assembly"
	@echo "  consensus      perform consensus calling for polishing assembly"
	@echo "  tree           generate phylogenetic tree containing assembly and RefSeq genomes"
	@echo ""

run: fetch qc map

fetch:
	@echo "======================="
	@echo "==  Retrieving data  =="
	@echo "======================="
	make -f src/fetch.mk run

qc:
	@echo "======================="
	@echo "==  Quality Control  =="
	@echo "======================="
	make -f src/qc.mk run

map:
	@echo "==========================="
	@echo "==  Host Read Depletion  =="
	@echo "==========================="

assemble:
	@echo "=========================="
	@echo "==  Long-read Assembly  =="
	@echo "=========================="
	make -f src/assemble.mk run
