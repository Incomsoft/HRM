
#Область ОписаниеПеременных

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Объект.ВедомостьНаВыплатуЗарплаты = Документы.инкВедомостьНаВыплатуЗарплаты.НайтиПоНомеру("00000000001",Дата("20220101000000"));
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьРКО(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ПечатьРКОЗавершение", ЭтотОбъект);
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("АдресПараметровВХранилище", ВыборСпискаСотрудниковВХранилище());
	
	ОткрытьФорму("ОбщаяФорма.инкВыборСотрудниковСписком", 
		ПараметрыОткрытия,
		ЭтотОбъект,
		УникальныйИдентификатор,
		,
		,
		Оповещение,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры  

&НаКлиенте
Процедура ПечатьРКОЗавершение(Знач РезультатРедактирования, Знач ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(РезультатРедактирования) Тогда
		
		ТабличныйДокумент = ПолучитьТабличныйДокумент(РезультатРедактирования); 
		инкОтчетыКлиент.ПечатьТабличногоДокумента(ТабличныйДокумент,"РКО",ЭтаФорма);
		
	КонецЕсли;	
	
КонецПроцедуры 

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
// Код процедур и функций
#КонецОбласти

#Область ОбработчикиКомандФормы
// Код процедур и функций
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьТабличныйДокумент(РезультатРедактирования)
	
	РезультатВыбора = ПолучитьИзВременногоХранилища(РезультатРедактирования);
	МенеджерПечати = РеквизитФормыВЗначение("Объект");
	ТабличныйДокумент = МенеджерПечати.ПолучитьПечатныйДокументРКОНаСервере(Объект.ВедомостьНаВыплатуЗарплаты,РезультатВыбора.Сотрудники);
	
	Возврат ТабличныйДокумент; 
	
КонецФункции

&НаСервере
Функция ВыборСпискаСотрудниковВХранилище()
	
	ПараметрыРасчета = Новый Структура;
	ПараметрыРасчета.Вставить("Сотрудники",Объект.ВедомостьНаВыплатуЗарплаты.Зарплата.Выгрузить().ВыгрузитьКолонку("Сотрудник"));
	
	Возврат ПоместитьВоВременноеХранилище(ПараметрыРасчета, УникальныйИдентификатор);
	
КонецФункции

#КонецОбласти
