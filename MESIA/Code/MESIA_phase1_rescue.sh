echo "==========="
echo "Make dir..."
echo "==========="
echo " "

mkdir ./$3
mkdir ./$3/BAM
mkdir ./$3/narrowPeak/
mkdir ./$3/narrowPeak/$1
mkdir ./$3/narrowPeak/$2
mkdir ./$3/narrowPeak/$3
mkdir ./$3/IDR

echo "=================="
echo "Preparing files..."
echo "=================="
echo " "

samtools merge -f -@ $4 -u ./$3/BAM/$3.bam ../Input_NF/$1.bam ../Input_NF/$2.bam
samtools view -@ $4 -H ./$3/BAM/$3.bam > ./$3/BAM/$3_header.sam 

nlines=$(samtools view ./$3/BAM/$3.bam | wc -l )
nlines=$(( (nlines + 1) / 2 )) 

samtools view -@ $4 ./$3/BAM/$3.bam | shuf - | split -d -l ${nlines} - "./$3/BAM/$3"

cat ./$3/BAM/$3_header.sam ./$3/BAM/$3"00" | samtools view -bS - > ./$3/BAM/$3"00.bam"
cat ./$3/BAM/$3_header.sam ./$3/BAM/$3"01" | samtools view -bS - > ./$3/BAM/$3"01.bam"

samtools sort -@ $4 -n ./$3/BAM/$3"00.bam" -o ./$3/BAM/$3"00_nameO.bam"
samtools fixmate -@ $4 ./$3/BAM/$3"00_nameO.bam" ./$3/BAM/$3"_pseudoRep1.bam"

samtools sort -@ $4 -n ./$3/BAM/$3"01.bam" -o ./$3/BAM/$3"01_nameO.bam" 
samtools fixmate -@ $4 ./$3/BAM/$3"01_nameO.bam" ./$3/BAM/$3"_pseudoRep2.bam"

samtools sort -@ $4 ./$3/BAM/$3.bam -o ./$3/BAM/$3"_name.bam"
samtools sort -@ $4 -n ./$3/BAM/$3"_name.bam" -o ./$3/BAM/$3"_nameO.bam"
samtools fixmate -@ $4 ./$3/BAM/$3"_nameO.bam" ./$3/BAM/$3"_pooled_FULL.bam"

samtools sort -@ $4 ../Input_NF/$1.bam -o ./$3/BAM/$1"_name.bam"
samtools sort -@ $4 -n ./$3/BAM/$1"_name.bam" -o ./$3/BAM/$1"_nameO.bam"
samtools fixmate -@ $4 ./$3/BAM/$1"_nameO.bam" ./$3/BAM/$1".bam"

samtools sort -@ $4 ../Input_NF/$2.bam -o ./$3/BAM/$2"_name.bam"
samtools sort -@ $4 -n ./$3/BAM/$2"_name.bam" -o ./$3/BAM/$2"_nameO.bam"
samtools fixmate -@ $4 ./$3/BAM/$2"_nameO.bam" ./$3/BAM/$2".bam"

samtools view -@ $4 -bf 0x2 ./$3/BAM/$3"_pseudoRep1.bam" | bedtools bamtobed -i stdin -bedpe > ./$3/BAM/$3"_pseudoRep1.bedpe"
samtools view -@ $4 -bf 0x2 ./$3/BAM/$3"_pseudoRep2.bam" | bedtools bamtobed -i stdin -bedpe > ./$3/BAM/$3"_pseudoRep2.bedpe"
bedtools bamtobed -i ./$3/BAM/$3"_pooled_FULL.bam" -bedpe > ./$3/BAM/$3"_pooled_FULL.bedpe"
#samtools view -@ $4 -bf 0x2 ./$3/BAM/$3"_pooled_FULL.bam" | bedtools bamtobed -i stdin -bedpe > ./$3/BAM/$3"_pooled_FULL.bedpe"

samtools view -@ $4 -bf 0x2 ./$3/BAM/$1".bam" | bedtools bamtobed -i stdin -bedpe > ./$3/BAM/$1.bedpe
samtools view -@ $4 -bf 0x2 ./$3/BAM/$2".bam" | bedtools bamtobed -i stdin -bedpe > ./$3/BAM/$2.bedpe

bash ../Code/bedpeTn5shift.sh ./$3/BAM/$3"_pseudoRep1.bedpe" > ./$3/BAM/$3"_pseudoRep1_tn5.bedpe"
bash ../Code/bedpeTn5shift.sh ./$3/BAM/$3"_pseudoRep2.bedpe" > ./$3/BAM/$3"_pseudoRep2_tn5.bedpe" 
bash ../Code/bedpeTn5shift.sh ./$3/BAM/$3"_pooled_FULL.bedpe" > ./$3/BAM/$3"_pooled_FULL_tn5.bedpe"

bash ../Code/bedpeTn5shift.sh ./$3/BAM/$1.bedpe > ./$3/BAM/$1"_tn5.bedpe"
bash ../Code/bedpeTn5shift.sh ./$3/BAM/$2.bedpe > ./$3/BAM/$2"_tn5.bedpe"

echo "==============="
echo "Peak calling..."
echo "==============="
echo " "

macs2 callpeak -t ./$3/BAM/$3"_pseudoRep1_tn5.bedpe" --name ./$3/narrowPeak/$3/$3"_pseudoRep1" -f BEDPE -g $5 --shift 100 --extsize 200 --nomodel --nolambda --keep-dup all
awk 'BEGIN{FS=OFS="\t"; print "GeneID\tChr\tStart\tEnd\tStrand"}{print $4, $1, $2+1, $3, "."}' ./$3/narrowPeak/$3/$3"_pseudoRep1_peaks.narrowPeak" > ./$3/narrowPeak/$3/$3"_pseudoRep1_peaks.saf"
featureCounts -T $4 -p -a ./$3/narrowPeak/$3/$3"_pseudoRep1_peaks.saf" -F SAF -o ./$3/narrowPeak/$3/$3"_pseudoRep1_peaks.txt" ./$3/BAM/$3"_pseudoRep1.bam"

macs2 callpeak -t ./$3/BAM/$3"_pseudoRep2_tn5.bedpe" --name ./$3/narrowPeak/$3/$3"_pseudoRep2" -f BEDPE -g $5 --shift 100 --extsize 200 --nomodel --nolambda --keep-dup all
awk 'BEGIN{FS=OFS="\t"; print "GeneID\tChr\tStart\tEnd\tStrand"}{print $4, $1, $2+1, $3, "."}' ./$3/narrowPeak/$3/$3"_pseudoRep2_peaks.narrowPeak" > ./$3/narrowPeak/$3/$3"_pseudoRep2_peaks.saf"
featureCounts -T $4 -p -a ./$3/narrowPeak/$3/$3"_pseudoRep2_peaks.saf" -F SAF -o ./$3/narrowPeak/$3/$3"_pseudoRep2_peaks.txt" ./$3/BAM/$3"_pseudoRep2.bam"

macs2 callpeak -t ./$3/BAM/$3"_pooled_FULL_tn5.bedpe" --name ./$3/narrowPeak/$3/$3"_pooled_FULL" -f BEDPE -g $5 --shift 100 --extsize 200 --nomodel --nolambda --keep-dup all
awk 'BEGIN{FS=OFS="\t"; print "GeneID\tChr\tStart\tEnd\tStrand"}{print $4, $1, $2+1, $3, "."}' ./$3/narrowPeak/$3/$3"_pooled_FULL_peaks.narrowPeak" > ./$3/narrowPeak/$3/$3"_pooled_FULL_peaks.saf"
featureCounts -T $4 -p -a ./$3/narrowPeak/$3/$3"_pooled_FULL_peaks.saf" -F SAF -o ./$3/narrowPeak/$3/$3"_pooled_FULL_peaks.txt" ./$3/BAM/$3"_pooled_FULL.bam"

macs2 callpeak -t ./$3/BAM/$1"_tn5.bedpe" --name ./$3/narrowPeak/$1/$1 -f BEDPE -g $5 --shift 100 --extsize 200 --nomodel --nolambda --keep-dup all
awk 'BEGIN{FS=OFS="\t"; print "GeneID\tChr\tStart\tEnd\tStrand"}{print $4, $1, $2+1, $3, "."}' ./$3/narrowPeak/$1/$1"_peaks.narrowPeak" >./$3/narrowPeak/$1/$1"_peaks.saf"
featureCounts -T $4 -p -a ./$3/narrowPeak/$1/$1"_peaks.saf" -F SAF -o ./$3/narrowPeak/$1/$1"_peaks.txt" ../Input_NF/$1.bam

macs2 callpeak -t ./$3/BAM/$2"_tn5.bedpe" --name ./$3/narrowPeak/$2/$2 -f BEDPE -g $5 --shift 100 --extsize 200 --nomodel --nolambda --keep-dup all
awk 'BEGIN{FS=OFS="\t"; print "GeneID\tChr\tStart\tEnd\tStrand"}{print $4, $1, $2+1, $3, "."}' ./$3/narrowPeak/$2/$2"_peaks.narrowPeak" >./$3/narrowPeak/$2/$2"_peaks.saf"
featureCounts -T $4 -p -a ./$3/narrowPeak/$2/$2"_peaks.saf" -F SAF -o ./$3/narrowPeak/$2/$2"_peaks.txt" ../Input_NF/$2.bam

sort -k8,8nr ./$3/narrowPeak/$3/$3"_pseudoRep1_peaks.narrowPeak" > ./$3/narrowPeak/$3/$3"_pseudoRep1_peaks_sorted.narrowPeak"
sort -k8,8nr ./$3/narrowPeak/$3/$3"_pseudoRep2_peaks.narrowPeak" > ./$3/narrowPeak/$3/$3"_pseudoRep2_peaks_sorted.narrowPeak"
sort -k8,8nr ./$3/narrowPeak/$3/$3"_pooled_FULL_peaks.narrowPeak" > ./$3/narrowPeak/$3/$3"_pooled_FULL_peaks_sorted.narrowPeak"

sort -k8,8nr ./$3/narrowPeak/$1/$1"_peaks.narrowPeak" > ./$3/narrowPeak/$1/$1"_peaks_sort.narrowPeak"
sort -k8,8nr ./$3/narrowPeak/$2/$2"_peaks.narrowPeak" > ./$3/narrowPeak/$2/$2"_peaks_sort.narrowPeak"

echo "==============="
echo "IDR Analysis..."
echo "==============="
echo " "

idr --input-file-type narrowPeak --output-file-type narrowPeak --soft-idr-threshold 0.05 --plot --use-best-multisummit-IDR  --peak-list ./$3/narrowPeak/$3/$3"_pooled_FULL_peaks_sorted.narrowPeak" -s ./$3/narrowPeak/$3/$3"_pseudoRep1_peaks_sorted.narrowPeak" ./$3/narrowPeak/$3/$3"_pseudoRep2_peaks_sorted.narrowPeak" --output-file ./$3/IDR/$3"_Np_long.narrowPeak"

cat ./$3/IDR/$3"_Np_long.narrowPeak" | cut -f 1-10 > ./$3/IDR/$3"_Np.narrowPeak"  



idr --input-file-type narrowPeak --output-file-type narrowPeak --soft-idr-threshold 0.05 --plot --use-best-multisummit-IDR -s ./$3/narrowPeak/$1/$1"_peaks_sort.narrowPeak" ./$3/narrowPeak/$2/$2"_peaks_sort.narrowPeak" --output-file ./$3/IDR/$3"_Nt_long.narrowPeak"

cat ./$3/IDR/$3"_Nt_long.narrowPeak" | cut -f 1-10 > ./$3/IDR/$3"_Nt.narrowPeak"

echo " "
echo "==========="
echo "Finising..."
echo "==========="


rm ./$3/BAM/*.bam
rm ./$3/BAM/*.sam
rm ./$3/BAM/*00
rm ./$3/BAM/*01
rm ./$3/narrowPeak/$1/*saf
rm ./$3/narrowPeak/$1/*txt
rm ./$3/narrowPeak/$1/*summary
rm ./$3/narrowPeak/$1/*xls
rm ./$3/narrowPeak/$1/*bed
rm ./$3/narrowPeak/$2/*saf
rm ./$3/narrowPeak/$2/*txt
rm ./$3/narrowPeak/$2/*summary
rm ./$3/narrowPeak/$2/*xls
rm ./$3/narrowPeak/$2/*bed
rm ./$3/narrowPeak/$3/*saf
rm ./$3/narrowPeak/$3/*txt
rm ./$3/narrowPeak/$3/*summary
rm ./$3/narrowPeak/$3/*xls
rm ./$3/narrowPeak/$3/*bed

