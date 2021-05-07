#BEGIN { 
#        FS=":" 
#} 
#{ print $1 "---" $2 }

BEGIN { 
        FS=","
} 
{
   for(i = 1; i <= NF; i++) if(tolower($i) ~ "processname=") {print "___"$i} else if (tolower($i) ~ "context=") {print $i} ;
}
#END {
#   print str;
#}