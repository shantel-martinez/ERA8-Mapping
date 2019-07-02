open $in,'<',"$ARGV[0]/CombinedGrepPlusAlleles.out";
open $out5,'>',"$ARGV[0]/KnownLocalleles5pctHet.out";
open $out10,'>',"$ARGV[0]/KnownLocalleles10pctHet.out";
while($one=<$in>)
{
	$two=<$in>;
	$three=<$in>;
	$four=<$in>;
	$five=<$in>;
	@prts4=split /\=/,$four;
	@acnt=split / /,$prts4[1];#$acnt[0];
	@bcnt=split / /,$prts4[2];#$bcnt[0];
	@hcnt=split / /,$prts4[3];#$hcnt[0];
	chomp $acnt[0]; chomp $bcnt[0]; chomp $hcnt[0];
	$foundcnt=$acnt[0]+$bcnt[0]+$hcnt[0];
	$hfract=$hcnt[0]/$foundcnt;
	if($hfract <= 0.05)
	{
	print $out5 "$one$two$three$four$five";
	}
	if($hfract <= 0.1)
	{
	print $out10 "$one$two$three$four$five";
	}
}
