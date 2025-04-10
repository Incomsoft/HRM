
#Область ОписаниеПеременных

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначениямиПоУмолчанию();
	ПересчитатьДанныеНаФорме();
	
КонецПроцедуры                    

&НаСервере
Процедура ЗаполнитьЗначениямиПоУмолчанию()

	Объект.Год = ТекущаяДата();
	Объект.Организация = Справочники.инкОрганизации.ПолучитьТекущуюОрганизацию();
	Объект.Признак = "1";
	Объект.НомерКорректировки = "00";
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ПересчитатьДанныеНаФорме();
КонецПроцедуры

&НаКлиенте
Процедура ГодПриИзменении(Элемент)
	ПересчитатьДанныеНаФорме();
КонецПроцедуры

&НаКлиенте
Процедура СуммаУплаченногоНалогаПриИзменении(Элемент)
	Объект.ПроцентУплаты = ПолучитьПроцентУплаты();
КонецПроцедуры

Процедура ПересчитатьДанныеНаФорме()

	Объект.НачисленоСНачалаГода = ПолучитьСуммуУдержанногоНалога();
	Объект.ПроцентУплаты = ПолучитьПроцентУплаты();
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПроцентУплаты()
	
	ПроцентУплаты = 0;
	
	Если Объект.НачисленоСНачалаГода <> 0 Тогда
		ПроцентУплаты = Объект.ПеречисленоСНачалаГода / Объект.НачисленоСНачалаГода * 100;		
	КонецЕсли;           
	
	Если ПроцентУплаты > 100 Тогда
		ПроцентУплаты = 100;
	КонецЕсли;
	
	Возврат ПроцентУплаты;
	
КонецФункции

&НаСервере
Функция ПолучитьСуммуУдержанногоНалога()
	
	ОблагаемыеДоходы = 0;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	инкНалогУдержанныйОбороты.Организация КАК Организация,
		|	инкНалогУдержанныйОбороты.СуммаНалогаОборот КАК СуммаНалогаОборот
		|ИЗ
		|	РегистрНакопления.инкНалогУдержанный.Обороты(&Дата1, &Дата2, , Организация = &Организация) КАК инкНалогУдержанныйОбороты";
	
	Запрос.УстановитьПараметр("Дата1", НачалоГода(Объект.Год));
	Запрос.УстановитьПараметр("Дата2", КонецГода(Объект.Год));
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ОблагаемыеДоходы = ОблагаемыеДоходы + ВыборкаДетальныеЗаписи.СуммаНалогаОборот;
	КонецЦикла;
	
	Возврат ОблагаемыеДоходы;

КонецФункции	

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
// Код процедур и функций
#КонецОбласти

#Область ОбработчикиКомандФормы
// Код процедур и функций
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область о // Печать:

&НаКлиенте
Процедура Печать(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ВыборСотрудниковЗавершение", ЭтотОбъект);
		   
	ВыборкаПериод = Новый СтандартныйПериод;
	ВыборкаПериод.ДатаНачала = НачалоГода(Объект.Год);
	ВыборкаПериод.ДатаОкончания = КонецГода(Объект.Год);
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Организация",Объект.Организация);  
	ПараметрыОткрытия.Вставить("Период",ВыборкаПериод);  
		   
	ОткрытьФорму("ОбщаяФорма.инкВыборСотрудников", 
		ПараметрыОткрытия,
		ЭтотОбъект,
		УникальныйИдентификатор,
		,
		,
		Оповещение,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборСотрудниковЗавершение(Знач РезультатРедактирования, Знач ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(РезультатРедактирования) Тогда
		
		ТабличныйДокумент = ПолучитьТабличныйДокументНаСервере(РезультатРедактирования);
		инкОтчетыКлиент.ПечатьТабличногоДокумента(ТабличныйДокумент,"Справка 2 НДФЛ",ЭтаФорма);
			
	КонецЕсли;
	
КонецПроцедуры 

&НаСервере
Функция ПолучитьТабличныйДокументНаСервере(ПараметрыПечати)
	
	МенеджерПечати = РеквизитФормыВЗначение("Объект");
	МенеджерПечати.Сотрудники = ПараметрыПечати.Сотрудники;
	МенеджерПечати.Организация = ПараметрыПечати.Организация;
	ТабличныйДокумент = МенеджерПечати.ПолучитьРезультатРасчета();

	Возврат ТабличныйДокумент; 
	
КонецФункции

#КонецОбласти

#КонецОбласти
