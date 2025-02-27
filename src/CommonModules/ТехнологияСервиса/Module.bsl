
#Область ПрограммныйИнтерфейс

// Возвращает версию библиотеки "1С:Библиотека технологии сервиса"
//
// Возвращаемое значение:
//  Строка - версия библиотеки в формате РР.{П|ПП}.ЗЗ.СС.
//
Функция ВерсияБиблиотеки() Экспорт
	
	Возврат "2.0.1.11";
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем БСП

// Вызывается при включении разделения данных по областям данных.
//
Процедура ПриВключенииРазделенияПоОбластямДанных() Экспорт
	
	ПроверитьВозможностьИспользованияКонфигурацииВМоделиСервиса();
	
КонецПроцедуры

// Добавляет в список Обработчики процедуры-обработчики обновления,
// необходимые данной подсистеме.
//
// Параметры:
//	Обработчики - см. ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления
//
Процедура ЗарегистрироватьОбработчикиОбновления(Обработчики) Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "*";
		Обработчик.Процедура = "ТехнологияСервиса.ПроверитьВозможностьИспользованияКонфигурацииВМоделиСервиса";
		Обработчик.ОбщиеДанные = Истина;
		Обработчик.ВыполнятьВГруппеОбязательных = Истина;
		Обработчик.Приоритет = 99;
		Обработчик.МонопольныйРежим = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

// Вызывается при установке параметров сеанса.
//
// Параметры:
//  Параметры - Массив Из Строка, Неопределено - имена параметров сеанса.
//
Процедура ВыполнитьДействияПриУстановкеПараметровСеанса(Параметры) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.ЭлектроннаяПодписьВМоделиСервиса") Тогда
		МодульЭлектроннаяПодписьВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("ЭлектроннаяПодписьВМоделиСервиса");
		МодульЭлектроннаяПодписьВМоделиСервиса.ПриУстановкеПараметровСеанса(Параметры);
	КонецЕсли;
	
	Если Параметры = Неопределено
		И ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.РезервноеКопированиеОбластейДанных") Тогда
		МодульРезервноеКопированиеОбластейДанных = ОбщегоНазначения.ОбщийМодуль("РезервноеКопированиеОбластейДанных");
		МодульРезервноеКопированиеОбластейДанных.УстановитьФлагАктивностиПользователяВОбласти();
	КонецЕсли;
	
КонецПроцедуры

// Проверяет возможность использования конфигурации в модели сервиса.
//  При невозможности использования - генерируется исключение с указанием причины,
//  из-за которой использование конфигурации в модели сервиса невозможно.
//
Процедура ПроверитьВозможностьИспользованияКонфигурацииВМоделиСервиса() Экспорт
	
	ОписанияПодсистем = ОбщегоНазначения.ОписанияПодсистем();
	ОписаниеБСП = Неопределено;
	
	Для каждого ОписаниеПодсистемы Из ОписанияПодсистем Цикл
		
		Если ОписаниеПодсистемы.Имя = "СтандартныеПодсистемы" Тогда
			
			ОписаниеБСП = ОписаниеПодсистемы;
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ОписаниеБСП = Неопределено Тогда
		
		ВызватьИсключение СтрШаблон(
			НСтр("ru = 'В конфигурацию не внедрена библиотека ""1С:Библиотека стандартных подсистем"".
                  |Без внедрения этой библиотеки конфигурация не может использоваться в модели сервиса.
                  |
                  |Для использования этой конфигурации в модели сервиса требуется внедрить библиотеку
                  |""1С:Библиотека стандартных подсистем"" версии не младше %1'", Метаданные.ОсновнойЯзык.КодЯзыка),
			ТребуемаяВерсияБСП());
		
	Иначе
		
		ВерсияБСП = ОписаниеБСП.Версия;
		
		Если ОбщегоНазначенияКлиентСервер.СравнитьВерсии(ВерсияБСП, ТребуемаяВерсияБСП()) < 0 Тогда
			
			ВызватьИсключение СтрШаблон(
				НСтр("ru = 'Для использования конфигурации в модели сервиса с текущей версией библиотеки
                      |""1С:Библиотека технологии сервиса"" требуется обновить используемую версию
                      |библиотеки ""1С:Библиотека стандартных подсистем"".
                      |
                      |Используемая версия: %1, требуется версия не младше %2'", Метаданные.ОсновнойЯзык.КодЯзыка),
				ВерсияБСП, ТребуемаяВерсияБСП());
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Формирует описание ошибки для передачи через web-сервис
//
// Параметры:
//  ИнформацияОбОшибке - ИнформацияОбОшибке - информация об ошибке,
//   на основе которой требуется сформировать описание.
//
// Возвращаемое значение:
//  ОбъектXDTO - {http://www.1c.ru/SaaS/ServiceCommon}ErrorDescription
//   описание ошибки для передачи через web-сервис.
//
Функция ПолучитьОписаниеОшибкиWebСервиса(ИнформацияОбОшибке) Экспорт
	
	ЗаписьЖурналаРегистрации(НСтр("ru = 'Выполнение операции web-сервиса'", ОбщегоНазначения.КодОсновногоЯзыка()), УровеньЖурналаРегистрации.Ошибка, , ,
		ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
	
	ОписаниеОшибки = ФабрикаXDTO.Создать(
		ФабрикаXDTO.Тип("http://www.1c.ru/SaaS/ServiceCommon", "ErrorDescription"));
		
	ОписаниеОшибки.BriefErrorDescription = КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
	ОписаниеОшибки.DetailErrorDescription = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
	
	Возврат ОписаниеОшибки;
	
КонецФункции

Функция ПередОбновлениемИнформационнойБазы(ВыполнятьОтложенныеОбработчики = Ложь) Экспорт
	
	Если Не ОбщегоНазначения.РазделениеВключено() 
		Или РаботаВМоделиСервиса.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		Возврат Ложь;
		
	КонецЕсли;
		
	РасширениеФреш = Неопределено;

	Для Каждого Расширение Из РасширенияКонфигурации.Получить(Новый Структура("Имя", "fresh"), ИсточникРасширенийКонфигурации.БазаДанных) Цикл
		
		РасширениеФреш = Расширение;
		Прервать;
		
	КонецЦикла;
	
	ДанныеПоставляемогоРасширенияФреш = ПолучитьОбщийМакет("fresh");
	УстановитьРасширениеФреш = Ложь;
	
	Если РасширениеФреш = Неопределено Тогда
		
		УстановитьРасширениеФреш = Истина;
		
	Иначе
		
		//@skip-warning
		МетаданныеПоставляемогоРасширенияФреш = Новый ОбъектМетаданныхКонфигурация(ДанныеПоставляемогоРасширенияФреш);
		//@skip-warning
		МетаданныеУстановленногоРасширенияФреш = Новый ОбъектМетаданныхКонфигурация(РасширениеФреш.ПолучитьДанные());
		
		Если Не РасширениеФреш.Активно
			Или РасширениеФреш.БезопасныйРежим
			Или РасширениеФреш.ЗащитаОтОпасныхДействий.ПредупреждатьОбОпасныхДействиях
			Или РасширениеФреш.ИспользоватьОсновныеРолиДляВсехПользователей
			Или ОбщегоНазначенияКлиентСервер.СравнитьВерсии(МетаданныеПоставляемогоРасширенияФреш.Версия, МетаданныеУстановленногоРасширенияФреш.Версия) > 0 Тогда
			
			РасширениеФреш.Удалить();
			УстановитьРасширениеФреш = Истина;	
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если УстановитьРасширениеФреш Тогда
				
		РасширениеФреш = РасширенияКонфигурации.Создать();
		
		СтруктураРеквизитовРасширения = Новый Структура();	
		СтруктураРеквизитовРасширения.Вставить("БезопасныйРежим", Ложь);
		ЗащитаОтОпасныхДействийНеПредупреждать = Новый ОписаниеЗащитыОтОпасныхДействий();
		ЗащитаОтОпасныхДействийНеПредупреждать.ПредупреждатьОбОпасныхДействиях = Ложь;
		СтруктураРеквизитовРасширения.Вставить("ЗащитаОтОпасныхДействий", ЗащитаОтОпасныхДействийНеПредупреждать);
		СтруктураРеквизитовРасширения.Вставить("ИспользоватьОсновныеРолиДляВсехПользователей", Ложь);	
		ЗаполнитьЗначенияСвойств(РасширениеФреш, СтруктураРеквизитовРасширения);

		РасширениеФреш.Записать(ДанныеПоставляемогоРасширенияФреш);
			
		ПараметрыОбновления = ОбновлениеИнформационнойБазыСлужебный.ПараметрыОбновления();
		ПараметрыОбновления.ВыполнятьОтложенныеОбработчики = ВыполнятьОтложенныеОбработчики;
			
		БлокировкаИБ = Новый Структура;
		БлокировкаИБ.Вставить("Установлена", Истина);
		БлокировкаИБ.Вставить("ОперативноеОбновление", Ложь);
		БлокировкаИБ.Вставить("РежимОтладки", Ложь);
		
		ПараметрыОбновления.УстановленнаяБлокировкаИБ = БлокировкаИБ;
	  	
		ПараметрыЗаданияОбновления = Новый Массив;
		ПараметрыЗаданияОбновления.Добавить(ПараметрыОбновления);
		
		УстановитьМонопольныйРежим(Истина);								
		
		ДатаНачала = ТекущаяДатаСеанса();
		
		ЗаданиеОбновления = РасширенияКонфигурации.ВыполнитьФоновоеЗаданиеСРасширениямиБазыДанных("ОбновлениеИнформационнойБазыСлужебный.ВыполнитьОбновлениеИнформационнойБазы", ПараметрыЗаданияОбновления);
		ЗаданиеОбновления = ЗаданиеОбновления.ОжидатьЗавершенияВыполнения();
		
		УстановитьМонопольныйРежим(Ложь);
		
		Если ЗаданиеОбновления.Состояние = СостояниеФоновогоЗадания.ЗавершеноАварийно Тогда
			
			ВызватьИсключение ПодробноеПредставлениеОшибки(ЗаданиеОбновления.ИнформацияОбОшибке);
			
		ИначеЕсли ЗаданиеОбновления.Состояние = СостояниеФоновогоЗадания.Отменено Тогда
			
			ВызватьИсключение НСтр("ru = 'Фоновое задание обновления информационной базы отменено'");
			
		КонецЕсли;	
		
		ДатаОкончания = ТекущаяДатаСеанса();
		ОбновлениеИнформационнойБазыСлужебный.ЗаписатьВремяВыполненияОбновления(ДатаНачала, ДатаОкончания);
	
		ОбновитьПовторноИспользуемыеЗначения();
		
		Возврат Истина;
		
	КонецЕсли;
	
	Возврат Ложь;
			
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции


// Возвращает минимальную поддерживаемую версию библиотеки "1С:Библиотека стандартных подсистем".
//
// Возвращаемое значение:
//   Строка - версия библиотеки в формате РР.{П|ПП}.ЗЗ.СС.
//
Функция ТребуемаяВерсияБСП()
	
	Возврат "3.1.1.1";
	
КонецФункции

#КонецОбласти
