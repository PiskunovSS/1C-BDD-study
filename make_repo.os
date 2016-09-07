Функция ФайлИлиКаталогСуществует(КаталогПоиска, ИмяФайлаИлиКаталога)

    МассивФайлов = НайтиФайлы(КаталогПоиска, ИмяФайлаИлиКаталога);
    Если МассивФайлов.Количество() > 0 Тогда
        Возврат Истина;
    КонецЕсли; 
    Возврат Ложь;
    
КонецФункции

Процедура СкопироватьФайлыИКаталоги(Источник, Приемник)

    Разделитель = ПолучитьРазделительПути();
    
    Файл = Новый Файл(Источник);
    Если Файл.ЭтоКаталог() тогда
    
        СоздатьКаталог(Приемник);
        МассивФайлов = НайтиФайлы(Источник, "*");
        Для каждого файл из МассивФайлов Цикл
            
            Если Файл.ЭтоФайл() Тогда
                КопироватьФайл(Файл.ПолноеИмя, Приемник + Разделитель + Файл.Имя);  
            Иначе
                СкопироватьФайлыИКаталоги(Файл.ПолноеИмя, Приемник + Разделитель + Файл.Имя);   
            КонецЕсли;        
        
        КонецЦикла;
    Иначе
        КопироватьФайл(Источник, Приемник);    
    КонецЕсли;    
КонецПроцедуры    

Функция ПолучитьМассивФайловДляКопирования()
    
    МассивФайловДляКопирования = Новый Массив;
    МассивФайловДляКопирования.Добавить("pre-commit");
    МассивФайловДляКопирования.Добавить("v8files-extractor.os");
    МассивФайловДляКопирования.Добавить("ibService");
    МассивФайловДляКопирования.Добавить("tools");
    МассивФайловДляКопирования.Добавить("v8Reader");
    
    Возврат МассивФайловДляКопирования;
        
Конецфункции     

КаталогНовогоРепозитория = ТекущийКаталог();
Разделитель = ПолучитьРазделительПути();

КодВозварата = "";
ЗапуститьПриложение("git init", КаталогНовогоРепозитория,Истина, КодВозварата);
Если КодВозварата <> 0 Тогда
    Сообщить("Не удалось инициализировать новый репозиторий (КодВозврата = " + КодВозварата + ")");
    Приостановить(30000);       
    ЗавершитьРаботу(0);
КонецЕсли;
Сообщить("Репозиторий " + КаталогНовогоРепозитория + " успешно инициализирован.");

//Находим родительский каталог, в котором находятся все репозитории, для работы с дополнительными репозиториями
ПозицияРазделителя = 0;
Пока СтрНайти(КаталогНовогоРепозитория, Разделитель,,ПозицияРазделителя+1) > 0 Цикл
    ПозицияРазделителя = СтрНайти(КаталогНовогоРепозитория, Разделитель,,ПозицияРазделителя+1);
КонецЦикла; 

Если ПозицияРазделителя <> 0 Тогда   
    КаталогВсехРепозиториев = Лев(КаталогНовогоРепозитория, ПозицияРазделителя-1);
    
    precommit1c = "precommit1c";
    
    КаталогPrecommit1c = КаталогВсехРепозиториев + Разделитель + precommit1c;
    
    Если не ФайлИлиКаталогСуществует(КаталогВсехРепозиториев, precommit1c) Тогда

        Сообщить("Каталог " + КаталогPrecommit1c + " не обнаружен. Будет создан репозиторий precommit1c.");
        
        КодВозварата = "";
        ЗапуститьПриложение("git clone https://github.com/xDrivenDevelopment/precommit1c.git", КаталогВсехРепозиториев,Истина, КодВозварата);
        Если КодВозварата <> 0 Тогда
            Сообщить("Не удалось клонировать репозиторий precommit1c (КодВозврата = " + КодВозварата + ")");
            Приостановить(30000);
            ЗавершитьРаботу(0);
        КонецЕсли;
        Сообщить("Репозиторий precommit1c успешно склонирован.");
    КонецЕсли;    
    
    Если не ФайлИлиКаталогСуществует(КаталогНовогоРепозитория + Разделитель + ".git", "hooks") тогда
        СоздатьКаталог(КаталогНовогоРепозитория + Разделитель + ".git" + Разделитель + "hooks");
        Сообщить("Создан каталог " + КаталогНовогоРепозитория + Разделитель + ".git" + Разделитель + "hooks");
    КонецЕсли;
    
    МассивФайловДляКопирования = ПолучитьМассивФайловДляКопирования();
    
    Для Каждого ИмяФайла из МассивФайловДляКопирования Цикл
        Если ФайлИлиКаталогСуществует(КаталогPrecommit1c, ИмяФайла) Тогда
            СкопироватьФайлыИКаталоги(КаталогPrecommit1c + Разделитель + ИмяФайла, КаталогНовогоРепозитория + Разделитель + ".git" + Разделитель + "hooks" + Разделитель + ИмяФайла);
            Сообщить("Скопирован файл " + ИмяФайла);    
        КонецЕсли;    
    КонецЦикла;    
       
Иначе
    
    Сообщить("Не удалось найти каталог хранения репозиториев. Файлы precommit1c не скопированы.")    
КонецЕсли;