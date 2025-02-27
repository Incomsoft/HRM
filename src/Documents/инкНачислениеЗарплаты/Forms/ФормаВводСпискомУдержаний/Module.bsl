
#Область ОписаниеПеременных

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ПустаяСтрока(Параметры.АдресПараметровВХранилище) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;

	ПараметрыРасчета = ПолучитьИзВременногоХранилища(Параметры.АдресПараметровВХранилище);
	
	мПрочиеУдержанияТаблица.Очистить();
	Для каждого СотрудникЭлемент из ПараметрыРасчета.Сотрудники Цикл
		УдержаниеСтрока = мПрочиеУдержанияТаблица.Добавить();
		УдержаниеСтрока.Сотрудник = СотрудникЭлемент;
	КонецЦикла;
	
	Элементы.мПрочиеУдержанияТаблица.Доступность = Ложь;
	РассчитатьИтогиТаблицы();
	
КонецПроцедуры

&НаКлиенте
Процедура ВвестиСписком(Команда)
	
	СуммаУдержанияСумма = Элементы.мПрочиеУдержанияТаблица.ТекущиеДанные.СуммаУдержания;
	
	Если ЗначениеЗаполнено(СуммаУдержанияСумма) Тогда
		
		ДопПараметры = Новый Структура("СуммаУдержания",СуммаУдержанияСумма);
		
		ТекстВопроса = НСтр("ru = 'Ввести списком "+СуммаУдержанияСумма+"?'");
		Оповещение = Новый ОписаниеОповещения("ВопросЗаполнитьСпискомТЧВедомостьЗавершение", ЭтотОбъект, ДопПараметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросЗаполнитьСпискомТЧВедомостьЗавершение(Знач Результат, Знач ДопПараметры) Экспорт

	Если Результат = КодВозвратаДиалога.Да Тогда
	
		КолВо = мПрочиеУдержанияТаблица.Количество()-1;
		СчЦикла = 0;
		Для СчЦикла = 0 По КолВо Цикл
			Элементы.мПрочиеУдержанияТаблица.ДанныеСтроки(СчЦикла)["СуммаУдержания"] = ДопПараметры.СуммаУдержания;
		КонецЦикла;
						
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Удержать(Команда)
	
	ДопПараметры = Новый Структура;
	
	ТекстВопроса = НСтр("ru = 'Выполнить удержание?'");
	Оповещение = Новый ОписаниеОповещения("УдержатьЗавершение", ЭтотОбъект, ДопПараметры);
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры                                                 

&НаКлиенте
Процедура УдержатьЗавершение(Знач Результат, Знач ДопПараметры) Экспорт

	Если Результат = КодВозвратаДиалога.Да Тогда
		
		ДобавитьВПостоянныеУдержанияНаСервере();
		Закрыть(ПоместитьИзмененныеДанныеВоВременноеХранилище());
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдержаниеПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(мУдержание) Тогда
		
		Элементы.мПрочиеУдержанияТаблица.Доступность = Истина;
		Для каждого УдержаниеСтрока Из мПрочиеУдержанияТаблица Цикл
			УдержаниеСтрока.Удержание = мУдержание;
		КонецЦикла; 
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура мПрочиеУдержанияТаблицаПриИзменении(Элемент)
	
	РассчитатьИтогиТаблицы();
	
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
Процедура РассчитатьИтогиТаблицы()

	мИтогСуммаУдержания = мПрочиеУдержанияТаблица.Итог("СуммаУдержания");
	
КонецПроцедуры

#Область о // Постоянные удержания:

&НаСервере
Процедура ДобавитьВПостоянныеУдержанияНаСервере()

	Если мДобавитьУдержанияВПостоянные Тогда

		Для каждого ПрочееУдержание Из мПрочиеУдержанияТаблица Цикл

			Если ПрочееУдержание.СуммаУдержания = 0 Тогда
				Продолжить;
			КонецЕсли;

			НаборЗаписейПостоянныеУдержания = РегистрыСведений.инкПостоянныеУдержания.СоздатьНаборЗаписей();
			НаборЗаписейПостоянныеУдержания.Отбор.Сотрудник.Установить(ПрочееУдержание.Сотрудник);
			НаборЗаписейПостоянныеУдержания.Отбор.Удержание.Установить(мУдержание);
			
			ЗаписьНабора = НаборЗаписейПостоянныеУдержания.Добавить();
			ЗаписьНабора.Сотрудник	= ПрочееУдержание.Сотрудник;
			ЗаписьНабора.Удержание = мУдержание;
			ЗаписьНабора.Размер = ПрочееУдержание.СуммаУдержания;
			
			НаборЗаписейПостоянныеУдержания.Записать(Истина);
			
		КонецЦикла;
		
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область о // Перенос в форму:

&НаСервере
Функция ПоместитьИзмененныеДанныеВоВременноеХранилище()
	         	
	ВозвращаемыеСведения = Новый Структура;
	ВозвращаемыеСведения.Вставить("мПрочиеУдержанияТаблица", Неопределено);
	
	Если ЗначениеЗаполнено(мУдержание) Тогда
		ВозвращаемыеСведения.мПрочиеУдержанияТаблица = мПрочиеУдержанияТаблица.Выгрузить();
	КонецЕсли; 
	
	Возврат ПоместитьВоВременноеХранилище(ВозвращаемыеСведения, Новый УникальныйИдентификатор);
	
КонецФункции

#КонецОбласти

#КонецОбласти

