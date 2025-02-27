////////////////////////////////////////////////////////////////////////////////
// Подсистема "Выгрузка загрузка данных".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Добавляет в список Обработчики процедуры-обработчики обновления, необходимые данной подсистеме.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//   Обработчики - см. ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления
// 
Процедура ЗарегистрироватьОбработчикиОбновления(Обработчики) Экспорт
	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Выгрузка/загрузка данных

// Выполняет удаление временного файла, ошибки при удалении игнорируются.
//
// Параметры:
//  Путь - Строка - путь к удаляемому файлу.
//
Процедура УдалитьВременныйФайл(Знач Путь) Экспорт
	
	Инфо = Новый Файл(Путь);
	Если Не Инфо.Существует() Тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		УдалитьФайлы(Путь);
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Удаление файла'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,
			,
			,
			ИнформацияОбОшибке().Описание);
	КонецПопытки;
	
КонецПроцедуры

// Возвращает массив всех объектов метаданных, содержащихся в конфигурации.
//  Используется для запуска выгрузки и загрузки данных в конфигурациях, не содержащих БСП.
//
// Возвращаемое значение:
//   Массив из ОбъектМетаданных - типы.
//
// Пример:
//  ПараметрыВыгрузки = Новый Структура();
//  ПараметрыВыгрузки.Вставить("ВыгружаемыеТипы", ВыгрузкаЗагрузкаДанныхСлужебный.ПолучитьВсеТипыКонфигурации());
//  ПараметрыВыгрузки.Вставить("ВыгружатьПользователей", Истина);
//  ПараметрыВыгрузки.Вставить("ВыгружатьНастройкиПользователей", Истина);
//  ИмяФайла = ВыгрузкаЗагрузкаДанных.ВыгрузитьДанныеВАрхив(ПараметрыВыгрузки);
//
//  ПараметрыЗагрузки = Новый Структура();
//  ПараметрыЗагрузки.Вставить("ЗагружаемыеТипы", ВыгрузкаЗагрузкаДанныхСлужебный.ПолучитьВсеТипыКонфигурации());
//  ПараметрыЗагрузки.Вставить("ЗагружатьПользователей", Истина);
//  ПараметрыЗагрузки.Вставить("ЗагружатьНастройкиПользователей", Истина);
//  ВыгрузкаЗагрузкаДанных.ЗагрузитьДанныеИзАрхива(ИмяФайла, ПараметрыЗагрузки);
//
Функция ПолучитьВсеТипыКонфигурации() Экспорт
	
	МассивКоллекцийМетаданных = Новый Массив();
	
	ЗаполнитьКоллекцииКонстант(МассивКоллекцийМетаданных);
	ЗаполнитьКоллекцииСсылочныхОбъектов(МассивКоллекцийМетаданных);
	ЗаполнитьКоллекцииНаборовЗаписей(МассивКоллекцийМетаданных);
	
	Возврат МассивКоллекцийМетаданных;
	
КонецФункции

// Выгружает данные в каталог.
//
// Параметры:
//	ИмяФайла - Строка - путь к архиву.
//	ПараметрыВыгрузки - Структура - содержащая параметры выгрузки данных.
//		Ключи:
//			ВыгружаемыеТипы - Массив Из ОбъектМетаданных - массив объектов метаданных, данные
//				которых требуется выгрузить в архив,
//			ВыгружатьПользователей - Булево - выгружать информацию о пользователях информационной базы,
//			ВыгружатьНастройкиПользователей - Булево - игнорируется если ВыгружатьПользователей = Ложь.
//			Также структура может содержать дополнительные ключи, которые могут быть обработаны внутри
//				произвольных обработчиков выгрузки данных.
//
Процедура ВыгрузитьДанныеВАрхив(Знач ИмяФайла, Знач ПараметрыВыгрузки) Экспорт
	
	Контейнер = Обработки.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.Создать();
	Контейнер.ИнициализироватьВыгрузку(ИмяФайла, ПараметрыВыгрузки);
	
	АннотируемыеСсылочныеТипы = ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ПолучитьТипыТребующиеАннотациюСсылокПриВыгрузке();
	Сериализатор = СериализаторXDTOСАннотациейТипов(Контейнер, АннотируемыеСсылочныеТипы);
	
	Обработчики = Обработки.ВыгрузкаЗагрузкаДанныхМенеджерОбработчиковВыгрузкиДанных.Создать();
	
	Обработчики.ПередВыгрузкойДанных(Контейнер);
	
	СохранитьОписаниеВыгрузки(Контейнер);
	
	Обработки.ВыгрузкаЗагрузкаДанныхМенеджерВыгрузкиДанныхИнформационнойБазы.ВыгрузитьДанныеИнформационнойБазы(
		Контейнер, Обработчики, Сериализатор);
	
	Если ПараметрыВыгрузки.ВыгружатьПользователей Тогда
		
		ВыгрузкаЗагрузкаПользователейИнформационнойБазы.ВыгрузитьПользователейИнформационнойБазы(Контейнер);
		
		Если ПараметрыВыгрузки.ВыгружатьНастройкиПользователей Тогда
			
			Обработки.ВыгрузкаЗагрузкаДанныхМенеджерВыгрузкиНастроекПользователей.ВыгрузитьНастройкиПользователейИнформационнойБазы(
				Контейнер, Обработчики, Сериализатор);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Обработчики.ПослеВыгрузкиДанных(Контейнер);
	
	Контейнер.ФинализироватьВыгрузку();
	
КонецПроцедуры

// Загружает данные из каталога.
//
// Параметры:
//	ИмяФайла - Строка - имя файла архива.
//	ПараметрыЗагрузки - Структура - параметры загрузки, см. параметр "ПараметрыЗагрузки" процедуры "ЗагрузитьТекущуюОбластьДанныхИзАрхива" общего модуля "ВыгрузкаЗагрузкаОбластейДанных".
//
Процедура ЗагрузитьДанныеИзАрхива(Знач ИмяФайла, Знач ПараметрыЗагрузки) Экспорт
	
	СистемнаяИнформация = Новый СистемнаяИнформация();
	ВерсияПлатформы = СистемнаяИнформация.ВерсияПриложения;
	
	Если ОбщегоНазначенияКлиентСервер.СравнитьВерсии(ВерсияПлатформы, "8.2.19.0") < 0
		ИЛИ (ОбщегоНазначенияКлиентСервер.СравнитьВерсии(ВерсияПлатформы, "8.3.1.0") > 0
		И ОбщегоНазначенияКлиентСервер.СравнитьВерсии(ВерсияПлатформы, "8.3.4.0") < 0) Тогда
		
		ВызватьИсключение
			НСтр("ru = 'Для выполнения загрузки данных требуется обновить технологическую платформу ""1С:Предприятие"".
                  |Для версии 8.2 необходимо использовать релиз 8.2.19 (или более новый).
                  |Для версии 8.3 необходимо использовать релиз 8.3.4 (или более новый).'");
		
	КонецЕсли;
	
	Обработчики = Обработки.ВыгрузкаЗагрузкаДанныхМенеджерОбработчиковЗагрузкиДанных.Создать();
	
	Контейнер = Обработки.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.Создать();
	Контейнер.ИнициализироватьЗагрузку(ИмяФайла, ПараметрыЗагрузки);
	
	ИнформацияОВыгрузке = ПрочитатьИнформациюОВыгрузке(Контейнер);
	
	Если Не ВыгрузкаВАрхивеСовместимаСТекущейКонфигурацией(ИнформацияОВыгрузке) Тогда
		
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Невозможно загрузить данные из файла, т.к. файл был выгружен из другой конфигурации (файл выгружен из конфигурации %1 и не может быть загружен в конфигурацию %2)'"),
			ИнформацияОВыгрузке.Configuration.Name,
			Метаданные.Имя);
		
	КонецЕсли;
	
	Если Не ВыгрузкаВАрхивеСовместимаСТекущейВерсиейКонфигурации(ИнформацияОВыгрузке) Тогда
		
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Невозможно загрузить данные из файла, т.к. файл был выгружен из другой версии конфигурации (файл выгружен из конфигурации версии %1 и не может быть загружен в конфигурацию версии %2)'"),
			ИнформацияОВыгрузке.Configuration.Version,
			Метаданные.Версия);
		
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ОтключитьОбновлениеКлючейДоступа(Истина, Ложь);
	КонецЕсли;
	
	Обработчики.ПередОчисткойДанных(Контейнер);
	
	РаботаВМоделиСервиса.ОчиститьДанныеОбласти(ПараметрыЗагрузки.ЗагружатьПользователей);
	
	Обработчики.ПередЗагрузкойДанных(Контейнер);
	
	ЕстьУстановленныеРасширения = Ложь;
	
	Если ПараметрыЗагрузки.Свойство("ДанныеРасширений") Тогда
		
		Если ПараметрыЗагрузки.ДанныеРасширений.Свойство("КлючОбластиДанных") Тогда
			Константы.КлючОбластиДанных.Установить(ПараметрыЗагрузки.ДанныеРасширений.КлючОбластиДанных);
		КонецЕсли;
		
		Если ПараметрыЗагрузки.ДанныеРасширений.Свойство("РасширенияДляВосстановления") Тогда
			ЕстьУстановленныеРасширения = КаталогРасширений.ВосстановитьРасширенияВНовойОбласти(ПараметрыЗагрузки.ДанныеРасширений.РасширенияДляВосстановления);					
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЕстьУстановленныеРасширения Тогда
		
		АдресСоответствиеСсылок = ПоместитьВоВременноеХранилище(Неопределено);
		
		Кеш = Новый Структура("ЗагружаемыеТипы", ПараметрыЗагрузки.ЗагружаемыеТипы);
		ПараметрыЗагрузки.ЗагружаемыеТипы = Новый Массив;
		
		МассивПараметров = Новый Массив;
		МассивПараметров.Добавить(ИмяФайла);
		МассивПараметров.Добавить(ПараметрыЗагрузки);
		МассивПараметров.Добавить(АдресСоответствиеСсылок);

		ИмяМетода = "ВыгрузкаЗагрузкаДанныхСлужебный.ВыполнитьЗагрузкуДанныхИнформационнойБазыВФоне";
		
		ФоновоеЗадание = РасширенияКонфигурации.ВыполнитьФоновоеЗаданиеСРасширениямиБазыДанных(ИмяМетода, МассивПараметров, Новый УникальныйИдентификатор, НСтр("ru = 'Восстановление области данных из архива'"));
		Результат = ФоновоеЗадание.ОжидатьЗавершенияВыполнения();
		
		Если Результат.Состояние <> СостояниеФоновогоЗадания.Завершено Тогда
			
			Если Результат.ИнформацияОбОшибке = Неопределено Тогда
				ВызватьИсключение Результат.Состояние;
			Иначе
				ВызватьИсключение ПодробноеПредставлениеОшибки(Результат.ИнформацияОбОшибке);	
			КонецЕсли;
			
		КонецЕсли;
		
		ПараметрыЗагрузки.ЗагружаемыеТипы = Кеш.ЗагружаемыеТипы;
		
		ПотокЗаменыСсылок = Обработки.ВыгрузкаЗагрузкаДанныхПотокЗаменыСсылок.Создать();
		ПотокЗаменыСсылок.Инициализировать(Контейнер, Обработчики, АдресСоответствиеСсылок);
		
	Иначе 
		ПотокЗаменыСсылок = Обработки.ВыгрузкаЗагрузкаДанныхМенеджерЗагрузкиДанныхИнформационнойБазы.ЗагрузитьДанныеИнформационнойБазы(Контейнер, Обработчики);
	КонецЕсли;
	
	СопоставлениеПользователей = Неопределено;
	Если ПараметрыЗагрузки.ЗагружатьПользователей Тогда
		
		ВыгрузкаЗагрузкаПользователейИнформационнойБазы.ЗагрузитьПользователейИнформационнойБазы(Контейнер);
		
		Если ПараметрыЗагрузки.ЗагружатьНастройкиПользователей Тогда
			
			Обработки.ВыгрузкаЗагрузкаДанныхМенеджерЗагрузкиНастроекПользователей.ЗагрузитьНастройкиПользователейИнформационнойБазы(
				Контейнер, Обработчики, ПотокЗаменыСсылок);
			
		КонецЕсли;
		
	ИначеЕсли ПараметрыЗагрузки.Свойство("СопоставлениеПользователей", СопоставлениеПользователей) Тогда
		
		// Очистить идентификаторы, если они используются.
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Пользователи", СопоставлениеПользователей.ВыгрузитьКолонку("Пользователь"));
		Запрос.УстановитьПараметр("Идентификаторы", СопоставлениеПользователей.ВыгрузитьКолонку("ИдентификаторПользователяСервиса"));
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Пользователи.Ссылка КАК Пользователь
		|ИЗ
		|	Справочник.Пользователи КАК Пользователи
		|ГДЕ
		|	НЕ Пользователи.Ссылка В (&Пользователи)
		|	И Пользователи.ИдентификаторПользователяСервиса В(&Идентификаторы)";
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			ПользовательОбъект = Выборка.Пользователь.ПолучитьОбъект();
			ПользовательОбъект.ИдентификаторПользователяСервиса = Неопределено;
			ПользовательОбъект.ОбменДанными.Загрузка = Истина;
			ПользовательОбъект.Записать();
		КонецЦикла;
		
		// Обновить идентификаторы для используемых пользователей.
		Для Каждого СопоставлениеПользователя Из СопоставлениеПользователей Цикл
			Если Не ЗначениеЗаполнено(СопоставлениеПользователя.Пользователь) Тогда
				Продолжить;
			КонецЕсли;
			ПользовательОбъект = СопоставлениеПользователя.Пользователь.ПолучитьОбъект();
			Если ПользовательОбъект.ИдентификаторПользователяСервиса <> СопоставлениеПользователя.ИдентификаторПользователяСервиса Тогда
				ПользовательОбъект.ИдентификаторПользователяСервиса = СопоставлениеПользователя.ИдентификаторПользователяСервиса;
				ПользовательОбъект.ОбменДанными.Загрузка = Истина;
				ПользовательОбъект.Записать();
			КонецЕсли;
		КонецЦикла;
		
		// Загрузить настройки с заменой имени пользователя ИБ.
		ЗаменитьПользователяВНастройках = Новый Соответствие;
		Для Каждого СопоставлениеПользователя Из СопоставлениеПользователей Цикл
			Если ЗначениеЗаполнено(СопоставлениеПользователя.СтароеИмяПользователяИБ) 
				И ЗначениеЗаполнено(СопоставлениеПользователя.НовоеИмяПользователяИБ) Тогда
				ЗаменитьПользователяВНастройках.Вставить(СопоставлениеПользователя.СтароеИмяПользователяИБ, СопоставлениеПользователя.НовоеИмяПользователяИБ);
			КонецЕсли;
		КонецЦикла;
		Обработки.ВыгрузкаЗагрузкаДанныхМенеджерЗагрузкиНастроекПользователей.ЗагрузитьНастройкиПользователейИнформационнойБазы(
			Контейнер, Обработчики, ПотокЗаменыСсылок, ЗаменитьПользователяВНастройках);
		
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ОтключитьОбновлениеКлючейДоступа(Истина);
	КонецЕсли;
	
	РазделениеВключено = РаботаВМоделиСервиса.РазделениеВключено(); 
	Если РазделениеВключено Тогда
		ПараметрыБлокировки = СоединенияИБ.ПолучитьБлокировкуСеансовОбластиДанных();
		Если НЕ ПараметрыБлокировки.Установлена Тогда
			ПараметрыБлокировки.Установлена = Истина;
			СоединенияИБ.УстановитьБлокировкуСеансовОбластиДанных(ПараметрыБлокировки);		
		КонецЕсли;
	КонецЕсли;
	
	ОчередьЗаданийСлужебныйРазделениеДанных.ПослеЗагрузкиДанных(Контейнер);
	Обработчики.ПослеЗагрузкиДанных(Контейнер);
	
	Если РазделениеВключено Тогда
		ПараметрыБлокировки.Установлена = Ложь;
		СоединенияИБ.УстановитьБлокировкуСеансовОбластиДанных(ПараметрыБлокировки);	
	КонецЕсли;

	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ОтключитьОбновлениеКлючейДоступа(Ложь);
	КонецЕсли;
	
	Контейнер.ФинализироватьЗагрузку();
	
КонецПроцедуры

// Выполняет загрузку данных из архива
//
Процедура ВыполнитьЗагрузкуДанныхИнформационнойБазыВФоне(Знач ИмяФайла, Знач ПараметрыЗагрузки, Знач АдресСоответствиеСсылок) Экспорт 
	
	ЗагружаемыеТипы = Новый Массив();
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ЗагружаемыеТипы, ВыгрузкаЗагрузкаОбластейДанных.ПолучитьТипыМоделиДанныхОбласти());
		
	Если Не РаботаВМоделиСервисаПовтИсп.РазделениеВключено() Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ЗагружаемыеТипы,
			ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ПолучитьТипыОбщихДанныхПоддерживающиеСопоставлениеСсылокПриЗагрузке(), Истина);
	КонецЕсли; 
	
	ПараметрыЗагрузки.ЗагружаемыеТипы = ЗагружаемыеТипы;
	
	Обработчики = Обработки.ВыгрузкаЗагрузкаДанныхМенеджерОбработчиковЗагрузкиДанных.Создать();
	
	Контейнер = Обработки.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.Создать();
	Контейнер.ИнициализироватьЗагрузку(ИмяФайла, ПараметрыЗагрузки);
	
	ПотокЗаменыСсылок = Обработки.ВыгрузкаЗагрузкаДанныхМенеджерЗагрузкиДанныхИнформационнойБазы.ЗагрузитьДанныеИнформационнойБазы(Контейнер, Обработчики);
	ПотокЗаменыСсылок.СохранитьСоответствиеСсылокВоВременноеХранилище(АдресСоответствиеСсылок);
	
	Контейнер.ФинализироватьЗагрузку();
	
КонецПроцедуры

// Сравнивает совместима ли выгрузка с текущей конфигурацией.
//
// Параметры:
//	ИнформацияОВыгрузке - ОбъектXDTO - см. процедуру "СохранитьОписаниеВыгрузки".
//
// Возвращаемое значение:
//	Булево - Истина, если совпадает.
//
Функция ВыгрузкаВАрхивеСовместимаСТекущейКонфигурацией(Знач ИнформацияОВыгрузке) Экспорт
	
	Возврат ИнформацияОВыгрузке.Configuration.Name = Метаданные.Имя;
	
КонецФункции

// Сравнивает совместима ли версия конфигурации с выгруженной.
//
// Параметры:
//	ИнформацияОВыгрузке - ОбъектXDTO - см. процедуру "СохранитьОписаниеВыгрузки".
//
// Возвращаемое значение:
//	Булево - Истина, если совпадает.
//
Функция ВыгрузкаВАрхивеСовместимаСТекущейВерсиейКонфигурации(Знач ИнформацияОВыгрузке) Экспорт
	
	Возврат ИнформацияОВыгрузке.Configuration.Version = Метаданные.Версия;
	
КонецФункции

// Тип данных файла, в котором хранится имя колонки с исходной ссылкой.
//
// Возвращаемое значение:
//	Строка - имя типа.
//
Функция ТипДанныхДляИмениКолонкиТаблицыЗначений() Экспорт
	
	Возврат "1cfresh\ReferenceMapping\ValueTableColumnName";
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Типы файлов и структура каталогов выгрузки/загрузки

// Возвращает наименование типа файла с информацией о выгрузке.
// Возвращаемое значение:
//  Строка - наименование типа.
Функция DumpInfo() Экспорт
	Возврат "DumpInfo";
КонецФункции

// Возвращает наименование типа файла с информацией о составе выгрузке.
// Возвращаемое значение:
//  Строка - наименование типа.
Функция PackageContents() Экспорт
	Возврат "PackageContents";
КонецФункции

// Возвращает наименование типа файла с информацией о сопоставлении ссылок.
// Возвращаемое значение:
//  Строка - наименование типа.
Функция ReferenceMapping() Экспорт
	Возврат "ReferenceMapping";
КонецФункции

// Возвращает наименование типа файла с информацией о пересоздании ссылок.
// Возвращаемое значение:
//  Строка - наименование типа.
Функция ReferenceRebuilding() Экспорт
	Возврат "ReferenceRebuilding";
КонецФункции

// Возвращает наименование типа файла, хранящий сериализованные данные информационной базы.
// Возвращаемое значение:
//  Строка - наименование типа.
Функция InfobaseData() Экспорт
	Возврат "InfobaseData";
КонецФункции

// Возвращает наименование типа файла, хранящий сериализованные данные границ последовательности.
// Возвращаемое значение:
//	Строка - наименование типа.
Функция SequenceBoundary() Экспорт
	Возврат "SequenceBoundary";
КонецФункции

// Возвращает наименование типа файла, хранящий сериализованные данные настроек пользователей.
// Возвращаемое значение:
//	Строка - наименование типа.
Функция UserSettings() Экспорт
	Возврат "UserSettings";
КонецФункции

// Возвращает наименование типа файла, хранящий сериализованные данные пользователей.
// Возвращаемое значение:
//	Строка - наименование типа.
Функция Users() Экспорт
	Возврат "Users";
КонецФункции

// Возвращает наименование типа файла, хранящий произвольные данные.
// Возвращаемое значение:
//	Строка - наименование типа.
Функция CustomData() Экспорт
	Возврат "CustomData";
КонецФункции

// Функция формирует правила структуры каталогов в выгрузке.
//
// Возвращаемое значение:
//	ФиксированнаяСтруктура - структура каталогов.
//
Функция ПравилаФормированияСтруктурыКаталогов() Экспорт
	
	КорневойКаталог = "";
	КаталогДанных = "Data";
	
	Результат = Новый Структура();
	Результат.Вставить(DumpInfo(), КорневойКаталог);
	Результат.Вставить(Digest(), КорневойКаталог);
	Результат.Вставить(Extensions(), КорневойКаталог);
	Результат.Вставить(PackageContents(), КорневойКаталог);
	Результат.Вставить(ReferenceMapping(), ReferenceMapping());
	Результат.Вставить(ReferenceRebuilding(), ReferenceRebuilding());
	Результат.Вставить(InfobaseData(), КаталогДанных);
	Результат.Вставить(SequenceBoundary(), КаталогДанных);
	Результат.Вставить(Users(), КорневойКаталог);
	Результат.Вставить(UserSettings(), UserSettings());
	Результат.Вставить(CustomData(), CustomData());
	
	Возврат Новый ФиксированнаяСтруктура(Результат);
	
КонецФункции

// Возвращает типы файлов, которые поддерживают замену ссылок.
//
// Возвращаемое значение:
//	Массив - массив типов файлов.
//
Функция ТипыФайловПоддерживающиеЗаменуСсылок() Экспорт
	
	Результат = Новый Массив();
	
	Результат.Добавить(InfobaseData());
	Результат.Добавить(SequenceBoundary());
	Результат.Добавить(UserSettings());
	
	Возврат Результат;
	
КонецФункции

// Возвращает имя типа, который будет использован в xml файле для указанного объекта метаданных
// Используется при поиске и замене ссылок при загрузке, при модификации схемы current-config при записи.
// 
// Параметры:
//  Значение - СправочникСсылка, ДокументСсылка, ОбъектМетаданных - объект метаданных или ссылка.
//
// Возвращаемое значение:
//  Строка - Строка вида AccountingRegisterRecordSet.Хозрасчетный, описывающая объект метаданных.
//
Функция XMLТипСсылки(Знач Значение) Экспорт
	
	Если ТипЗнч(Значение) = Тип("ОбъектМетаданных") Тогда
		ОбъектМетаданных = Значение;
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ОбъектМетаданных.ПолноеИмя());
		Ссылка = МенеджерОбъекта.ПолучитьСсылку();
	Иначе
		ОбъектМетаданных = Значение.Метаданные();
		Ссылка = Значение;
	КонецЕсли;
	
	Если ОбщегоНазначенияБТС.ЭтоСсылочныеДанные(ОбъектМетаданных) Тогда
		
		Возврат СериализаторXDTO.XMLТипЗнч(Ссылка).ИмяТипа;
		
	Иначе
		
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Ошибка при определении XMLТипа ссылки для объекта %1: объект не является ссылочным'"),
			ОбъектМетаданных.ПолноеИмя());
		
	КонецЕсли;
	
КонецФункции

// Возвращает объект метаданных по типу поля.
//
// Параметры:
//	ТипПоля - Тип - тип поля
//
// Возвращаемое значение:
//	ОбъектМетаданных - объект метаданных.
//
Функция ОбъектМетаданныхПоТипуСсылки(Знач ТипПоля) Экспорт
	
	СсылкиТочекМаршрутаБизнесПроцессов = СсылкиТочекМаршрутаБизнесПроцессов();
	
	БизнесПроцесс = СсылкиТочекМаршрутаБизнесПроцессов.Получить(ТипПоля);
	Если БизнесПроцесс = Неопределено Тогда
		Ссылка = Новый(ТипПоля);
		МетаданныеСсылки = Ссылка.Метаданные();
	Иначе
		МетаданныеСсылки = БизнесПроцесс;
	КонецЕсли;
	
	Возврат МетаданныеСсылки;
	
КонецФункции

// Возвращает полный список констант конфигурации
//
// Возвращаемое значение:
//  Массив из ОбъектМетаданных - объекты метаданных.
//
Функция ВсеКонстанты() Экспорт
	
	МетаданныеОбъектов = Новый Массив;
	ЗаполнитьКоллекцииКонстант(МетаданныеОбъектов);
	Возврат ВсеМетаданныеКоллекций(МетаданныеОбъектов);
	
КонецФункции

// Возвращает полный список ссылочных типов конфигурации
//
// Возвращаемое значение:
//  Массив - Объекты метаданных
//
Функция ВсеСсылочныеДанные() Экспорт
	
	МетаданныеОбъектов = Новый Массив;
	ЗаполнитьКоллекцииСсылочныхОбъектов(МетаданныеОбъектов);
	Возврат ВсеМетаданныеКоллекций(МетаданныеОбъектов);
	
КонецФункции

// Возвращает полный список наборов записей конфигурации
//
// Возвращаемое значение:
//  Массив - Объекты метаданных
//
Функция ВсеНаборыЗаписей() Экспорт
	
	МетаданныеОбъектов = Новый Массив;
	ЗаполнитьКоллекцииНаборовЗаписей(МетаданныеОбъектов);
	Возврат ВсеМетаданныеКоллекций(МетаданныеОбъектов);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Чтение/запись данных

// Записывает объект в поток записи.
//
// Параметры:
//	Объект - Произвольный - записываемый объект.
//	ПотокЗаписи - ЗаписьXML - поток записи.
//	Сериализатор - СериализаторXDTO - сериализатор.
//
Процедура ЗаписатьОбъектВПоток(Знач Объект, ПотокЗаписи, Сериализатор = Неопределено) Экспорт
	
	Если Сериализатор = Неопределено Тогда
		Сериализатор = СериализаторXDTO;
	КонецЕсли;
	
	ПотокЗаписи.ЗаписатьНачалоЭлемента(ИмяЭлементаСодержащегоОбъект());
	
	ПрефиксыПространствИмен = ПрефиксыПространствИмен();
	Для Каждого ПрефиксПространстваИмен Из ПрефиксыПространствИмен Цикл
		ПотокЗаписи.ЗаписатьСоответствиеПространстваИмен(ПрефиксПространстваИмен.Значение, ПрефиксПространстваИмен.Ключ);
	КонецЦикла;
	
	Сериализатор.ЗаписатьXML(ПотокЗаписи, Объект, НазначениеТипаXML.Явное);
	
	ПотокЗаписи.ЗаписатьКонецЭлемента();
	
КонецПроцедуры

// Возвращает объект из файла.
//
// Параметры:
//	ПотокЧтения - ЧтениеXML - поток чтения.
//
// Возвращаемое значение:
//	Произвольный - прочитанных объект.
//
Функция ПрочитатьОбъектИзПотока(ПотокЧтения) Экспорт
	
	Если ПотокЧтения.ТипУзла <> ТипУзлаXML.НачалоЭлемента
			Или ПотокЧтения.Имя <> ИмяЭлементаСодержащегоОбъект() Тогда
		
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Ошибка чтения XML. Неверный формат файла. Ожидается начало элемента %1.'"),
			ИмяЭлементаСодержащегоОбъект());
		
	КонецЕсли;
	
	Если НЕ ПотокЧтения.Прочитать() Тогда
		ВызватьИсключение НСтр("ru = 'Ошибка чтения XML. Обнаружено завершение файла.'");
	КонецЕсли;
	
	Объект = СериализаторXDTO.ПрочитатьXML(ПотокЧтения);
	
	Возврат Объект;
	
КонецФункции

// Читает ОбъектXDTO из файла.
//
// Параметры:
//	ИмяФайла - Строка - полный путь к файлу.
//	ТипXDTO - ТипОбъектаXDTO - тип объекта XDTO.
//
// Возвращаемое значение:
//	ОбъектXDTO - прочитанный объект.
//
Функция ПрочитатьОбъектXDTOИзФайла(Знач ИмяФайла, Знач ТипXDTO) Экспорт
	
	ПотокЧтения = Новый ЧтениеXML();
	ПотокЧтения.ОткрытьФайл(ИмяФайла);
	ПотокЧтения.ПерейтиКСодержимому();
	
	Если ПотокЧтения.ТипУзла <> ТипУзлаXML.НачалоЭлемента
			Или ПотокЧтения.Имя <> ИмяЭлементаСодержащегоXDTOОбъект() Тогда
		
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Ошибка чтения XML. Неверный формат файла. Ожидается начало элемента %1.'"),
			ИмяЭлементаСодержащегоXDTOОбъект());
		
	КонецЕсли;
	
	Если НЕ ПотокЧтения.Прочитать() Тогда
		ВызватьИсключение НСтр("ru = 'Ошибка чтения XML. Обнаружено завершение файла.'");
	КонецЕсли;
	
	ОбъектXDTO = ФабрикаXDTO.ПрочитатьXML(ПотокЧтения, ТипXDTO);
	
	ПотокЧтения.Закрыть();
	
	Возврат ОбъектXDTO;
	
КонецФункции

// Возвращает префиксы для часто используемых пространств имен.
//
// Возвращаемое значение:
//	Соответствие - где:
//	* Ключ - Строка - пространство имени.
//	* Значение - Строка - префикс.
//
Функция ПрефиксыПространствИмен() Экспорт
	
	Результат = Новый Соответствие();
	
	Результат.Вставить("http://www.w3.org/2001/XMLSchema", "xs");
	Результат.Вставить("http://www.w3.org/2001/XMLSchema-instance", "xsi");
	Результат.Вставить("http://v8.1c.ru/8.1/data/core", "v8");
	Результат.Вставить("http://v8.1c.ru/8.1/data/enterprise", "ns");
	Результат.Вставить("http://v8.1c.ru/8.1/data/enterprise/current-config", "cc");
	Результат.Вставить("http://www.1c.ru/1cFresh/Data/Dump/1.0.2.1", "dmp");
	
	Возврат Новый ФиксированноеСоответствие(Результат);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Прочее

Функция ТипыСтандартныхХранилищНастроек() Экспорт
	
	Результат = Новый Массив();
	
	Результат.Добавить("ХранилищеОбщихНастроек");
	Результат.Добавить("ХранилищеСистемныхНастроек");
	Результат.Добавить("ХранилищеПользовательскихНастроекОтчетов");
	Результат.Добавить("ХранилищеВариантовОтчетов");
	Результат.Добавить("ХранилищеНастроекДанныхФорм");
	Результат.Добавить("ХранилищеПользовательскихНастроекДинамическихСписков");
	
	Возврат Новый ФиксированныйМассив(Результат);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Записывает описание конфигурации
//
// Параметры:
//	Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//		контейнера, используемый в процессе выгрузи данных. Подробнее см. комментарий
//		к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//
Процедура СохранитьОписаниеВыгрузки(Знач Контейнер)
	
	ТипDumpInfo = ФабрикаXDTO.Тип("http://www.1c.ru/1cFresh/Data/Dump/1.0.2.1", "DumpInfo");
	ТипConfigurationInfo = ФабрикаXDTO.Тип("http://www.1c.ru/1cFresh/Data/Dump/1.0.2.1", "ConfigurationInfo");
	
	ИнформацияОВыгрузке = ФабрикаXDTO.Создать(ТипDumpInfo);
	ИнформацияОВыгрузке.Created = ТекущаяУниверсальнаяДата();
	
	ИнформацияОКонфигурации = ФабрикаXDTO.Создать(ТипConfigurationInfo);
	ИнформацияОКонфигурации.Name = Метаданные.Имя;
	ИнформацияОКонфигурации.Version = Метаданные.Версия;
	ИнформацияОКонфигурации.Vendor = Метаданные.Поставщик;
	// @skip-warning МетодНеОбнаружен - ошибка проверки.
	ИнформацияОКонфигурации.Presentation = Метаданные.Представление();
	
	ИнформацияОВыгрузке.Configuration = ИнформацияОКонфигурации;
	
	ИмяФайла = Контейнер.СоздатьФайл(DumpInfo());
	ЗаписатьОбъектXDTOВФайл(ИнформацияОВыгрузке, ИмяФайла);
	Контейнер.ФайлЗаписан(ИмяФайла);
	
КонецПроцедуры

// Читает описание конфигурации
//
// Параметры:
//	Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//		контейнера, используемый в процессе выгрузи данных. Подробнее см. комментарий
//		к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//
Функция ПрочитатьИнформациюОВыгрузке(Контейнер)
	
	Файл = Контейнер.ПолучитьФайлИзКаталога(DumpInfo());
	
	Контейнер.РаспаковатьФайл(Файл);
	
	Результат =  ПрочитатьОбъектXDTOИзФайла(Файл.ПолноеИмя, ФабрикаXDTO.Тип("http://www.1c.ru/1cFresh/Data/Dump/1.0.2.1", "DumpInfo"));
	
	УдалитьФайлы(Файл.ПолноеИмя);
	
	Возврат Результат;
	
КонецФункции

// Возвращает имя элемента в потоке записи/чтения, в котором хранится XDTOОбъект.
//
// Возвращаемое значение:
//	Строка - имя элемента.
//
Функция ИмяЭлементаСодержащегоXDTOОбъект()
	
	Возврат "XDTODataObject";
	
КонецФункции

// Возвращает имя элемента в потоке записи/чтения, в котором хранится объект.
//
// Возвращаемое значение:
//	Строка - имя элемента.
//
Функция ИмяЭлементаСодержащегоОбъект()
	
	Возврат "Data";
	
КонецФункции

// Возвращает массив пространства имен для записи пакетов.
//
// Параметры:
//	URIПространстваИмен - Строка - пространство имен.
//
// Возвращаемое значение:
//	Массив - массив пространств имен.
//
Функция ПолучитьПространстваИменДляЗаписиПакета(Знач URIПространстваИмен)
	
	Результат = Новый Массив();
	Результат.Добавить(URIПространстваИмен);
	
	Зависимости = ФабрикаXDTO.Пакеты.Получить(URIПространстваИмен).Зависимости;
	Для Каждого Зависимость Из Зависимости Цикл
		ЗависимыеПространстваИмен = ПолучитьПространстваИменДляЗаписиПакета(Зависимость.URIПространстваИмен);
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(Результат, ЗависимыеПространстваИмен, Истина);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Заполняет массив коллекцией метаданных ссылочных объектов.
//
// Параметры:
//	МассивКоллекцийМетаданных - Массив из ОбъектМетаданных - объекты метаданных.
//
Процедура ЗаполнитьКоллекцииСсылочныхОбъектов(МассивКоллекцийМетаданных)

	МассивКоллекцийМетаданных.Добавить(Метаданные.Справочники);
	МассивКоллекцийМетаданных.Добавить(Метаданные.Документы);
	МассивКоллекцийМетаданных.Добавить(Метаданные.БизнесПроцессы);
	МассивКоллекцийМетаданных.Добавить(Метаданные.Задачи);
	МассивКоллекцийМетаданных.Добавить(Метаданные.ПланыСчетов);
	МассивКоллекцийМетаданных.Добавить(Метаданные.ПланыОбмена);
	МассивКоллекцийМетаданных.Добавить(Метаданные.ПланыВидовХарактеристик);
	МассивКоллекцийМетаданных.Добавить(Метаданные.ПланыВидовРасчета);
	
КонецПроцедуры

// Заполняет массив коллекцией метаданных наборов записей.
//
// Параметры:
//	МассивКоллекцийМетаданных - Массив - массив.
//
Процедура ЗаполнитьКоллекцииНаборовЗаписей(МассивКоллекцийМетаданных)
	
	МассивКоллекцийМетаданных.Добавить(Метаданные.РегистрыСведений);
	МассивКоллекцийМетаданных.Добавить(Метаданные.РегистрыНакопления);
	МассивКоллекцийМетаданных.Добавить(Метаданные.РегистрыБухгалтерии);
	МассивКоллекцийМетаданных.Добавить(Метаданные.Последовательности);
	МассивКоллекцийМетаданных.Добавить(Метаданные.РегистрыРасчета);
	Для Каждого РегистрРасчета Из Метаданные.РегистрыРасчета Цикл
		МассивКоллекцийМетаданных.Добавить(РегистрРасчета.Перерасчеты);
	КонецЦикла;
	
КонецПроцедуры

// Заполняет массив коллекцией метаданных констант.
//
// Параметры:
//	МассивКоллекцийМетаданных - Массив - массив.
//
Процедура ЗаполнитьКоллекцииКонстант(МассивКоллекцийМетаданных)
	
	МассивКоллекцийМетаданных.Добавить(Метаданные.Константы);
	
КонецПроцедуры

// Возвращает полный список объектов из указанных коллекций
//
// Параметры:
//  Коллекции - Массив - Коллекции.
//
// Возвращаемое значение:
//  Массив - Объекты метаданных.
//
Функция ВсеМетаданныеКоллекций(Знач Коллекции)
	
	Результат = Новый Массив;
	Для Каждого Коллекция Из Коллекции Цикл
		
		Для Каждого Объект Из Коллекция Цикл
			Результат.Добавить(Объект);
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Возвращает ссылки точек бизнес процесса
//
// Возвращаемое значение:
//	Соответствие - где:
//		Ключ - Тип - тип ссылки точки бизнес процесса.
//		Значение - ОбъектМетаданных -бизнес процесс.
//
Функция СсылкиТочекМаршрутаБизнесПроцессов()
	
	Результат = Новый Соответствие();
	
	Для Каждого БизнесПроцесс Из Метаданные.БизнесПроцессы Цикл
		
		Результат.Вставить(Тип("ТочкаМаршрутаБизнесПроцессаСсылка." + БизнесПроцесс.Имя), БизнесПроцесс);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Возвращает СериализаторXDTO с аннотацией типов.
//
// Возвращаемое значение:
//	СериализаторXDTO - сериализатор.
//
Функция СериализаторXDTOСАннотациейТипов(Знач ТекущийКонтейнер, Знач АннотируемыеТипы)
	
	Если АннотируемыеТипы.Количество() > 0 Тогда
		
		Фабрика = ПолучитьФабрикуСУказаниемТипов(ТекущийКонтейнер, АннотируемыеТипы);
		Возврат Новый СериализаторXDTO(Фабрика);
		
	Иначе
		
		Возврат СериализаторXDTO;
		
	КонецЕсли;
	
КонецФункции

// Возвращает фабрику с указанием типов.
//
// Параметры:
//	Типы - ФиксированныйМассив Из ОбъектМетаданных - массив типов.
//
// Возвращаемое значение:
//	ФабрикаXDTO - фабрика.
//
Функция ПолучитьФабрикуСУказаниемТипов(Знач ТекущийКонтейнер, Знач Типы)
	
	НаборСхем = ФабрикаXDTO.ЭкспортСхемыXML("http://v8.1c.ru/8.1/data/enterprise/current-config");
	Схема = НаборСхем[0];
	Схема.ОбновитьЭлементDOM();
	
	ОригинальнаяСхема = ТекущийКонтейнер.СоздатьПроизвольныйФайл(
		"xsd", "http://v8.1c.ru/8.1/data/enterprise/current-config");
	
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.ОткрытьФайл(ОригинальнаяСхема);
	ЗаписьDOM = Новый ЗаписьDOM;
	ЗаписьDOM.Записать(Схема.ДокументDOM, ЗаписьXML);
	ЗаписьXML.Закрыть();
	
	ТекущийКонтейнер.УстановитьКоличествоОбъектов(ОригинальнаяСхема, 1);
	ТекущийКонтейнер.ФайлЗаписан(ОригинальнаяСхема);
	
	УказанныеТипы = Новый Соответствие;
	Для каждого Тип Из Типы Цикл
		УказанныеТипы.Вставить(XMLТипСсылки(Тип), Истина);
	КонецЦикла;
	
	ПространствоИмен = Новый Соответствие;
	ПространствоИмен.Вставить("xs", "http://www.w3.org/2001/XMLSchema");
	РазыменовательПространствИменDOM = Новый РазыменовательПространствИменDOM(ПространствоИмен);
	ТекстXPath = "/xs:schema/xs:complexType/xs:sequence/xs:element[starts-with(@type,'tns:')]";
	
	Запрос = Схема.ДокументDOM.СоздатьВыражениеXPath(ТекстXPath,
		РазыменовательПространствИменDOM);
	Результат = Запрос.Вычислить(Схема.ДокументDOM);

	Пока Истина Цикл
		
		УзелПоля = Результат.ПолучитьСледующий();
		Если УзелПоля = Неопределено Тогда
			Прервать;
		КонецЕсли;
		АтрибутТип = УзелПоля.Атрибуты.ПолучитьИменованныйЭлемент("type");
		ТипБезNSПрефикса = Сред(АтрибутТип.ТекстовоеСодержимое, СтрДлина("tns:") + 1);
		
		Если УказанныеТипы.Получить(ТипБезNSПрефикса) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		УзелПоля.УстановитьАтрибут("nillable", "true");
		УзелПоля.УдалитьАтрибут("type");
	КонецЦикла;
	
	СхемаСАннотациейТипов = ТекущийКонтейнер.СоздатьПроизвольныйФайл(
		"xsd", "http://v8.1c.ru/8.1/data/enterprise/current-config");
	
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.ОткрытьФайл(СхемаСАннотациейТипов);
	ЗаписьDOM = Новый ЗаписьDOM;
	ЗаписьDOM.Записать(Схема.ДокументDOM, ЗаписьXML);
	ЗаписьXML.Закрыть();
	
	Фабрика = СоздатьФабрикуXDTO(СхемаСАннотациейТипов);
	ТекущийКонтейнер.УстановитьКоличествоОбъектов(СхемаСАннотациейТипов, 1);
	ТекущийКонтейнер.ФайлЗаписан(СхемаСАннотациейТипов);
	
	Возврат Фабрика;
	
КонецФункции

// Возвращает наименование файла с дайджестом выгрузки.
//
// Возвращаемое значение:
//	Строка - наименование
Функция Digest() Экспорт
	Возврат "Digest";
КонецФункции

Функция Extensions() Экспорт 
	Возврат "Extensions";	
КонецФункции

// Записывает ОбъектXDTO в файл.
//
// Параметры:
//	ОбъектXDTO - ОбъектXDTO - записываемый ОбъектXDTO.
//	ИмяФайла - Строка - полный путь к файлу.
//	ПрефиксПространстваИменПоУмолчанию - Строка - префикс.
//
Процедура ЗаписатьОбъектXDTOВФайл(Знач ОбъектXDTO, Знач ИмяФайла, Знач ПрефиксПространстваИменПоУмолчанию = "")
	
	ПотокЗаписи = Новый ЗаписьXML();
	ПотокЗаписи.ОткрытьФайл(ИмяФайла);
	
	ПрефиксыПространствИмен = ПрефиксыПространствИмен();
	ПространствоИменОбъекта = ОбъектXDTO.Тип().URIПространстваИмен;
	Если ПустаяСтрока(ПрефиксПространстваИменПоУмолчанию) Тогда
		ПрефиксПространстваИменПоУмолчанию = ПрефиксыПространствИмен.Получить(ПространствоИменОбъекта);
	КонецЕсли;
	ИспользуемыеПространстваИмен = ПолучитьПространстваИменДляЗаписиПакета(ПространствоИменОбъекта);
	
	ПотокЗаписи.ЗаписатьНачалоЭлемента(ИмяЭлементаСодержащегоXDTOОбъект());
	
	Для Каждого ИспользуемоеПространствоИмен Из ИспользуемыеПространстваИмен Цикл
		ПрефиксПространстваИмен = ПрефиксыПространствИмен.Получить(ИспользуемоеПространствоИмен);
		Если ПрефиксПространстваИмен = ПрефиксПространстваИменПоУмолчанию Тогда
			ПотокЗаписи.ЗаписатьСоответствиеПространстваИмен("", ИспользуемоеПространствоИмен);
		Иначе
			ПотокЗаписи.ЗаписатьСоответствиеПространстваИмен(ПрефиксПространстваИмен, ИспользуемоеПространствоИмен);
		КонецЕсли;
	КонецЦикла;
	
	ФабрикаXDTO.ЗаписатьXML(ПотокЗаписи, ОбъектXDTO);
	
	ПотокЗаписи.ЗаписатьКонецЭлемента();
	
	ПотокЗаписи.Закрыть();
	
КонецПроцедуры

#КонецОбласти
