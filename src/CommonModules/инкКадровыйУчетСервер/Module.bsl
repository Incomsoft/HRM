
#Область ОписаниеПеременных

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Процедура - Обработать отображение поля ИНН
//
// Параметры:
//  ИНН		 - Строка	 		- ИНН
//  Элемент	 - ЭлементФормы	 	- Элемент формы
//  Форма	 - Форма			- Форма
//
Процедура ОбработатьОтображениеПоляИНН(ИНН, Элемент, Форма) Экспорт
	
	СообщенияПроверки = "";
	ИННУказанПравильно = Ложь;
	
	Если НЕ ПустаяСтрока(ИНН) Тогда
	
		ИННУказанПравильно = РегламентированныеДанныеКлиентСервер.ИННСоответствуетТребованиям(ИНН, Ложь, СообщенияПроверки);
		Если ИННУказанПравильно Тогда
			ЭлементЦветТекста = Новый Цвет(0,0,0);
		Иначе
			ЭлементЦветТекста = Новый Цвет(255,0,0);
		КонецЕсли;
		
	Иначе
		                                       
		СообщенияПроверки = НСтр("ru = 'Не указан ИНН (используется, например, в отчетности по форме 2-НДФЛ)'");
		ЭлементЦветТекста = Форма.ЦветСтиляЦветТекстаПоля;
			
	КонецЕсли;
	
	Элемент.ЦветТекста = ЭлементЦветТекста;
	 
КонецПроцедуры   

// Процедура - Осуществляет проверку заполненного элемента содержащему СНИЛС
//
// Параметры:
//  СНИЛС	 - Строка	 	- Номер ПФ СНИЛС
//  Элемент	 - ЭлементФормы	- ЭлементФормы
//  Форма	 - Форма		- Форма
//
Процедура ОбработатьОтображениеПоляСНИЛС(СНИЛС, Элемент, Форма) Экспорт
	
	СообщенияПроверки = "";
	СНИЛСУказанПравильно = Ложь;
	
	Если НЕ ПустаяСтрока(СНИЛС) Тогда
	
		СНИЛСУказанПравильно = РегламентированныеДанныеКлиентСервер.СтраховойНомерПФРСоответствуетТребованиям(СНИЛС, СообщенияПроверки);
		Если СНИЛСУказанПравильно Тогда
			ЭлементЦветТекста = Новый Цвет(0,0,0);
		Иначе
			ЭлементЦветТекста = Новый Цвет(255,0,0);
		КонецЕсли;
		
	Иначе
		                                       
		СообщенияПроверки = НСтр("ru = 'Не указан СНИЛС.'");
		ЭлементЦветТекста = Форма.ЦветСтиляЦветТекстаПоля;
			
	КонецЕсли;
	
	Элемент.ЦветТекста = ЭлементЦветТекста;
	 
КонецПроцедуры   

// Процедура - Перепровести все кадровые документы за период
//
// Параметры:
//  ИсходныеДанные		 - Структура	 - Исходные данные для перепроведения
//  ВыводитьСообщения	 - Булево		 - Признак вывода сообщений
//
Процедура ПерепровестиВсеКадровыеДокументыЗаПериод(ИсходныеДанные,ВыводитьСообщения = Ложь) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	инкРеестрКадровыхДокументов.Регистратор КАК Регистратор
		|ИЗ
		|	РегистрСведений.инкРеестрКадровыхДокументов КАК инкРеестрКадровыхДокументов
		|ГДЕ
		|	инкРеестрКадровыхДокументов.Регистратор.Дата МЕЖДУ &Дата1 И &Дата2";
	
	Запрос.УстановитьПараметр("Дата1", ИсходныеДанные.Дата1);
	Запрос.УстановитьПараметр("Дата2", ИсходныеДанные.Дата2);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		Попытка
			ДокументОбъект = ВыборкаДетальныеЗаписи.Регистратор.ПолучитьОбъект();
			ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
			Если ВыводитьСообщения Тогда
				инкОбщийКлиентСервер.СообщитьПользователю("Проведен документ: "+ВыборкаДетальныеЗаписи.Регистратор);	
			КонецЕсли;
		Исключение
			инкОбщийКлиентСервер.СообщитьПользователю("Ошибка при проведении документа: " +
			                                          ВыборкаДетальныеЗаписи.Регистратор +
													  ". Описание ошибки: " + 
													  ОписаниеОшибки());
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры
	                                                               
// Функция - Получить кадровые данные за период
//
// Параметры:
//  ИсходныеДанные			 - Структура - Данные для запроса
//  СортировкаПоСотруднику	 - Булево	 - Признак сортировки
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Сотрудники с кадровыми данными
//
Функция ПолучитьКадровыеДанныеЗаПериод(ИсходныеДанные, СортировкаПоСотруднику = Истина) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	инкКадроваяИсторияСотрудниковСрезПоследних.Период КАК Период,
		|	инкКадроваяИсторияСотрудниковСрезПоследних.Сотрудник КАК Сотрудник,
		|	инкКадроваяИсторияСотрудниковСрезПоследних.ДатаПриемаНаРаботу КАК ДатаПриемаНаРаботу,
		|	инкКадроваяИсторияСотрудниковСрезПоследних.ДатаУвольнения КАК ДатаУвольнения,
		|	инкКадроваяИсторияСотрудниковСрезПоследних.Должность КАК Должность,
		|	ВЫБОР
		|		КОГДА ЕСТЬNULL(инкКадроваяИсторияСотрудниковСрезПоследних.ИндивидуальныйКоэффициент, 0) = 0
		|			ТОГДА 1
		|		ИНАЧЕ инкКадроваяИсторияСотрудниковСрезПоследних.ИндивидуальныйКоэффициент
		|	КОНЕЦ КАК ИндивидуальныйКоэффициент,
		|	инкКадроваяИсторияСотрудниковСрезПоследних.Оклад КАК Оклад,
		|	инкКадроваяИсторияСотрудниковСрезПоследних.Организация КАК Организация,
		|	инкКадроваяИсторияСотрудниковСрезПоследних.Подразделение КАК Подразделение,
		|	инкКадроваяИсторияСотрудниковСрезПоследних.РайонныйКоэффициент КАК РайонныйКоэффициент,
		|	инкКадроваяИсторияСотрудниковСрезПоследних.СевернаяНадбавка КАК СевернаяНадбавка,
		|	инкКадроваяИсторияСотрудниковСрезПоследних.ВидРабочейНедели КАК ВидРабочейНедели
		|ИЗ
		|	РегистрСведений.инкКадроваяИсторияСотрудников.СрезПоследних(
		|			,
		|			Организация = &Организация
		|				И Подразделение = &Подразделение) КАК инкКадроваяИсторияСотрудниковСрезПоследних
		|ГДЕ
		|	инкКадроваяИсторияСотрудниковСрезПоследних.Период МЕЖДУ &Дата1 И &Дата2
		|	И инкКадроваяИсторияСотрудниковСрезПоследних.Сотрудник В(&Сотрудники)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Период,
		|	Сотрудник";
	
	Если  инкОбщийКлиентСервер.ЕстьСвойство(ИсходныеДанные,"Дата1") И 
		  инкОбщийКлиентСервер.ЕстьСвойство(ИсходныеДанные,"Дата2")	
	Тогда
		Запрос.УстановитьПараметр("Дата1", ИсходныеДанные.Дата1);
		Запрос.УстановитьПараметр("Дата2", ИсходныеДанные.Дата2);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"инкКадроваяИсторияСотрудниковСрезПоследних.Период МЕЖДУ &Дата1 И &Дата2","Истина");	
	КонецЕсли;     
	
	Если инкОбщийКлиентСервер.ЕстьСвойство(ИсходныеДанные,"Организация") Тогда
		Если ЗначениеЗаполнено(ИсходныеДанные.Организация) Тогда
			Запрос.УстановитьПараметр("Организация", ИсходныеДанные.Организация);
		Иначе
			Запрос.Текст = СтрЗаменить(Запрос.Текст,"Организация = &Организация","Истина");		
		КонецЕсли;
	КонецЕсли;
	
	Если инкОбщийКлиентСервер.ЕстьСвойство(ИсходныеДанные,"Подразделение") Тогда
		Если ЗначениеЗаполнено(ИсходныеДанные.Подразделение) Тогда
			Запрос.УстановитьПараметр("Подразделение", ИсходныеДанные.Подразделение);
		Иначе
			Запрос.Текст = СтрЗаменить(Запрос.Текст,"Подразделение = &Подразделение","Истина");		
		КонецЕсли;
	КонецЕсли;
	
	инкОбщийСервер.УстановитьПараметрВЗапросе("Сотрудники","инкКадроваяИсторияСотрудниковСрезПоследних.Сотрудник В(&Сотрудники)",ИсходныеДанные,Запрос);

	РезультатТаблица = Запрос.Выполнить().Выгрузить();
	РезультатТаблица.Индексы.Добавить("Сотрудник"); 
	
	Если СортировкаПоСотруднику Тогда
		РезультатТаблица.Сортировать("Сотрудник");
	КонецЕсли;
	
	Возврат РезультатТаблица;
	
КонецФункции

// Функция - Получить реестры кадровых документов
//
// Параметры:
//  ИсходныеДанные	 - Структура	 - Содержит данные для выполнения запроса 
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Реестры кадровых документов 
//
Функция ПолучитьРеестрыКадровыхДокументов(ИсходныеДанные) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	инкРеестрКадровыхДокументов.ДатаПриказа КАК ДатаПриказа,
		|	инкРеестрКадровыхДокументов.Сотрудник КАК Сотрудник,
		|	инкРеестрКадровыхДокументов.Регистратор КАК Регистратор
		|ИЗ
		|	РегистрСведений.инкРеестрКадровыхДокументов КАК инкРеестрКадровыхДокументов
		|ГДЕ
		|	инкРеестрКадровыхДокументов.ДатаПриказа МЕЖДУ &Дата1 И &Дата2
		|	И инкРеестрКадровыхДокументов.Сотрудник В(&Сотрудники)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаПриказа";
	
	Запрос.УстановитьПараметр("Дата1", ДобавитьМесяц(ИсходныеДанные.Дата1,-1));
	Запрос.УстановитьПараметр("Дата2", ДобавитьМесяц(ИсходныеДанные.Дата2,1)); 
	
	Если инкОбщийКлиентСервер.ЕстьСвойство(ИсходныеДанные,"Сотрудники") Тогда
		Запрос.УстановитьПараметр("Сотрудники", ИсходныеДанные.Сотрудники);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"инкРеестрКадровыхДокументов.Сотрудник В (&Сотрудники)","Истина");
	КонецЕсли;

	КадровыеДокументыТаблица = Запрос.Выполнить().Выгрузить();
	КадровыеДокументыТаблица.Индексы.Добавить("Сотрудник");
	
	Возврат КадровыеДокументыТаблица;	
	
КонецФункции

// Процедура - Загрузить данные по сотруднику на сервере
//
// Параметры:
//  Объект	 - Объект - Кадровый документ объект
//
Процедура ЗагрузитьДанныеПоСотрудникуНаСервере(Объект) Экспорт
	
	Если Не ЗначениеЗаполнено(Объект.Сотрудник) Тогда
		Возврат;
	КонецЕсли; 
	
	МоментВремени = ТекущаяДата();
	Если инкОбщийКлиентСервер.ЕстьСвойство(Объект,"ДатаПриказа") Тогда
		Если ЗначениеЗаполнено(Объект.ДатаПриказа) Тогда
			МоментВремени = НачалоДня(Объект.ДатаПриказа)-1;
		КонецЕсли;	
	КонецЕсли;
	
	ДанныеПоСотруднику = инкКадровыйУчетСервер.ПолучитьКадровыеДанныеСотрудникаВСтруктуру(Объект.Сотрудник,МоментВремени); 
	Если ЗначениеЗаполнено(ДанныеПоСотруднику.Сотрудник) Тогда
		ЗаполнитьЗначенияСвойств(Объект,ДанныеПоСотруднику);	
	КонецЕсли;	   
	
	Если инкОбщийКлиентСервер.ЕстьСвойство(Объект,"Руководитель") И
		 инкОбщийКлиентСервер.ЕстьСвойство(Объект,"Организация")
	Тогда
		Объект.Руководитель = Объект.Организация.Руководитель;	
	КонецЕсли;
	
КонецПроцедуры	
	
// Функция - Получить кадровые данные сотрудников
//
// Параметры:
//  ИсходныеДанные		 - Структура - Данные для запроса
//  ПоискПоДатеНачала	 - Булево	 - Признак поиска по дате начала
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Кадровые данные сотрудника 
//
Функция ПолучитьКадровыеДанныеСотрудников(ИсходныеДанные,ПоискПоДатеНачала = Истина) Экспорт
	
    Запрос = Новый Запрос;
    Запрос.Текст = 
    	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
    	|	инкКадроваяИсторияСотрудниковСрезПоследних.Период КАК Период,
    	|	инкКадроваяИсторияСотрудниковСрезПоследних.Сотрудник КАК Сотрудник,
    	|	инкКадроваяИсторияСотрудниковСрезПоследних.Сотрудник.ФИОСокращенное КАК ФИОСокращенное,
    	|	инкКадроваяИсторияСотрудниковСрезПоследних.Должность КАК Должность,
    	|	инкКадроваяИсторияСотрудниковСрезПоследних.Организация КАК Организация,
    	|	инкКадроваяИсторияСотрудниковСрезПоследних.ДатаПриемаНаРаботу КАК ДатаПриемаНаРаботу,
    	|	инкКадроваяИсторияСотрудниковСрезПоследних.ДатаУвольнения КАК ДатаУвольнения,
    	|	инкКадроваяИсторияСотрудниковСрезПоследних.Оклад КАК Оклад,
    	|	инкКадроваяИсторияСотрудниковСрезПоследних.Оклад КАК СотрудникОклад,
    	|	ВЫБОР
    	|		КОГДА инкКадроваяИсторияСотрудниковСрезПоследних.ДатаУвольнения = ДАТАВРЕМЯ(1, 1, 1)
    	|			ТОГДА ЛОЖЬ
    	|		ИНАЧЕ ИСТИНА
    	|	КОНЕЦ КАК Уволен,
    	|	инкКадроваяИсторияСотрудниковСрезПоследних.Подразделение КАК Подразделение,
    	|	ВЫБОР
    	|		КОГДА ЕСТЬNULL(инкКадроваяИсторияСотрудниковСрезПоследних.ИндивидуальныйКоэффициент, 0) = 0
    	|			ТОГДА 1
    	|		ИНАЧЕ инкКадроваяИсторияСотрудниковСрезПоследних.ИндивидуальныйКоэффициент
    	|	КОНЕЦ КАК ИндивидуальныйКоэффициент,
    	|	инкКадроваяИсторияСотрудниковСрезПоследних.РайонныйКоэффициент КАК РайонныйКоэффициент,
    	|	инкКадроваяИсторияСотрудниковСрезПоследних.СевернаяНадбавка КАК СевернаяНадбавка,
    	|	инкКадроваяИсторияСотрудниковСрезПоследних.ВидРабочейНедели КАК ВидРабочейНедели,
    	|	инкКадроваяИсторияСотрудниковСрезПоследних.Регистратор КАК Регистратор,
    	|	инкКадроваяИсторияСотрудниковСрезПоследних.Сотрудник.ТабельныйНомер КАК ТабельныйНомер,
    	|	инкКадроваяИсторияСотрудниковСрезПоследних.Сотрудник.ИНН КАК ИНН,
    	|	инкКадроваяИсторияСотрудниковСрезПоследних.Сотрудник.СНИЛС КАК СНИЛС,
    	|	инкКадроваяИсторияСотрудниковСрезПоследних.Сотрудник.ИсполнительныйЛистПроцент КАК ИсполнительныйЛистПроцент,
    	|	инкКадроваяИсторияСотрудниковСрезПоследних.Сотрудник.ДатаРождения КАК ДатаРождения,
    	|	инкКадроваяИсторияСотрудниковСрезПоследних.Сотрудник.ОсновнойОтпускДни КАК ОсновнойОтпускДни,
    	|	инкКадроваяИсторияСотрудниковСрезПоследних.Сотрудник.ДополнительныйОтпускДни КАК ДополнительныйОтпускДни,
    	|	инкКадроваяИсторияСотрудниковСрезПоследних.Сотрудник.ДополнительныйОтпускДни + инкКадроваяИсторияСотрудниковСрезПоследних.Сотрудник.ОсновнойОтпускДни КАК ВсегоОтпускДни,
    	|	инкКадроваяИсторияСотрудниковСрезПоследних.Сотрудник.Инвалид КАК Инвалид,
    	|	инкКадроваяИсторияСотрудниковСрезПоследних.Сотрудник.Фамилия КАК Фамилия,
    	|	инкКадроваяИсторияСотрудниковСрезПоследних.Сотрудник.Имя КАК Имя,
    	|	инкКадроваяИсторияСотрудниковСрезПоследних.Сотрудник.Отчество КАК Отчество,
    	|	инкКадроваяИсторияСотрудниковСрезПоследних.Сотрудник.ФИО КАК СотрудникФИО,
    	|	инкКадроваяИсторияСотрудниковСрезПоследних.Сотрудник.ФИОСокращенное КАК СотрудникФИОСокращенное,
    	|	инкКадроваяИсторияСотрудниковСрезПоследних.Сотрудник.Пол КАК Пол,
    	|	инкКадроваяИсторияСотрудниковСрезПоследних.Сотрудник.Гражданство КАК Гражданство,
    	|	инкКадроваяИсторияСотрудниковСрезПоследних.Сотрудник.Гражданство.Код КАК ГражданствоКод,
    	|	инкКадроваяИсторияСотрудниковСрезПоследних.Сотрудник.ДокументНомер КАК ДокументНомер,
    	|	инкКадроваяИсторияСотрудниковСрезПоследних.Сотрудник.ДокументСерия КАК ДокументСерия,
    	|	инкКадроваяИсторияСотрудниковСрезПоследних.Сотрудник.ДокументУдостоверяющийЛичность КАК ДокументУдостоверяющийЛичность,
    	|	инкКадроваяИсторияСотрудниковСрезПоследних.Сотрудник.ДокументУдостоверяющийЛичность.КодМВД КАК ДокументКод
    	|ИЗ
    	|	РегистрСведений.инкКадроваяИсторияСотрудников.СрезПоследних(
    	|			&Дата,
    	|			Сотрудник В (&Сотрудники)
    	|				И Организация = &Организация
    	|				И Подразделение В (&Подразделения)) КАК инкКадроваяИсторияСотрудниковСрезПоследних";

	
	ПараметрДатаСтрока = "Дата1";
	Если НЕ ПоискПоДатеНачала Тогда
		ПараметрДатаСтрока = "Дата2";		
	КонецЕсли;
	инкОбщийСервер.УстановитьПараметрВЗапросе(ПараметрДатаСтрока,"&Дата",ИсходныеДанные,Запрос,"","Дата");
	инкОбщийСервер.УстановитьПараметрВЗапросе("Сотрудники","Сотрудник В (&Сотрудники)",ИсходныеДанные,Запрос);
	инкОбщийСервер.УстановитьПараметрВЗапросе("Организация","Организация = &Организация",ИсходныеДанные,Запрос);
	инкОбщийСервер.УстановитьПараметрВЗапросе("Подразделения","Подразделение В (&Подразделения)",ИсходныеДанные,Запрос);

	РезультатЗапроса = Запрос.Выполнить().Выгрузить();

	Возврат РезультатЗапроса; 
	
КонецФункции

// Функция - Получить кадровые данные сотрудника в структуру
//
// Параметры:
//  Сотрудник	 - Ссылка	- Справочник "Сотрудники"
//  Дата		 - Дата		- Дата на которую мы получаем данные 
// 
// Возвращаемое значение:
//  Структура - Кадровые данные сотрудника 
//
Функция ПолучитьКадровыеДанныеСотрудникаВСтруктуру(Сотрудник,Дата = Неопределено) Экспорт
	
	КадровыеДанныеСтруктура = Новый Структура;
	КадровыеДанныеСтруктура.Вставить("Период");
	КадровыеДанныеСтруктура.Вставить("Сотрудник");
	КадровыеДанныеСтруктура.Вставить("ФИОСокращенное");
	КадровыеДанныеСтруктура.Вставить("Должность");
	КадровыеДанныеСтруктура.Вставить("Организация");
	КадровыеДанныеСтруктура.Вставить("ДатаПриемаНаРаботу");
	КадровыеДанныеСтруктура.Вставить("ДатаУвольнения");
	КадровыеДанныеСтруктура.Вставить("Оклад");
	КадровыеДанныеСтруктура.Вставить("СотрудникОклад");
	КадровыеДанныеСтруктура.Вставить("Уволен");
	КадровыеДанныеСтруктура.Вставить("Подразделение");
	КадровыеДанныеСтруктура.Вставить("ИндивидуальныйКоэффициент");
	КадровыеДанныеСтруктура.Вставить("РайонныйКоэффициент");
	КадровыеДанныеСтруктура.Вставить("СевернаяНадбавка");
	КадровыеДанныеСтруктура.Вставить("ВидРабочейНедели");
	КадровыеДанныеСтруктура.Вставить("Регистратор");
	
	Если ЗначениеЗаполнено(Сотрудник) Тогда
		
		ИсходныеДанные = Новый Структура;
		ИсходныеДанные.Вставить("Сотрудники",Сотрудник);
		Если ЗначениеЗаполнено(Дата) Тогда
			ИсходныеДанные.Вставить("Дата1",Дата);	
		КонецЕсли;	
		КадровыеДанныеТаблица = ПолучитьКадровыеДанныеСотрудников(ИсходныеДанные);
		
		//Для каждого Колонка Из КадровыеДанныеТаблица.Колонки Цикл
		//	КадровыеДанныеСтруктура.Вставить(Колонка.Имя);	
		//КонецЦикла;

		Для каждого РезультатСтрока Из КадровыеДанныеТаблица Цикл
			ЗаполнитьЗначенияСвойств(КадровыеДанныеСтруктура,РезультатСтрока);
		КонецЦикла;

	КонецЕсли;
	
	Возврат КадровыеДанныеСтруктура; 
	
КонецФункции

// Функция - Получить данные документа удостоверяющего личность
//
// Параметры:
//  СотрудникЭлемент - ссылка - Справочник "Сотрудники". 
// 
// Возвращаемое значение:
//  Строка - Данные документа удостоверяющего личность.
//
Функция ПолучитьДанныеДокументаУдостоверяющегоЛичность(СотрудникЭлемент) Экспорт
	
	СтрокаДокумента = "";                                          

	Если ЗначениеЗаполнено(СотрудникЭлемент) Тогда             
		
		 Если ЗначениеЗаполнено(СотрудникЭлемент.ДокументУдостоверяющийЛичность) Тогда
			 
			СтрокаДокумента = Строка(СотрудникЭлемент.ДокументУдостоверяющийЛичность)
			                + " Серия: " + СотрудникЭлемент.ДокументСерия
							+ " Номер: " + СотрудникЭлемент.ДокументНомер
							+ " Выдан: " + СотрудникЭлемент.ДокументВыдан
							+ " от " + СотрудникЭлемент.ДокументДата		 
							+ " Код подразделения: "+СотрудникЭлемент.ДокументКодПодразделения;
			 
		 КонецЕсли;
		
	КонецЕсли;
	
	Возврат СтрокаДокумента;

КонецФункции

// Функция - получает ФИО по строке ввиде структуры.
//
// Параметры:
//  Строка	 - Строка	 - ФИО сотрудника;
// 
// Возвращаемое значение:
//  Структура - ФИО в виде структуры;
//
Функция ПолучитьФИОПоСтроке(Строка) Экспорт
	
	сФИО = Строка; 
	
	стрФИО = Новый Структура;
	стрФИО.Вставить("Фамилия",инкОбщийСервер.ВыделитьСлово(сФИО));
	стрФИО.Вставить("Имя",инкОбщийСервер.ВыделитьСлово(сФИО));
	стрФИО.Вставить("Отчество",инкОбщийСервер.ВыделитьСлово(сФИО));	
	
	Возврат стрФИО;
	
КонецФункции	

// Функция - Получить таблицу значений для заполнения сотрудники
//
// Параметры:
//  ПараметрыЗапроса - Структура	 - Структура для получения данных
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Список сотрудников 
//
Функция ПолучитьТаблицуЗначенийДляЗаполнения_Сотрудники(ПараметрыЗапроса) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = ПолучитьТекстЗапроса_Сотрудники(ПараметрыЗапроса); 
	
	массВидыСобытийПриема = Новый Массив;
	массВидыСобытийПриема.Добавить(Перечисления.инкВидыКадровыхСобытий.Прием);
	массВидыСобытийПриема.Добавить(Перечисления.инкВидыКадровыхСобытий.Перемещение);
	массВидыСобытийПриема.Добавить(Перечисления.инкВидыКадровыхСобытий.ВосстановлениеВДолжности);
	Запрос.УстановитьПараметр("ВидыСобытийПриема", массВидыСобытийПриема);
	
	Запрос.УстановитьПараметр("Организация", ПараметрыЗапроса.Организация);
	Запрос.УстановитьПараметр("Подразделение", ПараметрыЗапроса.Подразделение);
	Запрос.УстановитьПараметр("Дата1", ПараметрыЗапроса.Дата1);
	Запрос.УстановитьПараметр("Дата2", ПараметрыЗапроса.Дата2);
	Запрос.УстановитьПараметр("Сотрудники", ПараметрыЗапроса.Сотрудники);
    
    тз = Запрос.Выполнить().Выгрузить(); 
    
	Возврат тз;
	
КонецФункции

// Функция - Получить зарплатные проекты сотрудников
//
// Параметры:
//  Сотрудники - Массив - Массив сотрудников
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Перечень зарплатных проектов
//
Функция ПолучитьЗарплатныеПроектыСотрудников(Сотрудники) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	инкСотрудники.ЗарплатныйПроект КАК ЗарплатныйПроект
		|ИЗ
		|	Справочник.инкСотрудники КАК инкСотрудники
		|ГДЕ
		|	инкСотрудники.Ссылка В (&Сотрудники)
		|
		|СГРУППИРОВАТЬ ПО
		|	инкСотрудники.ЗарплатныйПроект";
	
	Запрос.УстановитьПараметр("Сотрудники", Сотрудники);
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	Возврат РезультатЗапроса;
	
КонецФункции

// Функция - Получить структуру параметров для запроса сотрудники
// 
// Возвращаемое значение:
//  Структура - Cтруктура параметров для запроса сотрудники
//
Функция ПолучитьСтруктуруПараметровДляЗапроса_Сотрудники() Экспорт
	
	СтруктураПараметров = Новый Структура;
	
	СтруктураПараметров.Вставить("Организация",Справочники.инкОрганизации.ПустаяСсылка());
	СтруктураПараметров.Вставить("Подразделение",Справочники.инкПодразделения.ПустаяСсылка());
	СтруктураПараметров.Вставить("Дата1",НачалоГода(ТекущаяДата()));
	СтруктураПараметров.Вставить("Дата2",КонецГода(ТекущаяДата()));
	СтруктураПараметров.Вставить("Сотрудники",Новый Массив);
	
	Возврат СтруктураПараметров;
	
КонецФункции    

#КонецОбласти

#Область ОбработчикиСобытий
// Код процедур и функций
#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс
// Код процедур и функций
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция - Получить текст запроса сотрудники
//
// Параметры:
//  ДанныеНачисленияЗарплаты - Структура	 - Данные для запроса;
// 
// Возвращаемое значение:
//  Текст - Текст запроса;
//
Функция ПолучитьТекстЗапроса_Сотрудники(ДанныеНачисленияЗарплаты)

	стрТекстЗапроса =	
		"ВЫБРАТЬ
		|	инкКадроваяИсторияСотрудниковСрезПоследних.Сотрудник КАК Сотрудник,
		|	инкКадроваяИсторияСотрудниковСрезПоследних.Организация КАК Организация,
		|	инкКадроваяИсторияСотрудниковСрезПоследних.Подразделение КАК Подразделение,
		|	инкКадроваяИсторияСотрудниковСрезПоследних.ВидСобытия КАК ВидСобытия
		|ПОМЕСТИТЬ втРаботающиеСотрудникиНаНачалоПериода
		|ИЗ
		|	РегистрСведений.инкКадроваяИсторияСотрудников.СрезПоследних(
		|			&Дата1,
		|			Организация = &Организация
		|				И Подразделение = &Подразделение
		|				И Сотрудник В (&Сотрудники)) КАК инкКадроваяИсторияСотрудниковСрезПоследних
		|ГДЕ
		|	инкКадроваяИсторияСотрудниковСрезПоследних.ВидСобытия В(&ВидыСобытийПриема)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	инкКадроваяИсторияСотрудниковСрезПоследних.Сотрудник КАК Сотрудник,
		|	инкКадроваяИсторияСотрудниковСрезПоследних.Организация КАК Организация,
		|	инкКадроваяИсторияСотрудниковСрезПоследних.Подразделение КАК Подразделение,
		|	инкКадроваяИсторияСотрудниковСрезПоследних.ВидСобытия КАК ВидСобытия
		|ПОМЕСТИТЬ втРаботающиеСотрудникиНаКонецПериода
		|ИЗ
		|	РегистрСведений.инкКадроваяИсторияСотрудников.СрезПоследних(
		|			&Дата2,
		|			Организация = &Организация
		|				И Подразделение = &Подразделение
		|				И Сотрудник В (&Сотрудники)) КАК инкКадроваяИсторияСотрудниковСрезПоследних
		|ГДЕ
		|	инкКадроваяИсторияСотрудниковСрезПоследних.ВидСобытия В(&ВидыСобытийПриема)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	инкКадроваяИсторияСотрудниковСрезПоследних.Сотрудник КАК Сотрудник,
		|	инкКадроваяИсторияСотрудниковСрезПоследних.Организация КАК Организация,
		|	инкКадроваяИсторияСотрудниковСрезПоследних.Подразделение КАК Подразделение,
		|	инкКадроваяИсторияСотрудниковСрезПоследних.ВидСобытия КАК ВидСобытия
		|ПОМЕСТИТЬ втУволенныеСотрудникиНаНачалоПериода
		|ИЗ
		|	РегистрСведений.инкКадроваяИсторияСотрудников.СрезПоследних(
		|			&Дата1,
		|			Организация = &Организация
		|				И Подразделение = &Подразделение
		|				И Сотрудник В (&Сотрудники)) КАК инкКадроваяИсторияСотрудниковСрезПоследних
		|ГДЕ
		|	инкКадроваяИсторияСотрудниковСрезПоследних.ВидСобытия = ЗНАЧЕНИЕ(Перечисление.инкВидыКадровыхСобытий.Увольнение)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	инкКадроваяИсторияСотрудников.Сотрудник КАК Сотрудник,
		|	инкКадроваяИсторияСотрудников.Организация КАК Организация,
		|	инкКадроваяИсторияСотрудников.Подразделение КАК Подразделение,
		|	инкКадроваяИсторияСотрудников.ВидСобытия КАК ВидСобытия
		|ПОМЕСТИТЬ втУволенныеВТекущемПериоде
		|ИЗ
		|	РегистрСведений.инкКадроваяИсторияСотрудников КАК инкКадроваяИсторияСотрудников
		|ГДЕ
		|	инкКадроваяИсторияСотрудников.Период >= &Дата1
		|	И инкКадроваяИсторияСотрудников.Период <= &Дата2
		|	И инкКадроваяИсторияСотрудников.ВидСобытия = ЗНАЧЕНИЕ(Перечисление.инкВидыКадровыхСобытий.Увольнение)
		|	И инкКадроваяИсторияСотрудников.Организация = &Организация
		|	И инкКадроваяИсторияСотрудников.Подразделение = &Подразделение
		|	И инкКадроваяИсторияСотрудников.Сотрудник В(&Сотрудники)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втРаботающиеСотрудникиНаНачалоПериода.Сотрудник КАК Сотрудник,
		|	втРаботающиеСотрудникиНаНачалоПериода.Организация КАК Организация,
		|	втРаботающиеСотрудникиНаНачалоПериода.Подразделение КАК Подразделение,
		|	втРаботающиеСотрудникиНаНачалоПериода.ВидСобытия КАК ВидСобытия
		|ПОМЕСТИТЬ втОбъединение
		|ИЗ
		|	втРаботающиеСотрудникиНаНачалоПериода КАК втРаботающиеСотрудникиНаНачалоПериода
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	втРаботающиеСотрудникиНаКонецПериода.Сотрудник,
		|	втРаботающиеСотрудникиНаКонецПериода.Организация,
		|	втРаботающиеСотрудникиНаКонецПериода.Подразделение,
		|	втРаботающиеСотрудникиНаКонецПериода.ВидСобытия
		|ИЗ
		|	втРаботающиеСотрудникиНаКонецПериода КАК втРаботающиеСотрудникиНаКонецПериода
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	втУволенныеСотрудникиНаНачалоПериода.Сотрудник,
		|	втУволенныеСотрудникиНаНачалоПериода.Организация,
		|	втУволенныеСотрудникиНаНачалоПериода.Подразделение,
		|	втУволенныеСотрудникиНаНачалоПериода.ВидСобытия
		|ИЗ
		|	втУволенныеСотрудникиНаНачалоПериода КАК втУволенныеСотрудникиНаНачалоПериода
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	втУволенныеВТекущемПериоде.Сотрудник,
		|	втУволенныеВТекущемПериоде.Организация,
		|	втУволенныеВТекущемПериоде.Подразделение,
		|	втУволенныеВТекущемПериоде.ВидСобытия
		|ИЗ
		|	втУволенныеВТекущемПериоде КАК втУволенныеВТекущемПериоде
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втОбъединение.Сотрудник КАК Сотрудник,
		|	втОбъединение.Организация КАК Организация,
		|	втОбъединение.Подразделение КАК Подразделение
		|ПОМЕСТИТЬ втРаботающиеСотрудники
		|ИЗ
		|	втОбъединение КАК втОбъединение
		|ГДЕ
		|	втОбъединение.ВидСобытия <> ЗНАЧЕНИЕ(Перечисление.инкВидыКадровыхСобытий.Увольнение)
		|
		|СГРУППИРОВАТЬ ПО
		|	втОбъединение.Сотрудник,
		|	втОбъединение.Организация,
		|	втОбъединение.Подразделение
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	инкКадроваяИсторияСотрудниковСрезПоследних.Сотрудник КАК Сотрудник,
		|	инкКадроваяИсторияСотрудниковСрезПоследних.ДатаПриемаНаРаботу КАК ДатаПриемаНаРаботу,
		|	инкКадроваяИсторияСотрудниковСрезПоследних.ДатаУвольнения КАК ДатаУвольнения,
		|	инкКадроваяИсторияСотрудниковСрезПоследних.Должность КАК Должность,
		|	инкКадроваяИсторияСотрудниковСрезПоследних.ИндивидуальныйКоэффициент КАК ИндивидуальныйКоэффициент,
		|	инкКадроваяИсторияСотрудниковСрезПоследних.Оклад КАК Оклад,
		|	инкКадроваяИсторияСотрудниковСрезПоследних.Организация КАК Организация,
		|	инкКадроваяИсторияСотрудниковСрезПоследних.Подразделение КАК Подразделение,
		|	инкКадроваяИсторияСотрудниковСрезПоследних.РайонныйКоэффициент КАК РайонныйКоэффициент,
		|	инкКадроваяИсторияСотрудниковСрезПоследних.СевернаяНадбавка КАК СевернаяНадбавка
		|ПОМЕСТИТЬ втКадровыеДанные
		|ИЗ
		|	РегистрСведений.инкКадроваяИсторияСотрудников.СрезПоследних(
		|			,
		|			Сотрудник В
		|				(ВЫБРАТЬ
		|					втРаботающиеСотрудники.Сотрудник КАК Сотрудник
		|				ИЗ
		|					втРаботающиеСотрудники КАК втРаботающиеСотрудники)) КАК инкКадроваяИсторияСотрудниковСрезПоследних
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втРаботающиеСотрудники.Сотрудник КАК Сотрудник,
		|	втРаботающиеСотрудники.Организация КАК Организация,
		|	втРаботающиеСотрудники.Подразделение КАК Подразделение,
		|	втКадровыеДанные.ДатаПриемаНаРаботу КАК ДатаПриемаНаРаботу,
		|	втКадровыеДанные.ДатаУвольнения КАК ДатаУвольнения,
		|	втКадровыеДанные.Должность КАК Должность,
		|	втКадровыеДанные.ИндивидуальныйКоэффициент КАК ИндивидуальныйКоэффициент,
		|	втКадровыеДанные.Оклад КАК Оклад,
		|	втКадровыеДанные.Организация КАК Организация1,
		|	втКадровыеДанные.Подразделение КАК Подразделение1,
		|	втКадровыеДанные.РайонныйКоэффициент КАК РайонныйКоэффициент,
		|	втКадровыеДанные.СевернаяНадбавка КАК СевернаяНадбавка
		|ИЗ
		|	втРаботающиеСотрудники КАК втРаботающиеСотрудники
		|		ЛЕВОЕ СОЕДИНЕНИЕ втКадровыеДанные КАК втКадровыеДанные
		|		ПО втРаботающиеСотрудники.Сотрудник = втКадровыеДанные.Сотрудник";
	
	Если Не ЗначениеЗаполнено(ДанныеНачисленияЗарплаты.Сотрудники) Тогда
		
		стрТекстЗапроса = СтрЗаменить(стрТекстЗапроса,"инкКадроваяИсторияСотрудников.Сотрудник В (&Сотрудники)","Истина");
		стрТекстЗапроса = СтрЗаменить(стрТекстЗапроса,"Сотрудник В (&Сотрудники)","Истина");
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДанныеНачисленияЗарплаты.Организация) Тогда   
		стрТекстЗапроса = СтрЗаменить(стрТекстЗапроса,"инкКадроваяИсторияСотрудников.Организация = &Организация","Истина");
		стрТекстЗапроса = СтрЗаменить(стрТекстЗапроса,"Организация = &Организация","Истина");
	КонецЕсли;		
	
	Если Не ЗначениеЗаполнено(ДанныеНачисленияЗарплаты.Подразделение) Тогда
		стрТекстЗапроса = СтрЗаменить(стрТекстЗапроса,"инкКадроваяИсторияСотрудников.Подразделение = &Подразделение","Истина");
		стрТекстЗапроса = СтрЗаменить(стрТекстЗапроса,"Подразделение = &Подразделение","Истина");
	КонецЕсли;		
	
	Возврат стрТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область Инициализация

#КонецОбласти
