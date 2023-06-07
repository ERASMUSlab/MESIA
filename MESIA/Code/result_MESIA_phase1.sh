#!/bin/bash

index_num=$#

if [ $index_num -eq 5 ]
then

	#GET IDR SCORE
	s1IDR=$(grep chr ./$1/MESIA_phase1_Self-consistence/$2/IDR/$2"_IDR.narrowPeak" | wc -l )
	s2IDR=$(grep chr ./$1/MESIA_phase1_Self-consistence/$3/IDR/$3"_IDR.narrowPeak" | wc -l )
	s3IDR=$(grep chr ./$1/MESIA_phase1_Self-consistence/$4/IDR/$4"_IDR.narrowPeak" | wc -l )
	s4IDR=$(grep chr ./$1/MESIA_phase1_Self-consistence/$5/IDR/$5"_IDR.narrowPeak" | wc -l )

	Np12=$(grep chr ./$1/MESIA_phase1_rescue/$2-$3/IDR/*Np.narrowPeak | wc -l )
	Np13=$(grep chr ./$1/MESIA_phase1_rescue/$2-$4/IDR/*Np.narrowPeak | wc -l )
	Np14=$(grep chr ./$1/MESIA_phase1_rescue/$2-$5/IDR/*Np.narrowPeak | wc -l )
        Np23=$(grep chr ./$1/MESIA_phase1_rescue/$3-$4/IDR/*Np.narrowPeak | wc -l )	
        Np24=$(grep chr ./$1/MESIA_phase1_rescue/$3-$5/IDR/*Np.narrowPeak | wc -l )
        Np34=$(grep chr ./$1/MESIA_phase1_rescue/$4-$5/IDR/*Np.narrowPeak | wc -l )

        Nt12=$(grep chr ./$1/MESIA_phase1_rescue/$2-$3/IDR/*Nt.narrowPeak | wc -l )
        Nt13=$(grep chr ./$1/MESIA_phase1_rescue/$2-$4/IDR/*Nt.narrowPeak | wc -l )
        Nt14=$(grep chr ./$1/MESIA_phase1_rescue/$2-$5/IDR/*Nt.narrowPeak | wc -l )
        Nt23=$(grep chr ./$1/MESIA_phase1_rescue/$3-$4/IDR/*Nt.narrowPeak | wc -l )
        Nt24=$(grep chr ./$1/MESIA_phase1_rescue/$3-$5/IDR/*Nt.narrowPeak | wc -l )
        Nt34=$(grep chr ./$1/MESIA_phase1_rescue/$4-$5/IDR/*Nt.narrowPeak | wc -l )

	if [ $Np12 -lt 1 ]
	then
		Np12=1
	fi
	if [ $Np13 -lt 1 ]
        then
                Np13=1
        fi
        if [ $Np14 -lt 1 ]
        then
                Np14=1
        fi
        if [ $Np23 -lt 1 ]
        then
                Np23=1
        fi
        if [ $Np24 -lt 1 ]
        then
                Np24=1
        fi
        if [ $Np34 -lt 1 ]
        then
                Np34=1
        fi
        if [ $Nt12 -lt 1 ]
        then
                Nt12=1
        fi
        if [ $Nt13 -lt 1 ]
        then
                Nt13=1
        fi
        if [ $Nt14 -lt 1 ]
        then
                Nt14=1
        fi
        if [ $Nt23 -lt 1 ]
        then
                Nt23=1
        fi
        if [ $Nt24 -lt 1 ]
        then
                Nt24=1
        fi
        if [ $Nt34 -lt 1 ]
        then
                Nt34=1
        fi

	#sample1's Self-consistence
	#sample1-2
	if [ $s1IDR -gt $s2IDR ]
	then
		SCA=$(($s1IDR/$s2IDR))
	fi
	if [ $s2IDR -gt $s1IDR ]
	then
        	SCA=$(($s2IDR/$s1IDR))
	fi


	if [ $SCA -lt 2 ]
	then
        	s12=O
	fi
	if [ $SCA -gt 1 ]
	then
        	s12=X
	fi

        #sample1-3
        if [ $s1IDR -gt $s3IDR ]
        then
                SCA=$(($s1IDR/$s3IDR))
        fi
        if [ $s3IDR -gt $s1IDR ]
        then
                SCA=$(($s3IDR/$s1IDR))
        fi


        if [ $SCA -lt 2 ]
        then
                s13=O
        fi
        if [ $SCA -gt 1 ]
        then
                s13=X
        fi

        #sample1-4
        if [ $s1IDR -gt $s4IDR ]
        then
                SCA=$(($s1IDR/$s4IDR))
        fi
        if [ $s4IDR -gt $s1IDR ]
        then
                SCA=$(($s4IDR/$s1IDR))
        fi


        if [ $SCA -lt 2 ]
        then
                s14=O
        fi
        if [ $SCA -gt 1 ]
        then
                s14=X
        fi

	#sample2's Self-consistence
        #sample2-3
        if [ $s2IDR -gt $s3IDR ]
        then
                SCA=$(($s2IDR/$s3IDR))
        fi
        if [ $s3IDR -gt $s2IDR ]
        then
                SCA=$(($s3IDR/$s2IDR))
        fi


        if [ $SCA -lt 2 ]
        then
                s23=O
        fi
        if [ $SCA -gt 1 ]
        then
                s23=X
        fi

	#sample2-4
        if [ $s2IDR -gt $s4IDR ]
        then
                SCA=$(($s2IDR/$s4IDR))
        fi
        if [ $s4IDR -gt $s2IDR ]
        then
                SCA=$(($s4IDR/$s2IDR))
        fi


        if [ $SCA -lt 2 ]
        then
                s24=O
        fi
        if [ $SCA -gt 1 ]
        then
                s24=X
        fi

	#sample3-4
        if [ $s3IDR -gt $s4IDR ]
        then
                SCA=$(($s3IDR/$s4IDR))
        fi
        if [ $s4IDR -gt $s3IDR ]
        then
                SCA=$(($s4IDR/$s3IDR))
        fi


        if [ $SCA -lt 2 ]
        then
                s34=O
        fi
        if [ $SCA -gt 1 ]
        then
                s34=X
        fi



        #sample1's Rescue
        #sample1-2
        if [ $Np12 -gt $Nt12 ]
        then
                RS=$(($Np12/$Nt12))
        fi
        if [ $Nt12 -gt $Np12 ]
        then
                RS=$(($Nt12/$Np12))
        fi


        if [ $RS -lt 2 ]
        then
                r12=O
        fi
        if [ $RS -gt 1 ]
        then
                r12=X
        fi

        #sample1-3
        if [ $Np13 -gt $Nt13 ]
        then
                RS=$(($Np13/$Nt13))
        fi
        if [ $Nt13 -gt $Np13 ]
        then
                RS=$(($Nt13/$Np13))
        fi


        if [ $RS -lt 2 ]
        then
                r13=O
        fi
        if [ $RS -gt 1 ]
        then
                r13=X
        fi


        #sample1-4
        if [ $Np14 -gt $Nt14 ]
        then
                RS=$(($Np14/$Nt14))
        fi
        if [ $Nt14 -gt $Np14 ]
        then
                RS=$(($Nt14/$Np14))
        fi


        if [ $RS -lt 2 ]
        then
                r14=O
        fi
        if [ $RS -gt 1 ]
        then
                r14=X
        fi

        #sample2-3
        if [ $Np23 -gt $Nt23 ]
        then
                RS=$(($Np23/$Nt23))
        fi
        if [ $Nt23 -gt $Np23 ]
        then
                RS=$(($Nt23/$Np23))
        fi


        if [ $RS -lt 2 ]
        then
                r23=O
        fi
        if [ $RS -gt 1 ]
        then
                r23=X
        fi

        #sample2-4
        if [ $Np24 -gt $Nt24 ]
        then
                RS=$(($Np24/$Nt24))
        fi
        if [ $Nt24 -gt $Np24 ]
        then
                RS=$(($Nt24/$Np24))
        fi


        if [ $RS -lt 2 ]
        then
                r24=O
        fi
        if [ $RS -gt 1 ]
        then
                r24=X
        fi


        #sample3-4
        if [ $Np34 -gt $Nt34 ]
        then
                RS=$(($Np34/$Nt34))
        fi
        if [ $Nt34 -gt $Np34 ]
        then
                RS=$(($Nt34/$Np34))
        fi


        if [ $RS -lt 2 ]
        then
                r34=O
        fi
        if [ $RS -gt 1 ]
        then
                r34=X
        fi

	f12=X
        f13=X
        f14=X
        f23=X
        f24=X
        f34=X

	#final
	if [ $s12 == O ]
        then
                if [ $r12 == O ]
		then	
			f12=O
        	fi
        fi
	if [ $s13 == O ]
        then
                if [ $r13 == O ]
                then    
                        f13=O
        	fi
        fi
	if [ $s14 == O ]
        then
                if [ $r14 == O ]
                then    
                        f14=O
        	fi
        fi
        if [ $s24 == O ]
        then
                if [ $r24 == O ]
                then
                        f24=O
        	fi
        fi
        if [ $s23 == O ]
        then
                if [ $r23 == O ]
                then
                        f23=O
        	fi
        fi
        if [ $s34 == O ]
        then
                if [ $r34 == O ]
                then
                        f34=O
        	fi
        fi

echo "==================================="
echo "Result of Self-consistence analysis"
echo "==================================="
echo "    s1 s2 s3 s4  "
echo " s1 ~  $s12  $s13  $s14 "
echo " s2 $s12  ~  $s23  $s24 "
echo " s3 $s13  $s23  ~  $s34 "
echo " s4 $s14  $s24  $s34  ~ "
echo "==================================="
echo "Result of Rescue analysis"
echo "==================================="
echo "    s1 s2 s3 s4  "
echo " s1 ~  $r12  $r13  $r14 "
echo " s2 $r12  ~  $r23  $r24 "
echo " s3 $r13  $r23  ~  $r34 "
echo " s4 $r14  $r24  $r34  ~ "
echo "==================================="
echo "Result of MESIA phase1 analysis"
echo "==================================="
echo "    s1 s2 s3 s4  "
echo " s1 ~  $f12  $f13  $f14 "
echo " s2 $f12  ~  $f23  $f24 "
echo " s3 $f13  $f23  ~  $f34 "
echo " s4 $f14  $f24  $f34  ~ "

	

	phase1_12=""
        phase1_13=""
        phase1_14=""
        phase1_23=""
        phase1_24=""
        phase1_34=""

	if [ $f12 == O ]
        then
		phase1_12="$2-$3 "
        fi

        if [ $f13 == O ]
        then
                phase1_13="$2-$4 "
        fi

        if [ $f14 == O ]
        then
                phase1_14="$2-$5 "
        fi

        if [ $f23 == O ]
        then
                phase1_23="$3-$4 "
        fi

        if [ $f24 == O ]
        then
                phase1_24="$3-$5 "
        fi

        if [ $f34 == O ]
        then
                phase1_34="$4-$5 "
        fi

	final="$phase1_12$phase1_13$phase1_14$phase1_23$phase1_24$phase1_34"

	echo "Passed replication set is"
	echo "$final"

fi

if [ $index_num -eq 4 ]
then

        #GET IDR SCORE
        s1IDR=$(grep chr ./$1/MESIA_phase1_Self-consistence/$2/IDR/$2"_IDR.narrowPeak" | wc -l )
        s2IDR=$(grep chr ./$1/MESIA_phase1_Self-consistence/$3/IDR/$3"_IDR.narrowPeak" | wc -l )
        s3IDR=$(grep chr ./$1/MESIA_phase1_Self-consistence/$4/IDR/$4"_IDR.narrowPeak" | wc -l )

        Np12=$(grep chr ./$1/MESIA_phase1_rescue/$2-$3/IDR/*Np.narrowPeak | wc -l )
        Np13=$(grep chr ./$1/MESIA_phase1_rescue/$2-$4/IDR/*Np.narrowPeak | wc -l )
        Np23=$(grep chr ./$1/MESIA_phase1_rescue/$3-$4/IDR/*Np.narrowPeak | wc -l )

        Nt12=$(grep chr ./$1/MESIA_phase1_rescue/$2-$3/IDR/*Nt.narrowPeak | wc -l )
        Nt13=$(grep chr ./$1/MESIA_phase1_rescue/$2-$4/IDR/*Nt.narrowPeak | wc -l )
        Nt23=$(grep chr ./$1/MESIA_phase1_rescue/$3-$4/IDR/*Nt.narrowPeak | wc -l )

        if [ $Np12 -lt 1 ]
        then
                Np12=1
        fi
        if [ $Np13 -lt 1 ]
        then
                Np13=1
        fi
        if [ $Np23 -lt 1 ]
        then
                Np23=1
        fi

        if [ $Nt12 -lt 1 ]
        then
                Nt12=1
        fi
        if [ $Nt13 -lt 1 ]
        then
                Nt13=1
        fi
        if [ $Nt23 -lt 1 ]
        then
                Nt23=1
        fi

        #sample1's Self-consistence
        #sample1-2
        if [ $s1IDR -gt $s2IDR ]
        then
                SCA=$(($s1IDR/$s2IDR))
        fi
        if [ $s2IDR -gt $s1IDR ]
        then
                SCA=$(($s2IDR/$s1IDR))
        fi


        if [ $SCA -lt 2 ]
        then
                s12=O
        fi
        if [ $SCA -gt 1 ]
        then
                s12=X
        fi

        #sample1-3
        if [ $s1IDR -gt $s3IDR ]
        then
                SCA=$(($s1IDR/$s3IDR))
        fi
        if [ $s3IDR -gt $s1IDR ]
        then
                SCA=$(($s3IDR/$s1IDR))
        fi


        if [ $SCA -lt 2 ]
        then
                s13=O
        fi
        if [ $SCA -gt 1 ]
        then
                s13=X
        fi


        #sample2's Self-consistence
        #sample2-3
        if [ $s2IDR -gt $s3IDR ]
        then
                SCA=$(($s2IDR/$s3IDR))
        fi
        if [ $s3IDR -gt $s2IDR ]
        then
                SCA=$(($s3IDR/$s2IDR))
        fi


        if [ $SCA -lt 2 ]
        then
                s23=O
        fi
        if [ $SCA -gt 1 ]
        then
                s23=X
        fi

        #sample1's Rescue
        #sample1-2
        if [ $Np12 -gt $Nt12 ]
        then
                RS=$(($Np12/$Nt12))
        fi
        if [ $Nt12 -gt $Np12 ]
        then
                RS=$(($Nt12/$Np12))
        fi


        if [ $RS -lt 2 ]
        then
                r12=O
        fi
        if [ $RS -gt 1 ]
        then
                r12=X
        fi

        #sample1-3
        if [ $Np13 -gt $Nt13 ]
        then
                RS=$(($Np13/$Nt13))
        fi
        if [ $Nt13 -gt $Np13 ]
        then
                RS=$(($Nt13/$Np13))
        fi

        if [ $RS -lt 2 ]
        then
                r13=O
        fi
        if [ $RS -gt 1 ]
        then
                r13=X
        fi

        #sample2-3
        if [ $Np23 -gt $Nt23 ]
        then
                RS=$(($Np23/$Nt23))
        fi
        if [ $Nt23 -gt $Np23 ]
        then
                RS=$(($Nt23/$Np23))
        fi

	if [ $RS -lt 2 ]
        then
                r23=O
        fi
        if [ $RS -gt 1 ]
        then
                r23=X
        fi


        f12=X
        f13=X
        f23=X

        #final
        if [ $s12 == O ]
        then
                if [ $r12 == O ]
                then
                        f12=O
                fi
        fi
        if [ $s13 == O ]
        then
                if [ $r13 == O ]
                then
                        f13=O
                fi
        fi
        if [ $s23 == O ]
        then
                if [ $r23 == O ]
                then
                        f23=O
                fi
        fi

echo "==================================="
echo "Result of Self-consistence analysis"
echo "==================================="
echo "    s1 s2 s3   "
echo " s1 ~  $s12  $s13  "
echo " s2 $s12  ~  $s23  "
echo " s3 $s13  $s23  ~  "
echo "==================================="
echo "Result of Rescue analysis"
echo "==================================="
echo "    s1 s2 s3   "
echo " s1 ~  $r12  $r13  "
echo " s2 $r12  ~  $r23  "
echo " s3 $r13  $r23  ~  "
echo "==================================="
echo "Result of MESIA phase1 analysis"
echo "==================================="
echo "    s1 s2 s3   "
echo " s1 ~  $f12  $f13   "
echo " s2 $f12  ~  $f23   "
echo " s3 $f13  $f23  ~   "

        phase1_12=""
        phase1_13=""
        phase1_23=""

        if [ $f12 == O ]
        then
                phase1_12="$2-$3 "
        fi

        if [ $f13 == O ]
        then
                phase1_13="$2-$4 "
        fi


        if [ $f23 == O ]
        then
                phase1_23="$3-$4 "
        fi


        final="$phase1_12$phase1_13$phase1_23"

	echo "Passed replication set is"
	echo "$final"


fi


if [ $index_num -eq 3 ]
then

        #GET IDR SCORE
        s1IDR=$(grep chr ./$1/MESIA_phase1_Self-consistence/$2/IDR/$2"_IDR.narrowPeak" | wc -l )
        s2IDR=$(grep chr ./$1/MESIA_phase1_Self-consistence/$3/IDR/$3"_IDR.narrowPeak" | wc -l )

        Np12=$(grep chr ./$1/MESIA_phase1_rescue/$2-$3/IDR/*Np.narrowPeak | wc -l )

        Nt12=$(grep chr ./$1/MESIA_phase1_rescue/$2-$3/IDR/*Nt.narrowPeak | wc -l )

        if [ $Np12 -lt 1 ]
        then
                Np12=1
        fi

        if [ $Nt12 -lt 1 ]
        then
                Nt12=1
        fi


        #sample1's Self-consistence
        #sample1-2
        if [ $s1IDR -gt $s2IDR ]
        then
                SCA=$(($s1IDR/$s2IDR))
        fi
        if [ $s2IDR -gt $s1IDR ]
        then
                SCA=$(($s2IDR/$s1IDR))
        fi


        if [ $SCA -lt 2 ]
        then
                s12=O
        fi
        if [ $SCA -gt 1 ]
        then
                s12=X
        fi

        #sample1's Rescue
        #sample1-2
        if [ $Np12 -gt $Nt12 ]
        then
                RS=$(($Np12/$Nt12))
        fi
        if [ $Nt12 -gt $Np12 ]
        then
                RS=$(($Nt12/$Np12))
        fi


        if [ $RS -lt 2 ]
        then
                r12=O
        fi
        if [ $RS -gt 1 ]
        then
                r12=X
        fi

        f12=X

        #final
        if [ $s12 == O ]
        then
                if [ $r12 == O ]
                then
                        f12=O
                fi
        fi

echo "==================================="
echo "Result of Self-consistence analysis"
echo "==================================="
echo "    s1 s2   "
echo " s1 ~  $s12  "
echo " s2 $s12  ~  "
echo "==================================="
echo "Result of Rescue analysis"
echo "==================================="
echo "    s1 s2   "
echo " s1 ~  $r12  "
echo " s2 $r12  ~  "
echo "==================================="
echo "Result of MESIA phase1 analysis"
echo "==================================="
echo "    s1 s2   "
echo " s1 ~  $f12   "
echo " s2 $f12  ~   "

        phase1_12=""
        
        if [ $f12 == O ]
        then    
                phase1_12="$2-$3 "
        fi              

        final="$phase1_12"

        echo "Passed replication set is"
        echo "$final"


fi

