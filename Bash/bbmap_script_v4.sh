#!/bin/bash
set -euo pipefail

export PATH="/proj/virus/tools/samtools/1.9/bin:$PATH"
bbmap="/proj/virus/tools/bbmap/38.44/bbmap.sh"
list_ref=()
while IFS= read -d $'\0' -r file ; do
	      list_ref=("${list_ref[@]}" "$file")
done < <(find "$(cd /proj/virus/results/LCH/episome_seq; pwd)" -name *fasta -print0)

list_dir=()
while IFS= read -d $'\0' -r file ; do
		list_dir=("${list_dir[@]}" "$file")
done < <(find "$(cd /proj/virus/results/LCH/190402/preprocessing; pwd)" -name P* -maxdepth 1 -print0)

IFS=$'\n' sorted_list_dir=($(sort <<<"${list_dir[*]}"))
#printf "[%s]\n" "${sorted_list_dir[@]}"

IFS=$'\n' sorted_ref=($(sort <<<"${list_ref[*]}"))
#printf "[%s]\n" "${sorted_ref[@]}"

for i in "${sorted_list_dir[@]}"; do
	echo "$i"
	
	tmp_reads=()
	while IFS= read -d $'\0' -r file ; do
			tmp_reads=("${tmp_reads[@]}" "$file")
	done < <(find "$(cd $i; pwd)" -name *fq.gz -print0)

	IFS=$'\n' sorted_tmp_reads=($(sort <<<"${tmp_reads[*]}"))
	printf "[%s]\n" "${sorted_tmp_reads[@]}"

	for j in "${sorted_ref[@]}"; do
		outname_dir="$(basename $i)"
		outname_ref="$(basename $j)"
		outname="mapped_""$outname_dir""_ref_""$outname_ref"
		paired_out=$outname"_paried.sam"
		unpaired_out=$outname"_unpaired.sam"

		$bbmap in1="${sorted_tmp_reads[0]}" in2="${sorted_tmp_reads[1]}" out="$paired_out" ref="$j" covstats="covstats_""$paired_out"".txt" covhist="covhist_""$paired_out"".txt" basecov="basecov_""$paired_out"".txt" bincov="bincov_""$paired_out"".txt"
		mv ref ref_paired
		samtools view -hbS "$paired_out" | samtools sort -O bam - | samtools flagstat - > "flagstat_""$paired_out"".txt" 		

		$bbmap in="${sorted_tmp_reads[2]}" ref="$j" out="$unpaired_out" covstats="covstats_""$unpaired_out"".txt" covhist="covhist_""$unpaired_out"".txt" basecov="basecov_""$unpaired_out"".txt" bincov="bincov_""$unpaired_out"".txt"
		samtools view -hbS "$paired_out" | samtools sort -O bam - | samtools flagstat - > "flagstat_""$unpaired_out"".txt"
	
		python3 gen_lineChart.py "basecov_""$paired_out"".txt" "$paired_out"".png"
		python3 gen_lineChart.py "basecov_""$unpaired_out"".txt" "$unpaired_out"".png"	
		mv ref ref_unpaired
		mkdir -p $outname_dir
		mkdir $outname_ref
		mv *txt $outname_ref
		mv *png $outname_ref
		mv $paired_out $outname_ref
		mv $unpaired_out $outname_ref
		mv ref* $outname_ref
		mv $outname_ref $outname_dir
	done
	unset tmp_reads
done


