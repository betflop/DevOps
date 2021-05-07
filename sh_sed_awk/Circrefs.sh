find SCRIPTCIRCREFS/ -type f | xargs cat |
# cat 19121816.log | 
gawk -vORS= '{if ($0~"^[0-9][0-9]:[0-9][0-9].[0-9]{1,20}") { print "\n"$0;} else { print " "$0; }}' |
sed -r 's/\n/@/g; s/^[0-9][0-9]:[0-9][0-9].[0-9]+-/\n/' |
# -v - переопределяет стандартные переменные
# -RS - переопределяет символ переноса строки
grep -P 'SCRIPTCIRCREFS.+Context=' |
# sed -r 's/^[0-9]+:[0-9]+\.[0-9]+-//' |
sed -r 's/.+,SCRIPTCIRCREFS.+processName=//' |
sed -r 's/,OSThread.+,Context/ Context/' |
gawk '{errs[$0]+=1}END{for (i in errs) print errs[i] " " i}' |
sort -rnb |
head -n 100 > count.txt