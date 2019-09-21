BEGIN {
	INSERT="##INFO=<ID=MATEID,Number=1,Type=String,Description=\"ID of mate\">"
}
{
	if(NR == 37) {
		print INSERT
	}
	print $0
}
