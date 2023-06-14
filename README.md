# <b>MESIA</b><br>Multi-Epigenome Sample Integration Approach for Precise Peak Calling

<img width="1000" alt="image" src="https://github.com/ERASMUSlab/MESIA/assets/135592214/6ee0de9b-ce09-4d50-9780-6c4133a21d27">
<br>
<br>

## <b>Features</b>
  Among many methods of measuring chromatin accessibility, Assay for Transposase Accessible Chromatin (ATAC-seq) is widely used. 
  As like many other types of next generation sequencing (NGS), researchers include multi-sample replication in ATAC-seq experimental designs 
  to compensate for lack of consistency. 
  In epigenome analysis, researchers should measure subtle changes in peak considering read depth of individual samples. 
  It is very important to determine whether peaks of each replication have integrative meaning for interesting region observed during multi-sample integration. 
  Therefore, we developed MESIA that integrates replication with high representative & reproducibility in multi sample replication and determine optimal peak. 
  Based on IDR, our methods identify reproducibility between all replications while derives distance from beginning of peak to point and Q value. 
  Afterwards, multi samples determined as representative replication are integrated using the distance and Q value. 
  When verifying performance based on expression value of gene with a peak formed in promoter, 
  MESIA detected 8.61 times more peaks than previously used method, and value (median of gene expression) of the peaks was 1.32 times higher. 
  These results indicate that MSIA is less likely to determine false positive peak than previously used method. 
  MESIA is a shell script-based open source code that provides researchers involved in epigenome with comprehensive insight into peak and strategies 
  for multi-sample integrates.

## <b>Installation</b>
MESIA requires following packages:
+ shuf
+ bedtools
+ samtools
+ macs2
+ featureCounts
+ idr

```
micromamba install --allow-downgrade -y -c conda-forge -c bioconda bedtools
micromamba install --allow-downgrade -y -c conda-forge -c bioconda samtools
micromamba install --allow-downgrade -y -c conda-forge -c bioconda macs2
micromamba install --allow-downgrade -y -c conda-forge -c bioconda subread
micromamba install --allow-downgrade -y -c conda-forge -c bioconda idr
```

## <b>Quick start</b>
  ### <b>1. Install MESIA</b>
  ```shell script
  git clone https://github.com/ERASMUSlab/MESIA.git
  ```
  
  ### <b>2. Input BAM file</b>
  ```shell script
  cd MESIA/MESIA/Input_NF
  cp "Your Input file path" . 
  ```
  
  ### <b>3. Run MESIA</b>
  ```shell script
  cd ../Program
  bash MESIA.sh "Project Name" "BAM file1" "BAM file2" "BAM file3" "BAM file4" "Threads" "mappable genome size"
  ``` 
  example
  ```shell script
  bash MESIA.sh test GM12878_rep1 GM12878_rep2 GM12878_rep3 GM12878_rep4 30 hs
  ```
  mappable genome size section can be hs, mm or others
  
  ## <b>Output</b>
  + MESIA_optimal.narrowPeak
    + chrom - Name of the chromosome (or contig, scaffold, etc.).
    + chromStart - The starting position of the feature in the chromosome or scaffold.
    + chromEnd - The ending position of the feature in the chromosome or scaffold. 
    + name - Name given to a region (preferably unique). Use "." if no name is assigned.
    + score - Indicates how dark the peak will be displayed in the browser (0-1000). 
    + strand - +/- to denote strand or orientation (whenever applicable). Use "." if no orientation is assigned.
    + signalValue - Measurement of overall (usually, average) enrichment for the region.
    + pValue - Measurement of statistical significance (-log10).
    + qValue - Measurement of statistical significance using false discovery rate (-log10).
    + peak - Point-source called for this peak; 0-based offset from chromStart.

  ```shell script
  chr1	4688502	4688766	.	864.75	.	43.566975	110.47625	107.238775	176
  chr1	4688963	4689167	.	891.5	.	46.87355	120.97355	117.6737	91
  chr1	4771118	4771440	.	1000	.	43.736	112.307	109.21	231
  chr1	4776272	4776804	.	1472.25	.	95.801275	287.73925	283.984	192.75
  chr1	4844967	4846600	.	1011.666667	.	69.51251333	201.3756166	197.9333833	691.5
  chr1	4896692	4896898	.	1210.75	.	75.159125	215.3315	211.74	104.25
  chr1	5083128	5083590	.	1018	.	53.2404	140.4385	137.073	91
  chr1	7169526	7171356	.	938	.	28.4947	65.6063	62.7625	259
  chr1	9545419	9547400	.	843.25	.	40.806025	101.765175	98.569575	189.25
  chr1	9745452	9748276	.	727	.	31.1453	73.4112	70.5175	454
  ```

  
  
  



