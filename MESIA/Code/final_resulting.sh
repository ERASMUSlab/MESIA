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

        mkdir $name/final
        bash ../Code/final_2pass.sh $name $sample_set1 $sample_set2
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

        mkdir $name/final
	bash ../Code/final_3pass.sh $name $sample_set1 $sample_set2 $sample_set3

fi

if [ $index_num -eq 8 ]
then
        name=$1
        sample_set1=$2
        sample_set2=$3
        sample_set3=$4
	sample_set4=$5
        core=$6
        size=$7
        rawsamplenum=$8

        mkdir $name/final
        bash ../Code/final_4pass.sh $name $sample_set1 $sample_set2 $sample_set3 $sample_set4

fi

if [ $index_num -eq 9 ]
then
        name=$1
        sample_set1=$2
        sample_set2=$3
        sample_set3=$4
        sample_set4=$5
	sample_set5=$6
        core=$7
        size=$8
        rawsamplenum=$9

        mkdir $name/final
        bash ../Code/final_5pass.sh $name $sample_set1 $sample_set2 $sample_set3 $sample_set4 $sample_set5

fi

if [ $index_num -eq 10 ]
then
        name=$1
        sample_set1=$2
        sample_set2=$3
        sample_set3=$4
        sample_set4=$5
        sample_set5=$6
	sample_set6=$7
        core=$8
        size=$9
        rawsamplenum=$10

        mkdir $name/final
        bash ../Code/final_6pass.sh $name $sample_set1 $sample_set2 $sample_set3 $sample_set4 $sample_set5 $sample_set6

fi

