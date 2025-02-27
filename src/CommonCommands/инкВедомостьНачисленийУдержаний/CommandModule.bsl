
#Область ОписаниеПеременных

#КонецОбласти

#Область ПрограммныйИнтерфейс
//
#КонецОбласти

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Оповещение = Новый ОписаниеОповещения("ВыборПериодаЗавершение", ЭтотОбъект);
		   
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Организация", инкОбщийСервер.ПолучитьТекущуюОрганизациюНаСервере());
		   
	ОткрытьФорму("ОбщаяФорма.инкВыборПериодаИПодразделений", 
		ПараметрыОткрытия,
		ЭтотОбъект,
		Новый УникальныйИдентификатор,
		,
		,
		Оповещение,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс
//
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура - Выбор периода завершение
//
// Параметры:
//  РезультатРедактирования	 - Структура	 - Результат редактирования
//  ДополнительныеПараметры	 - Структура	 - Доп. параметры
//
&НаКлиенте
Процедура ВыборПериодаЗавершение(Знач РезультатРедактирования, Знач ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(РезультатРедактирования) Тогда
		
		ПараметрыОткрытия = инкОтчетыСервер.ПолучитьПараметрыОткрытияФормыВедомости(РезультатРедактирования);
		
		ПолноеИмяФормыСтрока = "Обработка.инкВедомостьНачисленийУдержаний.Форма.ФормаВедомости";
	 	ОткрытьФорму(ПолноеИмяФормыСтрока, 
			ПараметрыОткрытия,
			ЭтотОбъект,
			Новый УникальныйИдентификатор,
			,
			,
			,
			РежимОткрытияОкнаФормы.Независимый);

	КонецЕсли;
	
КонецПроцедуры 

#КонецОбласти

#Область Инициализация

#КонецОбласти

