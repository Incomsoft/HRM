// Добавляет динамический список вместо формы списка соответствующего объекта
//
&НаСервере
Процедура ДобавитьДинамическийСписокНаФорму(Тип, Вид)
	Если Тип = "Справочник" Тогда
		мдСсылки = Метаданные.Справочники[Вид];
	ИначеЕсли Тип = "Документ" Тогда
		мдСсылки = Метаданные.Документы[Вид];
	ИначеЕсли Тип = "ПланВидовХарактеристик" Тогда
		мдСсылки = Метаданные.ПланыВидовХарактеристик[Вид];
	ИначеЕсли Тип = "ПланСчетов" Тогда
		мдСсылки = Метаданные.ПланыСчетов[Вид];
	ИначеЕсли Тип = "ПланВидовРасчета" Тогда
		мдСсылки = Метаданные.ПланыВидовРасчета[Вид];
	ИначеЕсли Тип = "ПланОбмена" Тогда
		мдСсылки = Метаданные.ПланыОбмена[Вид];
	ИначеЕсли Тип = "БизнесПроцесс" Тогда
		мдСсылки = Метаданные.БизнесПроцессы[Вид];
	ИначеЕсли Тип = "Задача" Тогда
		мдСсылки = Метаданные.Задачи[Вид];
	Иначе
		Сообщить("Выбранный тип данных """ + Тип + """ не поддерживается.");
		Возврат;
	КонецЕсли;
	
	ИмяРеквизитаФормы = "lyayСписокВыбора";
	// Добавляем реквизит формы ДинамическийСписок
	ДобавляемыеРеквизиты = Новый Массив;
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы(ИмяРеквизитаФормы,
									Новый ОписаниеТипов("ДинамическийСписок"),
									,
									мдСсылки.Имя + ?(ПустаяСтрока(мдСсылки.Синоним), "", " (" + мдСсылки.Синоним + ")"),
									Ложь));
	ЭтаФорма.ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	
	ЭтаФорма[ИмяРеквизитаФормы].ОсновнаяТаблица = Тип + "." + Вид;
	
	// Создаём таблицу (элемент формы) для отображения данных
	ЭлементФормы = ЭтаФорма.Элементы.Добавить(ИмяРеквизитаФормы, Тип("ТаблицаФормы"));
	ЭлементФормы.ПутьКДанным = ИмяРеквизитаФормы;
	ЭлементФормы.Подсказка = мдСсылки.Комментарий;
	ЭлементФормы.Заголовок = мдСсылки.Синоним;
	ЭлементФормы.УстановитьДействие("ВыборЗначения", "СписокВыбор");
	ЭлементФормы.РежимВыбора = Истина;
	ЭлементФормы.ВыборГруппИЭлементов = ИспользованиеГруппИЭлементов.ГруппыИЭлементы;
	ЭлементФормы.РежимВыделения = РежимВыделенияТаблицы.Одиночный;
	//ЭлементФормы.ТекущиеДанные = ЭтаФорма.ВыбСсылка; Жалко не работает. Хорошо бы устанавливать текущую строку.
	
	// Создаём колонки в отображаемой таблице
	Для каждого мдРеквизита Из мдСсылки.СтандартныеРеквизиты Цикл
		Колонка = ЭтаФорма.Элементы.Добавить(ЭлементФормы.Имя + мдРеквизита.Имя, Тип("ПолеФормы"), ЭлементФормы);
		Колонка.Вид = ?(мдРеквизита.Тип.Типы().Количество() = 1 И мдРеквизита.Тип.Типы()[0] = Тип("Булево"), ВидПоляФормы.ПолеФлажка, ВидПоляФормы.ПолеНадписи);
		Колонка.ПутьКДанным = ИмяРеквизитаФормы + "." + мдРеквизита.Имя;
		Колонка.Подсказка = мдРеквизита.Синоним;
	КонецЦикла; 
КонецПроцедуры // ДобавитьДинамическийСписокНаФорму()
 
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ОписаниеТипа = Неопределено;
	//ВыбСсылкаИзвестна = Параметры.Свойство("ВыбСсылка", ВыбСсылка);
	Если Параметры.Свойство("ОписаниеТипа", ОписаниеТипа) Тогда
		ДобавитьДинамическийСписокНаФорму(ОписаниеТипа.Тип, ОписаниеТипа.Вид);
	Иначе
		Сообщить("Это несамостоятельная форма. Работать будет криво.");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОповеститьОВыборе(ВыбраннаяСтрока);
КонецПроцедуры
