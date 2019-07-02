open $incombo,'<',"@ARGV[0]";
open $outcombo,'>',"@ARGV[0].out";
while ($read1=<$incombo>)
{
@rdprts=split /\t/,$read1;
    @allelepair=`agrep -1 $rdprts[0] @ARGV[1]`;
    $Grandcnt=pop @allelepair;
    @grndprts=split / /,$Grandcnt;
    $chcnt=$grndprts[2];
    if($chcnt==2)
    {
        $existchk=`grep -ch $rdprts[0] @ARGV[0].out`;
        chomp $existchk;
        if($existchk == 0)
        {
            @rd1prts=split /\t/,$allelepair[0];
            @rd2prts=split /\t/,$allelepair[1];
            chomp $rd2prts[0];
            chomp $rd1prts[0];
            callalleles();
}
}
}
sub callalleles
{
foreach $pr (@allelepair){chomp $pr;print $outcombo "$pr\n";}
$howmany=scalar @rd1prts;
@indbases1=split //,$rd1prts[0];
@indbases2=split //,$rd2prts[0];
$howmany1=scalar @indbases1;
$howmany2=scalar @indbases2;
for $xpnt (0..($howmany1-1))
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
$A=0;$B=0;$H=0;$U=0;
for $ypnt (1..($howmany-1))
    {
        if($rd1prts[$ypnt] == 1 && $rd2prts[$ypnt] == 1){print $outcombo "\tH";++$H;}
        if($rd1prts[$ypnt] == 1 && $rd2prts[$ypnt] == 0){print $outcombo "\tA";++$A}
        if($rd1prts[$ypnt] == 0 && $rd2prts[$ypnt] == 1){print $outcombo "\tB";++$B}
        if($rd1prts[$ypnt] == 0 && $rd2prts[$ypnt] == 0){print $outcombo "\tU";++$U}
    }
    print $outcombo "\nA=$A B=$B H=$H U=$U\n\n";
}

