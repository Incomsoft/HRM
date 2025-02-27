
#Область ОписаниеПеременных

#КонецОбласти

#Область ПрограммныйИнтерфейс
// Код процедур и функций
#КонецОбласти

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Оповещение = Новый ОписаниеОповещения("ВыборСотрудниковЗавершение", ЭтотОбъект);
	
	ПараметрыОткрытияФормы = ПолучитьПараметрыОткрытияФормы();
	
	ОткрытьФорму("ОбщаяФорма.инкВыборСотрудников", 
		ПараметрыОткрытияФормы,
		ЭтотОбъект,
		Новый УникальныйИдентификатор,
		,
		,
		Оповещение,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс
// Код процедур и функций
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьПараметрыОткрытияФормы()
	
	ПараметрыОткрытияФормы = Новый Структура;
	
	ПараметрыОткрытияФормы.Вставить("Организация",Справочники.инкОрганизации.ПолучитьЕдинственнуюОрганизацию());
	//ПараметрыОткрытияФормы.Вставить("Организация",Справочники.инкОрганизации.НайтиПоКоду("000000001"));
	
	ПериодЗапроса = Новый СтандартныйПериод;
	ПериодЗапроса.ДатаНачала = НачалоГода(ТекущаяДата());
	ПериодЗапроса.ДатаОкончания = КонецГода(ТекущаяДата());
	ПараметрыОткрытияФормы.Вставить("Период",ПериодЗапроса);
	
	Возврат ПараметрыОткрытияФормы;
	
КонецФункции

&НаКлиенте
Процедура ВыборСотрудниковЗавершение(Знач РезультатРедактирования, Знач ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(РезультатРедактирования) Тогда
		
		ТабличныеДокументыРаздел1 = ПолучитьТабличныйРаздел1(РезультатРедактирования);	
		инкОтчетыКлиент.ПечатьТабличногоДокумента(ТабличныеДокументыРаздел1,"",Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры                                            

&НаСервере
Функция ПолучитьТабличныйРаздел1(ПараметрыСтруктура)	

	МенеджерПечати = Отчеты.инкЕФС_1.Создать();
	ТабличныйДокументЕФС = МенеджерПечати.СформироватьТабличныеДокументыЕФС_1(ПараметрыСтруктура,"Раздел1");
	
	Возврат ТабличныйДокументЕФС.ТаблицаРаздел1;
	
КонецФункции

#КонецОбласти

#Область Инициализация

#КонецОбласти


