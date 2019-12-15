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
# cat test1* | grep -P '[BT]en\.' --color
# ^ - отрицает всё что в наборе
# [\b] - Возврат на один символ Backspace
# cat test1* | grep -P '[SBT]en[0-9]\.' --color --line-number
# \f - Перевод страницы Form feed
# \n - Перевод строки Line feed
# \r - Перевод каретки Carriage return CR при выводе которого курсор перемещается к левому краю поля, не переходя на другую строку
# \t - Tab
# \v - Вертикальная табуляция

# grep "\S" - Удаляет пустые строк ис пробелами
# sed -r "/^#/d" - Удаляем пустые строки
# sed -r "s/ //g" - Убирает пробелы
# cat test1* | grep -P "Hell" --color | sed -r 's/\s//g'
 

cat test* | gsed -r '/^$/d' | gsed -r 's/ //g'