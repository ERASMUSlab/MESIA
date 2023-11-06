mkdir ME1/$1
mkdir ME2/$1

num=$2
ten=100
bedlines=$3
tentimes=$(( (bedlines + 1) / $ten ))
percent=`expr $tentimes \* $num`
rest=`expr $bedlines - $percent`

rest_tentimes=$(( (rest + 1) / $ten ))
range=`expr $rest_tentimes \* $1`

cat ./ME1/ME1_set.bed | shuf - | split -d -l ${percent} - ME1/$1/ME1_part
mv ./ME1/$1/ME1_part00 ./ME1/$1/ME1_body_set.bed
cat ./ME1/$1/ME1_part* >./ME1/$1/ME1_rest_set.bed

cat ./ME2/ME2_set.bed | shuf - | split -d -l ${percent} - ME2/$1/ME2_part
mv ./ME2/$1/ME2_part00 ./ME2/$1/ME2_body_set.bed
cat ./ME2/$1/ME2_part* >./ME2/$1/ME2_rest_set.bed

cat ./ME1/$1/ME1_rest_set.bed | shuf - | split -d -l ${range} - ME1/$1/ME1_smallpart
mv ./ME1/$1/ME1_smallpart00 ./ME1/$1/ME1_function_set.bed

cat ./ME2/$1/ME2_rest_set.bed | shuf - | split -d -l ${range} - ME2/$1/ME2_smallpart
mv ./ME2/$1/ME2_smallpart00 ./ME2/$1/ME2_function_set.bed

bedtools intersect -wa -a ME1/ME1.bedpe -b ./ME1/$1/ME1_body_set.bed > ./ME1/$1/ME1_body_pre.bedpe
bedtools intersect -wa -a ME2/ME2.bedpe -b ./ME2/$1/ME2_body_set.bed > ./ME2/$1/ME2_body_pre.bedpe

bedtools intersect -wa -a ME1/ME1.bedpe -b ./ME1/$1/ME1_function_set.bed > ./ME1/$1/ME1_function_pre.bedpe
bedtools intersect -wa -a ME2/ME2.bedpe -b ./ME2/$1/ME2_function_set.bed > ./ME2/$1/ME2_function_pre.bedpe

cat ./ME1/$1/ME1_body_pre.bedpe ./ME2/$1/ME2_body_pre.bedpe > ./ME1/$1/ME1_body.bedpe
cat ./ME1/$1/ME1_body_pre.bedpe ./ME2/$1/ME2_body_pre.bedpe > ./ME2/$1/ME2_body.bedpe

cat ./ME1/$1/ME1_body.bedpe ./ME1/$1/ME1_function_pre.bedpe > ME1/$1/raw_ME1.bedpe
cat ./ME2/$1/ME2_body.bedpe ./ME2/$1/ME2_function_pre.bedpe > ME2/$1/raw_ME2.bedpe

bedtools bedpetobam -i ME1/$1/raw_ME1.bedpe -g $4 >raw_ME1.bam
bedtools bedpetobam -i ME2/$1/raw_ME2.bedpe -g $4 >raw_ME2.bam
