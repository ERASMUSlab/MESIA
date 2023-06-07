###################################################
intersectBed -wo -a simulation_sample1_1-simulation_sample1_2_Np.narrowPeak -b simulation_sample1_1-simulation_sample1_2_Nt.narrowPeak | \
awk 'BEGIN{FS="\t";OFS="\t"}{s1=$3-$2; s2=$13-$12; if (($21/s1 >= 0) || ($21/s2 >= 0)) {print $0}}' | \
cut -f 1-10 | sort | uniq >IDR_intersect.narrowPeak
###################################################
###################################################
awk -F'\t' '{print $7}' IDR_intersect.narrowPeak >pvalue_raw.txt
sort -n pvalue_raw.txt > pvalue.txt

totalnum=$(cat pvalue.txt | wc -l)
Q1num_pre=$((totalnum / 4))
Q1num=$(echo $Q1num_pre | cut -d'.' -f 1)
Q3num=$((Q1num * 3))
Q1pre=$(head -n $Q1num pvalue.txt | tail -n 1)
Q3pre=$(head -n $Q3num pvalue.txt | tail -n 1)
pvalueQ1=$(echo $Q1pre | cut -d'.' -f 1)
pvalueQ3=$(echo $Q3pre | cut -d'.' -f 1)


let IQR=pvalueQ3-pvalueQ1
nu_pre=$(( IQR / 2 ))
nu=$(echo $nu_pre | cut -d'.' -f 1)
multiIQR=$(( nu * 3 ))

let pvaluelower=pvalueQ1-multiIQR

if [ 0 -gt $pvaluelower ]
then
pvaluelower=0
fi

let pvalueupper=pvalueQ3+multiIQR

echo $pvaluelower
echo $pvalueQ1
echo $pvalueQ3
echo $pvalueupper
###################################################
###################################################
awk -F'\t' '{print $8}' IDR_intersect.narrowPeak >qvalue_raw.txt
sort -n qvalue_raw.txt > qvalue.txt

Q1pre=$(head -n $Q1num qvalue.txt | tail -n 1)
Q3pre=$(head -n $Q3num qvalue.txt | tail -n 1)
qvalueQ1=$(echo $Q1pre | cut -d'.' -f 1)
qvalueQ3=$(echo $Q3pre | cut -d'.' -f 1)


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

echo $qvaluelower
echo $qvalueQ1
echo $qvalueQ3
echo $qvalueupper
###################################################
###################################################

awk -F'\t' '{print $9}' IDR_intersect.narrowPeak >ps_raw.txt
sort -n ps_raw.txt > ps.txt

Q1pre=$(head -n $Q1num ps.txt | tail -n 1)
Q3pre=$(head -n $Q3num ps.txt | tail -n 1)
psQ1=$(echo $Q1pre | cut -d'.' -f 1)
psQ3=$(echo $Q3pre | cut -d'.' -f 1)


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

echo $pslower
echo $psQ1
echo $psQ3
echo $psupper




