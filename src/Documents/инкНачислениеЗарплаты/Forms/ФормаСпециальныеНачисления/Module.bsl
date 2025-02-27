
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
	ОбъектРасчетаЗарплаты = ПараметрыРасчета.ОбъектРасчетаЗарплаты;
	
	ПараметрыРасчета = Новый Структура;
	ПараметрыРасчета.Вставить("ОбъектРасчетаЗарплаты",ОбъектРасчетаЗарплаты);
	
	мВДняхЧасах = "ВРабочихДнях";
	УстановитьВидимостьКолонокВСпециальныхНачислениях();

	ПервоначальноеЗаполнениеТаблицФормы(ПараметрыРасчета);	
	        	
КонецПроцедуры

&НаСервере
Функция ПолучитьВидРасчетаВедомостиВДнях()
	
	Возврат (мВДняхЧасах = "ВРабочихДнях");
	
КонецФункции          

&НаСервере
Процедура УстановитьВидимостьКолонокВСпециальныхНачислениях()
	
	ВедомостьВДнях = ПолучитьВидРасчетаВедомостиВДнях();
	
	Элементы.мСпециальныеНачисленияТаблицаДни.Видимость 		= ВедомостьВДнях;
	Элементы.мСпециальныеНачисленияТаблицаДниФакт.Видимость		= ВедомостьВДнях;
	Элементы.мСпециальныеНачисленияТаблицаЧасы.Видимость 		= НЕ ВедомостьВДнях;
	Элементы.мСпециальныеНачисленияТаблицаЧасыФакт.Видимость 	= НЕ ВедомостьВДнях;
	
КонецПроцедуры

&НаСервере
Процедура ПервоначальноеЗаполнениеТаблицФормы(ПараметрыРасчета)
	
	мСпециальныеНачисленияТаблица.Очистить();
	мСдельнаяОплатаТаблица.Очистить();
	
	ИсходныеДанные = Новый Структура;
	ИсходныеДанные.Вставить("Дата1",ПараметрыРасчета.ОбъектРасчетаЗарплаты.МесяцНачисления);
	ИсходныеДанные.Вставить("Дата2",ПараметрыРасчета.ОбъектРасчетаЗарплаты.МесяцНачисления);
	НормаВремениТаблица = инкУчетВремениСервер.ПолучитьНормаВремениТаблица(ИсходныеДанные);
	
	Для каждого ВедомостьСтрока Из ПараметрыРасчета.ОбъектРасчетаЗарплаты.Ведомость Цикл
		
		СпециальныеНачисленияСтрока = мСпециальныеНачисленияТаблица.Добавить();
		ЗаполнитьЗначенияСвойств(СпециальныеНачисленияСтрока,ВедомостьСтрока);
		СпециальныеНачисленияСтрока.ФИО = ВедомостьСтрока.Сотрудник;
		СпециальныеНачисленияСтрока.РасчетнаяБаза = ВедомостьСтрока.СотрудникОклад;
		СпециальныеНачисленияСтрока.Процент = 0;
		СпециальныеНачисленияСтрока.ДниФакт = 0;
		СпециальныеНачисленияСтрока.ЧасыФакт = 0;
		
		СпециальныеНачисленияСтрока.Дни		= 0;		
		СпециальныеНачисленияСтрока.Часы    = 0;
		ПоискМесяц = Новый Структура("Месяц",ПараметрыРасчета.ОбъектРасчетаЗарплаты.МесяцНачисления);
		НормаВремениМассив = НормаВремениТаблица.НайтиСтроки(ПоискМесяц);
		Для каждого НормаВремениЭлемент Из НормаВремениМассив Цикл
			СпециальныеНачисленияСтрока.Дни		= НормаВремениЭлемент.РабочихДнейВМесяце;		
			СпециальныеНачисленияСтрока.Часы    = НормаВремениЭлемент.РабочихДнейВМесяце*8;
		КонецЦикла;
		
		СдельнаяОплатаСтрока = мСдельнаяОплатаТаблица.Добавить();
		СдельнаяОплатаСтрока.ФИО = ВедомостьСтрока.Сотрудник;
		
	КонецЦикла; 
	
	РассчитатьСуммыВСпециальныеНачисленияТаблица();
	
КонецПроцедуры

&НаСервере
Процедура РассчитатьСуммыВмСдельнаяОплатаТаблица()
	
	Для каждого ТаблицаСтрока Из мСдельнаяОплатаТаблица Цикл
		ТаблицаСтрока.Сумма = ТаблицаСтрока.Цена * ТаблицаСтрока.Количество;
	КонецЦикла; 
	
КонецПроцедуры                                         

&НаСервере
Процедура РассчитатьСуммыВСпециальныеНачисленияТаблица()
	
	ВедомостьВДнях = ПолучитьВидРасчетаВедомостиВДнях();

	Для каждого ТаблицаСтрока Из мСпециальныеНачисленияТаблица Цикл
		
		Если ВедомостьВДнях Тогда
			
			Если ТаблицаСтрока.Дни = 0  Тогда
				ТаблицаСтрока.Сумма = 0;
			Иначе
				ТаблицаСтрока.Сумма = ТаблицаСтрока.РасчетнаяБаза
				                    * ТаблицаСтрока.ДниФакт / ТаблицаСтрока.Дни 
									* ТаблицаСтрока.Процент / 100;
			КонецЕсли; 
			
		Иначе
			
			Если ТаблицаСтрока.Часы = 0  Тогда
				ТаблицаСтрока.Сумма = 0;
			Иначе
				ТаблицаСтрока.Сумма = ТаблицаСтрока.РасчетнаяБаза
				                    * ТаблицаСтрока.ЧасыФакт / ТаблицаСтрока.Часы 
									* ТаблицаСтрока.Процент / 100;
			КонецЕсли; 
			
		КонецЕсли; 
		
	КонецЦикла; 
	
КонецПроцедуры                                         

&НаКлиенте
Процедура ВвестиСписком(Команда)
	
	ВвестиСпискомНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьТекущееИмяТаблицы()
	
	ТекущаяТаблицаИмя = "";
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя = "ГруппаСпециальныеНачисления" Тогда
		ТекущаяТаблицаИмя = "мСпециальныеНачисленияТаблица";
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя = "ГруппаСдельнаяОплата" Тогда 	
		ТекущаяТаблицаИмя = "мСдельнаяОплатаТаблица";
	КонецЕсли;
	
	Возврат ТекущаяТаблицаИмя;
	
КонецФункции
                                   
&НаКлиенте
Процедура ВвестиСпискомНаКлиенте(ОбнулитьБулево = Ложь)
	
	ТекущаяТаблицаИмя = ПолучитьТекущееИмяТаблицы();
	
	Если Не ЗначениеЗаполнено(ТекущаяТаблицаИмя) Тогда
		Возврат;
	КонецЕсли; 
	
	ИмяТекущейКолонки	= СтрЗаменить(Элементы[ТекущаяТаблицаИмя].ТекущийЭлемент.Имя,ТекущаяТаблицаИмя,"");
	Если ИмяТекущейКолонки = "ФИО" Тогда
		Возврат;
	КонецЕсли; 
	
	ЗначениеВКолонке = 0;
	Если НЕ ОбнулитьБулево Тогда
		ЗначениеВКолонке 	= Элементы[ТекущаяТаблицаИмя].ТекущиеДанные[ИмяТекущейКолонки];	
	КонецЕсли;           	
	
	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("ИмяПоля",ИмяТекущейКолонки);
	ДопПараметры.Вставить("ТекущаяТаблицаИмя",ТекущаяТаблицаИмя);
	ДопПараметры.Вставить("ЗначениеВКолонке",ЗначениеВКолонке);

	ТекстВопроса = НСтр("ru = 'Ввести списком значение "+ЗначениеВКолонке+"?'");
	Оповещение = Новый ОписаниеОповещения("ВвестиСпискомЗавершение", ЭтотОбъект, ДопПараметры);
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры
 
&НаКлиенте
Процедура ВвестиСпискомЗавершение(Знач Результат, Знач ДопПараметры) Экспорт

	Если Результат = КодВозвратаДиалога.Да Тогда     
		
		Для каждого ТаблицаСтрока Из ЭтотОбъект[ДопПараметры.ТекущаяТаблицаИмя] Цикл
			
			ТаблицаСтрока[ДопПараметры.ИмяПоля] = ДопПараметры.ЗначениеВКолонке;
			
		КонецЦикла; 
		
	КонецЕсли;
	
	ТекущаяТаблицаИмя = ПолучитьТекущееИмяТаблицы();

	Если ТекущаяТаблицаИмя = "мСпециальныеНачисленияТаблица" Тогда
		РассчитатьСуммыВСпециальныеНачисленияТаблица();
	ИначеЕсли ТекущаяТаблицаИмя = "мСдельнаяОплатаТаблица" Тогда
		РассчитатьСуммыВмСдельнаяОплатаТаблица();	
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура Обнулить(Команда)              
	
	ВвестиСпискомНаКлиенте(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура мВДняхЧасахПриИзменении(Элемент)
	
	УстановитьВидимостьКолонокВСпециальныхНачислениях();
	
КонецПроцедуры

&НаКлиенте
Процедура мСпециальныеНачисленияТаблицаПриИзменении(Элемент)
	
	РассчитатьСуммыВСпециальныеНачисленияТаблица();
	
КонецПроцедуры

&НаКлиенте
Процедура НачислитьОдному(Команда)
	
	Если Не ЗначениеЗаполнено(мНачислениеСпециальное) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю("Внимание! Не выбрано специальное начисление.");
		Возврат;
	КонецЕсли; 
	
	ТекущаяТаблицаИмя = ПолучитьТекущееИмяТаблицы();
	
	Если Не ЗначениеЗаполнено(ТекущаяТаблицаИмя) Тогда
		Возврат;                                                   
	КонецЕсли; 
	
	СотрудникСсылка = Элементы[ТекущаяТаблицаИмя].ТекущиеДанные["ФИО"];
	
	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("Сотрудник",СотрудникСсылка);
	ДопПараметры.Вставить("Начисление",мНачислениеСпециальное);
	ДопПараметры.Вставить("ТекущаяТаблицаИмя",ТекущаяТаблицаИмя);
	
	ТекстВопроса = НСтр("ru = 'Выполнить начисление сотруднику "+СотрудникСсылка+"?'");
	Оповещение = Новый ОписаниеОповещения("НачислитьОдномуВсемЗавершение", ЭтотОбъект, ДопПараметры);
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры
  
&НаКлиенте
Процедура НачислитьОдномуВсемЗавершение(Знач Результат, Знач ДопПараметры) Экспорт

	Если Результат = КодВозвратаДиалога.Да Тогда     
		Закрыть(ПоместитьИзмененныеДанныеВоВременноеХранилище(ДопПараметры));
	КонецЕсли;	
		
КонецПроцедуры

&НаКлиенте
Процедура мСдельнаяОплатаТаблицаПриИзменении(Элемент)
	
	РассчитатьСуммыВмСдельнаяОплатаТаблица();
	
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
Функция ПолучитьСтруктуруНачисленияТаблица()
	
	ТаблицаСтруктура = Новый ТаблицаЗначений;
	ТаблицаСтруктура.Колонки.Добавить("Сотрудник");
	ТаблицаСтруктура.Колонки.Добавить("Начисление");
	ТаблицаСтруктура.Колонки.Добавить("РазмерНачисления");
	
	Возврат ТаблицаСтруктура;                       
	
КонецФункции                                  

&НаСервере
Функция ПоместитьИзмененныеДанныеВоВременноеХранилище(ДопПараметры)
	         	
	ВозвращаемыеСведения = Новый Структура;
	ВозвращаемыеСведения.Вставить("Начисление",ДопПараметры.Начисление);
	ВозвращаемыеСведения.Вставить("тзПрочиеНачисления", ПолучитьСтруктуруНачисленияТаблица());
	
	Если ЗначениеЗаполнено(ДопПараметры.Сотрудник) Тогда
		
		ПоискСтруктура = Новый Структура("ФИО",ДопПараметры.Сотрудник);
		НачисленияДанные = ЭтотОбъект[ДопПараметры.ТекущаяТаблицаИмя].НайтиСтроки(ПоискСтруктура);
		
	Иначе	
		
		НачисленияДанные = ЭтотОбъект[ДопПараметры.ТекущаяТаблицаИмя].Выгрузить();
		
	КонецЕсли; 
	
	Для каждого НачислениЭлемент Из НачисленияДанные Цикл
		
		НачисленияСтрока = ВозвращаемыеСведения.тзПрочиеНачисления.Добавить();
		НачисленияСтрока.Сотрудник         = НачислениЭлемент.ФИО;
		НачисленияСтрока.Начисление        = мНачислениеСпециальное;
		НачисленияСтрока.РазмерНачисления  = НачислениЭлемент.Сумма;
		                                 		
	КонецЦикла; 
	
	Возврат ПоместитьВоВременноеХранилище(ВозвращаемыеСведения, Новый УникальныйИдентификатор);
	
КонецФункции

&НаКлиенте
Процедура НачислитьВсем(Команда)
	
	Если Не ЗначениеЗаполнено(мНачислениеСпециальное) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю("Внимание! Не выбрано специальное начисление.");
		Возврат;
	КонецЕсли; 
	
	ТекущаяТаблицаИмя = ПолучитьТекущееИмяТаблицы();
	
	Если Не ЗначениеЗаполнено(ТекущаяТаблицаИмя) Тогда
		Возврат;                                                   
	КонецЕсли; 
	
	СотрудникСсылка = Элементы[ТекущаяТаблицаИмя].ТекущиеДанные["ФИО"];
	
	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("Сотрудник",Неопределено);
	ДопПараметры.Вставить("Начисление",мНачислениеСпециальное);
	ДопПараметры.Вставить("ТекущаяТаблицаИмя",ТекущаяТаблицаИмя);
	
	ТекстВопроса = НСтр("ru = 'Выполнить начисление всем сотрудникам?'");
	Оповещение = Новый ОписаниеОповещения("НачислитьОдномуВсемЗавершение", ЭтотОбъект, ДопПараметры);
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

#КонецОбласти
