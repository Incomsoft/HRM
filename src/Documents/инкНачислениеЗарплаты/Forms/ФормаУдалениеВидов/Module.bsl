
#Область ОписаниеПеременных

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ПустаяСтрока(Параметры.АдресПараметровВХранилище) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;

	ВыборНачисленийУдержаний = "Начисления";
	мПараметрыРасчета = ПолучитьИзВременногоХранилища(Параметры.АдресПараметровВХранилище);
	ЗаполнитьДаннымиФормуНаСервере(мПараметрыРасчета);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДаннымиФормуНаСервере(ПараметрыРасчета)
	
	НачисленияУдержанияВыбор.Очистить();
	НачисленияУдержанияКУдалению.Очистить();
	
	ПереченьСоответстие = ПараметрыРасчета.НачисленияСоответствие;
	Если ВыборНачисленийУдержаний = "Удержания" Тогда
		ПереченьСоответстие = ПараметрыРасчета.УдержанияСоответствие;
	КонецЕсли; 
	
	Для каждого ПереченьСтрока Из ПереченьСоответстие Цикл
		НачисленияУдержанияВыборСтрока = НачисленияУдержанияВыбор.Добавить();
		НачисленияУдержанияВыборСтрока.НачислениеУдержание = ПереченьСтрока.Ключ;
		НачисленияУдержанияВыборСтрока.Код = ПереченьСтрока.Значение;
	КонецЦикла; 
	
КонецПроцедуры
 
&НаКлиенте
Процедура КомандаПеренестиВПравоОдно(Команда)
	
	ТекущиеДанные = Элементы.НачисленияУдержанияВыбор.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		СтрокаКУдалению =  НачисленияУдержанияКУдалению.Добавить();
	    ЗаполнитьЗначенияСвойств(СтрокаКУдалению,ТекущиеДанные);
		НачисленияУдержанияВыбор.Удалить(НачисленияУдержанияВыбор.Индекс(ТекущиеДанные));
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПеренестиВлевоОдно(Команда)
	
	ТекущиеДанные = Элементы.НачисленияУдержанияКУдалению.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		СтрокаВыбор=  НачисленияУдержанияВыбор.Добавить();
	    ЗаполнитьЗначенияСвойств(СтрокаВыбор,ТекущиеДанные);
		НачисленияУдержанияКУдалению.Удалить(НачисленияУдержанияКУдалению.Индекс(ТекущиеДанные));
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПеренестиВправоВсе(Команда)
	
	Для каждого СтрокаВыбор Из НачисленияУдержанияВыбор Цикл
		СтрокаКУдалению =  НачисленияУдержанияКУдалению.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаКУдалению,СтрокаВыбор);
	КонецЦикла; 
	
	НачисленияУдержанияВыбор.Очистить();
	     	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПеренестиВлевоВсе(Команда)
	
	Для каждого СтрокаКУдалению Из НачисленияУдержанияКУдалению Цикл
		СтрокаВыбор = НачисленияУдержанияВыбор.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаВыбор,СтрокаКУдалению);
	КонецЦикла; 
	
	НачисленияУдержанияКУдалению.Очистить();

КонецПроцедуры

&НаКлиенте
Процедура ВыборНачисленийУдержанийПриИзменении(Элемент)
	
	ЗаполнитьДаннымиФормуНаСервере(мПараметрыРасчета);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьВыбранныеЗначения(Команда)
	
	Если НачисленияУдержанияКУдалению.Количество() > 0 Тогда
		
		ДопПараметры = Новый Структура;
		
		ТекстВопроса = НСтр("ru = 'Удалить выбранные значения?'");
		Оповещение = Новый ОписаниеОповещения("ВопросУдалитьВыбранныеЗначенияЗавершение", ЭтотОбъект, ДопПараметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	КонецЕсли; 

КонецПроцедуры

&НаКлиенте
Процедура ВопросУдалитьВыбранныеЗначенияЗавершение(Знач Результат, Знач ДопПараметры) Экспорт

	Если Результат = КодВозвратаДиалога.Да Тогда
		Закрыть(ПоместитьИзмененныеДанныеВоВременноеХранилище());	
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
Функция ПоместитьИзмененныеДанныеВоВременноеХранилище()
	
	ВозвращаемыеСведения = Неопределено;
	Если НачисленияУдержанияКУдалению.Количество() > 0 Тогда
		
		ВозвращаемыеСведения = Новый Структура;
		ВозвращаемыеСведения.Вставить("ВыборНачисленийУдержаний", ВыборНачисленийУдержаний);
		ВозвращаемыеСведения.Вставить("НачисленияУдержанияКУдалению", НачисленияУдержанияКУдалению.Выгрузить());
		
	КонецЕсли; 
	
	Возврат ПоместитьВоВременноеХранилище(ВозвращаемыеСведения, Новый УникальныйИдентификатор);
	
КонецФункции

#КонецОбласти
