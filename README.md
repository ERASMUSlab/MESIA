<img width="1000" alt="image" src="https://github.com/ERASMUSlab/MESIA/assets/135592214/7375e99e-5819-40a1-90f0-9e9c43d1473d">


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
  
## <b>Quick start</b>
  ### <b>1. Install MESIA</b>
  <pre><code>git clone https://github.com/ERASMUSlab/MESIA.git</pre></code>
  
  ### <b>2. Input BAM file</b>
  <pre><code>cd MESIA/Input_NF
  cp "Your Input file path" . </pre></code>
  
  ### <b>3. Run MESIA</b>
  <pre><code>cd ../Program
  bash MESIA.sh "Project Name" "BAM file1" "BAM file2" "BAM file3" "BAM file4" "Threads" "mappable genome size"</pre></code>
 example
  <pre><code>bash MESIA.sh test GM12878_rep1 GM12878_rep2 GM12878_rep3 GM12878_rep4 30 hs</pre></code>
  mappable genome size section can be "hs", "mm", or others
  
  



