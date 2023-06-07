index_num=$#


if [ $index_num -eq 5 ]
then


name=$1
a=$2
b=$3
core=$4
size=$5
        echo "===================================="
        echo "======= General information ========"
        echo "===================================="
        echo "Experiment name : $name"
        echo "sample list : $a $b"
        echo "core : $core"
        echo "size : $size"
        echo "===================================="

fi


if [ $index_num -eq 6 ]
then    
name=$1
a=$2
b=$3
c=$4
core=$5
size=$6

        echo "===================================="
        echo "======= General information ========"
        echo "===================================="
        echo "Experiment name : $name"
        echo "sample list : $a $b $c"
        echo "core : $core"
        echo "size : $size"
        echo "===================================="

fi

if [ $index_num -eq 7 ]
then

name=$1
a=$2
b=$3
c=$4
d=$5
core=$6
size=$7

        echo "===================================="
        echo "======= General information ========"
        echo "===================================="
        echo "Experiment name : $name"
        echo "sample list : $a $b $c $d"
        echo "core : $core"
        echo "size : $size"
        echo "===================================="

fi
