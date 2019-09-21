#!/usr/bin/env python
import sys
import pysam


def get_mate_id(var_id):
    p = var_id.split("_")
    if p[2] == "1":
        return "{}_{}_2".format(p[0], p[1])
    elif p[2] == "2":
        return "{}_{}_1".format(p[0], p[1])
    else:
        pass


def main():
    if len(sys.argv) < 2:
        print("fixer.py [vcf input]")
    else:
        # this is an ugly hack.
        # which kind of assumes that you manually add an ##INFO
        # field in the vcf header, otherwise pysam/htslib get a fit.
        vcf_file = pysam.VariantFile(sys.argv[1])
        vcf_out = pysam.VariantFile("-", "w", header=vcf_file.header)
        for record in vcf_file.fetch():
            var_id = record.id
            mate_id = get_mate_id(var_id)
            record.info["MATEID"] = mate_id
            vcf_out.write(record)


if __name__ == "__main__":
    main()
