cat ./ME1/ME1_set.bed | shuf - | split -d -l 1600000 - ME1_part
mv ME1_part00 ME1_prefunction_set.bed
cat ME1_part0* >ME1_prefunction_set.bed

cat ./ME2/ME2_set.bed | shuf - | split -d -l 1600000 - ME2_part
mv ME2_part00 ME2_prefunction_set.bed
cat ME2_part0* >ME2_prefunction_set.bed

rm *part*

bedtools intersect -wa -a ME1/ME1.bedpe -b ME1_prefunction_set.bed >ME1_prebody.bedpe
bedtools intersect -wa -a ME2/ME2.bedpe -b ME2_prefunction_set.bed >ME2_prebody.bedpe

cat ME1_prebody.bedpe ME2_prebody.bedpe >simulation_sample_body.bedpe

cat ME1_prefunction_set.bed | shuf - | split -d -l 400000 - ME1_part
mv ME1_part00 ME1_prefunction_set_4m.bed
cat ME1_prefunction_set.bed | shuf - | split -d -l 800000 - ME1_part
mv ME1_part00 ME1_prefunction_set_8m.bed
cat ME1_prefunction_set.bed | shuf - | split -d -l 1200000 - ME1_part
mv ME1_part00 ME1_prefunction_set_12m.bed
cat ME1_prefunction_set.bed | shuf - | split -d -l 1600000 - ME1_part
mv ME1_part00 ME1_prefunction_set_16m.bed
cat ME1_prefunction_set.bed | shuf - | split -d -l 2000000 - ME1_part
mv ME1_part00 ME1_prefunction_set_20m.bed

cat ME2_prefunction_set.bed | shuf - | split -d -l 400000 - ME2_part
mv ME2_part00 ME2_prefunction_set_4m.bed
cat ME2_prefunction_set.bed | shuf - | split -d -l 800000 - ME2_part
mv ME2_part00 ME2_prefunction_set_8m.bed
cat ME2_prefunction_set.bed | shuf - | split -d -l 1200000 - ME2_part
mv ME2_part00 ME2_prefunction_set_12m.bed
cat ME2_prefunction_set.bed | shuf - | split -d -l 1600000 - ME2_part
mv ME2_part00 ME2_prefunction_set_16m.bed
cat ME2_prefunction_set.bed | shuf - | split -d -l 2000000 - ME2_part
mv ME2_part00 ME2_prefunction_set_20m.bed

rm *part*

bedtools intersect -wa -a ME1/ME1.bedpe -b ME1_prefunction_set_4m.bed >ME1_prefunction_set_4m.bedpe
bedtools intersect -wa -a ME1/ME1.bedpe -b ME1_prefunction_set_8m.bed >ME1_prefunction_set_8m.bedpe
bedtools intersect -wa -a ME1/ME1.bedpe -b ME1_prefunction_set_12m.bed >ME1_prefunction_set_12m.bedpe
bedtools intersect -wa -a ME1/ME1.bedpe -b ME1_prefunction_set_16m.bed >ME1_prefunction_set_16m.bedpe
bedtools intersect -wa -a ME1/ME1.bedpe -b ME1_prefunction_set_20m.bed >ME1_prefunction_set_20m.bedpe


bedtools intersect -wa -a ME2/ME2.bedpe -b ME2_prefunction_set_4m.bed >ME2_prefunction_set_4m.bedpe
bedtools intersect -wa -a ME2/ME2.bedpe -b ME2_prefunction_set_8m.bed >ME2_prefunction_set_8m.bedpe
bedtools intersect -wa -a ME2/ME2.bedpe -b ME2_prefunction_set_12m.bed >ME2_prefunction_set_12m.bedpe
bedtools intersect -wa -a ME2/ME2.bedpe -b ME2_prefunction_set_16m.bed >ME2_prefunction_set_16m.bedpe
bedtools intersect -wa -a ME2/ME2.bedpe -b ME2_prefunction_set_20m.bed >ME2_prefunction_set_20m.bedpe

cat ME1_prefunction_set_4m.bedpe simulation_sample_body.bedpe >simulation_sample1_4m.bedpe
cat ME1_prefunction_set_8m.bedpe simulation_sample_body.bedpe >simulation_sample1_8m.bedpe
cat ME1_prefunction_set_12m.bedpe simulation_sample_body.bedpe >simulation_sample1_12m.bedpe
cat ME1_prefunction_set_16m.bedpe simulation_sample_body.bedpe >simulation_sample1_16m.bedpe
cat ME1_prefunction_set_20m.bedpe simulation_sample_body.bedpe >simulation_sample1_20m.bedpe
