echo "==========="
echo "Make dir..."
echo "==========="
echo " "

mkdir ./$1
mkdir ./$1/BAM
mkdir ./$1/narrowPeak/
mkdir ./$1/IDR

echo "=================="
echo "Preparing files..."
echo "=================="
echo " "

cp ../Input_NF/$1.bam ./$1/BAM/$1.bam
samtools view -@ $2 -H ./$1/BAM/$1.bam > ./$1/BAM/$1_header.sam

nlines=$(samtools view ./$1/BAM/$1.bam | wc -l )
nlines=$(( (nlines + 1) / 2 ))

samtools view -@ $2 ./$1/BAM/$1.bam | shuf - | split -d -l ${nlines} - "./$1/BAM/$1"

cat ./$1/BAM/$1_header.sam ./$1/BAM/$1"00" | samtools view -bS - > ./$1/BAM/$1"00.bam"
cat ./$1/BAM/$1_header.sam ./$1/BAM/$1"01" | samtools view -bS - > ./$1/BAM/$1"01.bam"

samtools sort -@ $2 -n ./$1/BAM/$1"00.bam" -o ./$1/BAM/$1"00_nameO.bam"
samtools fixmate -@ $2 ./$1/BAM/$1"00_nameO.bam" ./$1/BAM/$1"_pseudoRep1.bam"

samtools sort -@ $2 -n ./$1/BAM/$1"01.bam" -o ./$1/BAM/$1"01_nameO.bam"
samtools fixmate -@ $2 ./$1/BAM/$1"01_nameO.bam" ./$1/BAM/$1"_pseudoRep2.bam"

samtools sort -@ $2 -n ./$1/BAM/$1.bam -o ./$1/BAM/$1"_nameO.bam"
samtools fixmate -@ $2 ./$1/BAM/$1"_nameO.bam" ./$1/BAM/$1"_pooled_FULL.bam"

samtools view -@ $2 -bf 0x2 ./$1/BAM/$1"_pseudoRep1.bam" | bedtools bamtobed -i stdin -bedpe > ./$1/BAM/$1"_pseudoRep1.bedpe"
samtools view -@ $2 -bf 0x2 ./$1/BAM/$1"_pseudoRep2.bam" | bedtools bamtobed -i stdin -bedpe > ./$1/BAM/$1"_pseudoRep2.bedpe"
samtools view -@ $2 -bf 0x2 ./$1/BAM/$1"_pooled_FULL.bam" | bedtools bamtobed -i stdin -bedpe > ./$1/BAM/$1"_pooled_FULL.bedpe"

bash ../Code/bedpeTn5shift.sh ./$1/BAM/$1"_pseudoRep1.bedpe" > ./$1/BAM/$1"_pseudoRep1_tn5.bedpe"
bash ../Code/bedpeTn5shift.sh ./$1/BAM/$1"_pseudoRep2.bedpe" > ./$1/BAM/$1"_pseudoRep2_tn5.bedpe"
bash ../Code/bedpeTn5shift.sh ./$1/BAM/$1"_pooled_FULL.bedpe" > ./$1/BAM/$1"_pooled_FULL_tn5.bedpe"


echo "==============="
echo "Peak calling..."
echo "==============="
echo " "

macs2 callpeak -t ./$1/BAM/$1"_pseudoRep1_tn5.bedpe" --name ./$1/narrowPeak/$1"_pseudoRep1" -f BEDPE -g $3 --shift 100 --extsize 200 --nomodel --nolambda --keep-dup all
awk 'BEGIN{FS=OFS="\t"; print "GeneID\tChr\tStart\tEnd\tStrand"}{print $4, $1, $2+1, $3, "."}' ./$1/narrowPeak/$1"_pseudoRep1_peaks.narrowPeak" > ./$1/narrowPeak/$1"_pseudoRep1_peaks.saf"
featureCounts -T $2 -p -a ./$1/narrowPeak/$1"_pseudoRep1_peaks.saf" -F SAF -o ./$1/narrowPeak/$1"_pseudoRep1_peaks.txt" ./$1/BAM/$1"_pseudoRep1.bam"

macs2 callpeak -t ./$1/BAM/$1"_pseudoRep2_tn5.bedpe" --name ./$1/narrowPeak/$1"_pseudoRep2" -f BEDPE -g $3 --shift 100 --extsize 200 --nomodel --nolambda --keep-dup all
awk 'BEGIN{FS=OFS="\t"; print "GeneID\tChr\tStart\tEnd\tStrand"}{print $4, $1, $2+1, $3, "."}' ./$1/narrowPeak/$1"_pseudoRep2_peaks.narrowPeak" > ./$1/narrowPeak/$1"_pseudoRep2_peaks.saf"
featureCounts -T $2 -p -a ./$1/narrowPeak/$1"_pseudoRep2_peaks.saf" -F SAF -o ./$1/narrowPeak/$1"_pseudoRep2_peaks.txt" ./$1/BAM/$1"_pseudoRep2.bam"

macs2 callpeak -t ./$1/BAM/$1"_pooled_FULL_tn5.bedpe" --name ./$1/narrowPeak/$1"_pooled_FULL" -f BEDPE -g $3 --shift 100 --extsize 200 --nomodel --nolambda --keep-dup all
awk 'BEGIN{FS=OFS="\t"; print "GeneID\tChr\tStart\tEnd\tStrand"}{print $4, $1, $2+1, $3, "."}' ./$1/narrowPeak/$1"_pooled_FULL_peaks.narrowPeak" > ./$1/narrowPeak/$1"_pooled_FULL_peaks.saf"
featureCounts -T $2 -p -a ./$1/narrowPeak/$1"_pooled_FULL_peaks.saf" -F SAF -o ./$1/narrowPeak/$1"_pooled_FULL_peaks.txt" ./$1/BAM/$1"_pooled_FULL.bam"

sort -k8,8nr ./$1/narrowPeak/$1"_pseudoRep1_peaks.narrowPeak" > ./$1/narrowPeak/$1"_pseudoRep1_peaks_sorted.narrowPeak"
sort -k8,8nr ./$1/narrowPeak/$1"_pseudoRep2_peaks.narrowPeak" > ./$1/narrowPeak/$1"_pseudoRep2_peaks_sorted.narrowPeak"
sort -k8,8nr ./$1/narrowPeak/$1"_pooled_FULL_peaks.narrowPeak" > ./$1/narrowPeak/$1"_pooled_FULL_peaks_sorted.narrowPeak"

echo "==============="
echo "IDR Analysis..."
echo "==============="
echo " "

idr --input-file-type narrowPeak --output-file-type narrowPeak --rank p.value --soft-idr-threshold 0.05 --plot --use-best-multisummit-IDR  --peak-list ./$1/narrowPeak/$1"_pooled_FULL_peaks_sorted.narrowPeak" -s ./$1/narrowPeak/$1"_pseudoRep1_peaks_sorted.narrowPeak" ./$1/narrowPeak/$1"_pseudoRep2_peaks_sorted.narrowPeak" --output-file ./$1/IDR/$1"_IDR_long.narrowPeak"

cat ./$1/IDR/$1"_IDR_long.narrowPeak" |cut -f 1-10 > ./$1/IDR/$1"_IDR.narrowPeak"



echo "==========="
echo "Finising..."
echo "==========="
echo " "

rm ./$1/BAM/*.bam
rm ./$1/BAM/*.sam
rm ./$1/BAM/*00
rm ./$1/BAM/*01
rm ./$1/narrowPeak/*saf
rm ./$1/narrowPeak/*txt
rm ./$1/narrowPeak/*summary
rm ./$1/narrowPeak/*xls
rm ./$1/narrowPeak/*bed


