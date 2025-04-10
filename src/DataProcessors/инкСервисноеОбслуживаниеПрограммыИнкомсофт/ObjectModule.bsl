
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем ФайлыОбновленийМассив Экспорт; // Массив - Массив строк с адресами файлов обновлений;

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Процедура - Загрузить файлы обновлений
//
Процедура ЗагрузитьФайлыОбновлений() Экспорт

	инкОбщийКлиентСервер.СообщитьПользователю("Начало работы сервиса...");	
	Отказ = Ложь;

	Попытка
		
		Если НЕ инкОбщийСервер.ПроверкаРегистрацииПрограммы() Тогда
			инкОбщийКлиентСервер.СообщитьПользователю("Операция обновления прервана! Для продолжения необходима регистрация программы.");
			Отказ = Истина;
			Возврат;
		КонецЕсли;  

		ИсходныеДанные = ПолучитьИсходныеДанные();	
		
		ПроверкаВозможностиОбновления(Отказ);        
		ПолучитьИнформациюОДоступномОбновлении(Отказ,ИсходныеДанные);
		ПолучитьФайлыОбновлений(Отказ,ИсходныеДанные);
		ЗаписатьФайлыОбновлений(Отказ,ИсходныеДанные);	      
		
	Исключение
		
		инкОбщийКлиентСервер.СообщитьПользователю("Аварийное завершение работы сервиса. Описание ошибки: "+ОписаниеОшибки());
		
	КонецПопытки;
	
	инкОбщийКлиентСервер.СообщитьПользователю("Завершение работы сервиса...");	
	
КонецПроцедуры 

#Область о // Инициализация:

// Процедура - Инициализация
//
Процедура Инициализация() Экспорт
	
	ФайлыОбновленийМассив = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
#Область о // Обновление программы:

Процедура ПроверкаВозможностиОбновления(Отказ)
	
	Если ОбщегоНазначения.ЭтоВебКлиент() Тогда
		
		СообщениеЖурнала = НСтр("ru = 'Обновление программы невозможно. Обновление программы недоступно при работе в режиме веб-клиента.'");
		ПолучениеОбновленийПрограммы.ЗаписатьОшибкуВЖурналРегистрации(СообщениеЖурнала);
        Отказ = Истина;
		Возврат;
		
	ИначеЕсли ОбщегоНазначения.КлиентПодключенЧерезВебСервер() Тогда
		
		СообщениеЖурнала = НСтр("ru = 'Обновление программы невозможно. Обновление программы недоступно при работе в режиме подключения к веб серверу.'");
		ПолучениеОбновленийПрограммы.ЗаписатьОшибкуВЖурналРегистрации(СообщениеЖурнала);
        Отказ = Истина;
		Возврат;
		
	КонецЕсли;
	
	ЭтоАдминистраторСистемы = ПолучениеОбновленийПрограммы.ЭтоАдминистраторСистемы();
	ЭтоФайловаяИБ           = ПолучениеОбновленийПрограммы.ЭтоФайловаяИБ();
	
	Если Не ЭтоАдминистраторСистемы Тогда
		
		СообщениеЖурнала = НСтр("ru = 'Недостаточно прав для перехода на новую версию платформы.'");
		ПолучениеОбновленийПрограммы.ЗаписатьОшибкуВЖурналРегистрации(СообщениеЖурнала);
        Отказ = Истина;
		Возврат;
	
	КонецЕсли;
		
	Если НЕ ЭтоФайловаяИБ Тогда

		СообщениеЖурнала = НСтр("ru = 'Это не файловая база. Обновление прервано.'");
		ПолучениеОбновленийПрограммы.ЗаписатьОшибкуВЖурналРегистрации(СообщениеЖурнала);
        Отказ = Истина;
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры 

#КонецОбласти

#Область о // Исходные данные:

Функция ПолучитьИсходныеДанные() Экспорт

	ИсходныеДанные = Новый Структура;
	ИсходныеДанные.Вставить("ИмяОшибки","");
	ИсходныеДанные.Вставить("Сообщение","");
	ИсходныеДанные.Вставить("ИнформацияОбОшибке","");
	ИсходныеДанные.Вставить("ПутиКФайламТаблица",ПолучитьСтруктуруПутиКФайламТаблица());
	ИсходныеДанные.Вставить("Отказ",Ложь);     
	ИсходныеДанные.Вставить("КаталогШаблонов",ПолучениеОбновленийПрограммыКлиентСервер.КаталогШаблонов());
	ИсходныеДанные.Вставить("КаталогДляРаботыСОбновлениямиКонфигурации",ПолучениеОбновленийПрограммыКлиентСервер.КаталогДляРаботыСОбновлениямиКонфигурации()); 
	
	ИсходныеДанные.Вставить("ВерсияКонфигурации",ИнтернетПоддержкаПользователей.ВерсияКонфигурации());
	//ИсходныеДанные.Вставить("ВерсияКонфигурации","11.0.2.17");

	Возврат ИсходныеДанные;
	
КонецФункции   

Функция ПолучитьСтруктуруПутиКФайламТаблица()
	
	ПутиКФайламТаблица = Новый ТаблицаЗначений;
	ПутиКФайламТаблица.Колонки.Добавить("ВерсияКонфигурации"); 
	ПутиКФайламТаблица.Колонки.Добавить("URLПутьКФайлу"); 
	ПутиКФайламТаблица.Колонки.Добавить("КаталогДистрибутива");   
	ПутиКФайламТаблица.Колонки.Добавить("ФорматФайлаОбновления");
	ПутиКФайламТаблица.Колонки.Добавить("ИмяПолученногоФайла");	 
	ПутиКФайламТаблица.Колонки.Добавить("ПолноеИмяCFUФайлаВКаталогеДистрибутивов");	

	Возврат ПутиКФайламТаблица;
	
КонецФункции

#КонецОбласти

#Область о // Получение списка путей к файлам:

Процедура ПолучитьИнформациюОДоступномОбновлении(Отказ,ИсходныеДанные)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	НастройкиСоединения 	= ИнтернетПоддержкаПользователей.НастройкиСоединенияССерверами();
	НастройкиПроксиСервера 	= Неопределено;
	
	// Проверка доступности сервиса.
	//URLОперацииPing = "http://localhost/IncomsoftCRM/hs/PingOK"; 
	URLОперацииPing = "https://xn--h1aegcgbujr.xn--p1ai/inccrmapi/hs/PingOK";
	инкОбщийКлиентСервер.СообщитьПользователю("Подключение к ресурсу: "+URLОперацииPing);	
	
	РезультатПроверки = ИнтернетПоддержкаПользователей.ПроверитьURLДоступен(URLОперацииPing, НастройкиПроксиСервера);
	
	Если Не ПустаяСтрока(РезультатПроверки.ИмяОшибки) Тогда
		ИсходныеДанные.ИмяОшибки = РезультатПроверки.ИмяОшибки;
		ИсходныеДанные.Сообщение = РезультатПроверки.СообщениеОбОшибке;
		ИсходныеДанные.ИнформацияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось получить информацию о доступном обновлении.
				|Не удалось проверить доступность сервиса автоматического обновления программы: %1.
				|Причина:
				|%2'"),
			URLОперацииPing,
			РезультатПроверки.ИнформацияОбОшибке);
		ИнтернетПоддержкаПользователей.ЗаписатьОшибкуВЖурналРегистрации(ИсходныеДанные.ИнформацияОбОшибке);
		Отказ = Истина; 
		
		инкОбщийКлиентСервер.СообщитьПользователю(ИсходныеДанные.ИнформацияОбОшибке);	
 		
		Возврат;
	КонецЕсли;
	
	// Вызов операции сервиса.
	//URLОперации = "http://localhost/IncomsoftCRM/hs/update/files";
	URLОперации = "https://xn--h1aegcgbujr.xn--p1ai/inccrmapi/hs/update/files"; 
	инкОбщийКлиентСервер.СообщитьПользователю("Подключение к ресурсу: "+URLОперации);	

	// Логирование запроса.
	ИнтернетПоддержкаПользователей.ЗаписатьИнформациюВЖурналРегистрации(
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Получение информации о доступном обновлении (%1).'"),
			URLОперации)
		+ Символы.ПС
		+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Имя текущей программы: %1;
				|Версия текущей программы: %2;
				|'"),
			Строка(ИнтернетПоддержкаПользователей.ИмяПрограммы()),
			ИнтернетПоддержкаПользователей.ВерсияКонфигурации(),
			));
	
	ПараметрыЗапросаJSON = InfoRequestJSON(ИсходныеДанные);
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/json");
	ПараметрыОтправки = Новый Структура;
	ПараметрыОтправки.Вставить("Метод"                   , "POST");
	ПараметрыОтправки.Вставить("ФорматОтвета"            , 1);
	ПараметрыОтправки.Вставить("Заголовки"               , Заголовки);
	ПараметрыОтправки.Вставить("ДанныеДляОбработки"      , ПараметрыЗапросаJSON);
	ПараметрыОтправки.Вставить("ФорматДанныхДляОбработки", 1);
	ПараметрыОтправки.Вставить("НастройкиПрокси"         , НастройкиПроксиСервера);
	ПараметрыОтправки.Вставить("Таймаут"                 , 30);
	
	РезультатОтправки = ИнтернетПоддержкаПользователей.ЗагрузитьСодержимоеИзИнтернет(
		URLОперации,
		,
		,
		ПараметрыОтправки);
	
	Если Не ПустаяСтрока(РезультатОтправки.КодОшибки) Тогда
		
		ИсходныеДанные.ИнформацияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка при получении информации о доступном обновлении.
				|%1'"),
			РезультатОтправки.ИнформацияОбОшибке);
		ИнтернетПоддержкаПользователей.ЗаписатьОшибкуВЖурналРегистрации(ИсходныеДанные.ИнформацияОбОшибке);
		
		ИсходныеДанные.ИмяОшибки = РезультатОтправки.КодОшибки;
		ИсходныеДанные.Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось получить информацию о доступном обновлении.
				|%1'"),
			РезультатОтправки.СообщениеОбОшибке);
			
			
		инкОбщийКлиентСервер.СообщитьПользователю(ИсходныеДанные.ИнформацияОбОшибке);	
	
		Отказ = Истина;	
		Возврат;
		
	КонецЕсли;
	
	// Обработка ответа.
	Попытка
		ЗаполнитьИнформациюОбОбновленииИзInfoResonseИзJSON(ИсходныеДанные, РезультатОтправки.Содержимое);
	Исключение
		
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		
		ИсходныеДанные.ИнформацияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось проверить наличие обновлений программы.
				|Ошибка при обработке ответа сервиса.
				|Некорректный ответ сервиса.
				|%1
				|Тело ответа: %2'"),
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке),
			Лев(РезультатОтправки.Содержимое, 1024));
		ИнтернетПоддержкаПользователей.ЗаписатьОшибкуВЖурналРегистрации(ИсходныеДанные.ИнформацияОбОшибке);
		
		ИсходныеДанные.ИмяОшибки = "НекорректныйОтветСервиса";
		ИсходныеДанные.Сообщение =
			НСтр("ru = 'Не удалось проверить наличие обновлений программы.
				|Некорректный ответ сервиса.'");
		
		инкОбщийКлиентСервер.СообщитьПользователю(ИсходныеДанные.ИнформацияОбОшибке);	

		Возврат;
		
	КонецПопытки;
	
	Если ИсходныеДанные.Отказ Тогда
		
		ИнтернетПоддержкаПользователей.ЗаписатьОшибкуВЖурналРегистрации(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось проверить наличие обновлений программы.
				|
				|Сервис сообщил об ошибке.
				|
				|Ответ сервиса: %1'"),
			Лев(РезультатОтправки.Содержимое, 1024)));
			
		инкОбщийКлиентСервер.СообщитьПользователю(ИсходныеДанные.ИнформацияОбОшибке);	
			
		Возврат;
		
	КонецЕсли;
	
	ИнтернетПоддержкаПользователей.ЗаписатьИнформациюВЖурналРегистрации(
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Получена информация о доступном обновлении.
				|%1'"),
			РезультатОтправки.Содержимое));
	
КонецПроцедуры   

// Запрос на получение файлов обновлений: 
Функция InfoRequestJSON(ИсходныеДанные)
	
	// {
	//  programName: String,
	//  versionNumber: String,
	//  platformVersion: String,
	//  UIDReg: String,
	//  UIDProg: String,
    //  IBUserName: String,
    //  ConfigName: String,
    //  Vendor: String,
    //  ClientOSVersion: String,
    //  ClientPlatformType: String
    // }
	
	ПараметрыСервиса = ИнтернетПоддержкаПользователей.ДополнительныеПараметрыВызоваОперацииСервиса();

	ЗаписьДанныхСообщения = Новый ЗаписьJSON;
	ЗаписьДанныхСообщения.УстановитьСтроку();
	ЗаписьДанныхСообщения.ЗаписатьНачалоОбъекта();
	
	ЗаписьДанныхСообщения.ЗаписатьИмяСвойства("programName");
	ЗаписьДанныхСообщения.ЗаписатьЗначение(Строка(ИнтернетПоддержкаПользователей.ИмяПрограммы()));
	ЗаписьДанныхСообщения.ЗаписатьИмяСвойства("versionNumber");
	ЗаписьДанныхСообщения.ЗаписатьЗначение(ИсходныеДанные.ВерсияКонфигурации);
	ЗаписьДанныхСообщения.ЗаписатьИмяСвойства("platformVersion");
	ЗаписьДанныхСообщения.ЗаписатьЗначение(ИнтернетПоддержкаПользователей.ТекущаяВерсияПлатформы1СПредприятие());
	ЗаписьДанныхСообщения.ЗаписатьИмяСвойства("UIDReg");
	ЗаписьДанныхСообщения.ЗаписатьЗначение(инкОбщийСервер.ПолучитьУИДРегистрации());
	ЗаписьДанныхСообщения.ЗаписатьИмяСвойства("UIDProg");
	ЗаписьДанныхСообщения.ЗаписатьЗначение(инкОбщийСервер.ПолучитьУИДПрограммы());  
	ЗаписьДанныхСообщения.ЗаписатьИмяСвойства("IBUserName");
	ЗаписьДанныхСообщения.ЗаписатьЗначение(ПараметрыСервиса["IBUserName"]);  
	ЗаписьДанныхСообщения.ЗаписатьИмяСвойства("ConfigName");
	ЗаписьДанныхСообщения.ЗаписатьЗначение(ПараметрыСервиса["ConfigName"]);  
	ЗаписьДанныхСообщения.ЗаписатьИмяСвойства("Vendor");
	ЗаписьДанныхСообщения.ЗаписатьЗначение(ПараметрыСервиса["Vendor"]);  
	ЗаписьДанныхСообщения.ЗаписатьИмяСвойства("ClientOSVersion");
	ЗаписьДанныхСообщения.ЗаписатьЗначение(ПараметрыСервиса["ClientOSVersion"]);  
	ЗаписьДанныхСообщения.ЗаписатьИмяСвойства("ClientPlatformType");
	ЗаписьДанныхСообщения.ЗаписатьЗначение(ПараметрыСервиса["ClientPlatformType"]);  
	
	ЗаписьДанныхСообщения.ЗаписатьКонецОбъекта();
	
	Возврат ЗаписьДанныхСообщения.Закрыть();
	
КонецФункции

// Расшифровка ответа от сервера с файлами обновлений:
Процедура ЗаполнитьИнформациюОбОбновленииИзInfoResonseИзJSON(ИсходныеДанные, ТелоЗапроса) Экспорт
	
	ЧтениеОтвета = Новый ЧтениеJSON;
	ЧтениеОтвета.УстановитьСтроку(ТелоЗапроса);

	ТекущийУровень = 0;
	ПолучениеОбновленийПрограммы.ЧтениеJSONПрочитать(ЧтениеОтвета, ТекущийУровень);
	
	Если ЧтениеОтвета.ТипТекущегоЗначения <> ТипЗначенияJSON.НачалоОбъекта Тогда
		Возврат;
	КонецЕсли;
	
	Пока ПолучениеОбновленийПрограммы.ЧтениеJSONПрочитать(ЧтениеОтвета, ТекущийУровень) Цикл
		
		Если ЧтениеОтвета.ТипТекущегоЗначения = ТипЗначенияJSON.КонецОбъекта Тогда
			
			Возврат;
			
		ИначеЕсли ЧтениеОтвета.ТипТекущегоЗначения = ТипЗначенияJSON.ИмяСвойства Тогда
			
			ИмяСвойства = ЧтениеОтвета.ТекущееЗначение;
			ИмяСвойстваБазы = "";
			Если ИмяСвойства = "Rejection" Тогда
				ИмяСвойстваБазы = "Отказ";	
			ИначеЕсли ИмяСвойства = "MessageError" Тогда
				ИмяСвойстваБазы = "ИнформацияОбОшибке";	
			ИначеЕсли ИмяСвойства = "MassFiles" Тогда
				ИмяСвойстваБазы = "МассивПутейКФайлам";	
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ИмяСвойстваБазы) Тогда
				
				Если ИмяСвойстваБазы = "МассивПутейКФайлам" Тогда
					
					НомерВерсии = "";
					ПолучениеОбновленийПрограммы.ЧтениеJSONПрочитать(ЧтениеОтвета, ТекущийУровень);
					Если ЧтениеОтвета.ТипТекущегоЗначения = ТипЗначенияJSON.НачалоМассива Тогда
						Пока ПолучениеОбновленийПрограммы.ЧтениеJSONПрочитать(ЧтениеОтвета, ТекущийУровень) Цикл
							Если ЧтениеОтвета.ТипТекущегоЗначения = ТипЗначенияJSON.КонецМассива Тогда
								Прервать;
							ИначеЕсли ЧтениеОтвета.ТипТекущегоЗначения = ТипЗначенияJSON.Строка Тогда
								
								URLПутьКФайлу = ЧтениеОтвета.ТекущееЗначение;
								Если СтрНайти(НРег(URLПутьКФайлу),НРег("http")) > 0 Тогда
									
									ДобавитьСтрокуПутиКФайлам(НомерВерсии,URLПутьКФайлу,ИсходныеДанные);
									
								Иначе
									НомерВерсии = ЧтениеОтвета.ТекущееЗначение;	
								КонецЕсли;
								
							КонецЕсли;
						КонецЦикла;
					КонецЕсли;
					
				Иначе	
					
					ИсходныеДанные.Вставить(ИмяСвойстваБазы,ПолучениеОбновленийПрограммы.ЗначениеСвойстваJSON(ЧтениеОтвета, ТекущийУровень, ""));
					
				КонецЕсли;
				
			КонецЕсли;

		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры    

Процедура ДобавитьСтрокуПутиКФайлам(НомерВерсии,URLПутьКФайлу,ИсходныеДанные)

	ПутиКФайламСтрока = ИсходныеДанные.ПутиКФайламТаблица.Добавить();
	ПутиКФайламСтрока.ВерсияКонфигурации = НомерВерсии; 
	ПутиКФайламСтрока.URLПутьКФайлу = URLПутьКФайлу;
	ПутиКФайламСтрока.КаталогДистрибутива = ПолучитьКаталогДистрибутива(НомерВерсии,ИсходныеДанные);
	ПутиКФайламСтрока.ИмяПолученногоФайла = ПолучитьИмяПолученногоФайла(НомерВерсии,ИсходныеДанные);
	ПутиКФайламСтрока.ПолноеИмяCFUФайлаВКаталогеДистрибутивов = ПутиКФайламСтрока.КаталогДистрибутива
	                                                      + "\1Cv8.cfu";
	ПутиКФайламСтрока.ФорматФайлаОбновления = "zip";

КонецПроцедуры   

Функция ПолучитьИмяПолученногоФайла(НомерВерсии,ИсходныеДанные)
	
	ИмяПолученногоФайла = ИсходныеДанные.КаталогДляРаботыСОбновлениямиКонфигурации 
	                    + "inc_HRM_"+СтрЗаменить(НомерВерсии,".","_")+".zip";
	
	Возврат ИмяПолученногоФайла;	
	
КонецФункции

Функция ПолучитьКаталогДистрибутива(НомерВерсии,ИсходныеДанные)
	
	ПутьККаталогуШаблона = ИсходныеДанные.КаталогШаблонов
	                     + "Incomsoft\HRM\"
						 + СтрЗаменить(НомерВерсии,".","_");
	
	Возврат ПутьККаталогуШаблона;	
	
КонецФункции

#КонецОбласти

#Область о // Загрузка файлов обновлений:

Процедура ПолучитьФайлыОбновлений(Отказ,ИсходныеДанные) Экспорт
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если ИсходныеДанные.ПутиКФайламТаблица.Количество() = 0 Тогда    
		инкОбщийКлиентСервер.СообщитьПользователю("Ваша версия конфигурации актуальна и не требует обновления.");
		Возврат;	
	КонецЕсли;         
	
	Для каждого ПутьКФайлуСтрока Из ИсходныеДанные.ПутиКФайламТаблица Цикл
		
		//инкОбщийКлиентСервер.СообщитьПользователю(ПутьКФайлуСтрока.URLПутьКФайлу); 
		ЗагрузитьОбновлениеКонфигурации(ПутьКФайлуСтрока,ИсходныеДанные);
		
	КонецЦикла;		
	
КонецПроцедуры  

Процедура ЗагрузитьОбновлениеКонфигурации(ДанныеДляЗагрузки,ИсходныеДанные)
	
	СоздатьКаталогиДляПолученияОбновления(ДанныеДляЗагрузки);
	
	// Загрузка файла.
	ДопПараметры = Новый Структура("ИмяФайлаОтвета, Таймаут", ДанныеДляЗагрузки.ИмяПолученногоФайла, 43200);
	
	ИнтернетПоддержкаПользователей.ЗаписатьИнформациюВЖурналРегистрации(
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Загрузка файла обновления конфигурации %1'"),
			ДанныеДляЗагрузки.ИмяПолученногоФайла));
	
	РезультатПолучения = ИнтернетПоддержкаПользователей.ЗагрузитьСодержимоеИзИнтернет(
		ДанныеДляЗагрузки.URLПутьКФайлу,
		"",
		"",
		ДопПараметры);
	
	Если Не ПустаяСтрока(РезультатПолучения.КодОшибки) Тогда
		
		СообщениеЖурнала =
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при получении файла дистрибутива конфигурации (%1). %2'"),
				ДанныеДляЗагрузки.URLПутьКФайлу,
				РезультатПолучения.ИнформацияОбОшибке);
		ИнтернетПоддержкаПользователей.ЗаписатьОшибкуВЖурналРегистрации(СообщениеЖурнала);
		инкОбщийКлиентСервер.СообщитьПользователю(СообщениеЖурнала);
		
		Если ПолучениеОбновленийПрограммыКлиентСервер.ФайлСуществует(ДанныеДляЗагрузки.ИмяПолученногоФайла, Ложь) Тогда
			Попытка
				УдалитьФайлы(ДанныеДляЗагрузки.ИмяПолученногоФайла);
			Исключение
				ИнтернетПоддержкаПользователей.ЗаписатьОшибкуВЖурналРегистрации(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			КонецПопытки;
		КонецЕсли;
		Возврат;
		
	КонецЕсли;
	
	ИнтернетПоддержкаПользователей.ЗаписатьИнформациюВЖурналРегистрации(НСтр("ru = 'Файл обновления успешно загружен.'"));
	ЗавершитьПолучениеОбновления(ДанныеДляЗагрузки, ИсходныеДанные);
	
КонецПроцедуры 

Процедура ЗавершитьПолучениеОбновления(Обновление, Контекст) Экспорт
	
	// Извлечение дистрибутива.
	Если Обновление.ФорматФайлаОбновления = "zip" Тогда
		
		// Извлечение из архива.
		Попытка
			ЧтениеZIP = Новый ЧтениеZipФайла(Обновление.ИмяПолученногоФайла);
			ЧтениеZIP.ИзвлечьВсе(Обновление.КаталогДистрибутива,
				РежимВосстановленияПутейФайловZIP.Восстанавливать);
		Исключение
			
			СообщениеЖурнала =
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Ошибка при извлечении файлов архива (%1) в каталог %2.'"),
					Обновление.ИмяПолученногоФайла,
					Обновление.КаталогДистрибутива)
				+ Символы.ПС
				+ ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			
			ПолучениеОбновленийПрограммыВызовСервера.ЗаписатьОшибкуВЖурналРегистрации(СообщениеЖурнала);
			
			Контекст.ИмяОшибки          = "ОшибкаИзвлеченияДанныхИзФайла";
			Контекст.ИнформацияОбОшибке = СообщениеЖурнала;
			Контекст.Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось извлечь файлы дистрибутива. %1'"),
				КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			Возврат;
			
		КонецПопытки;
		
		ЧтениеZIP.Закрыть();
		
		// Проверка существования cfu-файла в полученном дистрибутиве.
		Если Не ПолучениеОбновленийПрограммыКлиентСервер.ФайлСуществует(Обновление.ПолноеИмяCFUФайлаВКаталогеДистрибутивов, Ложь) Тогда
			
			Контекст.ИмяОшибки          = "ОшибкаДистрибутиваКонфигурации";
			Контекст.ИнформацияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Некорректный файл дистрибутива %1. Отсутствует файл обновления конфигурации %2.'"),
				Обновление.URLФайлаОбновления,
				Обновление.ОтносительныйПутьCFUФайла);
			ПолучениеОбновленийПрограммыВызовСервера.ЗаписатьОшибкуВЖурналРегистрации(Контекст.ИнформацияОбОшибке);
			Контекст.Сообщение = НСтр("ru = 'Дистрибутив не содержит файл обновления конфигурации.'");
			Возврат;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Обновление.ФорматФайлаОбновления = "zip" Тогда
		Попытка
			УдалитьФайлы(Обновление.ИмяПолученногоФайла);
		Исключение
			ПолучениеОбновленийПрограммыВызовСервера.ЗаписатьОшибкуВЖурналРегистрации(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

Процедура СоздатьКаталогиДляПолученияОбновления(Контекст) Экспорт
	
	ПутьККаталогуШаблона = Контекст.КаталогДистрибутива;
	Попытка
		
		Если ЗначениеЗаполнено(ПутьККаталогуШаблона) Тогда
			СоздатьКаталог(ПутьККаталогуШаблона);	
		КонецЕсли;
		
	Исключение
		
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		СообщениеЖурнала =
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при создании каталога для сохранения дистрибутива конфигурации (%1).'"),
				ПутьККаталогуШаблона)
			+ Символы.ПС
			+ ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
		ПолучениеОбновленийПрограммыВызовСервера.ЗаписатьОшибкуВЖурналРегистрации(СообщениеЖурнала);
		
		Контекст.ИмяОшибки = "ОшибкаВзаимодействияСФайловойСистемой";
		Контекст.ИнформацияОбОшибке = СообщениеЖурнала;
		Контекст.Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось создать каталог %1 для сохранения дистрибутива конфигурации. %2'"),
			ПутьККаталогуШаблона,
			КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
		Возврат;
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Область о // Записать файлы обновлений:

Процедура ЗаписатьФайлыОбновлений(Отказ,ИсходныеДанные)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	ФайлыОбновленийМассив = Новый Массив;
	
	Для каждого ПутиКФайламСтрока Из ИсходныеДанные.ПутиКФайламТаблица Цикл
		
		ФайлОбновленияСтруктура = Новый Структура;
		ФайлОбновленияСтруктура.Вставить("ПолноеИмяФайлаОбновления",ПутиКФайламСтрока.ПолноеИмяCFUФайлаВКаталогеДистрибутивов);
		ФайлОбновленияСтруктура.Вставить("ВыполнитьОбработчикиОбновления",Истина);
		
		ФайлыОбновленийМассив.Добавить(ФайлОбновленияСтруктура);
	
	КонецЦикла;	
	
КонецПроцедуры

#КонецОбласти 

#КонецОбласти

#КонецЕсли



