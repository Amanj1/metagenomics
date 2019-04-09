#!/bin/bash
set -euo pipefail

reads=()
while IFS= read -d $'\0' -r file ; do
			reads=("${reads[@]}" "$file")
		done < <(find "$(cd /proj/virus/results/LCH/190405/bbmap_results; pwd)" -name *flagstat.txt -print0)	

IFS=$'\n' sorted_reads=($(sort <<<"${reads[*]}"))
#printf "[%s]\n" "${sorted_reads[@]}"

for i in "${sorted_reads[@]}"; do

	python3 gen_table.py "$i" "LCH_episome_mapped_reads.tsv"
done
