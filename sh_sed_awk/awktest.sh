#find . -name 'test1.txt' | xargs cat | awk '{print $0}'
cat test1* |
grep 'Hello' |
awk -F'Hello' '{errs1["Hello"]+=1;errs2["Hello"]+=$3}END{for (i in errs1) print i " " errs1[i] " " errs2[i]}'