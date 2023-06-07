#!/bin/usr/env bash
index_num=$#
today=`date +%m-%d-%y_%H:%M`

if [ $index_num -eq 5 ]
then
        name=$1
        sample_set1=$2
        core=$3
        size=$4
        rawsamplenum=$5

        mkdir $name/final
	bash ../Code/final_1pass.sh $name $sample_set1

fi

if [ $index_num -eq 6 ]
then
        name=$1
        sample_set1=$2
        sample_set2=$3
        core=$4
        size=$5
        rawsamplenum=$6

        mkdir $name/IIMR_phase2
        mkdir $name/IIMR_phase2/narrowPeak
        mkdir $name/IIMR_phase2/IDR
        mkdir $name/IIMR_phase2/BAM
        mkdir $name/final

                #sample_piece1_1=$(echo $sample_set1 | cut -d'-' -f 1)
                #sample_piece1_2=$(echo $sample_set1 | cut -d'-' -f 2)
                #sample_piece2_1=$(echo $sample_set2 | cut -d'-' -f 1)
                #sample_piece2_2=$(echo $sample_set2 | cut -d'-' -f 2)


        if [ $rawsamplenum -eq 3 ]
        then
        	bash ../Code/final_3samples_2pass.sh $name $sample_set1 $sample_set2 $core $size
        fi

        if [ $rawsamplenum -eq 4 ]
        then
                def=$(echo -e "$sample_piece1_1\n$sample_piece1_2\n$sample_piece2_1\n$sample_piece2_2" | sort | uniq | wc -l)
                if [ $def -eq 4 ]
                then
                        intersectBed -wo \
                        -a $name/IIMR_phase1_rescue/$sample_set1/narrowPeak/$sample_piece1_1/*peaks.narrowPeak \
                        -b $name/IIMR_phase1_rescue/$sample_set1/narrowPeak/$sample_piece1_2/*peaks.narrowPeak | awk 'BEGIN{FS="\t";OFS="\t"}{s1=$3-$2; s2=$13-$12; if (($21/s1 >= 0.5) || ($21/s2 >= 0.5)) {print $0}}' | \
                        cut -f 1-10 | sort | uniq | \
                        intersectBed -wo \
                        -a stdin -b $name/IIMR_phase1_rescue/$sample_set2/narrowPeak/$sample_piece2_1/*peaks.narrowPeak | awk 'BEGIN{FS="\t";OFS="\t"}{s1=$3-$2; s2=$13-$12; if (($21/s1 >= 0.5) || ($21/s2 >= 0.5)) {print $0}}' | \
                        cut -f 1-10 | sort | uniq | \
                        intersectBed -wo \
                        -a stdin -b $name/IIMR_phase1_rescue/$sample_set2/narrowPeak/$sample_piece2_2/*peaks.narrowPeak | awk 'BEGIN{FS="\t";OFS="\t"}{s1=$3-$2; s2=$13-$12; if (($21/s1 >= 0.5) || ($21/s2 >= 0.5)) {print $0}}' | \
                        cut -f 1-10 | sort | uniq > $name/final/IIMR_optimal.narrowPeak
                fi

        	#case1
		
		echo $sample_piece1_1
		echo $sample_piece2_1		

                if [ $sample_piece1_1 == $sample_piece2_1 ]
                then
                        samtools merge -f -@ $4 \
                        -u $name/IIMR_phase2/BAM/IIMR_phase2_pooled.bam \
                        ../Input_NF/$sample_piece1_1".bam" \
                        ../Input_NF/$sample_piece1_2".bam" \
                        ../Input_NF/$sample_piece2_2".bam"

                        samtools view -@ $4 -H $name/IIMR_phase2/BAM/IIMR_phase2_pooled.bam > $name/IIMR_phase2/BAM/IIMR_phase2_pooled_header.sam

                        nlines=$(samtools view $name/IIMR_phase2/BAM/IIMR_phase2_pooled.bam | wc -l )
                        nlines=$(( (nlines + 1) / 2 ))

                        samtools view -@ $4 $name/IIMR_phase2/BAM/IIMR_phase2_pooled.bam | shuf - | split -d -l ${nlines} - "$name/IIMR_phase2/BAM/IIMR_phase2_pooled"

                        cat $name/IIMR_phase2/BAM/IIMR_phase2_pooled_header.sam $name/IIMR_phase2/BAM/IIMR_phase2_pooled00 | samtools view -bS - > $name/IIMR_phase2/BAM/IIMR_phase2_00.bam
                        cat $name/IIMR_phase2/BAM/IIMR_phase2_pooled_header.sam $name/IIMR_phase2/BAM/IIMR_phase2_pooled01 | samtools view -bS - > $name/IIMR_phase2/BAM/IIMR_phase2_01.bam

                        samtools sort -@ $4 -n $name/IIMR_phase2/BAM/IIMR_phase2_00.bam -o $name/IIMR_phase2/BAM/IIMR_phase2_00_nameO.bam
                        samtools sort -@ $4 -n $name/IIMR_phase2/BAM/IIMR_phase2_01.bam -o $name/IIMR_phase2/BAM/IIMR_phase2_01_nameO.bam
                        samtools sort -@ $4 -n $name/IIMR_phase2/BAM/IIMR_phase2_pooled.bam -o $name/IIMR_phase2/BAM/IIMR_phase2_nameO.bam
                        samtools fixmate -@ $4 $name/IIMR_phase2/BAM/IIMR_phase2_00_nameO.bam $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep1.bam
                        samtools fixmate -@ $4 $name/IIMR_phase2/BAM/IIMR_phase2_01_nameO.bam $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep2.bam
                        samtools fixmate -@ $4 $name/IIMR_phase2/BAM/IIMR_phase2_nameO.bam $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRepFULL.bam

                        samtools view -@ $4 -bf 0x2 $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep1.bam | bedtools bamtobed -i stdin -bedpe > $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep1.bedpe
                        samtools view -@ $4 -bf 0x2 $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep2.bam | bedtools bamtobed -i stdin -bedpe > $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep2.bedpe
                        samtools view -@ $4 -bf 0x2 $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRepFULL.bam | bedtools bamtobed -i stdin -bedpe > $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRepFULL.bedpe

                        bash ../Code/bedpeTn5shift.sh $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep1.bedpe > $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep1_tn5.bedpe
                        bash ../Code/bedpeTn5shift.sh $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep2.bedpe > $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep2_tn5.bedpe
                        bash ../Code/bedpeTn5shift.sh $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRepFULL.bedpe > $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRepFULL_tn5.bedpe

                        macs2 callpeak -t $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep1_tn5.bedpe --name $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1 -f BEDPE -g $5 --shift 100 --extsize 200 --nomodel --nolambda --keep-dup all
                        macs2 callpeak -t $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep2_tn5.bedpe --name $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep2 -f BEDPE -g $5 --shift 100 --extsize 200 --nomodel --nolambda --keep-dup all
                        macs2 callpeak -t $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRepFULL_tn5.bedpe --name $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRepFULL -f BEDPE -g $5 --shift 100 --extsize 200 --nomodel --nolambda --keep-dup all
                        awk 'BEGIN{FS=OFS="\t"; print "GeneID\tChr\tStart\tEnd\tStrand"}{print $4, $1, $2+1, $3, "."}' $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1_peaks.narrowPeak > $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1_peaks.saf
                        awk 'BEGIN{FS=OFS="\t"; print "GeneID\tChr\tStart\tEnd\tStrand"}{print $4, $1, $2+1, $3, "."}' $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep2_peaks.narrowPeak > $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep2_peaks.saf
                        awk 'BEGIN{FS=OFS="\t"; print "GeneID\tChr\tStart\tEnd\tStrand"}{print $4, $1, $2+1, $3, "."}' $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRepFULL_peaks.narrowPeak > $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRepFULL_peaks.saf

                        featureCounts -T $4 -p -a $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1_peaks.saf -F SAF -o $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1_peaks.txt $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep1.bam
                        featureCounts -T $4 -p -a $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep2_peaks.saf -F SAF -o $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1_peaks.txt $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep2.bam
                        featureCounts -T $4 -p -a $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRepFULL_peaks.saf -F SAF -o $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1_peaks.txt $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRepFULL.bam

                        sort -k8,8nr $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1_peaks.narrowPeak > $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1_peaks_sorted.narrowPeak
                        sort -k8,8nr $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep2_peaks.narrowPeak > $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep2_peaks_sorted.narrowPeak
                        sort -k8,8nr $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRepFULL_peaks.narrowPeak > $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRepFULL_peaks_sorted.narrowPeak


                        idr --input-file-type narrowPeak --output-file-type narrowPeak --rank p.value --soft-idr-threshold 0.05 --plot --use-best-multisummit-IDR  --peak-list $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRepFULL_peaks_sorted.narrowPeak -s $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1_peaks_sorted.narrowPeak $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep2_peaks_sorted.narrowPeak --output-file $name/IIMR_phase2/IDR/IIMR_phase2_hard_long.narrowPeak

cat $name/IIMR_phase2/IDR/IIMR_phase2_hard_long.narrowPeak | cut -f 1-10 > $name/IIMR_phase2/IDR/IIMR_phase2_hard.narrowPeak



                        idr --input-file-type narrowPeak --output-file-type narrowPeak --rank p.value --soft-idr-threshold 0.05 --plot --use-best-multisummit-IDR -s $name/IIMR_phase1_rescue/$sample_set1/IDR/$sample_set1"_Nt.narrowPeak" $name/IIMR_phase1_rescue/$sample_set2/IDR/$sample_set2"_Nt.narrowPeak" --output-file $name/IIMR_phase2/IDR/IIMR_phase2_soft_long.narrowPeak

cat $name/IIMR_phase2/IDR/IIMR_phase2_soft_long.narrowPeak | cut -f 1-10 > $name/IIMR_phase2/IDR/IIMR_phase2_soft.narrowPeak

                        intersectBed -wo \
                        -a $name/IIMR_phase2/IDR/IIMR_phase2_soft.narrowPeak \
                        -b $name/IIMR_phase2/IDR/IIMR_phase2_hard.narrowPeak | \
                        awk 'BEGIN{FS="\t";OFS="\t"}{s1=$3-$2; s2=$13-$12; if (($21/s1 >= 0) || ($21/s2 >= 0)) {print $0}}' | \
                        cut -f 1-10 | sort | uniq > $name/final/IIMR_optimal.narrowPeak
                fi

                #case2
                if [ $sample_piece1_1 == $sample_piece2_2 ]
                then
                        samtools merge -f -@ $4 \
                        -u $name/IIMR_phase2/BAM/IIMR_phase2_pooled.bam \
                        ../Input_NF/$sample_piece1_1".bam" \
                        ../Input_NF/$sample_piece1_2".bam" \
                        ../Input_NF/$sample_piece2_1".bam"

                        samtools view -@ $4 -H $name/IIMR_phase2/BAM/IIMR_phase2_pooled.bam > $name/IIMR_phase2/BAM/IIMR_phase2_pooled_header.sam

                        nlines=$(samtools view $name/IIMR_phase2/BAM/IIMR_phase2_pooled.bam | wc -l )
                        nlines=$(( (nlines + 1) / 2 ))

                        samtools view -@ $4 $name/IIMR_phase2/BAM/IIMR_phase2_pooled.bam | shuf - | split -d -l ${nlines} - "$name/IIMR_phase2/BAM/IIMR_phase2_pooled"

                        cat $name/IIMR_phase2/BAM/IIMR_phase2_pooled_header.sam $name/IIMR_phase2/BAM/IIMR_phase2_pooled00 | samtools view -bS - > $name/IIMR_phase2/BAM/IIMR_phase2_00.bam
                        cat $name/IIMR_phase2/BAM/IIMR_phase2_pooled_header.sam $name/IIMR_phase2/BAM/IIMR_phase2_pooled01 | samtools view -bS - > $name/IIMR_phase2/BAM/IIMR_phase2_01.bam

                        samtools sort -@ $4 -n $name/IIMR_phase2/BAM/IIMR_phase2_00.bam -o $name/IIMR_phase2/BAM/IIMR_phase2_00_nameO.bam
                        samtools sort -@ $4 -n $name/IIMR_phase2/BAM/IIMR_phase2_01.bam -o $name/IIMR_phase2/BAM/IIMR_phase2_01_nameO.bam
                        samtools sort -@ $4 -n $name/IIMR_phase2/BAM/IIMR_phase2_pooled.bam -o $name/IIMR_phase2/BAM/IIMR_phase2_nameO.bam
                        samtools fixmate -@ $4 $name/IIMR_phase2/BAM/IIMR_phase2_00_nameO.bam $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep1.bam
                        samtools fixmate -@ $4 $name/IIMR_phase2/BAM/IIMR_phase2_01_nameO.bam $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep2.bam
                        samtools fixmate -@ $4 $name/IIMR_phase2/BAM/IIMR_phase2_nameO.bam $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRepFULL.bam

                        samtools view -@ $4 -bf 0x2 $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep1.bam | bedtools bamtobed -i stdin -bedpe > $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep1.bedpe
                        samtools view -@ $4 -bf 0x2 $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep2.bam | bedtools bamtobed -i stdin -bedpe > $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep2.bedpe
                        samtools view -@ $4 -bf 0x2 $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRepFULL.bam | bedtools bamtobed -i stdin -bedpe > $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRepFULL.bedpe

                        bash ../Code/bedpeTn5shift.sh $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep1.bedpe > $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep1_tn5.bedpe
                        bash ../Code/bedpeTn5shift.sh $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep2.bedpe > $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep2_tn5.bedpe
                        bash ../Code/bedpeTn5shift.sh $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRepFULL.bedpe > $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRepFULL_tn5.bedpe

                        macs2 callpeak -t $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep1_tn5.bedpe --name $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1 -f BEDPE -g $5 --shift 100 --extsize 200 --nomodel --nolambda --keep-dup all
                        macs2 callpeak -t $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep2_tn5.bedpe --name $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep2 -f BEDPE -g $5 --shift 100 --extsize 200 --nomodel --nolambda --keep-dup all
                        macs2 callpeak -t $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRepFULL_tn5.bedpe --name $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRepFULL -f BEDPE -g $5 --shift 100 --extsize 200 --nomodel --nolambda --keep-dup all

                        awk 'BEGIN{FS=OFS="\t"; print "GeneID\tChr\tStart\tEnd\tStrand"}{print $4, $1, $2+1, $3, "."}' $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1_peaks.narrowPeak > $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1_peaks.saf
                        awk 'BEGIN{FS=OFS="\t"; print "GeneID\tChr\tStart\tEnd\tStrand"}{print $4, $1, $2+1, $3, "."}' $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep2_peaks.narrowPeak > $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep2_peaks.saf
                        awk 'BEGIN{FS=OFS="\t"; print "GeneID\tChr\tStart\tEnd\tStrand"}{print $4, $1, $2+1, $3, "."}' $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRepFULL_peaks.narrowPeak > $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRepFULL_peaks.saf

                        featureCounts -T $4 -p -a $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1_peaks.saf -F SAF -o $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1_peaks.txt $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep1.bam
                        featureCounts -T $4 -p -a $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep2_peaks.saf -F SAF -o $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1_peaks.txt $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep2.bam
                        featureCounts -T $4 -p -a $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRepFULL_peaks.saf -F SAF -o $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1_peaks.txt $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRepFULL.bam

                        sort -k8,8nr $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1_peaks.narrowPeak > $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1_peaks_sorted.narrowPeak
                        sort -k8,8nr $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep2_peaks.narrowPeak > $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep2_peaks_sorted.narrowPeak
                        sort -k8,8nr $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRepFULL_peaks.narrowPeak > $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRepFULL_peaks_sorted.narrowPeak


                        idr --input-file-type narrowPeak --output-file-type narrowPeak --rank p.value --soft-idr-threshold 0.05 --plot --use-best-multisummit-IDR  --peak-list $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRepFULL_peaks_sorted.narrowPeak -s $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1_peaks_sorted.narrowPeak $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep2_peaks_sorted.narrowPeak --output-file $name/IIMR_phase2/IDR/IIMR_phase2_hard_long.narrowPeak

cat $name/IIMR_phase2/IDR/IIMR_phase2_hard_long.narrowPeak | cut -f 1-10 > $name/IIMR_phase2/IDR/IIMR_phase2_hard.narrowPeak

                        idr --input-file-type narrowPeak --output-file-type narrowPeak --rank p.value --soft-idr-threshold 0.05 --plot --use-best-multisummit-IDR -s $name/IIMR_phase1_rescue/$sample_set1/IDR/$sample_set1"_Nt.narrowPeak" $name/IIMR_phase1_rescue/$sample_set2/IDR/$sample_set2"_Nt.narrowPeak" --output-file $name/IIMR_phase2/IDR/IIMR_phase2_soft_long.narrowPeak

cat $name/IIMR_phase2/IDR/IIMR_phase2_soft_long.narrowPeak | cut -f 1-10 > $name/IIMR_phase2/IDR/IIMR_phase2_soft.narrowPeak

                        intersectBed -wo \
                        -a $name/IIMR_phase2/IDR/IIMR_phase2_soft.narrowPeak \
                        -b $name/IIMR_phase2/IDR/IIMR_phase2_hard.narrowPeak | \
                        awk 'BEGIN{FS="\t";OFS="\t"}{s1=$3-$2; s2=$13-$12; if (($21/s1 >= 0) || ($21/s2 >= 0)) {print $0}}' | \
                        cut -f 1-10 | sort | uniq > $name/final/IIMR_optimal.narrowPeak
                fi


                #case3
                if [ $sample_piece1_2 == $sample_piece2_1 ]
                then
                        samtools merge -f -@ $4 \
                        -u $name/IIMR_phase2/BAM/IIMR_phase2_pooled.bam \
                        ../Input_NF/$sample_piece1_1".bam" \
                        ../Input_NF/$sample_piece1_2".bam" \
                        ../Input_NF/$sample_piece2_2".bam"

                        samtools view -@ $4 -H $name/IIMR_phase2/BAM/IIMR_phase2_pooled.bam > $name/IIMR_phase2/BAM/IIMR_phase2_pooled_header.sam

                        nlines=$(samtools view $name/IIMR_phase2/BAM/IIMR_phase2_pooled.bam | wc -l )
                        nlines=$(( (nlines + 1) / 2 ))

                        samtools view -@ $4 $name/IIMR_phase2/BAM/IIMR_phase2_pooled.bam | shuf - | split -d -l ${nlines} - "$name/IIMR_phase2/BAM/IIMR_phase2_pooled"

                        cat $name/IIMR_phase2/BAM/IIMR_phase2_pooled_header.sam $name/IIMR_phase2/BAM/IIMR_phase2_pooled00 | samtools view -bS - > $name/IIMR_phase2/BAM/IIMR_phase2_00.bam
                        cat $name/IIMR_phase2/BAM/IIMR_phase2_pooled_header.sam $name/IIMR_phase2/BAM/IIMR_phase2_pooled01 | samtools view -bS - > $name/IIMR_phase2/BAM/IIMR_phase2_01.bam

                        samtools sort -@ $4 -n $name/IIMR_phase2/BAM/IIMR_phase2_00.bam -o $name/IIMR_phase2/BAM/IIMR_phase2_00_nameO.bam
                        samtools sort -@ $4 -n $name/IIMR_phase2/BAM/IIMR_phase2_01.bam -o $name/IIMR_phase2/BAM/IIMR_phase2_01_nameO.bam
                        samtools sort -@ $4 -n $name/IIMR_phase2/BAM/IIMR_phase2_pooled.bam -o $name/IIMR_phase2/BAM/IIMR_phase2_nameO.bam
                        samtools fixmate -@ $4 $name/IIMR_phase2/BAM/IIMR_phase2_00_nameO.bam $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep1.bam
                        samtools fixmate -@ $4 $name/IIMR_phase2/BAM/IIMR_phase2_01_nameO.bam $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep2.bam
                        samtools fixmate -@ $4 $name/IIMR_phase2/BAM/IIMR_phase2_nameO.bam $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRepFULL.bam

                        samtools view -@ $4 -bf 0x2 $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep1.bam | bedtools bamtobed -i stdin -bedpe > $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep1.bedpe
                        samtools view -@ $4 -bf 0x2 $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep2.bam | bedtools bamtobed -i stdin -bedpe > $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep2.bedpe
                        samtools view -@ $4 -bf 0x2 $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRepFULL.bam | bedtools bamtobed -i stdin -bedpe > $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRepFULL.bedpe

                        bash ../Code/bedpeTn5shift.sh $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep1.bedpe > $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep1_tn5.bedpe
                        bash ../Code/bedpeTn5shift.sh $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep2.bedpe > $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep2_tn5.bedpe
                        bash ../Code/bedpeTn5shift.sh $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRepFULL.bedpe > $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRepFULL_tn5.bedpe

                        macs2 callpeak -t $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep1_tn5.bedpe --name $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1 -f BEDPE -g $5 --shift 100 --extsize 200 --nomodel --nolambda --keep-dup all
                        macs2 callpeak -t $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep2_tn5.bedpe --name $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep2 -f BEDPE -g $5 --shift 100 --extsize 200 --nomodel --nolambda --keep-dup all
                        macs2 callpeak -t $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRepFULL_tn5.bedpe --name $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRepFULL -f BEDPE -g $5 --shift 100 --extsize 200 --nomodel --nolambda --keep-dup all
                        awk 'BEGIN{FS=OFS="\t"; print "GeneID\tChr\tStart\tEnd\tStrand"}{print $4, $1, $2+1, $3, "."}' $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1_peaks.narrowPeak > $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1_peaks.saf
                        awk 'BEGIN{FS=OFS="\t"; print "GeneID\tChr\tStart\tEnd\tStrand"}{print $4, $1, $2+1, $3, "."}' $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep2_peaks.narrowPeak > $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep2_peaks.saf
                        awk 'BEGIN{FS=OFS="\t"; print "GeneID\tChr\tStart\tEnd\tStrand"}{print $4, $1, $2+1, $3, "."}' $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRepFULL_peaks.narrowPeak > $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRepFULL_peaks.saf

                        featureCounts -T $4 -p -a $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1_peaks.saf -F SAF -o $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1_peaks.txt $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep1.bam
                        featureCounts -T $4 -p -a $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep2_peaks.saf -F SAF -o $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1_peaks.txt $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep2.bam
                        featureCounts -T $4 -p -a $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRepFULL_peaks.saf -F SAF -o $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1_peaks.txt $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRepFULL.bam

                        sort -k8,8nr $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1_peaks.narrowPeak > $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1_peaks_sorted.narrowPeak
                        sort -k8,8nr $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep2_peaks.narrowPeak > $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep2_peaks_sorted.narrowPeak
                        sort -k8,8nr $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRepFULL_peaks.narrowPeak > $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRepFULL_peaks_sorted.narrowPeak


                        idr --input-file-type narrowPeak --output-file-type narrowPeak --rank p.value --soft-idr-threshold 0.05 --plot --use-best-multisummit-IDR  --peak-list $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRepFULL_peaks_sorted.narrowPeak -s $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1_peaks_sorted.narrowPeak $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep2_peaks_sorted.narrowPeak --output-file $name/IIMR_phase2/IDR/IIMR_phase2_hard_long.narrowPeak

cat $name/IIMR_phase2/IDR/IIMR_phase2_hard_long.narrowPeak | cut -f 1-10 > $name/IIMR_phase2/IDR/IIMR_phase2_hard.narrowPeak

                        idr --input-file-type narrowPeak --output-file-type narrowPeak --rank p.value --soft-idr-threshold 0.05 --plot --use-best-multisummit-IDR -s $name/IIMR_phase1_rescue/$sample_set1/IDR/$sample_set1"_Nt.narrowPeak" $name/IIMR_phase1_rescue/$sample_set2/IDR/$sample_set2"_Nt.narrowPeak" --output-file $name/IIMR_phase2/IDR/IIMR_phase2_soft_long.narrowPeak

cat $name/IIMR_phase2/IDR/IIMR_phase2_soft_long.narrowPeak | cut -f 1-10 > $name/IIMR_phase2/IDR/IIMR_phase2_soft.narrowPeak

                        intersectBed -wo \
                        -a $name/IIMR_phase2/IDR/IIMR_phase2_soft.narrowPeak \
                        -b $name/IIMR_phase2/IDR/IIMR_phase2_hard.narrowPeak | \
                        awk 'BEGIN{FS="\t";OFS="\t"}{s1=$3-$2; s2=$13-$12; if (($21/s1 >= 0) || ($21/s2 >= 0)) {print $0}}' | \
                        cut -f 1-10 | sort | uniq > $name/final/IIMR_optimal.narrowPeak
                fi

                #case4
                if [ $sample_piece1_2 == $sample_piece2_2 ]
                then
                        samtools merge -f -@ $4 \
                        -u $name/IIMR_phase2/BAM/IIMR_phase2_pooled.bam \
                        ../Input_NF/$sample_piece1_1".bam" \
                        ../Input_NF/$sample_piece1_2".bam" \
                        ../Input_NF/$sample_piece2_1".bam"

                        samtools view -@ $4 -H $name/IIMR_phase2/BAM/IIMR_phase2_pooled.bam > $name/IIMR_phase2/BAM/IIMR_phase2_pooled_header.sam

                        nlines=$(samtools view $name/IIMR_phase2/BAM/IIMR_phase2_pooled.bam | wc -l )
                        nlines=$(( (nlines + 1) / 2 ))

                        samtools view -@ $4 $name/IIMR_phase2/BAM/IIMR_phase2_pooled.bam | shuf - | split -d -l ${nlines} - "$name/IIMR_phase2/BAM/IIMR_phase2_pooled"

                        cat $name/IIMR_phase2/BAM/IIMR_phase2_pooled_header.sam $name/IIMR_phase2/BAM/IIMR_phase2_pooled00 | samtools view -bS - > $name/IIMR_phase2/BAM/IIMR_phase2_00.bam
                        cat $name/IIMR_phase2/BAM/IIMR_phase2_pooled_header.sam $name/IIMR_phase2/BAM/IIMR_phase2_pooled01 | samtools view -bS - > $name/IIMR_phase2/BAM/IIMR_phase2_01.bam

                        samtools sort -@ $4 -n $name/IIMR_phase2/BAM/IIMR_phase2_00.bam -o $name/IIMR_phase2/BAM/IIMR_phase2_00_nameO.bam
                        samtools sort -@ $4 -n $name/IIMR_phase2/BAM/IIMR_phase2_01.bam -o $name/IIMR_phase2/BAM/IIMR_phase2_01_nameO.bam
                        samtools sort -@ $4 -n $name/IIMR_phase2/BAM/IIMR_phase2_pooled.bam -o $name/IIMR_phase2/BAM/IIMR_phase2_nameO.bam
                        samtools fixmate -@ $4 $name/IIMR_phase2/BAM/IIMR_phase2_00_nameO.bam $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep1.bam
                        samtools fixmate -@ $4 $name/IIMR_phase2/BAM/IIMR_phase2_01_nameO.bam $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep2.bam
                        samtools fixmate -@ $4 $name/IIMR_phase2/BAM/IIMR_phase2_nameO.bam $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRepFULL.bam

                        samtools view -@ $4 -bf 0x2 $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep1.bam | bedtools bamtobed -i stdin -bedpe > $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep1.bedpe
                        samtools view -@ $4 -bf 0x2 $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep2.bam | bedtools bamtobed -i stdin -bedpe > $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep2.bedpe
                        samtools view -@ $4 -bf 0x2 $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRepFULL.bam | bedtools bamtobed -i stdin -bedpe > $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRepFULL.bedpe

                        bash ../Code/bedpeTn5shift.sh $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep1.bedpe > $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep1_tn5.bedpe
                        bash ../Code/bedpeTn5shift.sh $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep2.bedpe > $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep2_tn5.bedpe
                        bash ../Code/bedpeTn5shift.sh $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRepFULL.bedpe > $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRepFULL_tn5.bedpe

                        macs2 callpeak -t $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep1_tn5.bedpe --name $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1 -f BEDPE -g $5 --shift 100 --extsize 200 --nomodel --nolambda --keep-dup all
                        macs2 callpeak -t $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep2_tn5.bedpe --name $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep2 -f BEDPE -g $5 --shift 100 --extsize 200 --nomodel --nolambda --keep-dup all
                        macs2 callpeak -t $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRepFULL_tn5.bedpe --name $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRepFULL -f BEDPE -g $5 --shift 100 --extsize 200 --nomodel --nolambda --keep-dup all

                        featureCounts -T $4 -p -a $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1_peaks.saf -F SAF -o $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1_peaks.txt $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep1.bam
                        featureCounts -T $4 -p -a $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep2_peaks.saf -F SAF -o $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1_peaks.txt $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep2.bam
                        featureCounts -T $4 -p -a $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRepFULL_peaks.saf -F SAF -o $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1_peaks.txt $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRepFULL.bam

                        sort -k8,8nr $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1_peaks.narrowPeak > $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1_peaks_sorted.narrowPeak
                        sort -k8,8nr $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep2_peaks.narrowPeak > $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep2_peaks_sorted.narrowPeak
                        sort -k8,8nr $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRepFULL_peaks.narrowPeak > $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRepFULL_peaks_sorted.narrowPeak


                        idr --input-file-type narrowPeak --output-file-type narrowPeak --rank p.value --soft-idr-threshold 0.05 --plot --use-best-multisummit-IDR  --peak-list $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRepFULL_peaks_sorted.narrowPeak -s $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1_peaks_sorted.narrowPeak $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep2_peaks_sorted.narrowPeak --output-file $name/IIMR_phase2/IDR/IIMR_phase2_hard_long.narrowPeak

cat $name/IIMR_phase2/IDR/IIMR_phase2_hard_long.narrowPeak | cut -f 1-10 > $name/IIMR_phase2/IDR/IIMR_phase2_hard.narrowPeak

                        idr --input-file-type narrowPeak --output-file-type narrowPeak --rank p.value --soft-idr-threshold 0.05 --plot --use-best-multisummit-IDR -s $name/IIMR_phase1_rescue/$sample_set1/IDR/$sample_set1"_Nt.narrowPeak" $name/IIMR_phase1_rescue/$sample_set2/IDR/$sample_set2"_Nt.narrowPeak" --output-file $name/IIMR_phase2/IDR/IIMR_phase2_soft_long.narrowPeak

cat $name/IIMR_phase2/IDR/IIMR_phase2_soft_long.narrowPeak | cut -f 1-10 > $name/IIMR_phase2/IDR/IIMR_phase2_soft.narrowPeak

                        intersectBed -wo \
                        -a $name/IIMR_phase2/IDR/IIMR_phase2_soft.narrowPeak \
                        -b $name/IIMR_phase2/IDR/IIMR_phase2_hard.narrowPeak | \
                        awk 'BEGIN{FS="\t";OFS="\t"}{s1=$3-$2; s2=$13-$12; if (($21/s1 >= 0) || ($21/s2 >= 0)) {print $0}}' | \
                        cut -f 1-10 | sort | uniq > $name/final/IIMR_optimal.narrowPeak
                fi

	fi

fi
if [ $index_num -eq 7 ]
then
        name=$1
        sample_set1=$2
        sample_set2=$3
        sample_set3=$4
        core=$5
        size=$6
        rawsamplenum=$7

        mkdir $name/IIMR_phase2
        mkdir $name/IIMR_phase2/narrowPeak
        mkdir $name/IIMR_phase2/IDR
        mkdir $name/IIMR_phase2/BAM
        mkdir $name/final

        #sample_piece1_1=$(echo $sample_set1 | cut -d'-' -f 1)
        #sample_piece1_2=$(echo $sample_set1 | cut -d'-' -f 2)
        #sample_piece2_1=$(echo $sample_set2 | cut -d'-' -f 1)
        #sample_piece2_2=$(echo $sample_set2 | cut -d'-' -f 2)
        #sample_piece3_1=$(echo $sample_set3 | cut -d'-' -f 2)
        #sample_piece3_2=$(echo $sample_set3 | cut -d'-' -f 2)


        if [ $rawsamplenum -eq 3 ]
        then
                bash ../Code/final_3samples_3pass.sh $name $sample_set1 $sample_set2 $sample_set3 $core $size
	fi


        if [ $rawsamplenum -eq 4 ]
        then
                def=$(echo -e "$sample_piece1_1\n$sample_piece1_2\n$sample_piece2_1\n$sample_piece2_2\n$sample_piece3_1\n$sample_piece3_2" | sort | uniq | wc -l)

                if [ $def -eq 4 ]
                then
                        intersectBed -wo \
                        -a $name/IIMR_phase1_rescue/$sample_set1/narrowPeak/$sample_piece1_1/*peaks.narrowPeak \
                        -b $name/IIMR_phase1_rescue/$sample_set1/narrowPeak/$sample_piece1_2/*peaks.narrowPeak | awk 'BEGIN{FS="\t";OFS="\t"}{s1=$3-$2; s2=$13-$12; if (($21/s1 >= 0.5) || ($21/s2 >= 0.5)) {print $0}}' | \
                        cut -f 1-10 | sort | uniq | \
                        intersectBed -wo \
                        -a stdin \
                        -b $name/IIMR_phase1_rescue/$sample_set2/narrowPeak/$sample_piece2_1/*peaks.narrowPeak | awk 'BEGIN{FS="\t";OFS="\t"}{s1=$3-$2; s2=$13-$12; if (($21/s1 >= 0.5) || ($21/s2 >= 0.5)) {print $0}}' | \
                        cut -f 1-10 | sort | uniq | \
                        intersectBed -wo \
                        -a stdin \
                        -b $name/IIMR_phase1_rescue/$sample_set2/narrowPeak/$sample_piece2_2/*peaks.narrowPeak | awk 'BEGIN{FS="\t";OFS="\t"}{s1=$3-$2; s2=$13-$12; if (($21/s1 >= 0.5) || ($21/s2 >= 0.5)) {print $0}}' | \
                        cut -f 1-10 | sort | uniq | \
                        intersectBed -wo \
                        -a stdin \
                        -b $name/IIMR_phase1_rescue/$sample_set3/narrowPeak/$sample_piece3_1/*peaks.narrowPeak | awk 'BEGIN{FS="\t";OFS="\t"}{s1=$3-$2; s2=$13-$12; if (($21/s1 >= 0.5) || ($21/s2 >= 0.5)) {print $0}}' | \
                        cut -f 1-10 | sort | uniq | \
                        intersectBed -wo \
                        -a stdin \
                        -b $name/IIMR_phase1_rescue/$sample_set3/narrowPeak/$sample_piece3_2/*peaks.narrowPeak | awk 'BEGIN{FS="\t";OFS="\t"}{s1=$3-$2; s2=$13-$12; if (($21/s1 >= 0.5) || ($21/s2 >= 0.5)) {print $0}}' | \
                        cut -f 1-10 | sort | uniq > $name/final/IIMR_optimal.narrowPeak
        	fi

                if [ $def -eq 3 ]
                then
                        sorted_set=""
                        SET=$(seq 1 $def)
                        for i in $SET;
                        do
                                rep=$(echo -e "$sample_piece1_1\n$sample_piece1_2\n$sample_piece2_1\n$sample_piece2_2\n$sample_piece3_1\n$sample_piece3_2" | sort | uniq | head -n $i | tail -n 1)
                                sorted_set=$sorted_set:$rep
                        done
			

                        piece1=$(echo $sorted_set | cut -d':' -f 2)
                        piece2=$(echo $sorted_set | cut -d':' -f 3)
                        piece3=$(echo $sorted_set | cut -d':' -f 4)



                        samtools merge -f -@ $5 \
                        -u $name/IIMR_phase2/BAM/IIMR_phase2_pooled.bam \
                        ../Input_NF/$piece1".bam" \
                        ../Input_NF/$piece2".bam" \
                        ../Input_NF/$piece3".bam"

                        samtools view -@ $5 -H $name/IIMR_phase2/BAM/IIMR_phase2_pooled.bam > $name/IIMR_phase2/BAM/IIMR_phase2_pooled_header.sam

                        nlines=$(samtools view $name/IIMR_phase2/BAM/IIMR_phase2_pooled.bam | wc -l )
                        nlines=$(( (nlines + 1) / 2 ))

                        samtools view -@ $5 $name/IIMR_phase2/BAM/IIMR_phase2_pooled.bam | shuf - | split -d -l ${nlines} - "$name/IIMR_phase2/BAM/IIMR_phase2_pooled"

                        cat $name/IIMR_phase2/BAM/IIMR_phase2_pooled_header.sam $name/IIMR_phase2/BAM/IIMR_phase2_pooled00 | samtools view -bS - > $name/IIMR_phase2/BAM/IIMR_phase2_00.bam
                        cat $name/IIMR_phase2/BAM/IIMR_phase2_pooled_header.sam $name/IIMR_phase2/BAM/IIMR_phase2_pooled01 | samtools view -bS - > $name/IIMR_phase2/BAM/IIMR_phase2_01.bam

                        samtools sort -@ $5 -n $name/IIMR_phase2/BAM/IIMR_phase2_00.bam -o $name/IIMR_phase2/BAM/IIMR_phase2_00_nameO.bam
                        samtools sort -@ $5 -n $name/IIMR_phase2/BAM/IIMR_phase2_01.bam -o $name/IIMR_phase2/BAM/IIMR_phase2_01_nameO.bam
                        samtools sort -@ $5 -n $name/IIMR_phase2/BAM/IIMR_phase2_pooled.bam -o $name/IIMR_phase2/BAM/IIMR_phase2_nameO.bam
                        samtools fixmate -@ $5 $name/IIMR_phase2/BAM/IIMR_phase2_00_nameO.bam $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep1.bam
                        samtools fixmate -@ $5 $name/IIMR_phase2/BAM/IIMR_phase2_01_nameO.bam $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep2.bam
                        samtools fixmate -@ $5 $name/IIMR_phase2/BAM/IIMR_phase2_nameO.bam $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRepFULL.bam

                        samtools view -@ $5 -bf 0x2 $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep1.bam | bedtools bamtobed -i stdin -bedpe > $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep1.bedpe
                        samtools view -@ $5 -bf 0x2 $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep2.bam | bedtools bamtobed -i stdin -bedpe > $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep2.bedpe
                        samtools view -@ $5 -bf 0x2 $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRepFULL.bam | bedtools bamtobed -i stdin -bedpe > $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRepFULL.bedpe

                        bash ../Code/bedpeTn5shift.sh $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep1.bedpe > $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep1_tn5.bedpe
                        bash ../Code/bedpeTn5shift.sh $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep2.bedpe > $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep2_tn5.bedpe
                        bash ../Code/bedpeTn5shift.sh $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRepFULL.bedpe > $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRepFULL_tn5.bedpe


                        macs2 callpeak -t $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep1_tn5.bedpe --name $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1 -f BEDPE -g $6 --shift 100 --extsize 200 --nomodel --nolambda --keep-dup all
                        macs2 callpeak -t $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep2_tn5.bedpe --name $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep2 -f BEDPE -g $6 --shift 100 --extsize 200 --nomodel --nolambda --keep-dup all
                        macs2 callpeak -t $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRepFULL_tn5.bedpe --name $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRepFULL -f BEDPE -g $6 --shift 100 --extsize 200 --nomodel --nolambda --keep-dup all

                        awk 'BEGIN{FS=OFS="\t"; print "GeneID\tChr\tStart\tEnd\tStrand"}{print $4, $1, $2+1, $3, "."}' $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1_peaks.narrowPeak > $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1_peaks.saf
                        awk 'BEGIN{FS=OFS="\t"; print "GeneID\tChr\tStart\tEnd\tStrand"}{print $4, $1, $2+1, $3, "."}' $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep2_peaks.narrowPeak > $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep2_peaks.saf
                        awk 'BEGIN{FS=OFS="\t"; print "GeneID\tChr\tStart\tEnd\tStrand"}{print $4, $1, $2+1, $3, "."}' $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRepFULL_peaks.narrowPeak > $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRepFULL_peaks.saf

                        featureCounts -T $5 -p -a $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1_peaks.saf -F SAF -o $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1_peaks.txt $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep1.bam
                        featureCounts -T $5 -p -a $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep2_peaks.saf -F SAF -o $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1_peaks.txt $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRep2.bam
                        featureCounts -T $5 -p -a $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRepFULL_peaks.saf -F SAF -o $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1_peaks.txt $name/IIMR_phase2/BAM/IIMR_phase2_pseudoRepFULL.bam

                        sort -k8,8nr $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1_peaks.narrowPeak > $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1_peaks_sorted.narrowPeak
                        sort -k8,8nr $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep2_peaks.narrowPeak > $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep2_peaks_sorted.narrowPeak
                        sort -k8,8nr $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRepFULL_peaks.narrowPeak > $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRepFULL_peaks_sorted.narrowPeak


                        idr --input-file-type narrowPeak --output-file-type narrowPeak --rank p.value --soft-idr-threshold 0.05 --plot --use-best-multisummit-IDR  --peak-list $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRepFULL_peaks_sorted.narrowPeak -s $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep1_peaks_sorted.narrowPeak $name/IIMR_phase2/narrowPeak/IIMR_phase2_pseudoRep2_peaks_sorted.narrowPeak --output-file $name/IIMR_phase2/IDR/IIMR_phase2_hard_long.narrowPeak

cat $name/IIMR_phase2/IDR/IIMR_phase2_hard_long.narrowPeak | cut -f 1-10 > $name/IIMR_phase2/IDR/IIMR_phase2_hard.narrowPeak

                        intersectBed -wo \
                        -a $name/IIMR_phase1_rescue/$sample_set1/IDR/$sample_set1"_Nt.narrowPeak" \
                        -b $name/IIMR_phase1_rescue/$sample_set2/IDR/$sample_set2"_Nt.narrowPeak" | awk 'BEGIN{FS="\t";OFS="\t"}{s1=$3-$2; s2=$13-$12; if (($21/s1 >= 0) || ($21/s2 >= 0)) {print $0}}' | \
                        cut -f 1-10 | sort | uniq | \
                        intersectBed -wo \
                        -a stdin \
                        -b $name/IIMR_phase1_rescue/$sample_set3/IDR/$sample_set3"_Nt.narrowPeak" | awk 'BEGIN{FS="\t";OFS="\t"}{s1=$3-$2; s2=$13-$12; if (($21/s1 >= 0) || ($21/s2 >= 0)) {print $0}}' | \
                        cut -f 1-10 | sort | uniq > $name/IIMR_phase2/IDR/IIMR_phase2_soft.narrowPeak


                        intersectBed -wo \
                        -a $name/IIMR_phase2/IDR/IIMR_phase2_soft.narrowPeak \
                        -b $name/IIMR_phase2/IDR/IIMR_phase2_hard.narrowPeak | awk 'BEGIN{FS="\t";OFS="\t"}{s1=$3-$2; s2=$13-$12; if (($21/s1 >= 0) || ($21/s2 >= 0)) {print $0}}' | \
                        cut -f 1-10 | sort | uniq > $name/final/IIMR_optimal.narrowPeak
                fi
	fi
fi
