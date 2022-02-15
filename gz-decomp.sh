#!/usr/bin/env bash

outlocation=$(mktemp -d /media/GalaxyData/database/files/XXXXXX)
SCRIPTDIR=$(dirname "$(readlink -f "$0")")

#extension=$(zipinfo -1 $1 | tail -n+2 | sort -n | awk -F"." '{print $NF}' | sort -n | uniq)
extension=$(zipinfo -1 $1 | egrep \.gz$ | awk -F"." '{print $NF}' | uniq)
filepick=$(zipinfo -1 $1 | egrep \.gz)

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
        zip -q $outlocation/output/out.zip $filepick_fastq
        mv $outlocation/output/out.zip $2
        rm -r $outlocation
    else
        echo "this archive contains no fastq.gz's"
    fi
else
    echo "this archive contains no gz's"
fi

zipinfo $2

echo ""
echo "Outlocation: $outlocation"
echo "\$1:$1"
echo "\$2:$2"