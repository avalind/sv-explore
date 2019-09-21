#!/bin/bash
OUTFILE=$(basename $1 | cut -d '_' -f 1)
bcftools filter -i 'FILTER="PASS"&&SVTYPE="BND"' $1 | bcftools filter -i 'INFO/LFA>3&INFO/LFB>3' - > "$OUTFILE.temp.vcf"
python fixer.py <(awk -f headerfix.awk "$OUTFILE.temp.vcf") > "$OUTFILE.final.vcf"
