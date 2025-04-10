
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования)                        
	
	ЭтотОбъект.Сотрудник = Справочники.инкСотрудники.ПустаяСсылка();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область о // Печать:

Функция СформироватьТабличныйДокументТ8() Экспорт
	
	Т1ТабличныйДокумент = Новый ТабличныйДокумент;
	Макет = ПолучитьОбщийМакет("ПФ_MXL_Т8"); 
	
	ОбластьОтчет = Макет.ПолучитьОбласть("Шапка");
	ОбластьОтчет.Параметры.СсылкаНаОбъектОрганизацияНаименованиеСокращенное	= Организация.Наименование;
	ОбластьОтчет.Параметры.СсылкаНаОбъектОрганизацияКодПоОКПО = Организация.ОКПО;
	ОбластьОтчет.Параметры.СсылкаНаОбъектНомерНаПечать = Номер;
	ОбластьОтчет.Параметры.СсылкаНаОбъектДата = Дата;
	Т1ТабличныйДокумент.Вывести(ОбластьОтчет); 
	
	ОбластьОтчет = Макет.ПолучитьОбласть("Работник");
	ОбластьОтчет.Параметры.РаботаТрудовойДоговорДатаОформленияНаПечать = Формат(Дата,"ДФ=dd.MM.yyyy");
	ОбластьОтчет.Параметры.РаботаТрудовойДоговорНомер = Номер;
	ОбластьОтчет.Параметры.РаботаДатаУвольненияНаПечать = Формат(ДатаПриказа,"ДФ=dd.MM.yyyy");
	ОбластьОтчет.Параметры.ЛичныеДанныеФИОФамилияИмяОтчествоВВинительномПадеже = Сотрудник.ФИО;
	ОбластьОтчет.Параметры.РаботаСотрудникТабельныйНомерНаПечать = Сотрудник.ТабельныйНомер;
	ОбластьОтчет.Параметры.РаботаПодразделениеНаПечать	= Подразделение;
	ОбластьОтчет.Параметры.РаботаДолжность =	Должность;								
	ОбластьОтчет.Параметры.РаботаРазрядКатегорияНаПечать = "";
	ОбластьОтчет.Параметры.РаботаСтатьяТКРФНаПечать = Основание;									
	ОбластьОтчет.Параметры.РаботаОснованиеУвольнения = "Заявление работника";							
	Т1ТабличныйДокумент.Вывести(ОбластьОтчет); 
	
	РуководительДанные = Справочники.инкОрганизации.КадровыеДанныеРуководителя(Организация);
	ОбластьОтчет = Макет.ПолучитьОбласть("Подвал");
	ОбластьОтчет.Параметры.СсылкаНаОбъектДолжностьРуководителя = РуководительДанные.Должность;
	ОбластьОтчет.Параметры.СсылкаНаОбъектРуководительРасшифровкаПодписи	= РуководительДанные.ФИОСокращенное;
	ОбластьОтчет.Параметры.СсылкаНаОбъектДатаОзнакомленияРаботника = инкОтчетыСервер.ПолучитьШаблонДляЗаполненияДатыОзнакомления();
	Т1ТабличныйДокумент.Вывести(ОбластьОтчет); 
	
	Возврат Т1ТабличныйДокумент;
	
КонецФункции     

#КонецОбласти

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
