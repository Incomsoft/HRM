
#Область ОписаниеПеременных

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначениямиПоУмолчанию();

КонецПроцедуры

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	ЗадатьВопросОПерезаполненииДокумента();
КонецПроцедуры

&НаКлиенте
Процедура ПериодДатаПриИзменении(Элемент)
	ЗадатьВопросОПерезаполненииДокумента();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
// Код процедур и функций
#КонецОбласти

#Область ОбработчикиКомандФормы

#Область о // Заполнить:

&НаКлиенте
Процедура Заполнить(Команда)  
	
	ЗадатьВопросОПерезаполненииДокумента();
	
КонецПроцедуры                             

&НаКлиенте
Процедура ЗадатьВопросОПерезаполненииДокумента()

	ТекстВопроса = НСтр("ru = 'Перезаполнить документ данными?'");
	Оповещение = Новый ОписаниеОповещения("ЗадатьВопросОПерезаполненииДокументаЗавершение", ЭтотОбъект);
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры 

&НаКлиенте
Процедура ЗадатьВопросОПерезаполненииДокументаЗавершение(Знач Результат, Знач ДопПараметры) Экспорт

	Если Результат = КодВозвратаДиалога.Да Тогда

		ЗаполнитьНаСервере();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	МенеджерЗаполнения = РеквизитФормыВЗначение("Объект");	
	МенеджерЗаполнения.ЗаполнитьНачальнымиДанными();
	МенеджерЗаполнения.РасчетДопРеквизитов();
	ЗначениеВРеквизитФормы(МенеджерЗаполнения,"Объект");
	инкОбщийКлиентСервер.СообщитьПользователю("Данные документа перезаполнены");
	
КонецПроцедуры

#КонецОбласти

#Область о // Печать:

&НаКлиенте
Процедура Печать6НДФЛ2023(Команда)
	
	ЭтотОбъект.Записать();
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ДокументСсылка",Объект.Ссылка);
	ОткрытьФорму("Документ.инк6НДФЛ.Форма.ФормаОтчета",ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура Печать6НДФЛ2024(Команда)
	
	ЭтотОбъект.Записать();
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ДокументСсылка",Объект.Ссылка);
	ОткрытьФорму("Отчет.инк6НДФЛ.Форма.ФормаОтчета",ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#Область о // Файл:

&НаКлиенте
Процедура Файл(Команда)

	ФайлВыгрузки = СформироватьXMLФайлНаСервере();
	Если НЕ ЗначениеЗаполнено(ФайлВыгрузки.ФайлАдрес) Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ФайлВыгрузкиАдрес",ФайлВыгрузки.ФайлАдрес);
	ДополнительныеПараметры.Вставить("ИмяФайла",ФайлВыгрузки.ФайлИмя);
	ДополнительныеПараметры.Вставить("ВидКлиента");
	
	#Если ВебКлиент Тогда     
		
		ДополнительныеПараметры.ВидКлиента = "ВебКлиент";	
		
		списокКнопокВопроса = новый СписокЗначений();
		списокКнопокВопроса.Добавить("Сохранить","Сохранить");
		списокКнопокВопроса.Добавить("Отмена","Отмена");
		
		Оповещение = новый ОписаниеОповещения("СохранитьФайлЗавершение",ЭтотОбъект,ДополнительныеПараметры);
	  	ПоказатьВопрос(Оповещение,"Выберите действие",списокКнопокВопроса,30,"Сохранить","Сохранить файл выгрузки?","Отмена");

	#Иначе	
		
		ДополнительныеПараметры.ВидКлиента = "";	

		// Выбор файла для открытия:	
		Режим = РежимДиалогаВыбораФайла.Сохранение;
		Диалог = Новый ДиалогВыбораФайла(Режим);
		Диалог.ПолноеИмяФайла = ДополнительныеПараметры.ИмяФайла;
		
		ОбратныйВызов = Новый ОписаниеОповещения("СохранитьФайлЗавершение", ЭтотОбъект, ДополнительныеПараметры); 
		// Открывает диалоговое окно:
		Диалог.Показать(ОбратныйВызов);
		
	#КонецЕсли 

КонецПроцедуры

&НаКлиенте
Процедура СохранитьФайлЗавершение(РезультатВопроса,ДополнительныеПараметры) экспорт
	
	Если РезультатВопроса = Неопределено Тогда
		Возврат;	
	КонецЕсли;
	
	ФайлВыгрузкиАдрес = ДополнительныеПараметры.ФайлВыгрузкиАдрес;
	Если ДополнительныеПараметры.ВидКлиента = "ВебКлиент" Тогда

		Если РезультатВопроса = "Сохранить" тогда
			НачатьПолучениеФайлаССервера(ФайлВыгрузкиАдрес,ДополнительныеПараметры.ИмяФайла);
		Иначе
			Возврат;
		КонецЕсли;		

	Иначе                              
		ПутьКФайлу = РезультатВопроса[0];
		НачатьПолучениеФайлаССервера(,ФайлВыгрузкиАдрес, ПутьКФайлу);	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СформироватьXMLФайлНаСервере()
	
	МенеджерОтчета = РеквизитФормыВЗначение("Объект");

	Возврат МенеджерОтчета.СформироватьФайл(); 
	
КонецФункции

&НаКлиенте
Процедура ВозвратНалогаПриИзменении(Элемент)
	
	ВозвратНалогаПриИзмененииНаСервере();
	
КонецПроцедуры    

&НаСервере
Процедура ВозвратНалогаПриИзмененииНаСервере()
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	Объект.СуммаНалогаВозвращенного = ДокументОбъект.РассчитатьСуммаНалогаВозвращенного();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьЗначениямиПоУмолчанию()

	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		Объект.Организация = Справочники.инкОрганизации.ПолучитьЕдинственнуюОрганизацию();
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Объект.ПериодРегламентногоОтчета) Тогда
		Объект.ПериодРегламентногоОтчета = инкОбщийСервер.ПолучитьПериодРегламентногоОтчетаПоДате(ТекущаяДата()); 
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.НомерКорректировки) Тогда
		Объект.НомерКорректировки = "000"; 
	КонецЕсли;                          
	
	Если НЕ ЗначениеЗаполнено(Объект.ПериодДата) Тогда
		Объект.ПериодДата = НачалоКвартала(ТекущаяДата()); 
	КонецЕсли;                          
	
КонецПроцедуры

#КонецОбласти



