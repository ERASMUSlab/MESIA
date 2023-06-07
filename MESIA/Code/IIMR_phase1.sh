#!/bin/bash

index_num=$#
today=`date +%m-%d-%y_%H:%M`

if [ $index_num -gt 7 ]
then
        echo "sorry"
fi

if [ $index_num -eq 5 ]
then
	name=$1
        a="$a${2%\.bam}"
        b="$b${3%\.bam}"
        core=$4
        size=$5
	echo "==================================="
	echo "======= General infomation ========"
	echo "==================================="
        echo "Experiment name : $name"
	echo "sample list : $a $b"
        echo "core : $core"
        echo "size : $size"
	echo "==================================="
	echo ""
		#Rescue analysis
		echo "Rescue analysis <<$a"-"$b>>..."
		bash ../Code/IIMR_phase1_rescue.sh $a $b $a"-"$b $core $size	
		mkdir $name
		mkdir $name/IIMR_phase1_rescue
		mv $a"-"$b $name/IIMR_phase1_rescue
fi


if [ $index_num -eq 6 ]
then
	name=$1
        a="$a${2%\.bam}"
        b="$b${3%\.bam}"
        c="$c${4%\.bam}"
        core=$5
        size=$6
	echo "==================================="
        echo "======= General infomation ========"
	echo "==================================="
        echo "Experiment name : $name"
	echo "sample list : $a $b $c"
        echo "core : $core"
        echo "size : $size"
        echo "==================================="
	echo ""
        	#Rescue analysis
		echo "Rescue analysis <<$a"-"$b>>..."
        	bash ../Code/IIMR_phase1_rescue.sh $a $b $a"-"$b $core $size
		echo "Rescue analysis <<$a"-"$c>>..."
        	bash ../Code/IIMR_phase1_rescue.sh $a $c $a"-"$c $core $size
		echo "Rescue analysis <<$b"-"$c>>..."
        	bash ../Code/IIMR_phase1_rescue.sh $b $c $b"-"$c $core $size	
		mkdir $name
		mkdir $name/IIMR_phase1_rescue
		mv $a"-"$b $name/IIMR_phase1_rescue
		mv $a"-"$c $name/IIMR_phase1_rescue
		mv $b"-"$c $name/IIMR_phase1_rescue
fi



if [ $index_num -eq 7 ]
then
	name=$1
    	a="$a${2%\.bam}"
	b="$b${3%\.bam}"
	c="$c${4%\.bam}"
	d="$d${5%\.bam}"
	core=$6
	size=$7
	echo "==================================="
        echo "======= General infomation ========"
	echo "==================================="
	echo "Experiment name : $name"
	echo "sample list : $a $b $c $d"
	echo "core : $core"
	echo "size : $size"
	echo "==================================="
	echo ""
        	#Rescue analysis
		echo "Rescue analysis <<$a"-"$b>>..."
        	bash ../Code/IIMR_phase1_rescue.sh $a $b $a"-"$b $core $size
        	echo "Rescue analysis <<$a"-"$c>>..."
        	bash ../Code/IIMR_phase1_rescue.sh $a $c $a"-"$c $core $size
		echo "Rescue analysis <<$a"-"$d>>..."
        	bash ../Code/IIMR_phase1_rescue.sh $a $d $a"-"$d $core $size
        	echo "Rescue analysis <<$b"-"$c>>..."
        	bash ../Code/IIMR_phase1_rescue.sh $b $c $b"-"$c $core $size
		echo "Rescue analysis <<$b"-"$d>>..."
        	bash ../Code/IIMR_phase1_rescue.sh $b $d $b"-"$d $core $size
		echo "Rescue analysis <<$c"-"$d>>..."
        	bash ../Code/IIMR_phase1_rescue.sh $c $d $c"-"$d $core $size
        	mkdir $name
		mkdir $name/IIMR_phase1_rescue
        	mv $a"-"$b $name/IIMR_phase1_rescue
        	mv $a"-"$c $name/IIMR_phase1_rescue
		mv $a"-"$d $name/IIMR_phase1_rescue
        	mv $b"-"$c $name/IIMR_phase1_rescue
		mv $b"-"$d $name/IIMR_phase1_rescue
		mv $c"-"$d $name/IIMR_phase1_rescue
	
fi

