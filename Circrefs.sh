cat *.log | 
awk -vORS= '{if ($0~"^[0-9][0-9]:[0-9][0-9].[0-9]{1,20}") { print "\n"$0;} else { print " "$0; }}' > prelog.txt &&
cat prelog.txt | 
grep -P 'SCRIPTCIRCREFS.+Context=' |
sed -r 's/^[0-9]+:[0-9]+\.[0-9]+-//' |
sed -r 's/SCRIPTCIRCREFS,.+,Context=/SCRIPTCIRCREFS,Context=/' |
gawk -F',SCRIPTCIRCREFS,Context=' '{errs[$2]+=1}END{for (i in errs) print errs[i] " " i}' |
sort -rnb |
head -n 100 > count.txt