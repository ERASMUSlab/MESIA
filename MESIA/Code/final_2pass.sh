#!/bin/usr/env bash
name=$1
sample_set1=$2
sample_set2=$3

sample_piece1_1=$(echo $sample_set1 | cut -d'-' -f 1)
sample_piece1_2=$(echo $sample_set1 | cut -d'-' -f 2)
sample_piece2_1=$(echo $sample_set2 | cut -d'-' -f 1)
sample_piece2_2=$(echo $sample_set2 | cut -d'-' -f 2)

#######################
####for sample set1####
#######################

intersectBed -wo \
-a $name/MESIA_phase1_rescue/$sample_set1/IDR/$sample_set1"_Np.narrowPeak" \
-b $name/MESIA_phase1_rescue/$sample_set1/IDR/$sample_set1"_Nt.narrowPeak" | \
awk 'BEGIN{FS="\t";OFS="\t"}{s1=$3-$2; s2=$13-$12; if (($21/s1 >= 0) || ($21/s2 >= 0)) {print $0}}' | \
cut -f 1-10 | sort | uniq > $name/final/IDR_intersect.narrowPeak
cp $name/final/IDR_intersect.narrowPeak $name/final/IDR_set1.narrowPeak

#############
###Q-value###
#############

awk -F'\t' '{print $9}' $name/final/IDR_intersect.narrowPeak >$name/final/$sample_set1"_qvalue_raw.txt"
sort -n $name/final/$sample_set1"_qvalue_raw.txt" > $name/final/$sample_set1"_qvalue.txt"

totalnum=$(cat $name/final/$sample_set1"_qvalue.txt" | wc -l)

Q1num_pre=$((totalnum / 4))
mediannum_pre=$((totalnum / 2))
FreeParameter_pre=$((totalnum / 100))

Q1num=$(echo $Q1num_pre | cut -d'.' -f 1)
mediannum=$(echo $mediannum_pre | cut -d'.' -f 1)
Q3num=$((Q1num * 3))
FreeParameternum_pre=$(echo $FreeParameter_pre | cut -d'.' -f 1)
								FreeParameternum=$((FreeParameternum_pre * 33))

Q1pre=$(head -n $Q1num $name/final/$sample_set1"_qvalue.txt" | tail -n 1)
qmediannumpre=$(head -n $mediannum $name/final/$sample_set1"_qvalue.txt" | tail -n 1)
Q3pre=$(head -n $Q3num $name/final/$sample_set1"_qvalue.txt" | tail -n 1)
FreeParameternum_tmp=$(head -n $FreeParameternum $name/final/$sample_set1"_qvalue.txt" | tail -n 1)


qvalueQ1=$(echo $Q1pre | cut -d'.' -f 1)
qvalue_median=$(echo $qmediannumpre | cut -d'.' -f 1)
qvalueQ3=$(echo $Q3pre | cut -d'.' -f 1)
qvalue_FreeParameter=$(echo $FreeParameternum_tmp | cut -d'.' -f 1)

let IQR=qvalueQ3-qvalueQ1
nu_pre=$(( IQR / 2 ))
nu=$(echo $nu_pre | cut -d'.' -f 1)
multiIQR=$(( nu * 3 ))

let qvaluelower=qvalueQ1-multiIQR

if [ 0 -gt $qvaluelower ]
then
        qvaluelower=0
fi

let qvalueupper=qvalueQ3+multiIQR

################
###Peak score###
################

awk -F'\t' '{print $10}' $name/final/IDR_intersect.narrowPeak >$name/final/$sample_set1"_ps_raw.txt"
sort -n $name/final/$sample_set1"_ps_raw.txt" > $name/final/$sample_set1"_ps.txt"

Q1pre=$(head -n $Q1num $name/final/$sample_set1"_ps.txt" | tail -n 1)
Q3pre=$(head -n $Q3num $name/final/$sample_set1"_ps.txt" | tail -n 1)
psQ1=$(echo $Q1pre | cut -d'.' -f 1)
psQ3=$(echo $Q3pre | cut -d'.' -f 1)

FreeParameternum_tmp=$(head -n $FreeParameternum $name/final/$sample_set1"_ps.txt" | tail -n 1)
ps_FreeParameter=$(echo $FreeParameternum_tmp | cut -d'.' -f 1)

psmediannumpre=$(head -n $mediannum $name/final/$sample_set1"_ps.txt" | tail -n 1)
ps_median=$(echo $psmediannumpre | cut -d'.' -f 1)

let IQR=psQ3-psQ1
nu_pre=$(( IQR / 2 ))
nu=$(echo $nu_pre | cut -d'.' -f 1)
multiIQR=$(( nu * 3 ))

let pslower=psQ1-multiIQR

if [ 0 -gt $pslower ]
then
        pslower=0
fi

let psupper=pvalueQ3+multiIQR

#$qvaluelower   $qvalueQ1       $qvalue_median  $qvalueQ3       $qvalueupper    $qvalue_FreeParameter
#$pslower       $psQ1           $ps_median      $psQ3           $psupper        $ps_FreeParameter

perl ../Code/get_BASE.pl $qvalue_median $ps_median $name/final/IDR_set1.narrowPeak \
        >$name/final/$sample_set1"_base.narrowPeak"

perl ../Code/get_HR_qvalue.pl $qvalue_median $name/MESIA_phase1_rescue/$sample_set1/narrowPeak/$sample_piece1_1/$sample_piece1_1"_peaks.narrowPeak" \
        >$name/final/HR_qvalue_$sample_piece1_1".narrowPeak"
perl ../Code/get_HR_qvalue.pl $qvalue_median $name/MESIA_phase1_rescue/$sample_set1/narrowPeak/$sample_piece1_2/$sample_piece1_2"_peaks.narrowPeak" \
        >$name/final/HR_qvalue_$sample_piece1_2".narrowPeak"

perl ../Code/get_HR_ps.pl $ps_median $name/MESIA_phase1_rescue/$sample_set1/narrowPeak/$sample_piece1_1/$sample_piece1_1"_peaks.narrowPeak" \
        >$name/final/HR_ps_$sample_piece1_1".narrowPeak"
perl ../Code/get_HR_ps.pl $ps_median $name/MESIA_phase1_rescue/$sample_set1/narrowPeak/$sample_piece1_2/$sample_piece1_2"_peaks.narrowPeak" \
        >$name/final/HR_ps_$sample_piece1_2".narrowPeak"

#######################
####for sample set2####
#######################


intersectBed -wo \
-a $name/MESIA_phase1_rescue/$sample_set2/IDR/$sample_set2"_Np.narrowPeak" \
-b $name/MESIA_phase1_rescue/$sample_set2/IDR/$sample_set2"_Nt.narrowPeak" | \
awk 'BEGIN{FS="\t";OFS="\t"}{s1=$3-$2; s2=$13-$12; if (($21/s1 >= 0) || ($21/s2 >= 0)) {print $0}}' | \
cut -f 1-10 | sort | uniq > $name/final/IDR_intersect.narrowPeak
cp $name/final/IDR_intersect.narrowPeak $name/final/IDR_set2.narrowPeak

#############
###Q-value###
#############

awk -F'\t' '{print $9}' $name/final/IDR_intersect.narrowPeak >$name/final/$sample_set2"_qvalue_raw.txt"
sort -n $name/final/$sample_set2"_qvalue_raw.txt" > $name/final/$sample_set2"_qvalue.txt"

totalnum=$(cat $name/final/$sample_set2"_qvalue.txt" | wc -l)

Q1num_pre=$((totalnum / 4))
mediannum_pre=$((totalnum / 2))
FreeParameter_pre=$((totalnum / 100))

Q1num=$(echo $Q1num_pre | cut -d'.' -f 1)
mediannum=$(echo $mediannum_pre | cut -d'.' -f 1)
Q3num=$((Q1num * 3))
FreeParameternum_pre=$(echo $FreeParameter_pre | cut -d'.' -f 1)
                                                                FreeParameternum=$((FreeParameternum_pre * 33))

Q1pre=$(head -n $Q1num $name/final/$sample_set2"_qvalue.txt" | tail -n 1)
qmediannumpre=$(head -n $mediannum $name/final/$sample_set2"_qvalue.txt" | tail -n 1)
Q3pre=$(head -n $Q3num $name/final/$sample_set2"_qvalue.txt" | tail -n 1)
FreeParameternum_tmp=$(head -n $FreeParameternum $name/final/$sample_set2"_qvalue.txt" | tail -n 1)


qvalueQ1=$(echo $Q1pre | cut -d'.' -f 1)
qvalue_median=$(echo $qmediannumpre | cut -d'.' -f 1)
qvalueQ3=$(echo $Q3pre | cut -d'.' -f 1)
qvalue_FreeParameter=$(echo $FreeParameternum_tmp | cut -d'.' -f 1)

let IQR=qvalueQ3-qvalueQ1
nu_pre=$(( IQR / 2 ))
nu=$(echo $nu_pre | cut -d'.' -f 1)
multiIQR=$(( nu * 3 ))

let qvaluelower=qvalueQ1-multiIQR

if [ 0 -gt $qvaluelower ]
then
        qvaluelower=0
fi

let qvalueupper=qvalueQ3+multiIQR


################
###Peak score###
################

awk -F'\t' '{print $10}' $name/final/IDR_intersect.narrowPeak >$name/final/$sample_set2"_ps_raw.txt"
sort -n $name/final/$sample_set2"_ps_raw.txt" > $name/final/$sample_set2"_ps.txt"

Q1pre=$(head -n $Q1num $name/final/$sample_set2"_ps.txt" | tail -n 1)
Q3pre=$(head -n $Q3num $name/final/$sample_set2"_ps.txt" | tail -n 1)
psQ1=$(echo $Q1pre | cut -d'.' -f 1)
psQ3=$(echo $Q3pre | cut -d'.' -f 1)

FreeParameternum_tmp=$(head -n $FreeParameternum $name/final/$sample_set2"_ps.txt" | tail -n 1)
ps_FreeParameter=$(echo $FreeParameternum_tmp | cut -d'.' -f 1)

psmediannumpre=$(head -n $mediannum $name/final/$sample_set2"_ps.txt" | tail -n 1)
ps_median=$(echo $psmediannumpre | cut -d'.' -f 1)

let IQR=psQ3-psQ1
nu_pre=$(( IQR / 2 ))
nu=$(echo $nu_pre | cut -d'.' -f 1)
multiIQR=$(( nu * 3 ))

let pslower=psQ1-multiIQR

if [ 0 -gt $pslower ]
then
        pslower=0
fi

let psupper=pvalueQ3+multiIQR


#$qvaluelower   $qvalueQ1       $qvalue_median  $qvalueQ3       $qvalueupper    $qvalue_FreeParameter
#$pslower       $psQ1           $ps_median      $psQ3           $psupper        $ps_FreeParameter

perl ../Code/get_BASE.pl $qvalue_median $ps_median $name/final/IDR_set2.narrowPeak \
        >$name/final/$sample_set2"_base.narrowPeak"

perl ../Code/get_HR_qvalue.pl $qvalue_median $name/MESIA_phase1_rescue/$sample_set2/narrowPeak/$sample_piece2_1/$sample_piece2_1"_peaks.narrowPeak" \
        >$name/final/HR_qvalue_$sample_piece2_1".narrowPeak"
perl ../Code/get_HR_qvalue.pl $qvalue_median $name/MESIA_phase1_rescue/$sample_set2/narrowPeak/$sample_piece2_2/$sample_piece2_2"_peaks.narrowPeak" \
        >$name/final/HR_qvalue_$sample_piece2_2".narrowPeak"

perl ../Code/get_HR_ps.pl $ps_median $name/MESIA_phase1_rescue/$sample_set2/narrowPeak/$sample_piece2_1/$sample_piece2_1"_peaks.narrowPeak" \
        >$name/final/HR_ps_$sample_piece2_1".narrowPeak"
perl ../Code/get_HR_ps.pl $ps_median $name/MESIA_phase1_rescue/$sample_set2/narrowPeak/$sample_piece2_2/$sample_piece2_2"_peaks.narrowPeak" \
        >$name/final/HR_ps_$sample_piece2_2".narrowPeak"




cat $name/final/HR_qvalue_$sample_piece1_1".narrowPeak" $name/final/HR_qvalue_$sample_piece1_2".narrowPeak" $name/final/HR_qvalue_$sample_piece2_1".narrowPeak" $name/final/HR_qvalue_$sample_piece2_2".narrowPeak" > $name/final/HR_qvalue_tmp.narrowPeak
sort -k1,1 -k2,2n $name/final/HR_qvalue_tmp.narrowPeak > $name/final/HR_qvalue_sorted.narrowPeak
bedtools merge -c 6,5,6,7,8,9,10 -o distinct,mean,distinct,mean,mean,mean,mean -i $name/final/HR_qvalue_sorted.narrowPeak >$name/final/HR_qvalue.narrowPeak


cat $name/final/HR_ps_$sample_piece1_1".narrowPeak" $name/final/HR_ps_$sample_piece1_2".narrowPeak" $name/final/HR_ps_$sample_piece2_1".narrowPeak" $name/final/HR_ps_$sample_piece2_2".narrowPeak" > $name/final/HR_ps_tmp.narrowPeak
sort -k1,1 -k2,2n $name/final/HR_ps_tmp.narrowPeak >$name/final/HR_ps_sorted.narrowPeak
bedtools merge -c 6,5,6,7,8,9,10 -o distinct,mean,distinct,mean,mean,mean,mean -i $name/final/HR_ps_sorted.narrowPeak >$name/final/HR_ps.narrowPeak

bedtools intersect -a $name/final/HR_ps.narrowPeak -b $name/final/HR_qvalue.narrowPeak \
       >$name/final/HR_ps_Qbase_tmp.narrowPeak
sort -k1,1 -k2,2n $name/final/HR_ps_Qbase_tmp.narrowPeak >$name/final/HR_ps_Qbase_sorted.narrowPeak
bedtools merge -c 6,5,6,7,8,9,10 -o distinct,mean,distinct,mean,mean,mean,mean -i $name/final/HR_ps_Qbase_sorted.narrowPeak >$name/final/HR_ps_Qbase.narrowPeak

sort -k1,1 -k2,2n $name/final/$sample_set1"_base.narrowPeak" >$name/final/$sample_set1"_base_sorted.narrowPeak"
bedtools merge -c 6,5,6,7,8,9,10 -o distinct,mean,distinct,mean,mean,mean,mean -i $name/final/$sample_set1"_base_sorted.narrowPeak" >$name/final/$sample_set1"_base.narrowPeak"

sort -k1,1 -k2,2n $name/final/$sample_set2"_base.narrowPeak" >$name/final/$sample_set2"_base_sorted.narrowPeak"
bedtools merge -c 6,5,6,7,8,9,10 -o distinct,mean,distinct,mean,mean,mean,mean -i $name/final/$sample_set2"_base_sorted.narrowPeak" >$name/final/$sample_set2"_base.narrowPeak"

#################
#####setting#####
#################

cat $name/final/HR_ps_Qbase.narrowPeak >$name/final/HR_tmp.narrowPeak
sort -k1,1 -k2,2n $name/final/HR_tmp.narrowPeak >$name/final/HR_sorted.narrowPeak
bedtools merge -c 6,5,6,7,8,9,10 -o distinct,mean,distinct,mean,mean,mean,mean -i $name/final/HR_sorted.narrowPeak >$name/final/HR.narrowPeak

cat $name/final/$sample_set1"_base.narrowPeak" $name/final/$sample_set2"_base.narrowPeak" \
       >$name/final/base_tmp.narrowPeak
sort -k1,1 -k2,2n $name/final/base_tmp.narrowPeak | uniq >$name/final/base_sorted.narrowPeak
bedtools merge -c 6,5,6,7,8,9,10 -o distinct,mean,distinct,mean,mean,mean,mean -i $name/final/base_sorted.narrowPeak >$name/final/base.narrowPeak

cat $name/final/HR.narrowPeak $name/final/base.narrowPeak >$name/final/MESIA_tmp.narrowPeak
sort -k1,1 -k2,2n $name/final/MESIA_tmp.narrowPeak | uniq >$name/final/MESIA_sorted.narrowPeak
bedtools merge -c 6,5,6,7,8,9,10 -o distinct,mean,distinct,mean,mean,mean,mean -i $name/final/MESIA_sorted.narrowPeak >$name/final/MESIA_optimal.narrowPeak

rm $name/final/*tmp*
rm $name/final/*sorted*
rm $name/final/*rep*
rm $name/final/*intersect*

mkdir $name/final/MESIA
mv $name/final/MESIA_optimal.narrowPeak $name/final/MESIA
rm $name/final/*
mv $name/final/MESIA/* $name/final/
rm -r $name/final/MESIA
