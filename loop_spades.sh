#!/bin/usr/env bash

# ABOUT:
# 	This file runs spades.py for multiple pairs of fastq.gz files in a directory
#
# USAGE:
# 	1) Put this file inside of the directory your fastq.gz files are located.
#   2) Make this file executable. From a command line type: chmod +x loop_spades.sh
#   3) RUN using this command from the terminal: bash loop_spades.sh

# *********************************************************************************
# Find all files in current directory that end with "_R1_001.fastq.gz" and parse to
# find number ranges that exist in file names
for file in *_R1_001.fastq.gz;
do
	front="${file%%S*}" # get file text before number
	back="${file#*S}"   # get file text after number
	num="${back%%_*}"	# get number from the file name text
	num_array+=($num)   # add file number to an array
done

# Loop through the number array with the numbered pairs
for i in ${num_array[@]};
do
	# make output directory
	mkdir ${PWD}/results_${i}

	# RUN SPADES PYTHON PROGRAM
	spades.py --cov-cutoff auto \
	-1 ${PWD}/*${i}_R1_001.fastq.gz \
	-2 ${PWD}/*${i}_R2_001.fastq.gz \
	-o ${PWD}/results_${i} \
	--threads 15 \
	--memory 500 \
	--isolate

	# wait for the first job to finish until 
	# program moves onto the next pair
	wait
done
