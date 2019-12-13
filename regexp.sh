# cat te*.txt |
# grep -P 'Ben' --color |
# grep -P 'my' --color

# find . | grep -P '\.sh' --color

# grep -P 'Ben' ./test.txt --color

# ls | grep -P '2' | xargs -d'\n' rm
# xargs - повторить 

# findfiles=$(find -type f | grep -P '\.txt')
# cat $findfiles
# Wrapping a command in $() will run the command and replace the command with its output.

# cat te*.txt |
# grep -P 'Ben' --color |
# grep -P 'my' --color

# find . | grep -P '\.sh' --color

# grep -P 'Ben' ./test.txt --color

# ls | grep -P '2' | xargs -d'\n' rm
# xargs - повторить 

# findfiles=$(find -type f | grep -P '\.txt')
# cat $findfiles
# Wrapping a command in $() will run the command and replace the command with its output.

# cat $(find . -type f -maxdepth 1 | grep -P 'ttt' --color)

# rm -r ./new # Удаление папки
# find . -type f -maxdepth 1 | grep -P 'ttt' --color | xargs -d'\n' rm

# ls -lh -S -R

# cat test1* | grep -P 'Ben.' --color
# -o, --only-matching       show only the part of a line matching PATTERN

# cat test1* | grep -o -P '.Ben.\.' --color
cat test1* | grep -P '[BT]en\.' --color
