#!/usr/bin/env bash

#extension=$(zipinfo -1 $1 | tail -n+2 | sort -n | awk -F"." '{print $NF}' | sort -n | uniq)

extension=$(zipinfo -1 $1 | egrep \.gz$ | awk -F"." '{print $NF}' | uniq)
filepick=$(zipinfo -1 $1 | egrep \.gz)

# check for gz
if [[ $extension == "gz" ]]
then
    echo "gzips detected: let's unzip"
    unzip -j $1 $filepick -d output
    extension2=$(ls -1 output | awk -F"." '{print $(NF-1)"."$NF}' | sort | uniq)
    # check for fastq
    if [[ $extension2 == "fastq.gz" ]]
    then
        for file in $(ls -1 output/*.gz)
        do
            gunzip $file
        done
        zip output/out.zip output/*.fastq
        rm output/*.fastq
    else
        echo "this archive contains no fastq.gz's"
    fi
else
    echo "this archive contains no gz's"
fi
