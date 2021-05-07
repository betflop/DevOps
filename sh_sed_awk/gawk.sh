# awk '{ print }' testawk.txt
# cat testawk.txt | awk '{ print }'
# cat testawk.txt | awk '{ print "fdf" }'
# cat testawk.txt | awk -F'name' '{ print $1}'
# cat testawk.txt | awk -F'name' '{ print $1}'
# cat testawk.txt | awk -F':' '{ print $1 "---"  $2 "---" $3 "---" $4 "---" $5 }'
# cat testawk.txt | awk -f myscript.awk

# gawk -F'DBMSSQL' '{Dur[$2]+=$1; Execs[$2]+=1}
# END
# {for (i in Dur) printf "%.3f=TotalDurationSec, %.3f=AvgDurationSec, %d=Execs, %s\n",
# Dur[i]/1000000, (Dur[i]/Execs[i])/1000000, Execs[i], i}'
