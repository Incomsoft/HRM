
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем Сотрудники Экспорт;		// Массив - Массив из справочников "Сотрудники";
Перем ДокументОбъект Экспорт;   // Объект - Документ объект (источник данных);
Перем Дата1 Экспорт;			// Дата	- Дата1 (начало периода); 
Перем Дата2 Экспорт; 			// Дата - Дата2 (конец периода);

#КонецОбласти

#Область ПрограммныйИнтерфейс

#Область о // Инициализация:

// Процедура - Инициализация
//
Процедура Инициализация() Экспорт

	Сотрудники = Новый Массив;
	ДокументОбъект = Неопределено; 
	Дата1  = Неопределено;  
	Дата2  = Неопределено;  

КонецПроцедуры

// Функция - Получить результат расчета
// 
// Возвращаемое значение:
//  ТабличныйДокумент - Перечень РКО (подробный) для печати; 
//
Функция ПолучитьРезультатРасчета() Экспорт
	
	ВремяНачалоЗамера = ОценкаПроизводительности.НачатьЗамерВремени();
    
	ЗаполнитьСотрудники();

	ТабличныйДокумент = ПолучитьРезультатыРасчетаНаСервере();
	
	ОценкаПроизводительности.ЗакончитьЗамерВремени("Обработка.инкРасчетныеЛисты.ФормированиеОтчета",ВремяНачалоЗамера,Сотрудники.Количество());

	Возврат ТабличныйДокумент; 
	
КонецФункции  

// Функция - Получить расчетные листки
// 
// Возвращаемое значение:
//  ТабличныйДокумент - Перечень РКО для печати; 
//
Функция ПолучитьРасчетныеЛистки() Экспорт
	
	ВремяНачалоЗамера = ОценкаПроизводительности.НачатьЗамерВремени();
    
	ЗаполнитьСотрудники();
	
	ТабличныйДокумент = ПолучитьРасчетныеЛисткиНаСервере();

	ОценкаПроизводительности.ЗакончитьЗамерВремени("Обработка.инкРасчетныеЛисты.ФормированиеОтчета",ВремяНачалоЗамера,Сотрудники.Количество());
	
	Возврат ТабличныйДокумент; 
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьСотрудники()
	
	Если Не ЗначениеЗаполнено(Сотрудники) Тогда
		
		Сотрудники = Новый Массив;

		Если ДокументОбъект <> Неопределено Тогда
			Для каждого ВедомостьСтрока из ДокументОбъект.Ведомость Цикл 
				Сотрудники.Добавить(ВедомостьСтрока.Сотрудник);		
			КонецЦикла;
		Иначе
			
			ПараметрыЗапроса = инкКадровыйУчетСервер.ПолучитьСтруктуруПараметровДляЗапроса_Сотрудники();
	        ПараметрыЗапроса.Дата1 = Дата1;
	        ПараметрыЗапроса.Дата2 = Дата2;
			СотрудникиТаблица = инкКадровыйУчетСервер.ПолучитьТаблицуЗначенийДляЗаполнения_Сотрудники(ПараметрыЗапроса);
			
			Сотрудники = СотрудникиТаблица.ВыгрузитьКолонку("Сотрудник");
			
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

#Область о // Печать результатов расчета:

Функция ПолучитьРезультатыРасчетаНаСервере()
	
	ТабДок = Новый ТабличныйДокумент;
	Макет = ПолучитьМакет("ПФ_MXL_РасчетныйЛисток");
	
	РасчетныйЛист = Новый ТабличныйДокумент;
	
	Для каждого Сотрудник из Сотрудники Цикл 
		
		стрПоиск = Новый Структура("Сотрудник",Сотрудник);
		ВедомостьМассив = ДокументОбъект.Ведомость.НайтиСтроки(стрПоиск);
		
		ДанныеСотрудника = Неопределено;
		Если ВедомостьМассив.Количество() <> 0 Тогда
			ДанныеСотрудника = ВедомостьМассив[0]; 	
		КонецЕсли;
		
		чСуммыНеВходящиеВФОТ = ПолучитьСуммыНеВходящиеВФОТ(стрПоиск); 
		чВсегоНачислено = ДанныеСотрудника.ВсегоНачислено;
		чВсегоУдаржано  = ДанныеСотрудника.ВсегоУдержано;
		чКВыплате		= чВсегоНачислено 
		                - чВсегоУдаржано 
						+ ДанныеСотрудника.СальдоВходящее
						- чСуммыНеВходящиеВФОТ;
		НДФЛСотрудника 	= ПолучитьНДФЛСотрудника(ДокументОбъект,стрПоиск);
		
		облШапка1 = Макет.ПолучитьОбласть("Шапка1");
		облШапка1.Параметры.ПериодПредставление = Формат(ДокументОбъект.МесяцНачисления, "ДФ='ММММ гггг'"); 
		облШапка1.Параметры.СотрудникКод = Сотрудник.ТабельныйНомер;
		облШапка1.Параметры.ПодразделениеГоловногоСотрудникаНаКонецПериода = ДанныеСотрудника.Подразделение;
		облШапка1.Параметры.ДолжностьГоловногоСотрудникаНаКонецПериода = Строка(ДанныеСотрудника.Должность);			
		облШапка1.Параметры.ТарифнаяСтавкаНаКонецПериода = Формат(ДанныеСотрудника.СотрудникОклад,"ЧДЦ=2; ЧН=");								
		
		облШапка1.Параметры.СотрудникФизическоеЛицоФИО = Сотрудник;
		облШапка1.Параметры.Организация = ДокументОбъект.Организация;
		облШапка1.Параметры.КВыплате = чКВыплате;			
		
		Если НДФЛСотрудника <> Неопределено Тогда
			
			// Облагаемая база:
			облШапка1.Параметры.ОблагаемыйДоход		= НДФЛСотрудника.НалоговаяБазаЗаМесяц;
			
			// Вычеты:
			облШапка1.Параметры.ВычетНаФизлицо		= Формат(НДФЛСотрудника.СтандартныеВычетыНаРаботникаЗаМесяц,"ЧДЦ=0; ЧН=");
			облШапка1.Параметры.ВычетНаДетей        = Формат(НДФЛСотрудника.СтандартныеВычетыНаДетейЗаМесяц,"ЧДЦ=0; ЧН=");
			облШапка1.Параметры.ВычетИмущественный  = Формат(НДФЛСотрудника.ИмущественныйВычетЗаМесяц,"ЧДЦ=0; ЧН=");
			облШапка1.Параметры.ВычетСоциальный     = Формат(НДФЛСотрудника.СоциальныеВычетыЗаМесяц,"ЧДЦ=0; ЧН="); 
			
		КонецЕсли;	
		
		РасчетныйЛист.Вывести(облШапка1);
		
		облШапка2 = Макет.ПолучитьОбласть("Шапка2");
		РасчетныйЛист.Вывести(облШапка2);
		
		облНачисленоУдержано = Макет.ПолучитьОбласть("НачисленоУдержано");
		РасчетныйЛист.Вывести(облНачисленоУдержано);
		
		облСтрокаДвижений = Макет.ПолучитьОбласть("СтрокаДвижений"); 
		
		тзНачисленияСотрудника    = ПолучитьВсеНачисленияСотрудника(ДокументОбъект,стрПоиск);
		тзУдержанияСотрудника     = ПолучитьВсеУдержанияСотрудника(ДокументОбъект,стрПоиск);

		чВсегоНачислено			  = тзНачисленияСотрудника.Итог("СуммаНачислено")
								  - чСуммыНеВходящиеВФОТ;
		чВсегоУдаржано			  =	тзУдержанияСотрудника.Итог("СуммаУдержано");
        
        ВывестиСальдоВходящее(ДанныеСотрудника.СальдоВходящее,облСтрокаДвижений,РасчетныйЛист);
        
		чМаксСтрок = Макс(тзНачисленияСотрудника.Количество(),тзУдержанияСотрудника.Количество());
		
		Для Индекс = 0 По чМаксСтрок - 1 Цикл
			//				
			облСтрокаДвижений.Параметры.Начисление = "";	
			облСтрокаДвижений.Параметры.ПериодДействияНачислений = ""; 		
			облСтрокаДвижений.Параметры.ОтработаноДней = "";	
			облСтрокаДвижений.Параметры.ОтработаноЧасов = "";	
			облСтрокаДвижений.Параметры.СуммаНачислено = "";		
			облСтрокаДвижений.Параметры.Удержание = "";			
			облСтрокаДвижений.Параметры.ПериодДействияУдержаний = "";		
			облСтрокаДвижений.Параметры.СуммаУдержано = "";		
			//
			Если Индекс <= (тзНачисленияСотрудника.Количество()-1) Тогда
				
				ЗаполнитьЗначенияСвойств(облСтрокаДвижений.Параметры,тзНачисленияСотрудника[Индекс]);	
				облСтрокаДвижений.Параметры.СуммаНачислено = Формат(облСтрокаДвижений.Параметры.СуммаНачислено,"ЧДЦ=2; ЧН=");	
				Если НЕ тзНачисленияСотрудника[Индекс].Начисление.ВходитВФОТ Тогда
					облСтрокаДвижений.Параметры.Начисление = Строка(облСтрокаДвижений.Параметры.Начисление) + "*";	
				КонецЕсли;
				
			КонецЕсли;
			//
			Если Индекс <= (тзУдержанияСотрудника.Количество()-1) Тогда
				ЗаполнитьЗначенияСвойств(облСтрокаДвижений.Параметры,тзУдержанияСотрудника[Индекс]);
				Если облСтрокаДвижений.Параметры.Удержание = "НДФЛ" Тогда    
					Если НДФЛСотрудника <> Неопределено Тогда
						облСтрокаДвижений.Параметры.СуммаУдержано = Формат(НДФЛСотрудника.СуммаНалога,"ЧДЦ=0; ЧН=");	
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			//
			РасчетныйЛист.Вывести(облСтрокаДвижений);
        КонецЦикла;
        
        ВывестиСальдоИсходящее(ДанныеСотрудника.СальдоИсходящее,облСтрокаДвижений,РасчетныйЛист);
        
		облИтог12 = Макет.ПолучитьОбласть("Итог12"); 
		облИтог12.Параметры.СуммаНачисления	= чВсегоНачислено;
		облИтог12.Параметры.СуммаУдержания	= чВсегоУдаржано;
		РасчетныйЛист.Вывести(облИтог12);
        
        Если ДанныеСотрудника.СальдоВходящее<>0 ИЛИ ДанныеСотрудника.СальдоИсходящее<>0 Тогда
            облВидыВыплатНеВходящиеВСуммуНаРуки = Макет.ПолучитьОбласть("ВидыВыплатНеВходящиеВСуммуНаРуки"); 
            РасчетныйЛист.Вывести(облВидыВыплатНеВходящиеВСуммуНаРуки);
        КонецЕсли; 

		ЗаполнитьОбластьДанными(Макет.ПолучитьОбласть("РазделительСтроки"),НДФЛСотрудника,РасчетныйЛист);
        
		Если НДФЛСотрудника <> Неопределено Тогда
			
			Если НДФЛСотрудника.ОблагаемыйДоходСНачалаГода > 0 Тогда
				ЗаполнитьОбластьДанными(Макет.ПолучитьОбласть("СовокупныйОблагаемыйДоход"),НДФЛСотрудника,РасчетныйЛист);
				ЗаполнитьОбластьДанными(Макет.ПолучитьОбласть("РазделительСтроки"),НДФЛСотрудника,РасчетныйЛист);
			КонецЕсли;	
			
			Если НДФЛСотрудника.СоциальныеВычетыСНачалаГода > 0 Тогда
				ЗаполнитьОбластьДанными(Макет.ПолучитьОбласть("НалоговыеВычеты"),НДФЛСотрудника,РасчетныйЛист);
			КонецЕсли;
			
			Если НДФЛСотрудника.СтандартныеВычетыНаРаботникаСНачалаГода > 0 Тогда 
				ЗаполнитьОбластьДанными(Макет.ПолучитьОбласть("СтандартныеВычетыНаРаботника"),НДФЛСотрудника,РасчетныйЛист);
			КонецЕсли;
			
			Если НДФЛСотрудника.СтандартныеВычетыНаДетейСНачалаГода > 0 Тогда
				ЗаполнитьОбластьДанными(Макет.ПолучитьОбласть("СтандартныеВычетыНаДетей"),НДФЛСотрудника,РасчетныйЛист);
			КонецЕсли;
			
			Если НДФЛСотрудника.ИмущественныйВычетСНачалаГода > 0 Тогда
				ЗаполнитьОбластьДанными(Макет.ПолучитьОбласть("ИмущественныйВычет"),НДФЛСотрудника,РасчетныйЛист);
			КонецЕсли;
			
			ЗаполнитьОбластьДанными(Макет.ПолучитьОбласть("НалоговаяБазаЗаМесяц"),НДФЛСотрудника,РасчетныйЛист);
			ЗаполнитьОбластьДанными(Макет.ПолучитьОбласть("РазделительСтроки"),НДФЛСотрудника,РасчетныйЛист);
			ЗаполнитьОбластьДанными(Макет.ПолучитьОбласть("РасчетНалога"),НДФЛСотрудника,РасчетныйЛист);
			
		КонецЕсли;	

		ЛинияСрезаОбласть = Макет.ПолучитьОбласть("ЛинияСреза"); 
		РасчетныйЛист.Вывести(ЛинияСрезаОбласть);      

		Если Не ТабДок.ПроверитьВывод(РасчетныйЛист) Тогда    
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;    
		
		ТабДок.Вывести(РасчетныйЛист);
		РасчетныйЛист.Очистить();
		
	КонецЦикла;

	инкОтчетыСервер.УстановитьНастройкиМаштабаДокумента(ТабДок);
	
	Возврат ТабДок;
	
КонецФункции

Функция ПолучитьТаблицуНачисленийДляОтчета()
	
	тзНачисленияСотрудника = Новый ТаблицаЗначений;
	тзНачисленияСотрудника.Колонки.Добавить("Начисление");
	тзНачисленияСотрудника.Колонки.Добавить("ПериодДействияНачислений");
	тзНачисленияСотрудника.Колонки.Добавить("ОтработаноДней");
	тзНачисленияСотрудника.Колонки.Добавить("ОтработаноЧасов");
	тзНачисленияСотрудника.Колонки.Добавить("ОплаченныеДниЧасы");
	тзНачисленияСотрудника.Колонки.Добавить("СуммаНачислено");
	тзНачисленияСотрудника.Колонки.Добавить("ПорядокВОтчете");

	Возврат тзНачисленияСотрудника;
	
КонецФункции

Функция ПолучитьВсеНачисленияСотрудника(Объект = Неопределено,стрПоиск = Неопределено,ВедомостьСтрока = Неопределено,НачисленияМассив = Неопределено)
	
	тзНачисленияСотрудника = ПолучитьТаблицуНачисленийДляОтчета();
	
	// Основные начисления:
	Если ВедомостьСтрока = Неопределено Тогда
		ВедомостьМассив = Объект.Ведомость.НайтиСтроки(стрПоиск); 
		Если ВедомостьМассив.Количество() > 0 Тогда 
			ВедомостьСтрока = ВедомостьМассив[0];		
		КонецЕсли;
	КонецЕсли;
	
	Если ВедомостьСтрока <> Неопределено Тогда
		
		// Оклад:
		Если ВедомостьСтрока.Оклад <> 0 Тогда 
			стр = тзНачисленияСотрудника.Добавить();
			стр.Начисление			= ПланыВидовРасчета.инкНачисления.Оклад;
			
			стр.ОтработаноЧасов	= ВедомостьСтрока.ЧасыФакт;
			стр.ОтработаноДней	= ВедомостьСтрока.ДниФакт;	
			Если инкОбщийКлиентСервер.ЕстьСвойство(ВедомостьСтрока,"НормаДни") Тогда
				Если ЗначениеЗаполнено(ВедомостьСтрока.НормаДни) Тогда
					стр.ОтработаноДней	= ВедомостьСтрока.НормаДниФакт;
				КонецЕсли;
				Если ЗначениеЗаполнено(ВедомостьСтрока.НормаЧасы) Тогда
					стр.ОтработаноЧасов	= ВедомостьСтрока.НормаЧасыФакт;
				КонецЕсли;
			КонецЕсли;
			стр.СуммаНачислено		= ВедомостьСтрока.Оклад;
			стр.ПорядокВОтчете		= 1;  
			стр.ПериодДействияНачислений = инкУчетВремениСервер.ПолучитьПериодНачислений(ВедомостьСтрока);
			
		КонецЕсли;
		
		// РК:
		Если ВедомостьСтрока.РайонныйКоэффициент <> 0 Тогда 
			стр = тзНачисленияСотрудника.Добавить();
			стр.Начисление			= ПланыВидовРасчета.инкНачисления.РайонныйКоэффициент;
			стр.ОтработаноДней		= "";
			стр.ОтработаноЧасов		= "";
			стр.СуммаНачислено		= ВедомостьСтрока.РайонныйКоэффициент;
			стр.ПорядокВОтчете		= 2;
		КонецЕсли;
		
		// СН:
		Если ВедомостьСтрока.СевернаяНадбавка <> 0 Тогда 
			стр = тзНачисленияСотрудника.Добавить();
			стр.Начисление			= ПланыВидовРасчета.инкНачисления.СевернаяНадбавка;
			стр.ОтработаноДней		= "";
			стр.ОтработаноЧасов		= "";
			стр.СуммаНачислено		= ВедомостьСтрока.СевернаяНадбавка;
			стр.ПорядокВОтчете		= 3;
		КонецЕсли;
		
	КонецЕсли;
	
	// Прочие начисления:
	Если НачисленияМассив = Неопределено Тогда
		НачисленияМассив = Объект.ПрочиеНачисления.НайтиСтроки(стрПоиск); 
	КонецЕсли;
	
	Для каждого НачислениеСтрока из НачисленияМассив Цикл
		
		// +++ Чесноков М.С. 2023-04-17 *№ 0000108
		// Убираем оклад в доп. начислениях, который ранее был отражен в ведомости (только для "Расчетные листы"):
		Если Объект = Неопределено И ВедомостьСтрока <> Неопределено Тогда
			
			Если НачислениеСтрока.Начисление = ПланыВидовРасчета.инкНачисления.Оклад Тогда  
				
				// Мы нашли дубль строки:
				Если (НачислениеСтрока.СуммаНачисления - ВедомостьСтрока.Оклад) = 0 Тогда
					НачислениеСтрока.СуммаНачисления = 0;
					НачислениеСтрока.Дни = 0;
					НачислениеСтрока.Часы = 0;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		// --- Чесноков М.С. 2023-04-17 *№ 0000108
		
		Если НачислениеСтрока.СуммаНачисления <> 0 Тогда 
			стр = тзНачисленияСотрудника.Добавить();
			ЗаполнитьЗначенияСвойств(стр, НачислениеСтрока);
			стр.ПорядокВОтчете		= 100;
			стр.СуммаНачислено 	= НачислениеСтрока.СуммаНачисления;   
			
			стр.ОтработаноДней 	= НачислениеСтрока.ДниФакт;
			стр.ОтработаноЧасов = НачислениеСтрока.ЧасыФакт;    
			
			ДокументСсылка = Неопределено;
			Если инкОбщийКлиентСервер.ЕстьСвойство(НачислениеСтрока,"ДокументСсылка") Тогда
				ДокументСсылка = НачислениеСтрока.ДокументСсылка;
			ИначеЕсли инкОбщийКлиентСервер.ЕстьСвойство(НачислениеСтрока,"ДокументНачисления") Тогда
				ДокументСсылка = НачислениеСтрока.ДокументНачисления;
			КонецЕсли;
			Если ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.инкБольничныйЛистРасчет") Тогда
				стр.ПериодДействияНачислений = Формат(ДокументСсылка.БольничныйДатаНачала,"ДФ=dd.MM.yy") 
				                             + " - " 
											 + Формат(ДокументСсылка.БольничныйДатаОкончания,"ДФ=dd.MM.yy");	
			ИначеЕсли ЗначениеЗаполнено(НачислениеСтрока.ПериодДата1) И ЗначениеЗаполнено(НачислениеСтрока.ПериодДата2) Тогда
					
					стр.ПериодДействияНачислений = Формат(НачислениеСтрока.ПериодДата1,"ДФ=dd.MM.yy") 
					                             + " - " 
												 + Формат(НачислениеСтрока.ПериодДата2,"ДФ=dd.MM.yy");	
					
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	тзНачисленияСотрудника.Сортировать("ПорядокВОтчете");
	тзНачисленияСотрудника.Свернуть("Начисление,ОтработаноДней,ОтработаноЧасов,ОплаченныеДниЧасы,ПорядокВОтчете,ПериодДействияНачислений","СуммаНачислено");
	
	Возврат тзНачисленияСотрудника;
	
КонецФункции  

Функция ПолучитьВсеНачисленияНеФОТСотрудника(ВедомостьСотрудник,НачисленияНеФОТМассив)
	
	тзНачисленияСотрудника = ПолучитьТаблицуНачисленийДляОтчета();
	
	Для каждого НачислениеНеФОТ Из НачисленияНеФОТМассив Цикл
		
		СтрокаТаблицы = тзНачисленияСотрудника.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы,НачислениеНеФОТ);
		
		СтрокаТаблицы.СуммаНачислено = НачислениеНеФОТ.СуммаНачисления;
		СтрокаТаблицы.ПорядокВОтчете = 0;
		
	КонецЦикла;
	
	Возврат тзНачисленияСотрудника;
	
КонецФункции

Функция ПолучитьСуммыНеВходящиеВФОТ(стрПоиск)
	
	СуммаНеВходящаяВФОТ = 0;    
	НачисленияМассив = ДокументОбъект.ПрочиеНачисления.НайтиСтроки(стрПоиск); 
	
	Для каждого НачислениеСтрока Из НачисленияМассив Цикл
		
		Если НЕ НачислениеСтрока.Начисление.ВходитВФОТ Тогда
			СуммаНеВходящаяВФОТ = СуммаНеВходящаяВФОТ + НачислениеСтрока.СуммаНачисления;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СуммаНеВходящаяВФОТ;
	
КонецФункции
	
Функция ПолучитьВсеУдержанияСотрудника(Объект = Неопределено,стрПоиск = Неопределено, УдержанияМассив = Неопределено, НДФЛМассив = Неопределено)
	
	тзУдержанияСотрудника = Новый ТаблицаЗначений;
	тзУдержанияСотрудника.Колонки.Добавить("Удержание");
	тзУдержанияСотрудника.Колонки.Добавить("ПериодДействияУдержаний");
	тзУдержанияСотрудника.Колонки.Добавить("СуммаУдержано");
	
	Если УдержанияМассив = Неопределено Тогда
		УдержанияМассив	= Объект.ПрочиеУдержания.НайтиСтроки(стрПоиск);
	КонецЕсли;
	Для каждого стрУдержанияСотрудника из УдержанияМассив Цикл
		стр = тзУдержанияСотрудника.Добавить();
		ЗаполнитьЗначенияСвойств(стр, стрУдержанияСотрудника);
		стр.СуммаУдержано = стрУдержанияСотрудника.СуммаУдержания;  
	КонецЦикла;
	             
	Если НДФЛМассив = Неопределено Тогда
		НДФЛМассив	= Объект.НДФЛ.НайтиСтроки(стрПоиск);
	КонецЕсли;
	
	стр = тзУдержанияСотрудника.Добавить();
	стр.Удержание = "НДФЛ";
	стр.СуммаУдержано = 0;
	Для каждого стрНДФЛ из НДФЛМассив Цикл
		стр.СуммаУдержано = стр.СуммаУдержано + стрНДФЛ.СуммаНалога;  
	КонецЦикла;    
	
	тзУдержанияСотрудника.Свернуть("Удержание,ПериодДействияУдержаний","СуммаУдержано");
	
	Возврат тзУдержанияСотрудника;
	
КонецФункции

Функция ПолучитьНДФЛСотрудника(Объект,стрПоиск)
	
	НДФЛСотрудникаСтрока = Неопределено;
	НДФЛМассив = Объект.НДФЛ.НайтиСтроки(стрПоиск);
	
	Если НДФЛМассив.Количество() > 0 Тогда
		НДФЛСотрудникаСтрока = НДФЛМассив[0];
	КонецЕсли;
		
	Возврат НДФЛСотрудникаСтрока;
	
КонецФункции

Процедура ЗаполнитьОбластьДанными(ТекущаяОбласть,НДФЛСотрудника,ТабДок)
	
	Если НДФЛСотрудника = Неопределено Тогда
		Возврат;	
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ТекущаяОбласть.Параметры,НДФЛСотрудника);
	ТабДок.Вывести(ТекущаяОбласть);
	
КонецПроцедуры

#КонецОбласти

#Область о // Печать расчетных листков:

Функция ПолучитьРасчетныеЛисткиНаСервере()

	ТабДок = Новый ТабличныйДокумент;
	Макет = ПолучитьМакет("ПФ_MXL_РасчетныйЛисток");
	ВедомостиТаблица = ПолучитьВедомостиСотрудников(); 
	СотрудникиТаблица = ПолучитьСотрудникиТаблица(ВедомостиТаблица);
	НачисленияТаблица = ПолучитьДанныеПоНачислениямСотрудников(Истина);
	НачисленияНеФОТТаблица = ПолучитьДанныеПоНачислениямСотрудников(Ложь);
	УдержанияТаблица = ПолучитьДанныеПоУдержаниямСотрудников();
	НДФЛТаблица = ПолучитьНДФЛ();
	
	Месяц1 = Месяц(Дата1); 
	Месяц2 = Месяц(Дата2);
	
	Для каждого СотрудникСтрока из СотрудникиТаблица Цикл 

		Для МесяцТекущий = Месяц1 По Месяц2 Цикл
			
			ПоискСотрудник = Новый Структура;
			ПоискСотрудник.Вставить("Сотрудник",СотрудникСтрока.Сотрудник);
			ПоискСотрудник.Вставить("МесяцНомер",МесяцТекущий);

			ВедомостиМассив = ВедомостиТаблица.НайтиСтроки(ПоискСотрудник);
			НачисленияМассив = НачисленияТаблица.НайтиСтроки(ПоискСотрудник);
			НачисленияНеФОТМассив = НачисленияНеФОТТаблица.НайтиСтроки(ПоискСотрудник);
			УдержанияМассив = УдержанияТаблица.НайтиСтроки(ПоискСотрудник);
			НДФЛМассив = НДФЛТаблица.НайтиСтроки(ПоискСотрудник);
			
			РасчетныйЛист = Новый ТабличныйДокумент;
			
            Для каждого ВедомостьСотрудник Из ВедомостиМассив Цикл
				
				тзНачисленияСотрудника    = ПолучитьВсеНачисленияСотрудника(,,ВедомостьСотрудник,НачисленияМассив);
				тзУдержанияСотрудника     = ПолучитьВсеУдержанияСотрудника(,,УдержанияМассив,НДФЛМассив);
				тзНачисленияНеФОТСотрудника = ПолучитьВсеНачисленияНеФОТСотрудника(ВедомостьСотрудник,НачисленияНеФОТМассив);
				
				чСуммыНеВходящиеВФОТ = тзНачисленияНеФОТСотрудника.Итог("СуммаНачислено");
				чВсегоНачислено = ВедомостьСотрудник.ВсегоНачислено;
				чВсегоУдаржано  = ВедомостьСотрудник.ВсегоУдержано;
				чКВыплате		= ВедомостьСотрудник.КВыплате
				                - чСуммыНеВходящиеВФОТ;
				
				облШапка1 = Макет.ПолучитьОбласть("Шапка1");
				облШапка1.Параметры.ПериодПредставление = Формат(ВедомостьСотрудник.МесяцНачисления, "ДФ='ММММ гггг'"); 
				облШапка1.Параметры.СотрудникКод = ВедомостьСотрудник.ТабельныйНомер;
				облШапка1.Параметры.ПодразделениеГоловногоСотрудникаНаКонецПериода = ВедомостьСотрудник.Подразделение;
				облШапка1.Параметры.ДолжностьГоловногоСотрудникаНаКонецПериода = Строка(ВедомостьСотрудник.Должность);			
				облШапка1.Параметры.ТарифнаяСтавкаНаКонецПериода = Формат(ВедомостьСотрудник.СотрудникОклад,"ЧДЦ=2; ЧН=");								
				
				облШапка1.Параметры.СотрудникФизическоеЛицоФИО = ВедомостьСотрудник.Сотрудник;
				облШапка1.Параметры.Организация = ВедомостьСотрудник.Организация;
				облШапка1.Параметры.КВыплате = чКВыплате;			
				
				// Облагаемый доход:
				// Налоговая база:
				облШапка1.Параметры.ОблагаемыйДоход		= ВедомостьСотрудник.НалоговаяБаза;
				
				// Вычеты:
				облШапка1.Параметры.ВычетНаФизлицо		= Формат(ВедомостьСотрудник.ВычетСтандартный,"ЧДЦ=0; ЧН=");
				облШапка1.Параметры.ВычетНаДетей        = Формат(ВедомостьСотрудник.ВычетНаДетей,"ЧДЦ=0; ЧН=");
				облШапка1.Параметры.ВычетИмущественный  = Формат(ВедомостьСотрудник.ВычетИмущественный,"ЧДЦ=0; ЧН=");
				облШапка1.Параметры.ВычетСоциальный     = Формат(ВедомостьСотрудник.ВычетСоциальный,"ЧДЦ=0; ЧН="); 
				
				РасчетныйЛист.Вывести(облШапка1);
				//
				
				облШапка2 = Макет.ПолучитьОбласть("Шапка2");
				РасчетныйЛист.Вывести(облШапка2);
				
				облНачисленоУдержано = Макет.ПолучитьОбласть("НачисленоУдержано");
				РасчетныйЛист.Вывести(облНачисленоУдержано);
				
				облСтрокаДвижений = Макет.ПолучитьОбласть("СтрокаДвижений"); 
				
				
				чВсегоНачислено			  = тзНачисленияСотрудника.Итог("СуммаНачислено");
				чВсегоУдаржано			  =	тзУдержанияСотрудника.Итог("СуммаУдержано");
	            
	            ВывестиСальдоВходящее(ВедомостьСотрудник.СальдоВходящее,облСтрокаДвижений,РасчетныйЛист);
				
				ОбщееКоличествоНачислений = тзНачисленияСотрудника.Количество() 
				                          + тзНачисленияНеФОТСотрудника.Количество();
				чМаксСтрок = Макс(ОбщееКоличествоНачислений,тзУдержанияСотрудника.Количество());
				ИндексНеФОТ = 0;
				Для Индекс = 0 По чМаксСтрок - 1 Цикл
					//				
	                ОчиститьПараметрыСтрокиДвижений(облСтрокаДвижений);
					//
					Если Индекс <= (тзНачисленияСотрудника.Количество()-1) Тогда
						
						ЗаполнитьЗначенияСвойств(облСтрокаДвижений.Параметры,тзНачисленияСотрудника[Индекс]); 
						
					Иначе
						
						Если ИндексНеФОТ <= (тзНачисленияНеФОТСотрудника.Количество()-1) Тогда
							ЗаполнитьЗначенияСвойств(облСтрокаДвижений.Параметры,тзНачисленияНеФОТСотрудника[ИндексНеФОТ]);	
							облСтрокаДвижений.Параметры.Начисление = Строка(облСтрокаДвижений.Параметры.Начисление) + "*";	
						КонецЕсли;
							
						ИндексНеФОТ = ИндексНеФОТ + 1;
						
					КонецЕсли;
					//
					Если Индекс <= (тзУдержанияСотрудника.Количество()-1) Тогда
						ЗаполнитьЗначенияСвойств(облСтрокаДвижений.Параметры,тзУдержанияСотрудника[Индекс]);
						Если облСтрокаДвижений.Параметры.Удержание = "НДФЛ" Тогда
							облСтрокаДвижений.Параметры.СуммаУдержано = Формат(тзУдержанияСотрудника[Индекс].СуммаУдержано,"ЧДЦ=0; ЧН="); 	
						КонецЕсли;
					КонецЕсли;
					//
					РасчетныйЛист.Вывести(облСтрокаДвижений);
	            КонецЦикла;
	                       
	            ВывестиСальдоИсходящее(ВедомостьСотрудник.СальдоИсходящее,облСтрокаДвижений,РасчетныйЛист);
	            
				облИтог12 = Макет.ПолучитьОбласть("Итог12"); 
				облИтог12.Параметры.СуммаНачисления	= чВсегоНачислено;
				облИтог12.Параметры.СуммаУдержания	= чВсегоУдаржано;
				РасчетныйЛист.Вывести(облИтог12);      
				
				ЛинияСрезаОбласть = Макет.ПолучитьОбласть("ЛинияСреза"); 
				РасчетныйЛист.Вывести(ЛинияСрезаОбласть);      
				
				Если Не ТабДок.ПроверитьВывод(РасчетныйЛист) Тогда    
					ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
				КонецЕсли;    
				
				ТабДок.Вывести(РасчетныйЛист);
				РасчетныйЛист.Очистить();
				
			КонецЦикла;

		КонецЦикла;

		// ТабДок.ВывестиГоризонтальныйРазделительСтраниц();

	КонецЦикла;

	инкОтчетыСервер.УстановитьНастройкиМаштабаДокумента(ТабДок);
	
	Возврат ТабДок;

КонецФункции   

Функция ПолучитьСотрудникиТаблица(ВедомостиТаблица)

	СотрудникиТаблица = ВедомостиТаблица.Скопировать();
	СотрудникиТаблица.Свернуть("Сотрудник");
	СотрудникиТаблица.Сортировать("Сотрудник");
	
	Возврат СотрудникиТаблица;
	
КонецФункции

Функция ПолучитьВедомостиСотрудников()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	инкВедомостиОбороты.Период КАК МесяцНачисления,
		|	МЕСЯЦ(инкВедомостиОбороты.Период) КАК МесяцНомер,
		|	инкВедомостиОбороты.Сотрудник КАК Сотрудник,
		|	инкВедомостиОбороты.Сотрудник.ТабельныйНомер КАК ТабельныйНомер,
		|	инкВедомостиОбороты.Подразделение КАК Подразделение,
		|	инкВедомостиОбороты.Организация КАК Организация,
		|	инкВедомостиОбороты.ОблагаемыйДоходОборот КАК ОблагаемыйДоход,
		|	инкВедомостиОбороты.ОкладОборот КАК Оклад,
		|	инкВедомостиОбороты.ВычетСтандартныйОборот КАК ВычетСтандартный,
		|	инкВедомостиОбороты.ВычетНаДетейОборот КАК ВычетНаДетей,
		|	инкВедомостиОбороты.ВычетИмущественныйОборот КАК ВычетИмущественный,
		|	инкВедомостиОбороты.ВычетСоциальныйОборот КАК ВычетСоциальный,
		|	инкВедомостиОбороты.ВсегоНачисленоОборот КАК ВсегоНачислено,
		|	инкВедомостиОбороты.ВсегоУдержаноОборот КАК ВсегоУдержано,
		|	инкВедомостиОбороты.ВсегоНачисленоОборот - инкВедомостиОбороты.ВсегоУдержаноОборот + инкВедомостиОбороты.СальдоВходящееОборот КАК КВыплате,
		|	ВЫБОР
		|		КОГДА инкВедомостиОбороты.НормаДниФактОборот = 0
		|			ТОГДА инкВедомостиОбороты.ДниФактОборот
		|		ИНАЧЕ инкВедомостиОбороты.НормаДниФактОборот
		|	КОНЕЦ КАК ДниФакт,
		|	ВЫБОР
		|		КОГДА инкВедомостиОбороты.НормаЧасыФактОборот = 0
		|			ТОГДА инкВедомостиОбороты.ЧасыФактОборот
		|		ИНАЧЕ инкВедомостиОбороты.НормаЧасыФактОборот
		|	КОНЕЦ КАК ЧасыФакт,
		|	инкВедомостиОбороты.РайонныйКоэффициентОборот КАК РайонныйКоэффициент,
		|	инкВедомостиОбороты.СевернаяНадбавкаОборот КАК СевернаяНадбавка,
		|	инкВедомостиОбороты.НалоговаяБазаОборот КАК НалоговаяБаза,
		|	инкВедомостиОбороты.СальдоВходящееОборот КАК СальдоВходящее,
		|	инкВедомостиОбороты.СальдоИсходящееОборот КАК СальдоИсходящее
		|ПОМЕСТИТЬ втВедомости
		|ИЗ
		|	РегистрНакопления.инкВедомости.Обороты(&Дата1, &Дата2, Месяц, Сотрудник В (&Сотрудники)) КАК инкВедомостиОбороты
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	инкКадроваяИсторияСотрудниковСрезПоследних.Сотрудник КАК Сотрудник,
		|	инкКадроваяИсторияСотрудниковСрезПоследних.Оклад КАК Оклад,
		|	инкКадроваяИсторияСотрудниковСрезПоследних.Должность КАК Должность,
		|	инкКадроваяИсторияСотрудниковСрезПоследних.ДатаПриемаНаРаботу КАК ДатаПриемаНаРаботу,
		|	инкКадроваяИсторияСотрудниковСрезПоследних.ДатаУвольнения КАК ДатаУвольнения
		|ПОМЕСТИТЬ втКадровыеДанные
		|ИЗ
		|	РегистрСведений.инкКадроваяИсторияСотрудников.СрезПоследних(
		|			,
		|			Сотрудник В
		|				(ВЫБРАТЬ
		|					втВедомости.Сотрудник КАК Сотрудник
		|				ИЗ
		|					втВедомости КАК втВедомости)) КАК инкКадроваяИсторияСотрудниковСрезПоследних
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втВедомости.МесяцНачисления КАК МесяцНачисления,
		|	втВедомости.МесяцНомер КАК МесяцНомер,
		|	втВедомости.Сотрудник КАК Сотрудник,
		|	втВедомости.ТабельныйНомер КАК ТабельныйНомер,
		|	втВедомости.Подразделение КАК Подразделение,
		|	втВедомости.Организация КАК Организация,
		|	втВедомости.ОблагаемыйДоход КАК ОблагаемыйДоход,
		|	втВедомости.Оклад КАК Оклад,
		|	втВедомости.ВычетСтандартный КАК ВычетСтандартный,
		|	втВедомости.ВычетНаДетей КАК ВычетНаДетей,
		|	втВедомости.ВычетИмущественный КАК ВычетИмущественный,
		|	втВедомости.ВычетСоциальный КАК ВычетСоциальный,
		|	втВедомости.ВсегоНачислено КАК ВсегоНачислено,
		|	втВедомости.ВсегоУдержано КАК ВсегоУдержано,
		|	втВедомости.КВыплате КАК КВыплате,
		|	втВедомости.ДниФакт КАК ДниФакт,
		|	втВедомости.ЧасыФакт КАК ЧасыФакт,
		|	втВедомости.РайонныйКоэффициент КАК РайонныйКоэффициент,
		|	втВедомости.СевернаяНадбавка КАК СевернаяНадбавка,
		|	втВедомости.НалоговаяБаза КАК НалоговаяБаза,
		|	втВедомости.СальдоВходящее КАК СальдоВходящее,
		|	втВедомости.СальдоИсходящее КАК СальдоИсходящее,
		|	втКадровыеДанные.Оклад КАК СотрудникОклад,
		|	втКадровыеДанные.Должность КАК Должность,
		|	втКадровыеДанные.ДатаПриемаНаРаботу КАК ДатаПриемаНаРаботу,
		|	втКадровыеДанные.ДатаУвольнения КАК ДатаУвольнения
		|ИЗ
		|	втВедомости КАК втВедомости
		|		ЛЕВОЕ СОЕДИНЕНИЕ втКадровыеДанные КАК втКадровыеДанные
		|		ПО втВедомости.Сотрудник = втКадровыеДанные.Сотрудник";
	
	Запрос.УстановитьПараметр("Дата1", Дата1);
	Запрос.УстановитьПараметр("Дата2", Дата2);
	Запрос.УстановитьПараметр("Сотрудники", Сотрудники);
	
	РезультатЗапросаТаблица = Запрос.Выполнить().Выгрузить();
	РезультатЗапросаТаблица.Индексы.Добавить("Сотрудник");
	
	Возврат РезультатЗапросаТаблица; 
	
КонецФункции

Функция ПолучитьДанныеПоНачислениямСотрудников(ВходитВФОТ)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	инкНачисленияОбороты.Период КАК МесяцНачисления,
		|	МЕСЯЦ(инкНачисленияОбороты.Период) КАК МесяцНомер,
		|	инкНачисленияОбороты.Сотрудник КАК Сотрудник,
		|	инкНачисленияОбороты.Начисление КАК Начисление,
		|	инкНачисленияОбороты.ДокументНачисления КАК ДокументНачисления,
		|	инкНачисленияОбороты.ПериодДата1 КАК ПериодДата1,
		|	инкНачисленияОбороты.ПериодДата2 КАК ПериодДата2,
		|	инкНачисленияОбороты.СуммаНачисленияОборот КАК СуммаНачисления,
		|	инкНачисленияОбороты.ДниОборот КАК Дни,
		|	инкНачисленияОбороты.ЧасыОборот КАК Часы,
		|	инкНачисленияОбороты.ДниФактОборот КАК ДниФакт,
		|	инкНачисленияОбороты.ЧасыФактОборот КАК ЧасыФакт
		|ИЗ
		|	РегистрНакопления.инкНачисления.Обороты(
		|			&Дата1,
		|			&Дата2,
		|			Месяц,
		|			Сотрудник В (&Сотрудники)
		|				И ВходитВФОТ = &ВходитВФОТ) КАК инкНачисленияОбороты";
	
	Запрос.УстановитьПараметр("Дата1", Дата1);
	Запрос.УстановитьПараметр("Дата2", Дата2);
	Запрос.УстановитьПараметр("Сотрудники", Сотрудники);
	Запрос.УстановитьПараметр("ВходитВФОТ", ВходитВФОТ);
	
	РезультатЗапросаТаблица = Запрос.Выполнить().Выгрузить();
	РезультатЗапросаТаблица.Индексы.Добавить("Сотрудник");
	
	Возврат РезультатЗапросаТаблица; 
	
КонецФункции

Функция ПолучитьДанныеПоУдержаниямСотрудников()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	инкУдержанияОбороты.Период КАК МесяцНачисления,
		|	МЕСЯЦ(инкУдержанияОбороты.Период) КАК МесяцНомер,
		|	инкУдержанияОбороты.Сотрудник КАК Сотрудник,
		|	инкУдержанияОбороты.Удержание КАК Удержание,
		|	СУММА(инкУдержанияОбороты.СуммаУдержанияОборот) КАК СуммаУдержания
		|ИЗ
		|	РегистрНакопления.инкУдержания.Обороты(&Дата1, &Дата2, Месяц, Сотрудник В (&Сотрудники)) КАК инкУдержанияОбороты
		|
		|СГРУППИРОВАТЬ ПО
		|	инкУдержанияОбороты.Период,
		|	МЕСЯЦ(инкУдержанияОбороты.Период),
		|	инкУдержанияОбороты.Сотрудник,
		|	инкУдержанияОбороты.Удержание";
	
	Запрос.УстановитьПараметр("Дата1", Дата1);
	Запрос.УстановитьПараметр("Дата2", Дата2);
	Запрос.УстановитьПараметр("Сотрудники", Сотрудники);
	
	РезультатЗапросаТаблица = Запрос.Выполнить().Выгрузить();
	РезультатЗапросаТаблица.Индексы.Добавить("Сотрудник");
	
	Возврат РезультатЗапросаТаблица; 
	
КонецФункции

Функция ПолучитьНДФЛ()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	инкНалогУдержанныйОбороты.Период КАК МесяцНачисления,
		|	МЕСЯЦ(инкНалогУдержанныйОбороты.Период) КАК МесяцНомер,
		|	инкНалогУдержанныйОбороты.Сотрудник КАК Сотрудник,
		|	инкНалогУдержанныйОбороты.СуммаНалогаОборот КАК СуммаНалога
		|ИЗ
		|	РегистрНакопления.инкНалогУдержанный.Обороты(&Дата1, &Дата2, Месяц, Сотрудник В (&Сотрудники)) КАК инкНалогУдержанныйОбороты";
	
	Запрос.УстановитьПараметр("Дата1", Дата1);
	Запрос.УстановитьПараметр("Дата2", Дата2);
	Запрос.УстановитьПараметр("Сотрудники", Сотрудники);
	
	РезультатЗапросаТаблица = Запрос.Выполнить().Выгрузить();
	РезультатЗапросаТаблица.Индексы.Добавить("Сотрудник");
	
	Возврат РезультатЗапросаТаблица; 
	
КонецФункции

Процедура ВывестиСальдоВходящее(СальдоВходящее,облСтрокаДвижений,РасчетныйЛист)
    
    Если СальдоВходящее <> 0 Тогда
        ОчиститьПараметрыСтрокиДвижений(облСтрокаДвижений);
        облСтрокаДвижений.Параметры.Начисление = "*Сальдо входящее:";
        облСтрокаДвижений.Параметры.СуммаНачислено = СальдоВходящее;   
		РасчетныйЛист.Вывести(облСтрокаДвижений);
    КонецЕсли; 
		
КонецПроцедуры     

Процедура ВывестиСальдоИсходящее(СальдоИсходящее,облСтрокаДвижений,РасчетныйЛист)
    
    Если СальдоИсходящее <> 0 Тогда
        ОчиститьПараметрыСтрокиДвижений(облСтрокаДвижений);
        облСтрокаДвижений.Параметры.Удержание = "*Сальдо исходящее:";
        облСтрокаДвижений.Параметры.СуммаУдержано = СальдоИсходящее;   
        РасчетныйЛист.Вывести(облСтрокаДвижений);
    КонецЕсли; 
		
КонецПроцедуры     

Процедура ОчиститьПараметрыСтрокиДвижений(облСтрокаДвижений)
	
    облСтрокаДвижений.Параметры.Начисление = "";	
    облСтрокаДвижений.Параметры.ПериодДействияНачислений = ""; 		
    облСтрокаДвижений.Параметры.ОтработаноДней = "";	
    облСтрокаДвижений.Параметры.ОтработаноЧасов = "";	
    облСтрокаДвижений.Параметры.СуммаНачислено = "";		
    облСтрокаДвижений.Параметры.Удержание = "";			
    облСтрокаДвижений.Параметры.ПериодДействияУдержаний = "";		
    облСтрокаДвижений.Параметры.СуммаУдержано = "";		
		
КонецПроцедуры

#КонецОбласти 

#КонецОбласти

#КонецЕсли  
