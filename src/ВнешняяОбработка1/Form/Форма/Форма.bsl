﻿
&НаСервереБезКонтекста
Процедура Команда1НаСервере()
	Сообщить("Обучение проходит успешно!");
КонецПроцедуры

&НаКлиенте
Процедура Команда1(Команда)
	Команда1НаСервере();
КонецПроцедуры
