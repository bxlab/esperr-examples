# Chromosomes you want to generate scores for
CHROMOSOMES=$(shell seq 1 19 ) X Y
# Location of the MAF format alignment files and 2bit file for the reference sequence
ALIGN=/aut/bx/james/cache/goldenPath/mm9/multiz30way/anno/maf
SEQ=/aut/bx/james/cache/goldenPath/mm9/mm9.2bit

ESPERR=../esperr-virtualenv/bin
UCSC=/aut/bx/sw/arch/Linux_x86_64/ucsc-genome-utils-279/bin

REF=mm9
SPECIES=mm9,hg18,panTro2,rheMac2,rn3,canFam2,bosTau3
REGIONS=$(CHROMOSOMES)

REORDER=3,0,1,2,4,5,6

MOD=test_1.063
MODEL=tree_pruned:N=10,D=0.01

default:
	echo $(CHROMOSOMES)

all_scores : $(foreach r, $(REGIONS), chr$r.scores)
all_covered : $(foreach r, $(REGIONS), chr$r.covered)

chr%.covered : $(ALIGN)/chr%.maf
	$(ESPERR)/maf_covered_ranges.py $(SPECIES) 4 < $< | $(ESPERR)/bed_merge_overlapping.py > $@

chr%.scores : chr%.covered $(ALIGN)/chr%.maf 
	pv $< \
	| $(ESPERR)/prefix_lines.py "$(REF)." \
	| $(ESPERR)/maf_tile_2bit.py $(SPECIES) $(SEQ) $(ALIGN)/chr$*.maf \
	| $(ESPERR)/maf_translate_chars.py \
	| $(ESPERR)/rp_score_maf.py /dev/stdin $(MOD).sm /dev/stdout -m $(MOD).mapping -w 100 -s 1 -M $(MODEL) \
	> $@

$(REF).sizes : $(SEQ)
	$(UCSC)/twoBitInfo $< $@

chr%.bw : chr%.scores $(REF).sizes
	$(UCSC)/wigToBigWig $^ $@ -clip

.SECONDARY:
