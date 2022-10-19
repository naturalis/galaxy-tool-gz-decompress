#!/usr/bin/env bash

printf "Conda env: $CONDA_DEFAULT_ENV\n"
printf "Python version: $(python --version)\n"
printf "Unzip version: $(unzip -v | head -n1 | awk '{print $1,$2}')\n"
printf "Bash version: ${BASH_VERSION}\n\n"

outlocation=$(mktemp -d /data/files/XXXXXX)
SCRIPTDIR=$(dirname "$(readlink -f "$0")")

#extension=$(zipinfo -1 $1 | tail -n+2 | sort -n | awk -F"." '{print $NF}' | sort -n | uniq)
extension=$(zipinfo -1 $1 | egrep \.gz$ | awk -F"." '{print $NF}' | uniq)
filepick=$(zipinfo -1 $1 | egrep \.gz$)

# check for gz
if [[ $extension == "gz" ]]
then
    # echo "gzips detected: let's unzip"
    unzip -q -j $1 $filepick -d $outlocation/output
    extension2=$(ls -1 $outlocation/output | awk -F"." '{print $(NF-1)"."$NF}' | sort | uniq)
    # check for fastq
    if [[ $extension2 == "fastq.gz" ]]
    then
        for file in $(ls -1d $outlocation/output/*.gz)
        do
            gunzip $file
        done
        # create zip from fastq
        filepick_fastq=$(ls -1d $outlocation/output/*.fastq)
        # printf "\nfilepick:\n$filepick_fastq\n"
        zip -q -j $outlocation/output/out.zip $filepick_fastq
        mv $outlocation/output/out.zip $2
        rm -r $outlocation
    elif [[ $extension2 == "fasta.gz" ]]
    then
        for file in $(ls -1d $outlocation/output/*.gz)
        do
            gunzip $file
        done
        # create zip from fasta
        filepick_fasta=$(ls -1d $outlocation/output/*.fasta)
        # printf "\nfilepick:\n$filepick_fasta\n"
        zip -q -j $outlocation/output/out.zip $filepick_fasta
        mv $outlocation/output/out.zip $2
        rm -r $outlocation        
    else
        printf "this archive contains no fasta/fastq.gz's" >&2
        exit 1
    fi
else
    printf "this archive contains no gz's" >&2
    exit 1
fi

printf "zip log:\n"
zipinfo $2

echo ""
echo "Outlocation: $outlocation"
echo "\$1:$1"
echo "\$2:$2"