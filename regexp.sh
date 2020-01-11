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
# cat test*.txt | sed -r '/^$/d' | sed -r 's/ //g'
 
# find 1/ -type f | xargs cat Прочитай все файлы любой вложенности из папки 1

# \d - любая цифра , тоже самое что [0-9] digit
# \D - Любой нецифроввой символ (тоже самое, что и [^0-9])
# cat test1* | grep -P "\d" --color

# \w - Любой алфавитно - цифровой символ на верхнем или нижнем регистре и символ подчеркивания [a-zA-Z0-9_]
# \W - Любой отличный символ
# cat test1* | grep -P "\w" --color | sed 's/\W//g'

# cat test1* | sed 's/\s//g' \s - пробел
# cat test1* | grep -P '\d\d\d' --color

# cat test1* | grep -P 'w+' --color - + Один или несколько символов

# cat test1* | grep -P '\w+@\w+\.\w+' --color

# cat test1* | grep -P '\+' --color

# * - соответствует нулю или большему количеству вхождений символа или шаблона

# cat test1* | grep -P '\+' --color

# ? - соответствует что предшествующий ему символ должен быть установлен один раз либо ноль

# cat test1* | grep -P 'https?://' --color

# cat test1* | grep -P 'w{1,3}' --color
# {1,3} {3, } - интервал

# cat test1* | grep -P '<B>.*?</B>' # --color - Ленивый поиск.

# cat test1* | grep -P '\bcat\b' --color # \b - границы слова

# cat test1* | grep -P '\s-\s' --color # \b - границы слова
# cat test1* | grep -P '\B-\B' --color # \B - дефис окружен символами границ слова

# ^ - Если стоит в начале выражения, то следующий символ должен соответствовать началу строки. Если заключено в квадратные скобки, то проверяемое значение не должно соответствовать последующим в скобках символам.
# ^ - [^абв] соответствует строкам, не содержащим сочетания букв а, б и в. Проверку пройдут строки гав и бах, но не бав. ^[абв] соответствует строке, начинающейся с а, б или в.

# cat test1* | grep -v 'Please' --color # Инвертировать, найти только то что неподходит

# cat test2* | grep -P '^\s*//.*'
# cat test2* | grep -P 'javasc' | gawk -F'script\"' '{print $1; print $2}'

# Вложенные подвыражения
# cat test2* | grep -P '(((\d{1,2})|(1\d{2})|(2[0-4]\d)|(25[0-5]))\.){3}' --color

# cat test2* | sed -r 's/(1[0-9])(.+)/Найден:\1/' # Замена на найденный фрагмент

# Просмотр вперед находит текст до ?=
# cat test2* | grep -P '.+(?=java)' --color 
# Просмотр назад находит текст после ?<=
# cat test2* | grep -P '(?<=java).+' --color
# Отрицательный просмотр вперед назад ?! ?<!
# cat test2* | grep -P '\b(?<!\$)\d+\b' --color # числам не предшествует $
# cat test2* | grep -P '(?m)^\s*\d+(?!\$)$' --color # числам не предшествует $

# Многострочный режим включается флагом m.
# Он влияет только на поведение ^ и $.
# В многострочном режиме они означают не только начало/конец текста, но и начало/конец каждой строки в тексте.
# cat test2* | grep -P '(?m)\b[0-9/.]+$' --color # после числа нет $

# cat test2* | grep -P '(\()?\d{3}(?(1)\)|-)\d{3}-d{4}' --color # условия в регулярный выражениях

