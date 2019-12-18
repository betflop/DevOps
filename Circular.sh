find SCRIPTCIRCREFS/* -type f |
xargs cat | 
grep -P 'SCRIPTCIRCREFS.+Context=' |
sed -r 's/^[0-9]+:[0-9]+\.[0-9]+-//' |
sed -r 's/SCRIPTCIRCREFS,.+,Context=/SCRIPTCIRCREFS,Context=/'
# sed -r 's/,Memory=.+$//' |
# gawk -F',SCRIPTCIRCREFS,Context=' '{errs[$2]+=1}END{for (i in errs) print errs[i] " " i}' |
# sort -rnb |
# head -n 100 > count.txt