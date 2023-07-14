cat GRCz11.fasta | awk -v SEQ="" '{if (match($1, ">") && $1 != NAME) { if (SEQ != "") { print NAME; print toupper(SEQ); } SEQ=""; NAME=$1; } else {SEQ=SEQ""$1;} } END { print NAME; print toupper(SEQ)}' | sed -r s/'A{1,}+'/A/g |sed -r s/'C{1,}+'/C/g |sed -r s/'G{1,}+'/G/g |sed -r s/'T{1,}+'/T/g > compressed.fasta

mv compressed.fasta 5-untip

if [ ! -e mashmap.out ]; then
   mashmap -r GRCz11.fasta -q assembly.fasta --pi 95 -s 10000 -t 8
fi
 
if [ ! -e compressed.mashmap.out ]; then
   cd 5-untip
   cat assembly.homopolymer-compressed.gfa | awk '{if (match($1, "^S")) { print ">"$2; print $3}}' | fold -c >  assembly.homopolymer-compressed.fasta
   mashmap -r compressed.fasta -q assembly.homopolymer-compressed.fasta --pi 95 -s 10000 -t 8
   cd ..
   ln -s 5-untip/mashmap.out compressed.mashmap.out
fi
 
hasNC=`cat mashmap.out | grep -c NC`
g="."
if [ $hasNC -gt 0 ]; then
   g="NC"
fi
hasCNC=`cat compressed.mashmap.out |grep -c NC`
cg="."
if [ $hasCNC -gt 0 ]; then
   cg="NC"
fi
label1="mat-"
label2="pat-"
 
isMAT=`grep -c "mat-" assembly.fasta`
if [ $isMAT -eq 0 ]; then
   isHF=`grep -c "h1tg" assembly.fasta`
   if [ $isHF -eq 0 ]; then
      isUnpaired=`grep -c "contig-" assembly.fasta`
      if [ $isUnpaired -eq 0 ]; then
         label1="haplotype1-"
         label2="haplotype2-"
      else
         label1="contig-"
         label2="none-ignore"
      fi
   else
      label1="h1tg"
      label2="h2tg"
   fi
fi
echo "$isMAT $label1 $label2 compNC: $cg regNC: $g"
 
echo -e "node\tchr" > assembly.homopolymer-compressed.chr.csv
for i in `cat compressed.mashmap.out |awk '{if ($NF > 99) print $6}'|sort |uniq`; do
   echo "Chr $i"
   cat compressed.mashmap.out |awk '{if ($NF > 99 && $4-$3 > 5000000) print $1"\t"$6"\t"$2}'|grep -w $i |sort -srnk3,3|head -n 1 |awk '{print $1"\t"$2}' |sort |uniq | grep "$cg" >> assembly.homopolymer-compressed.chr.csv
done
 
cat assembly.homopolymer-compressed.chr.csv | awk '{print $1}' |sort |uniq > tmp4

/data/korens/devel/sg_sandbox/gfacpp/build/neighborhood assembly.homopolymer-compressed.gfa tmp.gfa -n tmp4 --drop-sequence -r 1000
cat tmp.gfa | grep "^S" |awk '{print $2}' > tmp4
 
#second pass to get missing chr w/shorter matches
cat compressed.mashmap.out |grep -w -v -f tmp4 |awk '{if ($NF > 99 && $4-$3 > 500000) print $1"\t"$6}' |sort |uniq | grep "$cg"  >> assembly.homopolymer-compressed.chr.csv
 
cat mashmap.out |grep "$label1" |grep $g |awk '{if ($NF > 99 && $4-$3 > 1000000) print $1"\t"$6"\t"$2"\t"$7}' |sort |uniq  > translation_hap1
cat mashmap.out |grep "$label2" |grep $g |awk '{if ($NF > 99 && $4-$3 > 1000000) print $1"\t"$6"\t"$2"\t"$7}' |sort   > translation_hap2
 
cat translation_hap1 | sort -k2,2 | awk '{if ($3 > 15000000) print $0}' | awk -v LAST="" -v S="" '{if (LAST != $2) { if (S > 0) print LAST"\t"C"\t"SUM/S*100"\t"MAX/S*100"\t"TIG; SUM=0; MAX=0; C=0; } LAST=$2; S=$NF; SUM+=$3; if (MAX < $3) MAX=$3; C+=1; TIG=$1} END {print LAST"\t"C"\t"SUM/S*100"\t"MAX/S*100"\t"TIG;}'  |awk '{print $1"\t"$4}' | sort -nk1,1 -s > chr_completeness_max_hap1
cat translation_hap2 | sort -k2,2 | awk '{if ($3 > 15000000) print $0}' | awk -v LAST="" -v S="" '{if (LAST != $2) { if (S > 0) print LAST"\t"C"\t"SUM/S*100"\t"MAX/S*100"\t"TIG; SUM=0; MAX=0; C=0; } LAST=$2; S=$NF; SUM+=$3; if (MAX < $3) MAX=$3; C+=1; TIG=$1} END {print LAST"\t"C"\t"SUM/S*100"\t"MAX/S*100"\t"TIG;}' | awk '{print $1"\t"$4}' | sort -nk1,1 -s > chr_completeness_max_hap2
