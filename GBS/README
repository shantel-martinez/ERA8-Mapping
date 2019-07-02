# About procgbs.pl  
## README   

Author: Dan Z Skinner | USDA-ARS  Wheat Health, Genetics, and Quality Research | Pullman, WA

This set of scripts processes raw sequence reads in fasta format resulting in presence absence calls and allele calls for short sequence tags of user- defined length.  

### Preliminaries:    

Check that all required scripts and files are in the same directory. The scripts needed are:  

> allinone.settings  
> callNOLalleles.pl  
> callNOLalleles2.pl  
> callalleles.pl  
> makefasta.pl  
> procgbs.pl  
> scanforhets.pl  
> scanforhetsknown.pl  
> scanforhetsshow.pl  

1.	You must have soap (Li R, Yu C, Li Y, Lam TW, Yiu SM, Kristiansen K, Wang J. 2009. SOAP2: an improved ultrafast tool for short read alignment. Bioinformatics: 25(15):1966-7. doi: 10.1093/bioinformatics/btp336.)  and agrep (https://www.tgries.de/agrep) installed.  

2.	A soap index of the genome of interest in its own directory is needed. A separate index for each chromosome is recommended.    

### Operation:    

1.	Use a flat text editor such as vi to edit the file `allinone.settings`. The comment lines (starting with `#`) describe the information required on the next line. Do not delete any lines. Save your changes and exit the editor.  
2. From the command prompt, enter `perl procgbs.pl &`  

   > Processing time varies depending on file size and number of samples, but as a very approximate rule, one sample running on one core takes about 16 hours to run. So, 30 samples running on 30 cores also should take about 16 hours.    

### Results:  

1.	A new folder named `./Analysis` will be created in your samples directory. Several output files are created with allele information for tags of known location, and separate files of tags not found in the genome sequence also are created.  
2.	In the sample file directory are new files with the sample name and the `.scr` extension. The `.scr` extension indicates the "screened" sequence data based on the length and frequency you specified in the `allinone.settings`' file. The screened data is what is actually used in the analysis.  
3.	A new folder named `./work` will also be created in your samples directory. This directory holds numerous temporary files used in the analysis process. They are provided for those interested in seeing how the scripts work and may be safely deleted.  


