
#Область ОписаниеПеременных

#КонецОбласти

#Область ПрограммныйИнтерфейс

#Область ОбновлениеИнформационнойБазы

// Процедура - Обновление 11.0.2.73
//
Процедура Обновление_11_0_2_73() Экспорт

	ОбработкаЗагрузкиДанныхПК = Обработки.инкЗагрузкаДанныхПроизводственногоКалендаряИНормыВремени.Создать();
	ОбработкаЗагрузкиДанныхПК.ЗагрузитьДанныеНаСервере(2025,Истина);
	
КонецПроцедуры

// Процедура - Обновление 11.0.2.71
//
Процедура Обновление_11_0_2_71() Экспорт

	УстановитьПраваДляБухгалтераИКадровика("инкКонфигурацияВыплатВФонды");
	РегистрыСведений.инкСтандартныеВычетыНастройки.УстановитьНастройкиСтандартныхВычетов_11_0_2_71();
	
КонецПроцедуры

// Процедура - Обновление 11.0.2.70
//
Процедура Обновление_11_0_2_70() Экспорт
	
	инкОбновлениеИнформационнойБазыСервер.УстановитьПраваДляБухгалтераИКадровика("инкСводнаяВедомость");
	инкОбновлениеИнформационнойБазыСервер.УстановитьПраваДляБухгалтераИКадровика("инкВзносы");
	инкОбновлениеИнформационнойБазыСервер.УстановитьПраваДляБухгалтераИКадровика("инкСводнаяВедомость");
	инкОбновлениеИнформационнойБазыСервер.УстановитьПраваДляБухгалтераИКадровика("инкЗагрузкаКадровыхДанныхИзБПВЗИК");
	инкОбновлениеИнформационнойБазыСервер.УстановитьПраваДляБухгалтераИКадровика("инкЗагрузкаКадровыхДанныхИзРСВ");

	инкОбновлениеИнформационнойБазыСервер.УстановитьПраваДляБухгалтераИКадровика("инкНалоговыеУведомления");
	инкОбновлениеИнформационнойБазыСервер.УстановитьПраваДляБухгалтераИКадровика("инкПерсонифицированныеСведенияОФизическихЛицах");
	инкОбновлениеИнформационнойБазыСервер.УстановитьПраваДляБухгалтераИКадровика("инкЕФС_1");
	инкОбновлениеИнформационнойБазыСервер.УстановитьПраваДляБухгалтераИКадровика("инк1НДФЛ");
	инкОбновлениеИнформационнойБазыСервер.УстановитьПраваДляБухгалтераИКадровика("инк2НДФЛ");
	инкОбновлениеИнформационнойБазыСервер.УстановитьПраваДляБухгалтераИКадровика("инк6НДФЛ");
	
	инкОбновлениеИнформационнойБазыСервер.УстановитьПраваДляБухгалтераИКадровика("инкКонфигурацияВыплатВФонды");
	
КонецПроцедуры

// Процедура - Обновление 11.0.2.69
//
Процедура Обновление_11_0_2_69() Экспорт
	
	ИмяГруппыИПрофиля = "Бухгалтеры (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль("инкСправочники",ПрофильГруппДоступа);
	
	ИмяГруппыИПрофиля = "Кадровики (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль("инкСправочники",ПрофильГруппДоступа);
	
КонецПроцедуры

// Процедура - Обновление 11.0.2.68
//
Процедура Обновление_11_0_2_68() Экспорт
	
	ИмяГруппыИПрофиля = "Бухгалтеры (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль("инкАУСНИнформацияДляФНС",ПрофильГруппДоступа);
	
КонецПроцедуры

// Процедура - Обновление 11.0.2.67
//
Процедура Обновление_11_0_2_67() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	инкОрганизации.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.инкОрганизации КАК инкОрганизации
		|ГДЕ
		|	инкОрганизации.СистемаНалогооблажения = ЗНАЧЕНИЕ(Перечисление.инкСистемаНалогооблажения.ЕНВД)";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		ОрганизацияОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
		ОрганизацияОбъект.СистемаНалогооблажения = Перечисления.инкСистемаНалогооблажения.Патент;
		ОрганизацияОбъект.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

// Процедура - Обновление 11.0.2.64
//
Процедура Обновление_11_0_2_64() Экспорт

	ИмяГруппыИПрофиля = "Бухгалтеры (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль("инкРасчетПоСтраховымВзносам",ПрофильГруппДоступа);

КонецПроцедуры

// Процедура - Обновление 11.0.2.62
//
Процедура Обновление_11_0_2_62() Экспорт

	ИмяГруппыИПрофиля = "Бухгалтеры (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль("инкРеестрУведомлений",ПрофильГруппДоступа);

	ИмяГруппыИПрофиля = "Кадровики (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль("инкРеестрУведомлений",ПрофильГруппДоступа);
	
КонецПроцедуры

// Процедура - Обновление 11.0.2.61
//
Процедура Обновление_11_0_2_61() Экспорт

	ИмяГруппыИПрофиля = "Бухгалтеры (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль("инкНалоговыеУведомления",ПрофильГруппДоступа);

	ИмяГруппыИПрофиля = "Кадровики (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль("инкНалоговыеУведомления",ПрофильГруппДоступа);
	
КонецПроцедуры

// Процедура - Обновление 11.0.2.59
//
Процедура Обновление_11_0_2_59() Экспорт

	Константы.инкСсылкаНаСлужебныйВебСайтИнкомсофт.Установить("https://инкомсофт.рф");   
	
	ОбработкаЗагрузкиДанныхПК = Обработки.инкЗагрузкаДанныхПроизводственногоКалендаряИНормыВремени.Создать();
	ОбработкаЗагрузкиДанныхПК.ЗагрузитьДанныеНаСервере(2024,Истина);
	
КонецПроцедуры

// Процедура - Обновление 11.0.2.51
//
Процедура Обновление_11_0_2_51() Экспорт

	ИмяГруппыИПрофиля = "Бухгалтеры (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль("инкОснованияДляКадровыхПриказовДобавлениеИзменение",ПрофильГруппДоступа);

	ИмяГруппыИПрофиля = "Кадровики (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль("инкОснованияДляКадровыхПриказовДобавлениеИзменение",ПрофильГруппДоступа);
	
КонецПроцедуры

// Процедура - Обновление 11.0.2.50
//
Процедура Обновление_11_0_2_50() Экспорт

	ИмяГруппыИПрофиля = "Бухгалтеры (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль("инкПриказНаВыплатуКомпенсацииДобавлениеИзменение",ПрофильГруппДоступа);

	ИмяГруппыИПрофиля = "Кадровики (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль("инкПриказНаВыплатуКомпенсацииДобавлениеИзменение",ПрофильГруппДоступа);
	
КонецПроцедуры

// Процедура - Обновление 11.0.2.49
//
Процедура Обновление_11_0_2_49() Экспорт

	ИмяГруппыИПрофиля = "Бухгалтеры (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль("инкОтчетПоОстаткуОтпусков",ПрофильГруппДоступа);

	ИмяГруппыИПрофиля = "Кадровики (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль("инкОтчетПоОстаткуОтпусков",ПрофильГруппДоступа);
	
КонецПроцедуры

// Процедура - Обновление 11.0.2.46
//
Процедура Обновление_11_0_2_46() Экспорт

	ИмяГруппыИПрофиля = "Бухгалтеры (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль("инкЕФС_1_Раздел2",ПрофильГруппДоступа);
	
КонецПроцедуры

// Процедура - Обновление 11.0.2.44
//
Процедура Обновление_11_0_2_44() Экспорт

	ИмяГруппыИПрофиля = "Бухгалтеры (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль("инкМастерДобавленияНовогоСотрудника",ПрофильГруппДоступа);
	
	ИмяГруппыИПрофиля = "Кадровики (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль("инкМастерДобавленияНовогоСотрудника",ПрофильГруппДоступа);
	
КонецПроцедуры

// Процедура - Обновление 11.0.2.43
//
Процедура Обновление_11_0_2_43() Экспорт

	ИсходныеДанные = Новый Структура;
	ИсходныеДанные.Вставить("Дата1",Дата("00010101000000"));
	ИсходныеДанные.Вставить("Дата2",КонецГода(ТекущаяДата()));

	Документы.инкНачислениеЗарплаты.ПерепровестиВсеДокументыПоПериоду(ИсходныеДанные);
	
	ИмяГруппыИПрофиля = "Бухгалтеры (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль("инкЛицевойСчетТ54а",ПрофильГруппДоступа);
	
	ИмяГруппыИПрофиля = "Кадровики (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль("инкЛицевойСчетТ54а",ПрофильГруппДоступа);
	
КонецПроцедуры

// Процедура - Обновление 11.0.2.42
//
Процедура Обновление_11_0_2_42() Экспорт
	
	ИмяГруппыИПрофиля = "Бухгалтеры (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль("инкГрафикОтпусковДобавлениеИзменение",ПрофильГруппДоступа);
	
	ИмяГруппыИПрофиля = "Кадровики (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль("инкГрафикОтпусковДобавлениеИзменение",ПрофильГруппДоступа);
	
КонецПроцедуры

// Процедура - Обновление 11.0.2.40
//
Процедура Обновление_11_0_2_40() Экспорт
	
	ИмяГруппыИПрофиля = "Бухгалтеры (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль("инкДниРожденияСотрудников",ПрофильГруппДоступа);
	
	ИмяГруппыИПрофиля = "Кадровики (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль("инкДниРожденияСотрудников",ПрофильГруппДоступа);
	
КонецПроцедуры

// Процедура - Обновление 11.0.2.39
//
Процедура Обновление_11_0_2_39() Экспорт
	
	ИмяГруппыИПрофиля = "Бухгалтеры (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль("инкВебСсылкиНаСправкуКПрограммеИзменение",ПрофильГруппДоступа);
	
	ИмяГруппыИПрофиля = "Кадровики (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль("инкВебСсылкиНаСправкуКПрограммеЧтение",ПрофильГруппДоступа);
	
	ДобавитьСсылкиНаСправкуКПрограмме();
	
КонецПроцедуры

// Процедура - Обновление 11.0.2.38
//
Процедура Обновление_11_0_2_38() Экспорт
	
	ИмяГруппыИПрофиля = "Бухгалтеры (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль("инкШтатноеРасписаниеДобавлениеИзменение",ПрофильГруппДоступа);
	
	ИмяГруппыИПрофиля = "Кадровики (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль("инкШтатноеРасписаниеДобавлениеИзменение",ПрофильГруппДоступа);
	
КонецПроцедуры

// Процедура - Обновление 11.0.2.37
//
Процедура Обновление_11_0_2_37() Экспорт
	
	ИсходныеДанные = Новый Структура;
	ИсходныеДанные.Вставить("Дата1",Дата("00010101000000"));
	ИсходныеДанные.Вставить("Дата2",КонецГода(ТекущаяДата()));

	Документы.инкНачислениеЗарплаты.ПерепровестиВсеДокументыПоПериоду(ИсходныеДанные);
	
КонецПроцедуры

// Процедура - Обновление 11.0.2.36
//
Процедура Обновление_11_0_2_36() Экспорт

	ИмяГруппыИПрофиля = "Бухгалтеры (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль("инк6НДФЛ",ПрофильГруппДоступа);
	
КонецПроцедуры

// Процедура - Обновление 11.0.2.34
//
Процедура Обновление_11_0_2_34() Экспорт

	ИмяГруппыИПрофиля = "Бухгалтеры (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль("инкСтандартныеНастройкиИнтерфейса",ПрофильГруппДоступа);
	
	ИмяГруппыИПрофиля = "Кадровики (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль("инкСтандартныеНастройкиИнтерфейса",ПрофильГруппДоступа);
	
	Константы.инкСтандартныеНастройкиИнтерфейса.Установить(Истина);
	
КонецПроцедуры

// Процедура - Обновление 11.0.2.33
//
Процедура Обновление_11_0_2_33() Экспорт

	инкУчетВремениСервер.ЗаполнитьДанныеПоНормеВремениПоУмолчанию(2021);
	инкУчетВремениСервер.ЗаполнитьДанныеПоНормеВремениПоУмолчанию(2022);
	инкУчетВремениСервер.ЗаполнитьДанныеПоНормеВремениПоУмолчанию(2023);
	
КонецПроцедуры

// Процедура - Обновление 11.0.2.31
//
Процедура Обновление_11_0_2_31() Экспорт
	
	ИмяГруппыИПрофиля = "Бухгалтеры (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль("инкЗагрузкаНовостейССайта",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкНовостиЧтениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкСсылкаНаСлужебныйВебСайтИнкомсофтИзменение",ПрофильГруппДоступа);
	
	ИмяГруппыИПрофиля = "Кадровики (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль("инкЗагрузкаНовостейССайта",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкНовостиЧтениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкСсылкаНаСлужебныйВебСайтИнкомсофтИзменение",ПрофильГруппДоступа);
	
	Константы.инкЗагрузкаНовостейССайта.Установить(Истина);
	Константы.инкСсылкаНаСлужебныйВебСайтИнкомсофт.Установить("http://srv1c.ddns.net");
	
КонецПроцедуры

// Процедура - Обновление 11.0.2.29
//
Процедура Обновление_11_0_2_29() Экспорт

	ИмяГруппыИПрофиля = "Бухгалтеры (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль("инкСсылкаНаСлужебныйВебСайтИнкомсофтЧтение",ПрофильГруппДоступа);
	
	ИмяГруппыИПрофиля = "Кадровики (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль("инкСсылкаНаСлужебныйВебСайтИнкомсофтЧтение",ПрофильГруппДоступа);
	
	Константы.инкСсылкаНаСлужебныйВебСайтИнкомсофт.Установить("http://srv1c.ddns.net");
	
КонецПроцедуры

// Процедура - Обновление 11.0.2.25
//
Процедура Обновление_11_0_2_25() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	инкНачислениеЗарплаты.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.инкНачислениеЗарплаты КАК инкНачислениеЗарплаты
		|ГДЕ
		|	инкНачислениеЗарплаты.Проведен";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		НачисленияНабор = РегистрыНакопления.инкНачисления.СоздатьНаборЗаписей();
		НачисленияНабор.Отбор.Регистратор.Установить(ВыборкаДетальныеЗаписи.Ссылка);
		НачисленияНабор.Прочитать();
		Для каждого НачислениеЗапись Из НачисленияНабор Цикл
			НачислениеЗапись.ВходитВФОТ = НачислениеЗапись.Начисление.ВходитВФОТ;
		КонецЦикла;
		НачисленияНабор.Записать(Истина);
		
	КонецЦикла;
	
КонецПроцедуры

// Процедура - Обновление 11.0.2.24
//
Процедура Обновление_11_0_2_24() Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	инкНачисления.Ссылка КАК Ссылка
		|ИЗ
		|	ПланВидовРасчета.инкНачисления КАК инкНачисления";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		НачислениеОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
		НачислениеОбъект.ВходитВФОТ = Истина;
		НачислениеОбъект.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

// Процедура - Обновление 11.0.2.22
//
Процедура Обновление_11_0_2_22() Экспорт
	
	ИмяГруппыИПрофиля = "Бухгалтеры (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль("инкСервисноеОбслуживаниеПрограммыИнкомсофт",ПрофильГруппДоступа);

КонецПроцедуры

// Процедура - Обновление 11.0.2.20
//
Процедура Обновление_11_0_2_20() Экспорт
	
	ИмяГруппыИПрофиля = "Бухгалтеры (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль("инкОтчеты",ПрофильГруппДоступа);

	ИмяГруппыИПрофиля = "Кадровики (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль("инкОтчеты",ПрофильГруппДоступа);

КонецПроцедуры

// Процедура - Обновление 11.0.2.19
//
Процедура Обновление_11_0_2_19() Экспорт
	
	ИмяГруппыИПрофиля = "Бухгалтеры (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль("инкПерсонифицированныеСведенияОФизическихЛицах",ПрофильГруппДоступа);
	
КонецПроцедуры

// Процедура - Обновление 11.0.2.17
//
Процедура Обновление_11_0_2_17() Экспорт
	
	ИмяГруппыИПрофиля = "Бухгалтеры (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль("инкУИДПрограммыИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкУИДРегистрацииИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкРегистрацияПрограммы",ПрофильГруппДоступа);
	
КонецПроцедуры

// Процедура - Обновление 11.0.2.16
//
Процедура Обновление_11_0_2_16() Экспорт
	
	ИмяГруппыИПрофиля = "Бухгалтеры (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль("инкБухгалтерскаяОперацияДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкВводВходящегоСальдоДобавлениеИзменение",ПрофильГруппДоступа);
	
КонецПроцедуры

// Процедура - Обновление 11.0.2.15
//
Процедура Обновление_11_0_2_15() Экспорт
	
	ИмяГруппыИПрофиля = "Бухгалтеры (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль("инкУИДРегистрацииЧтение",ПрофильГруппДоступа);
	
	ИмяГруппыИПрофиля = "Кадровики (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль("инкУИДРегистрацииЧтение",ПрофильГруппДоступа);
	
КонецПроцедуры

// Процедура - Обновление 11.0.2.14
//
Процедура Обновление_11_0_2_14() Экспорт
	
	ИмяГруппыИПрофиля = "Бухгалтеры (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль("инкУИДПрограммыЧтение",ПрофильГруппДоступа);
	
	ИмяГруппыИПрофиля = "Кадровики (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль("инкУИДПрограммыЧтение",ПрофильГруппДоступа);
	
КонецПроцедуры

// Процедура - Обновление 11.0.2.12
//
Процедура Обновление_11_0_2_12() Экспорт
	
	ИмяГруппыИПрофиля = "Бухгалтеры (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль("инкБольничныйЛистДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкБольничныйЛистРасчетДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкБольничныйЛистЧтение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкБольничныйРасчетЛистЧтение",ПрофильГруппДоступа);
	
	ИмяГруппыИПрофиля = "Кадровики (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль("инкБольничныйЛистДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкБольничныйЛистЧтение",ПрофильГруппДоступа);
	
	ИсходныеДанные = Новый Структура;
	ИсходныеДанные.Вставить("Дата1",Дата("00010101000000"));
	ИсходныеДанные.Вставить("Дата2",ТекущаяДата());
	
	инкКадровыйУчетСервер.ПерепровестиВсеКадровыеДокументыЗаПериод(ИсходныеДанные);
	
КонецПроцедуры

// Процедура - Обновление 11.0.2.11
//
Процедура Обновление_11_0_2_11() Экспорт
	
	ИсходныеДанные = Новый Структура;
	ИсходныеДанные.Вставить("Дата1",Дата("00010101000000"));
	ИсходныеДанные.Вставить("Дата2",ТекущаяДата());
	
	инкКадровыйУчетСервер.ПерепровестиВсеКадровыеДокументыЗаПериод(ИсходныеДанные);
    Документы.инкНачислениеЗарплаты.ПерепровестиВсеДокументыПоПериоду(ИсходныеДанные);
	
КонецПроцедуры

// Процедура - Обновление 11.0.2.10
//
Процедура Обновление_11_0_2_10() Экспорт
	
	Справочники.ИдентификаторыОбъектовМетаданных.ОбновитьДанныеСправочника();
	
	Группа_Бухгалтеры();
	Группа_Кадровики();	
	
КонецПроцедуры

// Процедура - Обновление 11.0.2.9
//
Процедура Обновление_11_0_2_9() Экспорт
	
	ИсходныеДанные = Новый Структура;
	ИсходныеДанные.Вставить("Дата1",Дата("00010101000000"));
	ИсходныеДанные.Вставить("Дата2",ТекущаяДата());
	
	инкКадровыйУчетСервер.ПерепровестиВсеКадровыеДокументыЗаПериод(ИсходныеДанные);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий
// Код процедур и функций
#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс
// Код процедур и функций
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьПраваДляБухгалтераИКадровика(ИмяРоли) Экспорт

	ИмяГруппыИПрофиля = "Бухгалтеры (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль(ИмяРоли,ПрофильГруппДоступа);
	
	ИмяГруппыИПрофиля = "Кадровики (Инкомсофт)";
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильРоль(ИмяРоли,ПрофильГруппДоступа);

КонецПроцедуры

Процедура ДобавитьСсылкиНаСправкуКПрограмме()
	
	СправочникОбъект = Справочники.инкВебСсылкиНаСправкуКПрограмме.СоздатьЭлемент();
	СправочникОбъект.Наименование = "HLP файл к программе Инкомсофт: Зарплата и кадры 11.0";
	СправочникОбъект.ВебСсылка = "http://srv1c.ddns.net/help/";
	СправочникОбъект.Записать();
	
	СправочникОбъект = Справочники.инкВебСсылкиНаСправкуКПрограмме.СоздатьЭлемент();
	СправочникОбъект.Наименование = "Веб сайт ООО ""Инкомсофт""";
	СправочникОбъект.ВебСсылка = "http://incomsoft.karelia.ru/";
	СправочникОбъект.Записать();
	
	СправочникОбъект = Справочники.инкВебСсылкиНаСправкуКПрограмме.СоздатьЭлемент();
	СправочникОбъект.Наименование = "Видео: Выгрузка начисленной зарплаты из Инкомсофт: ""Зарплата и кадры 11.0"" в ""1С: Бухгалтерия 3.0""";
	СправочникОбъект.ВебСсылка = "https://www.youtube.com/watch?v=TwY4pm4mmtk";
	СправочникОбъект.Записать();
	
	СправочникОбъект = Справочники.инкВебСсылкиНаСправкуКПрограмме.СоздатьЭлемент();
	СправочникОбъект.Наименование = "Видео: Загрузка внешних начислений из программы Инкомсофт: ""ЗИК 10.5"" в ""ЗИК 11.0""";
	СправочникОбъект.ВебСсылка = "https://www.youtube.com/watch?v=7yMde12LYwc";
	СправочникОбъект.Записать();
	
	СправочникОбъект = Справочники.инкВебСсылкиНаСправкуКПрограмме.СоздатьЭлемент();
	СправочникОбъект.Наименование = "Видео: Загрузка кадровых данных из 1С: Бухгалтерия в Инкомсофт: Зарплата и кадры";
	СправочникОбъект.ВебСсылка = "https://www.youtube.com/watch?v=QuQLcHYXPPk";
	СправочникОбъект.Записать();
	
	СправочникОбъект = Справочники.инкВебСсылкиНаСправкуКПрограмме.СоздатьЭлемент();
	СправочникОбъект.Наименование = "Видео: Загрузка кадровых данных из РСВ";
	СправочникОбъект.ВебСсылка = "https://www.youtube.com/watch?v=VGrbRqv85co";
	СправочникОбъект.Записать();
	
	СправочникОбъект = Справочники.инкВебСсылкиНаСправкуКПрограмме.СоздатьЭлемент();
	СправочникОбъект.Наименование = "Видео: Презентация программы Инкомсофт ""Зарплата и кадры""";
	СправочникОбъект.ВебСсылка = "https://www.youtube.com/watch?v=dhQ5kV93kjQ";
	СправочникОбъект.Записать();
	
	СправочникОбъект = Справочники.инкВебСсылкиНаСправкуКПрограмме.СоздатьЭлемент();
	СправочникОбъект.Наименование = "Видео: Сервисное обслуживание программы ""Инкомсофт: Зарплата и кадры 11.0""";
	СправочникОбъект.ВебСсылка = "https://www.youtube.com/watch?v=zOyS-VwZh4U";
	СправочникОбъект.Записать();
	
КонецПроцедуры

Процедура Группа_Бухгалтеры()

	ИмяГруппыИПрофиля = "Бухгалтеры (Инкомсофт)";
	
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильБазовыеРоли(ПрофильГруппДоступа);
	
	ДобавитьВПрофильРоль("инкНДФЛ",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкКадры",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкВзносы",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инк1НДФЛ",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инк2НДФЛ",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкБлокировкаПроведенияДокументовЧтениеДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкБольничныйЛистДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкВводПостоянныхНачисленийУдержанийДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкВедомости",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкВедомостьНаВыплатуЗарплатыДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкВедомостьНачисленийУдержаний",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкВидыДокументовФизическихЛицДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкВыборПериода",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкВыборПериодаИПодразделений",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкВыборСотрудников",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкВыборСотрудниковСписком",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкВыборСтандартногоПериодаГодКвартал",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкВыборСтандартногоПериодаМесяц",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкВыгрузкаНачисленийЗарплатыВБухгалтерию",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкВычетыНДФЛДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкГодовойФондРабочегоВремени",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкДолжностиДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкДоходНДФЛДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкЗагрузкаВнешнихНачисленийИнкомсофт10_5",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкЗагрузкаДанныхПроизводственногоКалендаряИНормыВремени",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкЗарплатныеПроектыДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкИсточникиФинансированияДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкКадроваяИсторияСотрудников",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкКадровыйПереводДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкКнигаКадровыхПриказов",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкКодыБюджетнойКлассификацииДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкКонфигурацияВыплатВФонды",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкНалогУдержанный",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкНачислениеЗарплатыДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкНачисления",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкНормаВремени",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкОрганизацииДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкОснованиеПереводаДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкОсобыеУсловияТруда",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкОтпускРасчетПоСреднемуДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкОтчетПоСтраховымВзносам",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкПечатьОтпускРасчетПоСреднему",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкПечатьПриказВКомандировку",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкПечатьПриказНаОтпуск",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкПечатьПриказПоКадрам",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкПечатьРКО",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкПечатьТ53",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкПодразделенияВыдачиДокументовДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкПодразделенияДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкПолучитьОбработкуИИнструкциюПоЗагрузкеНачисленийИзИнкомсофт11вБП30",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкПостоянныеНачисления",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкПостоянныеУдержания",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкПриемНаРаботуДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкПриказВКомандировкуДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкПриказНаОтпускДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкПриказПоКадрамДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкРасчетВзносов",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкРасчетЗарабатнойПлаты",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкРасчетныеЛистки",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкРасчетныеЛисты",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкРасчетныеСчетаДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкРеестрБольничныхЛистов",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкРеестрКадровыхДокументов",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкРеестрОтпусков",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкСводнаяВедомость",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкСотрудникиДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкСотрудникиОрганизации",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкСотрудникиПрисоединенныеФайлыДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкСтандартныеВычетыНастройки",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкТабельУчетаРабочегоВремени",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкУвольнениеДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкУдержания",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкФондТравматизмаДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкХозрасчетный",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ДобавлениеИзменениеГрафиковРаботы",ПрофильГруппДоступа); 
	ДобавитьВПрофильРоль("ДобавлениеИзменениеКалендарныхГрафиков",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ВыполнениеСинхронизацииДанных",ПрофильГруппДоступа);

КонецПроцедуры

Процедура Группа_Кадровики()
	
	ИмяГруппыИПрофиля = "Кадровики (Инкомсофт)";
	
	ПрофильГруппДоступа = ПолучитьПрофильГруппДоступа(ИмяГруппыИПрофиля);
	ДобавитьВПрофильБазовыеРоли(ПрофильГруппДоступа);
	
	ДобавитьВПрофильРоль("инкКадры",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкБлокировкаПроведенияДокументовЧтение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкБольничныйЛистДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкВводПостоянныхНачисленийУдержанийЧтение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкВидыДокументовФизическихЛицДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкВыборПериода",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкВыборПериодаИПодразделений",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкВыборСотрудников",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкВыборСотрудниковСписком",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкВыборСтандартногоПериодаГодКвартал",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкВыборСтандартногоПериодаМесяц",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкВычетыНДФЛЧтение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкГодовойФондРабочегоВремени",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкДолжностиДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкДоходНДФЛЧтение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкЗагрузкаДанныхПроизводственногоКалендаряИНормыВремени",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкЗарплатныеПроектыДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкИсточникиФинансированияДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкКадроваяИсторияСотрудников",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкКадровыйПереводДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкКнигаКадровыхПриказов",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкКодыБюджетнойКлассификацииЧтение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкНормаВремени",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкОрганизацииДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкОснованиеПереводаДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкОсобыеУсловияТруда",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкПечатьОтпускРасчетПоСреднему",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкПечатьПриказВКомандировку",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкПечатьПриказНаОтпуск",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкПечатьПриказПоКадрам",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкПечатьРКО",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкПечатьТ53",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкПодразделенияВыдачиДокументовДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкПодразделенияДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкПостоянныеНачисления",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкПостоянныеУдержания",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкПриемНаРаботуДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкПриказВКомандировкуДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкПриказНаОтпускДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкПриказПоКадрамДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкРасчетныеСчетаЧтение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкРеестрБольничныхЛистов",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкРеестрКадровыхДокументов",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкРеестрОтпусков",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкСотрудникиДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкСотрудникиОрганизации",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкСотрудникиПрисоединенныеФайлыДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкТабельУчетаРабочегоВремени",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкУвольнениеДобавлениеИзменение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("инкФондТравматизмаЧтение",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ДобавлениеИзменениеГрафиковРаботы",ПрофильГруппДоступа); 
	ДобавитьВПрофильРоль("ДобавлениеИзменениеКалендарныхГрафиков",ПрофильГруппДоступа);
	
КонецПроцедуры    

Процедура ДобавитьВПрофильРоль(ИмяРоли,ПрофильГруппДоступа) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ИмяРоли) Тогда
		Возврат;
	КонецЕсли;
	
	РольСсылка = Справочники.ИдентификаторыОбъектовМетаданных.НайтиПоРеквизиту("Имя",ИмяРоли);

	Если НЕ ЗначениеЗаполнено(РольСсылка) Тогда
		Возврат;	
	КонецЕсли;
	
	НайденаРольВГруппе = Ложь;
	Для каждого РольСтрока Из ПрофильГруппДоступа.Роли Цикл
		
		Если РольСтрока.Роль = РольСсылка Тогда
			НайденаРольВГруппе = Истина;
			Прервать;
		КонецЕсли;	
		
	КонецЦикла;     
	
	Если НЕ НайденаРольВГруппе Тогда
		
		ПрофильГруппДоступаОбъект = ПрофильГруппДоступа.ПолучитьОбъект();
		РольПрофиляСтрока = ПрофильГруппДоступаОбъект.Роли.Добавить();
		РольПрофиляСтрока.Роль = РольСсылка;
		ПрофильГруппДоступаОбъект.Записать();
		
	КонецЕсли;	
	
КонецПроцедуры

Процедура ДобавитьВПрофильБазовыеРоли(ПрофильГруппДоступа)
	
	ДобавитьВПрофильРоль("БазовыеПраваБСП",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ВыводНаПринтерФайлБуферОбмена",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ДобавлениеИзменениеАдресныхСведений",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ДобавлениеИзменениеБанков",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ДобавлениеИзменениеВариантовОтчетов",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ДобавлениеИзменениеВидовКонтактнойИнформации",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ДобавлениеИзменениеДополнительныхОтчетовИОбработок",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ДобавлениеИзменениеДополнительныхРеквизитовИСведений",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ДобавлениеИзменениеЗаметок",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ДобавлениеИзменениеКалендарныхГрафиков",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ДобавлениеИзменениеКурсовВалют",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ДобавлениеИзменениеЛичныхВариантовОтчетов",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ДобавлениеИзменениеЛичныхШаблоновСообщений",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ДобавлениеИзменениеНапоминаний",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ДобавлениеИзменениеЭлектронныхПодписейИШифрование",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ЗапускAutomation",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ЗапускВебКлиента",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ЗапускВнешнегоСоединения",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ЗапускМобильногоКлиента",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ЗапускТолстогоКлиента",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ЗапускТонкогоКлиента",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ИзменениеДополнительныхСведений",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ИзменениеМакетовПечатныхФорм",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ИнтерактивноеОткрытиеВнешнихОтчетовИОбработок",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ИспользованиеУниверсальногоОтчета",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ПросмотрОписанияИзмененийПрограммы",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ПросмотрОтчетаДвиженияДокумента",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ПросмотрСвязанныеДокументы",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("РедактированиеРеквизитовОбъектов",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("РедактированиеПечатныхФорм",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("РежимВсеФункции",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("СохранениеДанныхПользователя",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("УдаленныйДоступБазоваяФункциональность",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ЧтениеВариантовОтчетов",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ЧтениеВерсийОбъектов",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ЧтениеДополнительныхОтчетовИОбработок",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ЧтениеДополнительныхСведений",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ЧтениеИнформацииОВерсияхОбъектов",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ЧтениеКурсовВалют",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ЧтениеРассылокОтчетов",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ЧтениеРезультатовПроверкиУчета",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ЧтениеУчетныхЗаписейЭлектроннойПочты",ПрофильГруппДоступа);
	ДобавитьВПрофильРоль("ЧтениеШаблоновСообщений",ПрофильГруппДоступа);
	
КонецПроцедуры

Функция ПолучитьПрофильГруппДоступа(НаименованиеПрофилиГруппДоступа) Экспорт

	ПрофильГруппДоступаСсылка = Справочники.ПрофилиГруппДоступа.НайтиПоНаименованию(НаименованиеПрофилиГруппДоступа);
	
	Если НЕ ЗначениеЗаполнено(ПрофильГруппДоступаСсылка) Тогда
		ПрофильГруппДоступаОбъект = Справочники.ПрофилиГруппДоступа.СоздатьЭлемент();
	Иначе
		ПрофильГруппДоступаОбъект = ПрофильГруппДоступаСсылка.ПолучитьОбъект();
	КонецЕсли;

	ПрофильГруппДоступаОбъект.Наименование = НаименованиеПрофилиГруппДоступа;  
	НазначениеСтрока = ПрофильГруппДоступаОбъект.Назначение.Добавить();
	ПрофильГруппДоступаОбъект.Записать();
	ПрофильГруппДоступаСсылка = ПрофильГруппДоступаОбъект.Ссылка;	
	
	Возврат ПрофильГруппДоступаСсылка;
	
КонецФункции 

#КонецОбласти

#Область Инициализация

#КонецОбласти
			  
