#!/bin/bash

list_ref=()
while IFS= read -d $'\0' -r file ; do
	      list_ref=("${list_ref[@]}" "$file")
done < <(find "$(cd /proj/virus/results/LCH/episome_seq; pwd)" -name *fasta -print0)

list_dir=()
while IFS= read -d $'\0' -r file ; do
		list_dir=("${list_dir[@]}" "$file")
done < <(find "$(cd /proj/virus/results/LCH/190402/preprocessing; pwd)" -name P* -maxdepth 1 -print0)

tmp_reads=()
while IFS= read -d $'\0' -r file ; do
		tmp_reads=("${tmp_reads[@]}" "$file")
done < <(find "$(cd ${list_dir[0]}; pwd)" -name *fq.gz -print0)

IFS=$'\n' sorted_tmp_reads=($(sort <<<"${tmp_reads[*]}"))
#printf "[%s]\n" "${sorted_tmp_reads[@]}"

FS=$'\n' sorted_list_dir=($(sort <<<"${list_dir[*]}"))
#printf "[%s]\n" "${sorted_list_dir[@]}"

IFS=$'\n' sorted_ref=($(sort <<<"${list_ref[*]}"))
#printf "[%s]\n" "${sorted_ref[@]}"

outname_dir="$(basename ${sorted_list_dir[0]})"
outname_ref="$(basename ${sorted_ref[0]})"
outname="mapped_""$outname_dir""_ref_""$outname_ref"
paired_out=$outname"_paried.sam"
unpaired_out=$outname"_unparied.sam"

for i in "${sorted_list_dir[@]}"; do
       	echo "$i"
done

/proj/virus/tools/bbmap/38.44/bbmap.sh in1="${sorted_tmp_reads[0]}" in2="${sorted_tmp_reads[1]}" out="$paired_out" ref="${sorted_ref[0]}"
mv ref ref_paired

/proj/virus/tools/bbmap/38.44/bbmap.sh in="${sorted_tmp_reads[2]}" ref="${sorted_ref[0]}" out="$unpaired_out"
mv ref ref_unpaired

mkdir $outname_dir
mkdir $outname_ref
mv $paired_out $outname_ref
mv $unpaired_out $outname_ref
mv ref* $outname_ref
mv $outname_ref $outname_dir

for i in "${sorted_list_dir[@]}"; do
	echo "$i"
done


