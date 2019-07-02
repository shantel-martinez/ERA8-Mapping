open $in,'<',"@ARGV[0]/counted.screened";
open $out,'>',"@ARGV[0]/AllReads.fasta";
while($lin=<$in>)
{
chomp $lin;
print $out ">$lin\n$lin\n";
}
exit;

