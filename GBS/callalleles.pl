open $incombo,'<',"$ARGV[0]/CombinedGrep.out";
open $outcombo,'>',"$ARGV[0]/CombinedGrepPlusAlleles.out";
while ($read1=<$incombo>)
{
@rd1prts=split /\t/,$read1;
$chcnt=`grep $rd1prts[1] $ARGV[0]/CombinedGrep.out|grep -c $rd1prts[2]`;

if($chcnt==2)
{
$read2=<$incombo>;
@rd2prts=split /\t/,$read2;
if($rd1prts[1] eq $rd2prts[1] && $rd1prts[2] eq $rd2prts[2]){callalleles();}
}
}
sub callalleles
{
print $outcombo "$read1$read2";
$howmany=scalar @rd1prts;
@indbases1=split //,$rd1prts[0];
@indbases2=split //,$rd2prts[0];
for $xpnt (0..(scalar @indbases1)-1)
{
if ($indbases1[$xpnt] eq $indbases2[$xpnt]){print $outcombo "$indbases1[$xpnt]";}
else
    {
        if ($indbases1[$xpnt] eq "A" && $indbases2[$xpnt] eq "C"){print $outcombo "M";}
        if ($indbases2[$xpnt] eq "A" && $indbases1[$xpnt] eq "C"){print $outcombo "M";}
        if ($indbases1[$xpnt] eq "A" && $indbases2[$xpnt] eq "G"){print $outcombo "R";}
        if ($indbases2[$xpnt] eq "A" && $indbases1[$xpnt] eq "G"){print $outcombo "R";}
        if ($indbases1[$xpnt] eq "A" && $indbases2[$xpnt] eq "T"){print $outcombo "W";}
        if ($indbases2[$xpnt] eq "A" && $indbases1[$xpnt] eq "T"){print $outcombo "W";}
        if ($indbases1[$xpnt] eq "C" && $indbases2[$xpnt] eq "G"){print $outcombo "S";}
        if ($indbases2[$xpnt] eq "C" && $indbases1[$xpnt] eq "G"){print $outcombo "S";}
        if ($indbases1[$xpnt] eq "C" && $indbases2[$xpnt] eq "T"){print $outcombo "Y";}
        if ($indbases2[$xpnt] eq "C" && $indbases1[$xpnt] eq "T"){print $outcombo "Y";}
        if ($indbases1[$xpnt] eq "G" && $indbases2[$xpnt] eq "T"){print $outcombo "K";}
        if ($indbases2[$xpnt] eq "G" && $indbases1[$xpnt] eq "T"){print $outcombo "K";}
    }
}
print $outcombo "\t$rd1prts[1]\t$rd1prts[2]";
$A=0;$B=0;$H=0;$U=0;
for $ypnt (3..($howmany-1))
    {
        if($rd1prts[$ypnt] == 1 && $rd2prts[$ypnt] == 1){print $outcombo "\tH";++$H;}
        if($rd1prts[$ypnt] == 1 && $rd2prts[$ypnt] == 0){print $outcombo "\tA";++$A;}
        if($rd1prts[$ypnt] == 0 && $rd2prts[$ypnt] == 1){print $outcombo "\tB";++$B;}
        if($rd1prts[$ypnt] == 0 && $rd2prts[$ypnt] == 0){print $outcombo "\tU";++$U;}
    }
print $outcombo "\nA=$A B=$B H=$H U=$U\n\n";
}

