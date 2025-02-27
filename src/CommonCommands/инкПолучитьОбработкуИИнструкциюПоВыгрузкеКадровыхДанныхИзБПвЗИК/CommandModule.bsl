
#Область ОписаниеПеременных

#КонецОбласти

#Область ПрограммныйИнтерфейс
// Код процедур и функций
#КонецОбласти

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

 	АдрресФайлаВХранилище = инкОбщийСервер.ПолучитьФайлИзМакетаВХранилищеНаСервере("инкВыгрузкаКадровыхДанныхИзБПвЗИКОбработкаИИнструкция","zip");
	
	Если АдрресФайлаВХранилище = Неопределено Тогда
    	Возврат;
    КонецЕсли;                                          

	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ФайлВыгрузкиАдрес",АдрресФайлаВХранилище);
	ДополнительныеПараметры.Вставить("ИмяФайла","инкВыгрузкаКадровыхДанныхИзБПвЗИКОбработкаИИнструкция.zip");
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

		// Выбор файла для открытия	
		Режим = РежимДиалогаВыбораФайла.Сохранение;
		Диалог = Новый ДиалогВыбораФайла(Режим);
		Диалог.ПолноеИмяФайла = ДополнительныеПараметры.ИмяФайла;
		
		ОбратныйВызов = Новый ОписаниеОповещения("СохранитьФайлЗавершение", ЭтотОбъект, ДополнительныеПараметры); 
		// Открывает диалоговое окно
		Диалог.Показать(ОбратныйВызов);
		
	#КонецЕсли 
	
КонецПроцедуры     

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс
//
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СохранитьФайлЗавершение(РезультатВопроса,ДополнительныеПараметры) Экспорт
	
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

#КонецОбласти

#Область Инициализация

#КонецОбласти

