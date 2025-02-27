
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Тогда

#Область ОбновлениеИнформационнойБазы

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Функция - Численность инвалидов
//
// Параметры:
//  ПараметрыЗапроса - Структура - Данные для получения численности
// 
// Возвращаемое значение:
//  Число - Численность инвалидов
//
Функция ПолучитьЧисленностьИнвалидов(ПараметрыЗапроса) Экспорт
	
	СотрудникиНаКонец 	= ПолучитьСписокСотрудниковНаПериод(ПараметрыЗапроса,Ложь);
	ИнвалидыПоиск = Новый Структура;
	ИнвалидыПоиск.Вставить("Инвалид",Истина);
	ИнвалидыМассив = СотрудникиНаКонец.НайтиСтроки(ИнвалидыПоиск);
	
	ЧисленностьИнвалидов = ИнвалидыМассив.Количество();	
	
	Возврат ЧисленностьИнвалидов;
	
КонецФункции

// Функция - Численность застрахованных
//
// Параметры:
//  ПараметрыЗапроса - Структура - Данные для получения численности застрахованных
// 
// Возвращаемое значение:
//  Число - Численность застрахованных;
//
Функция ПолучитьЧисленностьЗастрахованных(ПараметрыЗапроса) Экспорт
	
	СотрудникиНаКонец 	= ПолучитьСписокСотрудниковНаПериод(ПараметрыЗапроса,Ложь);
	ЧисленностьЗастрахованных = СотрудникиНаКонец.Количество();	
	
	Возврат ЧисленностьЗастрахованных;
	
КонецФункции

// Функция - Среднесписочная численность
//
// Параметры:
//  ПараметрыЗапроса - Структура - Данные для получение среднесписочной численности
// 
// Возвращаемое значение:
//   Число - Среднесписочная численность;
//
Функция ПолучитьСреднесписочнуюЧисленность(ПараметрыЗапроса) Экспорт
	
	СреднесписочнаяЧисленность = 0;
	
	СотрудникиНаНачало	= ПолучитьСписокСотрудниковНаПериод(ПараметрыЗапроса);
	СотрудникиНаКонец 	= ПолучитьСписокСотрудниковНаПериод(ПараметрыЗапроса,Ложь);
	
	ЧисленностьНаНачало = СотрудникиНаНачало.Итог("ИндивидуальныйКоэффициент");
	ЧисленностьНаКонец  = СотрудникиНаКонец.Итог("ИндивидуальныйКоэффициент");
	
	СреднесписочнаяЧисленность = Окр((ЧисленностьНаНачало + ЧисленностьНаКонец) / 2,2);
	
	Возврат СреднесписочнаяЧисленность;
	
КонецФункции

// Функция - Найти сотрудника по ФИО
//
// Параметры:
//  ФИОСтрока	 - Строка	 - ФИО сотрудника
// 
// Возвращаемое значение:
//  Ссылка - Справочник "Сотрудники"
//
Функция НайтиСотрудникаПоФИО(ФИОСтрока) Экспорт

	СотрудникСсылка = Справочники.инкСотрудники.ПустаяСсылка();

	Если ЗначениеЗаполнено(ФИОСтрока) Тогда
		
		СтруктураФИО = ФизическиеЛицаКлиентСервер.ЧастиИмени(ФИОСтрока);
		
		ПоискСотрудника = Новый Структура; 
		ПоискСотрудника.Вставить("ФИО",ФИОСтрока);
		ПоискСотрудника.Вставить("Фамилия",СтруктураФИО.Фамилия);
		ПоискСотрудника.Вставить("Имя",СтруктураФИО.Имя);
		ПоискСотрудника.Вставить("Отчество",СтруктураФИО.Отчество);

		СотрудникиТаблица = ПолучитьСписокСотрудников();  
		СотрудникСсылка = НайтиСотрудникаВТаблице(ПоискСотрудника,СотрудникиТаблица);
		
	КонецЕсли;

	Возврат СотрудникСсылка;
	
КонецФункции    

// Функция - Найти сотрудника в таблице
//
// Параметры:
//  ПоискСтруктура		 - Структура - Структура с данными для поиска сотрудника
//  СотрудникиТаблица	 - ТаблицаЗначений - Таблица с данными сотрудников
// 
// Возвращаемое значение:
//   Ссылка - Ссылка на справочник "Сотрудники"
//
Функция НайтиСотрудникаВТаблице(ПоискСтруктура,СотрудникиТаблица) Экспорт
	
	СотрудникСсылка = Справочники.инкСотрудники.ПустаяСсылка();
	
	// Поиск по ИНН:
	Если инкОбщийКлиентСервер.ЕстьСвойство(ПоискСтруктура,"ИНН") Тогда
		
		ПоискИНН = Новый Структура("ИНН",ПоискСтруктура.ИНН);
		СотрудникСсылка = ПоискСотрудникаПоСтруктуре(ПоискИНН,СотрудникиТаблица);
		
	КонецЕсли;     
	
	// Поиск по ФИО:
	Если НЕ ЗначениеЗаполнено(СотрудникСсылка) Тогда
		Если инкОбщийКлиентСервер.ЕстьСвойство(ПоискСтруктура,"ФИО") Тогда
			
			ПоискФИО = Новый Структура("ФИО",ВРег(ПоискСтруктура.ФИО));
			СотрудникСсылка = ПоискСотрудникаПоСтруктуре(ПоискФИО,СотрудникиТаблица);
			
		КонецЕсли;
	КонецЕсли;

	// Поиск по Ф.И.О:
	Если НЕ ЗначениеЗаполнено(СотрудникСсылка) Тогда
		Если инкОбщийКлиентСервер.ЕстьСвойство(ПоискСтруктура,"Фамилия") И  
			 инкОбщийКлиентСервер.ЕстьСвойство(ПоискСтруктура,"Имя") И 
			 инкОбщийКлиентСервер.ЕстьСвойство(ПоискСтруктура,"Отчество")  
		Тогда
			
			ПоискФИО = Новый Структура;
			ПоискФИО.Вставить("Фамилия",ВРег(ПоискСтруктура.Фамилия));
			ПоискФИО.Вставить("Имя",ВРег(ПоискСтруктура.Имя));
			ПоискФИО.Вставить("Отчество",ВРег(ПоискСтруктура.Отчество));
			СотрудникСсылка = ПоискСотрудникаПоСтруктуре(ПоискФИО,СотрудникиТаблица);
			
		КонецЕсли;
	КонецЕсли;
	
	Возврат СотрудникСсылка;
	
КонецФункции   

// Функция - Поиск сотрудника по структуре
//
// Параметры:
//  СтруктураПоиска		 - Структура - Структура с данными для поиска сотрудника;
//  СотрудникиТаблица	 - Таблица значений - Таблица с данными сотрудников;
// 
// Возвращаемое значение:
//  Ссылка - Ссылка на справочник "Сотрудники";
//
Функция ПоискСотрудникаПоСтруктуре(СтруктураПоиска,СотрудникиТаблица)
	
	СотрудникСсылка = Справочники.инкСотрудники.ПустаяСсылка();
	
	СотрудникиМассив = СотрудникиТаблица.НайтиСтроки(СтруктураПоиска);
	Если СотрудникиМассив.Количество() > 0 Тогда
		СотрудникСсылка = СотрудникиМассив[0].Ссылка;	
	КонецЕсли;
	
	Возврат СотрудникСсылка;
	
КонецФункции 
		
// Функция - Получить список сотрудников
// 
// Возвращаемое значение:
//  ТаблицаЗначений -  Сотрудники таблица;
//
Функция ПолучитьСписокСотрудников() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	инкСотрудники.Ссылка КАК Ссылка,
		|	инкСотрудники.Наименование КАК Наименование,
		|	инкСотрудники.ФИО КАК ФИО,
		|	инкСотрудники.Фамилия КАК Фамилия,
		|	инкСотрудники.Имя КАК Имя,
		|	инкСотрудники.Отчество КАК Отчество,
		|	инкСотрудники.ИНН КАК ИНН
		|ИЗ
		|	Справочник.инкСотрудники КАК инкСотрудники
		|ГДЕ
		|	НЕ инкСотрудники.ПометкаУдаления";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	СотрудникиТаблица = РезультатЗапроса.Выгрузить();
	
	Для каждого СотрудникСтрока Из СотрудникиТаблица Цикл
		
		СотрудникСтрока.Фамилия		= ВРег(СотрудникСтрока.Фамилия);
		СотрудникСтрока.Имя 		= ВРег(СотрудникСтрока.Имя);
		СотрудникСтрока.Отчество 	= ВРег(СотрудникСтрока.Отчество);
		СотрудникСтрока.ФИО 		= ВРег(СотрудникСтрока.ФИО);
		
	КонецЦикла;
	
	Возврат СотрудникиТаблица;

КонецФункции		

// Функция - Получить список сотрудников с кадровыми данными
//
// Параметры:
//  ДатаАктуальности - Дата	 - Дата актуальности кадровых данных; 
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Сотрудники с кадровыми данными таблица; 
//
Функция ПолучитьСписокСотрудниковСКадровымиДанными(ДатаАктуальности = Неопределено,СотрудникиМассив) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	инкСотрудники.Ссылка КАК Ссылка
		|ПОМЕСТИТЬ втСотрудники
		|ИЗ
		|	Справочник.инкСотрудники КАК инкСотрудники
		|ГДЕ
		|	НЕ инкСотрудники.ПометкаУдаления
		|	И инкСотрудники.Ссылка В(&СотрудникиМассив)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	инкКадроваяИсторияСотрудниковСрезПоследних.Сотрудник КАК Сотрудник,
		|	инкКадроваяИсторияСотрудниковСрезПоследних.Организация КАК Организация,
		|	инкКадроваяИсторияСотрудниковСрезПоследних.Подразделение КАК Подразделение,
		|	инкКадроваяИсторияСотрудниковСрезПоследних.Должность КАК Должность,
		|	инкКадроваяИсторияСотрудниковСрезПоследних.ДатаПриемаНаРаботу КАК ДатаПриемаНаРаботу,
		|	инкКадроваяИсторияСотрудниковСрезПоследних.ДатаУвольнения КАК ДатаУвольнения,
		|	инкКадроваяИсторияСотрудниковСрезПоследних.РайонныйКоэффициент КАК РайонныйКоэффициент,
		|	инкКадроваяИсторияСотрудниковСрезПоследних.СевернаяНадбавка КАК СевернаяНадбавка
		|ПОМЕСТИТЬ втКадровыеДанные
		|ИЗ
		|	РегистрСведений.инкКадроваяИсторияСотрудников.СрезПоследних(
		|			&ДатаАктуальности,
		|			Сотрудник В
		|				(ВЫБРАТЬ
		|					втСотрудники.Ссылка КАК Ссылка
		|				ИЗ
		|					втСотрудники КАК втСотрудники)) КАК инкКадроваяИсторияСотрудниковСрезПоследних
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втСотрудники.Ссылка КАК Ссылка,
		|	втСотрудники.Ссылка КАК Сотрудник,
		|	втСотрудники.Ссылка.Наименование КАК Наименование,
		|	втСотрудники.Ссылка.Фамилия КАК Фамилия,
		|	втСотрудники.Ссылка.Имя КАК Имя,
		|	втСотрудники.Ссылка.Отчество КАК Отчество,
		|	втСотрудники.Ссылка.ТабельныйНомер КАК ТабельныйНомер,
		|	втСотрудники.Ссылка.ИНН КАК ИНН,
		|	втСотрудники.Ссылка.СНИЛС КАК СНИЛС,
		|	втСотрудники.Ссылка.ДатаРождения КАК ДатаРождения,
		|	втСотрудники.Ссылка.Гражданство.Код КАК ГражданствоКод,
		|	ВЫБОР
		|		КОГДА втСотрудники.Ссылка.Пол = ЗНАЧЕНИЕ(Перечисление.инкПол.Мужской)
		|			ТОГДА 1
		|		ИНАЧЕ 2
		|	КОНЕЦ КАК Пол,
		|	ЕСТЬNULL(втСотрудники.Ссылка.ДокументУдостоверяющийЛичность.КодМВД, """") КАК ДокументКод,
		|	ЕСТЬNULL(втСотрудники.Ссылка.ДокументНомер, """") КАК ДокументНомер,
		|	ЕСТЬNULL(втСотрудники.Ссылка.ДокументСерия, """") КАК ДокументСерия,
		|	втКадровыеДанные.Организация КАК Организация,
		|	втКадровыеДанные.Подразделение КАК Подразделение,
		|	втКадровыеДанные.Должность КАК Должность,
		|	втКадровыеДанные.ДатаПриемаНаРаботу КАК ДатаПриемаНаРаботу,
		|	втКадровыеДанные.ДатаУвольнения КАК ДатаУвольнения,
		|	втКадровыеДанные.РайонныйКоэффициент КАК РайонныйКоэффициент,
		|	втКадровыеДанные.СевернаяНадбавка КАК СевернаяНадбавка
		|ИЗ
		|	втСотрудники КАК втСотрудники
		|		ЛЕВОЕ СОЕДИНЕНИЕ втКадровыеДанные КАК втКадровыеДанные
		|		ПО втСотрудники.Ссылка = втКадровыеДанные.Сотрудник";
	
	
	Если ЗначениеЗаполнено(ДатаАктуальности) Тогда
		Запрос.УстановитьПараметр("ДатаАктуальности",ДатаАктуальности);	      
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"&ДатаАктуальности","");
	КонецЕсли;

	Если ЗначениеЗаполнено(СотрудникиМассив) Тогда
		Запрос.УстановитьПараметр("СотрудникиМассив",СотрудникиМассив);	      
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"инкСотрудники.Ссылка В (&СотрудникиМассив)","Истина");
	КонецЕсли;
	
	ТаблицаЗначений = Запрос.Выполнить().Выгрузить();
	ТаблицаЗначений.Индексы.Добавить("Фамилия");
	ТаблицаЗначений.Индексы.Добавить("Имя");
	ТаблицаЗначений.Индексы.Добавить("Отчество");
	ТаблицаЗначений.Индексы.Добавить("Фамилия,Имя,Отчество");
	
	Возврат ТаблицаЗначений;
	
КонецФункции

// Функция - Получить данные удостоверяющего документа сотрудника
//
// Параметры:
//  СотрудникСсылка	 - Ссылка	 - Справочник "Сотрудники";
// 
// Возвращаемое значение:
//  Строка - Данные удостоверяющего документа сотрудника
//
Функция ПолучитьДанныеУдостоверяющегоДокументаСотрудника(СотрудникСсылка) Экспорт
	
	ДанныеДокумента = "";

	ДанныеДокумента = Строка(СотрудникСсылка.ДокументУдостоверяющийЛичность);
	ДанныеДокумента = ДанныеДокумента + ", " + СотрудникСсылка.ДокументСерия;
	ДанныеДокумента = ДанныеДокумента + " " + СотрудникСсылка.ДокументНомер; 
	ДанныеДокумента = ДанныеДокумента + ", выдан " + СотрудникСсылка.ДокументВыдан;
	ДанныеДокумента = ДанныеДокумента + " код подр. " + СотрудникСсылка.ДокументКодПодразделения;
	ДанныеДокумента = ДанныеДокумента + " дата выдачи " + Формат(СотрудникСсылка.ДокументДата,"ДФ=dd.MM.yyyy"); 

	Возврат ДанныеДокумента;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция - Получить список сотрудников на период
//
// Параметры:
//  ПараметрыЗапроса	 - Структура	- Параметры запроса
//  ПоискПоДатеНачала	 - Булево	 	- Признак поиска по дате начала
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Сотрудники таблица
//
Функция ПолучитьСписокСотрудниковНаПериод(ПараметрыЗапроса,ПоискПоДатеНачала = Истина)
	
	КадровыеДанныеТаблица = инкКадровыйУчетСервер.ПолучитьКадровыеДанныеСотрудников(ПараметрыЗапроса,ПоискПоДатеНачала);
	Возврат КадровыеДанныеТаблица;
	
КонецФункции

#КонецОбласти

#КонецЕсли
	   
