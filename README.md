# [image](https://github.com/ERASMUSlab/MESIA/assets/135592214/ba741f56-ce6b-467a-88b2-fba686b48272)

<img width="755" alt="image" src="https://github.com/ERASMUSlab/MESIA/assets/135592214/6ee0de9b-ce09-4d50-9780-6c4133a21d27">


Among many methods of measuring chromatin accessibility, Assay for Transposase Accessible Chromatin (ATAC-seq) is widely used. 
As like many other types of next generation sequencing (NGS), researchers include multi-sample replication in ATAC-seq experimental designs 
to compensate for lack of consistency. 
In epigenome analysis, researchers should measure subtle changes in peak considering read depth of individual samples. 
It is very important to determine whether peaks of each replication have integrative meaning for interesting region observed during multi-sample integration. 
Therefore, we developed MSIA that integrates replication with high representative & reproducibility in multi sample replication and determine optimal peak. 
Based on IDR, our methods identify reproducibility between all replications while derives distance from beginning of peak to point and Q value. 
Afterwards, multi samples determined as representative replication are integrated using the distance and Q value. 
When verifying performance based on expression value of gene with a peak formed in promoter, 
MESIA detected 8.61 times more peaks than previously used method, and value (median of gene expression) of the peaks was 1.32 times higher. 
These results indicate that MSIA is less likely to determine false positive peak than previously used method. 
MESIA is a shell script-based open source code that provides researchers involved in epigenome with comprehensive insight into peak and strategies 
for multi-sample integrates.



