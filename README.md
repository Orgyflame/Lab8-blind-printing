# Программа-тренажер печати вслепую

Цель программы - натренировать навык слепой печать на русском/английском языке.

Прграмма следует следующему алгоритму:
1. Пользователь выбирает язык (русский/английский)
2. Изначально stringLength := 20 и duplicateCount := 2
3. Если stringLength > 0, то генерируется и выводится строка длиной ровно stringLength символов из слов выбранного языка и пробелов между ними
4. Если stringLength > WINDOW_SIZE, то переход к шагу 2
5. Если stringLength <= 0, то stringLength := 20 и duplicateCount := duplicateCount + 2, переход к шагу 3
6. Пользователь пытается ввести эту строку
7. Анализируется введенная строка:
	* Если пользовательская строка точно совпадает с загаданной, то stringLength := stringLength - 2, переход к шагу 3
	* Если пользовательская строка равна '13', то выход из программы
	* Иначе, все правильно введенные слова заменяются на новые с такой же длинной, а в неправильных на несовпадающих позициях удваюваются символы из загаданной строки
8. Переход к шагу 4


## Учточнения по сравниванию слов

* Лишние пробелы не приводят к их удваиванию
* Если надо было написать work, а написали wor, то слово будет workk
* Если надо было написать work, а написали worka, то слово будет work
