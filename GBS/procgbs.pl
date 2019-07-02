open $sets,'<',"allinone.settings";
$def=<$sets>;
$wdir=<$sets>;chomp $wdir;
$def=<$sets>;
$ft=<$sets>;chomp $ft;
$def=<$sets>;
$cores=<$sets>;chomp $cores;
$def=<$sets>;
$len=<$sets>;chomp $len;
$def=<$sets>;
$readdepth=<$sets>;chomp $readdepth;
$def=<$sets>;
$tagstart=<$sets>;chomp $tagstart;
$def=<$sets>;
$lowfreq=<$sets>;chomp $lowfreq;
$def=<$sets>;
$highfreq=<$sets>;chomp $highfreq;
$def=<$sets>;
$genomedir=<$sets>;chomp $genomedir;
close $sets;
print"\n\nNow running with these parameters:\n\nworking directory: $wdir\nfile type: $ft\ncores: $cores\ntag length: $len\nread depth: $readdepth\ntag start:$tagstart\nlow frequency:$lowfreq\nhigh frequency:$highfreq\nGenome sequence directory: $genomedir\n\n";
$fls=`ls $wdir/*$ft|sed \'s#^.*/##g\'|sed \'s#$ft\$##\'|tr \'\n\' \'\t\'`;
$wkdir ="$wdir/work";$adir="$wdir/Analysis";$sdir="$wdir/work/scratch";
@fl=`ls $wdir\/*$ft`;
unless( -e $wkdir){mkdir $wkdir, 0755;}
unless( -e $sdir){mkdir $sdir, 0755;}
unless( -e $adir){mkdir $adir, 0755;}
open $knownhead ,'>', "$wkdir/knownhead";
print $knownhead "Tag\tChromosome\tLocation\t$fls\n";
close $knownhead;
open $unknownhead, '>', "$wkdir/unknownhead";
print $unknownhead "Tag\t$fls\n";
close $unknownhead;

open $soapout,'>',"$wdir/work/runsoap.sh";
@indexlist=`ls $genomedir/*.index.sai|sed 's#\.index\.sai##'|sed 's#^.*\/##'`;
foreach $a (@indexlist)
{
chomp $a;
print $soapout "soap -a $wkdir/AllReads.fasta -D $genomedir/$a.index -o $wdir/work/soap$a.out -r 2 -p 2 -v 1 &
wait$a=\$\!\n";
}
foreach $a (@indexlist){print $soapout "wait \$wait$a\n";}
print $soapout "LC_ALL=C && cut -f1  $wdir/work/soap*.out|sort -T $sdir|uniq -c|sed 's#^ *##'|tr ' ' '\\t'|awk '\$1 == 1'|awk '{print \$2}'>$wdir/work/onehit && cut -f1,8,9 $wdir/work/soap*.out>$wdir/work/all.out && sort -T $sdir -k1,1 $wdir/work/all.out >$wdir/work/all.out.srt && sort -T $sdir -k1,1 $wdir/work/onehit >$wdir/work/onehit.srt && join -1 1 -2 1 $wdir/work/onehit.srt $wdir/work/all.out.srt>$wdir/work/joined && sort -T $sdir -k2,2 -k3,3n $wdir/work/joined|tr ' ' '\\t'>$wdir/work/joined.srt";

$coretrk=1;$filecount=scalar @fl;
foreach $xy (@fl)
{
chomp $xy;
    open $outy, ">>$wkdir/y$coretrk";print $outy "$xy\n";close $outy;
    if ($coretrk==$cores){$coretrk=1;}else{++$coretrk;}
}
open $shellout, '>', "$wdir/work/launchshell1.sh";

foreach $thread (1..$cores)
{
	$eofflag=0;
open $in, '<', "$wdir/work/y$thread";
open $out, '>', "$wdir/work/sh$thread";
while ($readin=<$in>)
{
if(eof){$eofflag=1;}
chomp $readin;
unless ($eofflag==1){print $out "cut -c1-$len $readin |grep ^$tagstart|awk 'length (\$1) == $len'|sort -T $sdir|uniq -c|sed 's#^ *##'|tr ' ' '\\t'|awk '\$1 >= $readdepth'|sed 's#^.*\\t##' > $readin.scr && ";}
else{print $out "cut -c1-$len $readin |grep ^$tagstart|awk 'length (\$1) == $len'|sort |uniq -c|sed 's#^ *##'|tr ' ' '\\t'|awk '\$1 >= $readdepth'|sed 's#^.*\\t##' > $readin.scr\n";
print $shellout "sh $wdir/work/sh$thread \&\nmypid$thread=\$\!\n";}
}
close $out;
close $in;
}

foreach $job (1..$cores)
{
print $shellout "wait \$mypid$job\n";
}
print $shellout "sort -T $sdir -m $wdir/*.scr|uniq -c|sed 's#^ *##'|tr ' ' '\\t' |awk '(\$1) >= ($filecount*$lowfreq) && (\$1 <= $filecount*$highfreq)' |awk '{print \$2}'> $wkdir/counted.screened && perl makefasta.pl $wkdir && sh $wdir/work/runsoap.sh";
close $shellout;
system("sh $wdir/work/launchshell1.sh");
$grepcnt1=`wc -l $wdir/work/joined.srt`;
@grepcnt=split / /, $grepcnt1;
$subsetg=int(($grepcnt[0]/$cores)+1);
open $in,'<',"$wdir/work/joined.srt";
$y=1;
$x=0;
open $out, '>', "$wdir/work/g$y";
while($lin=<$in>)
{
if($x==$subsetg){$x=0;++$y;close $out;open $out, '>', "$wdir/work/g$y";}
print $out "$lin";
++$x;
}

for $gcnt (1..$cores)
{
open $lnchout,'>', "$wdir/work/launch$gcnt.pl";
print $lnchout "open \$in, \'<\', \"$wdir/work/g$gcnt\";
open \$out, \'>\', \"$wdir/work/g$gcnt.out\";
while(\$lin=<\$in>)
{
chomp \$lin;
\@linp=split /\\t/,\$lin;
\$grepout=`grep -ch \$linp[0] $wdir/*.scr|tr \'\\n\' \'\\t\'`;
print \$out \"\$linp[0]\\t\$linp[1]\\t\$linp[2]\\t\$grepout\\n\";
}";
close $lnchout;
}
open $nxtstep,'>',"$wdir/work/grepandcombine.sh";
for $gcnt (1..$cores)
{print $nxtstep "perl $wdir/work/launch$gcnt.pl & grpwait$gcnt=\$\!\n";}
for $gcnt (1..$cores)
{print $nxtstep "wait \$grpwait$gcnt\n";}
print $nxtstep "cat $wdir/work/g*.out|sed 's#\\t\$##' >$wdir/work/CombinedGrep.out && perl callalleles.pl $wdir/work && perl scanforhetsknown.pl $wkdir && cat $wkdir/knownhead $wkdir/CombinedGrep.out>$adir/KnownLocationTags.txt && cat $wkdir/knownhead $wkdir/CombinedGrepPlusAlleles.out>$adir/KnownLocationTagAlleles.txt && cat $wkdir/knownhead $wkdir/KnownLocalleles5pctHet.out> $adir/KnownLocationAlleles5pctHet.out && cat $wkdir/knownhead $wkdir/KnownLocalleles10pctHet.out>$adir/KnownLocationAlleles10pctHet.out &\n";
close $nxtstep;
system("sh $wdir/work/grepandcombine.sh &");

#tabulate the no location tags
system("cut -f1 $wdir/work/joined.srt|sort -T $sdir -u >$wdir/work/foundingenome && comm -13 $wdir/work/foundingenome $wkdir/counted.screened >$wdir/work/nolocation");

$grepcnt1=`wc -l $wdir/work/nolocation`;
@grepcnt=split / /, $grepcnt1;
$subsetg=int(($grepcnt[0]/$cores)+1);
open $in,'<',"$wdir/work/nolocation";
$y=1;
$x=0;
open $out, '>', "$wdir/work/nol$y";
while($lin=<$in>)
{
if($x==$subsetg){$x=0;++$y;close $out;open $out, '>', "$wdir/work/nol$y";}
print $out "$lin";
++$x;
}

for $gcnt (1..$cores)
{
open $lnchout,'>', "$wdir/work/nollaunch$gcnt.pl";
print $lnchout "open \$in, \'<\', \"$wdir/work/nol$gcnt\";
open \$out, \'>\', \"$wdir/work/nol$gcnt.out\";
while(\$lin=<\$in>)
{
chomp \$lin;
\$grepout=`grep -ch \$lin $wdir/*.scr|tr \'\\n\' \'\\t\'`;
print \$out \"\$lin\\t\$grepout\\n\";
}";
close $lnchout;
}
open $nxtstep,'>',"$wdir/work/nolgrepandcombine.sh";
for $gcnt (1..$cores)
{print $nxtstep "perl $wdir/work/nollaunch$gcnt.pl & nolgrpwait$gcnt=\$\!\n";}
for $gcnt (1..$cores)
{print $nxtstep "wait \$nolgrpwait$gcnt\n";}

#print $nxtstep "cat $wdir/work/nol*.out|sed 's#\\t\$##' >$wdir/work/NOLCombinedGrep.out && perl callNOLalleles.pl $wdir/work && perl scanforhets.pl $wdir/work && cat $wkdir/unknownhead $wdir/work/NOLCombinedGrep.out>$adir/UnknownLocationTags.txt && cat $wkdir/unknownhead $wkdir/NOLalleles10pctHet.out>$adir/UnknownLocationAlleles10pctHet.txt && cat $wkdir/unknownhead $wkdir/NOLalleles5pctHet.out>$adir/UnknownLocationAlleles5pctHet.txt && rm -rf $wkdir && rm $wdir/*.scr\n";
print $nxtstep "cat $wdir/work/nol*.out|sed 's#\\t\$##' >$wdir/work/NOLCombinedGrep.out";
close $nxtstep;
system("sh $wdir/work/nolgrepandcombine.sh");

$NOLlines=`wc -l $wdir/work/NOLCombinedGrep.out|cut -d" " -f1`;
chomp $NOLlines;
$subsetcnt=int($NOLlines/$cores)+1;
open $innol,'<',"$wdir/work/NOLCombinedGrep.out";
$y=1;
open $subout,'>',"$wdir/work/nolsub$y";
while ($onerd=<$innol>)
{
    $x=1;
    do
    {
        print $subout "$onerd";++$x;
        $onerd=<$innol>;
    }until($x==$subsetcnt+1);
    ++$y;
    close $subout;
    unless($y>$cores){open $subout,'>',"$wdir/work/nolsub$y";
        print $subout "$onerd";}
}
close $subout;

open $launchcall,'>',"$wdir/work/launchnolcalls.sh";
for $z (1..$cores)
{print $launchcall "perl callNOLalleles2.pl $wdir/work/nolsub$z $wdir/work/NOLCombinedGrep.out \&\nmypidlnch$z=\$\!\n";}
for $zcnt (1..$cores)
{print $launchcall "wait \$mypidlnch$zcnt\n";}
print $launchcall "cat $wdir/work/nolsub*.out > $wdir/work/NOLalleles.out && perl scanforhets.pl $wdir/work && cat $wkdir/unknownhead $wdir/work/NOLCombinedGrep.out>$adir/UnknownLocationTags.txt && cat $wkdir/unknownhead $wkdir/NOLalleles10pctHet.out>$adir/UnknownLocationAlleles10pctHet.txt && cat $wkdir/unknownhead $wkdir/NOLalleles5pctHet.out>$adir/UnknownLocationAlleles5pctHet.txt";
close $launchcall;
system("sh $wdir/work/launchnolcalls.sh");
#exec("rm $wdir/*.scr && rm $wdir/AllReads.fasta && rm $wdir/counted.screened && rm -rf $wdir/work\n");
