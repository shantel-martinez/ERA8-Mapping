# ERA8-Mapping-2019

**Title**: Exome sequencing of bulked segregants identified a novel *TaMKK3-A* allele linked to the wheat *ERA8* ABA-hypersensitive germination phenotype  
**Authors**: Shantel A. Martinez, Oluwayesi Shorinola, Samantha Conselman, Deven See, Daniel Z. Skinner, Cristobal Uauy, and Camille M. Steber  

This repository contains all datasets for the paper, Martinez et al. 2019, and can be used to enable reproducibility of the QTL Mapping and figures created.  

### Access
View the R code, analysis, and figures in the RPub website: [QTL_Mapping_of_ERA8](http://rpubs.com/shantel-martinez/ERA8-Mapping)<br/>

### GBS Analysis 
[README and scripts](https://github.com/shantel-martinez/ERA8-Mapping/tree/master/GBS) are available used for alignment and SNP calls in the Louise/ZakERA8 RIL population.  
Data wrangling from raw .csv files to JoinMap format was conducted in excel.   
All SNPs were included in the JoinMap linkage grouping. Raw data prior to linkage grouping is available upon request.    
The final genetic map, GBS genotypes, and dormancy phenotypes of the Louise/ZakERA8 RIL population is saved as [LZ8_SNP1-SNP30_MKK3.csv](https://github.com/shantel-martinez/ERA8-Mapping/blob/master/data/LZ8_GBS_all.csv) and also in Martinez et al. (2019) SUPPLEMENTAL TABLE 3.   

### File Descriptions   
Multiple files are included in the data analysis.   

ZZ8  "./ZZ8_SNP1-SNP_30_all.csv"  
data5.1  "./ZZ8_SNP1-SNP_30_5.1.csv"  
data5.2a "./ZZ8_SNP1-SNP_30_5.2a.csv"   
data5.2b "./ZZ8_SNP1-SNP_30_5.2b.csv"  

LZ "./LZ8_SNP1-SNP30_MKK3.csv"  
LZ8GBS "./LZ8_GBS_all.csv"  
OZ8 "./OZ8_SNP6-SNP29.csv"  

uniqpos "./GBS_UniquePos.txt"  
uniqposAHH "./GBS_UniquePos_ABAHeadHei.txt"  
ATol "AllTolQTLAlleles.txt"
ParABA "./LZ8ARTC_2014.csv"  
ZParABA "./ZZ8ARTC_E1.csv"
imap  "./ZZ8 5.1 5.2 Group Data for R.csv"
