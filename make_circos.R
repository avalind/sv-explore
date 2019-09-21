library(StructuralVariantAnnotation)
library(circlize)


load_data <- function(vcf_path, genome="hg19") {
	vcf.file <- VariantAnnotation::readVcf(vcf_path, genome)
	breaks <- breakpointRanges(vcf.file)
	seqlevelsStyle(breaks) <- "UCSC"
	return(breaks)
	#pairs <- breakpointgr2pairs(breaks)
	#return(pairs)
}

select_interchrom <- function(breaks) {
	return(breaks[seqnames(breaks) != seqnames(partner(breaks))] )
}

select_intrachrom <- function(breaks, chr="all") {
	if(chr == "all") {
		return(breaks[seqnames(breaks) == seqnames(partner(breaks))])
	} else {
		t <- breaks[seqnames(breaks)==chr]
		return(t[seqnames(breaks) == seqnames(partner(breaks))])
	}
}

plot_data <- function(pair_data) {
	circos.initializeWithIdeogram()
	circos.genomicLink(as.data.frame(S4Vectors::first(pair_data)),
			   as.data.frame(S4Vectors::second(pair_data)))
}


make_plots <- function(vcf_path, plot_base) {
	data <- load_data(vcf_path)

	inter_chrom <- breakpointgr2pairs(select_interchrom(data))
	intra_chrom <- breakpointgr2pairs(select_intrachrom(data))

	pdf(paste0("interchrom_", plot_base, ".pdf"), width=10, height=10)
	plot_data(inter_chrom)
	dev.off()
	pdf(paste0("intrachrom_", plot_base, ".pdf"), width=10, height=10)
	plot_data(intra_chrom)
	dev.off()
}
