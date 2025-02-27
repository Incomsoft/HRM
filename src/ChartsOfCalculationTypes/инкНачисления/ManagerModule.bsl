
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Тогда

#Область ПрограммныйИнтерфейс

#Область ОбновлениеИнформационнойБазы

// Процедура - Заполнить коды начислений 11 0 2 5
//
Процедура ЗаполнитьКодыНачислений_11_0_2_5() Экспорт
	
	НачислениеСтруктура = Новый Структура;
	НачислениеСтруктура.Вставить("ИмяПредопределенныхДанных","Оклад");
	НачислениеСтруктура.Вставить("Отпуск",Истина);
	ОписатьКодНачисленияСтруктура(НачислениеСтруктура);

	НачислениеСтруктура = Новый Структура;
	НачислениеСтруктура.Вставить("ИмяПредопределенныхДанных","Командировка");
	НачислениеСтруктура.Вставить("Отпуск",Истина);
	ОписатьКодНачисленияСтруктура(НачислениеСтруктура);

	НачислениеСтруктура = Новый Структура;
	НачислениеСтруктура.Вставить("ИмяПредопределенныхДанных","РайонныйКоэффициент");
	НачислениеСтруктура.Вставить("Отпуск",Истина);
	ОписатьКодНачисленияСтруктура(НачислениеСтруктура);

	НачислениеСтруктура = Новый Структура;
	НачислениеСтруктура.Вставить("ИмяПредопределенныхДанных","СевернаяНадбавка");
	НачислениеСтруктура.Вставить("Отпуск",Истина);
	ОписатьКодНачисленияСтруктура(НачислениеСтруктура);

КонецПроцедуры  

// Процедура - Заполнить коды начислений 11 0 0 10
//
Процедура ЗаполнитьКодыНачислений_11_0_0_10() Экспорт
	
	ДоходНДФЛ2300 = Справочники.инкДоходНДФЛ.НайтиПоКоду("2300");
	Дебет = ПланыСчетов.инкХозрасчетный.ФСС;
	
	ОписатьКодНачисления("ПособиеНаПогребение","00009","Пособие на погребение",Ложь,Ложь,Ложь,Ложь,Ложь,Ложь,Ложь,Истина,Ложь,Ложь,,,Дебет);
	ОписатьКодНачисления("ОплатаДопВыходныхДляУходаЗаДетьмиИнвалидами","00011","Оплата доп. вых. для ухода за детьми инв",Ложь,Ложь,Ложь,Истина,Ложь,Ложь,Ложь,Истина,Ложь,Ложь,,,Дебет);
	
КонецПроцедуры

// Процедура - Заполнить коды начислений 11 0 0 11
//
Процедура ЗаполнитьКодыНачислений_11_0_0_11() Экспорт
	
	//
	ДоходНДФЛ_2300 = Справочники.инкДоходНДФЛ.НайтиПоКоду("2300");
	ДоходНДФЛ_2000 = Справочники.инкДоходНДФЛ.НайтиПоКоду("2000");
	ДоходНДФЛ_2760 = Справочники.инкДоходНДФЛ.НайтиПоКоду("2760");
	ДоходНДФЛ_2720 = Справочники.инкДоходНДФЛ.НайтиПоКоду("2720");   
	ДоходНДФЛ_2012 = Справочники.инкДоходНДФЛ.НайтиПоКоду("2012");   
	//
	Дебет_69_01	= ПланыСчетов.инкХозрасчетный.ФСС;
	Дебет_99_1  = ПланыСчетов.инкХозрасчетный.ПрибылиИУбыткиБезНалогаНаПрибыль;
	
	// Специальные начисления:
             
	// Оплата по основному окладу:
	НачислениеСтруктура = Новый Структура;
	НачислениеСтруктура.Вставить("Код","10001");
	НачислениеСтруктура.Вставить("Наименование","Оплата по основному окладу");
	НачислениеСтруктура.Вставить("ИмяПредопределенныхДанных","Оклад");
  	НачислениеСтруктура.Вставить("РайонныйКоэффициент",Истина);
	НачислениеСтруктура.Вставить("СевернаяНадбавка",Истина);
	НачислениеСтруктура.Вставить("Налог",Истина);
	НачислениеСтруктура.Вставить("Отпуск",Истина);
	НачислениеСтруктура.Вставить("БольничныйЛист",Истина);
	НачислениеСтруктура.Вставить("Дебет");
	НачислениеСтруктура.Вставить("ВПроцентах",Ложь);
	НачислениеСтруктура.Вставить("Взносы",Истина);
	НачислениеСтруктура.Вставить("ФондТравматизма",Истина);
	НачислениеСтруктура.Вставить("Ст9ФЗ212");
	НачислениеСтруктура.Вставить("МатериальнаяПомощь");
	НачислениеСтруктура.Вставить("ДоходНДФЛ",ДоходНДФЛ_2000);
	НачислениеСтруктура.Вставить("ВычетНДФЛ");
	НачислениеСтруктура.Вставить("КодВСтаройПрограмме","00001");
	ОписатьКодНачисленияСтруктура(НачислениеСтруктура); 
	
	//	Районный коэффициент:
	НачислениеСтруктура = Новый Структура;
	НачислениеСтруктура.Вставить("Код","10002");
	НачислениеСтруктура.Вставить("Наименование","Районный коэффициент");
	НачислениеСтруктура.Вставить("ИмяПредопределенныхДанных","РайонныйКоэффициент");
  	НачислениеСтруктура.Вставить("РайонныйКоэффициент",Ложь);
	НачислениеСтруктура.Вставить("СевернаяНадбавка",Ложь);
	НачислениеСтруктура.Вставить("Налог",Истина);
	НачислениеСтруктура.Вставить("Отпуск",Истина);
	НачислениеСтруктура.Вставить("БольничныйЛист",Истина);
	НачислениеСтруктура.Вставить("Дебет");
	НачислениеСтруктура.Вставить("ВПроцентах");
	НачислениеСтруктура.Вставить("Взносы",Истина);
	НачислениеСтруктура.Вставить("ФондТравматизма",Истина);
	НачислениеСтруктура.Вставить("Ст9ФЗ212");
	НачислениеСтруктура.Вставить("МатериальнаяПомощь");
	НачислениеСтруктура.Вставить("ДоходНДФЛ",ДоходНДФЛ_2000);
	НачислениеСтруктура.Вставить("ВычетНДФЛ");
	НачислениеСтруктура.Вставить("КодВСтаройПрограмме","00013");
	ОписатьКодНачисленияСтруктура(НачислениеСтруктура); 
	
	// Северная надбавка за стаж работы в РКС/МКС:	
	НачислениеСтруктура = Новый Структура;
	НачислениеСтруктура.Вставить("Код","10003");
	НачислениеСтруктура.Вставить("Наименование","Северная надбавка за стаж работы в РКС/МКС");
	НачислениеСтруктура.Вставить("ИмяПредопределенныхДанных","СевернаяНадбавка");
  	НачислениеСтруктура.Вставить("РайонныйКоэффициент",Ложь);
	НачислениеСтруктура.Вставить("СевернаяНадбавка",Ложь);
	НачислениеСтруктура.Вставить("Налог",Истина);
	НачислениеСтруктура.Вставить("Отпуск",Истина);
	НачислениеСтруктура.Вставить("БольничныйЛист",Истина);
	НачислениеСтруктура.Вставить("Дебет");
	НачислениеСтруктура.Вставить("ВПроцентах",Ложь);
	НачислениеСтруктура.Вставить("Взносы",Истина);
	НачислениеСтруктура.Вставить("ФондТравматизма",Истина);
	НачислениеСтруктура.Вставить("Ст9ФЗ212");
	НачислениеСтруктура.Вставить("МатериальнаяПомощь");
	НачислениеСтруктура.Вставить("ДоходНДФЛ",ДоходНДФЛ_2000);
	НачислениеСтруктура.Вставить("ВычетНДФЛ");
	НачислениеСтруктура.Вставить("КодВСтаройПрограмме","00014"); 
	ОписатьКодНачисленияСтруктура(НачислениеСтруктура);
	
	//	Пособие на погребение:	
	НачислениеСтруктура = Новый Структура;
	НачислениеСтруктура.Вставить("Код","10009");
	НачислениеСтруктура.Вставить("Наименование","Пособие на погребение");
	НачислениеСтруктура.Вставить("ИмяПредопределенныхДанных","ПособиеНаПогребение");
  	НачислениеСтруктура.Вставить("РайонныйКоэффициент",Ложь);
	НачислениеСтруктура.Вставить("СевернаяНадбавка",Ложь);
	НачислениеСтруктура.Вставить("Налог",Ложь);
	НачислениеСтруктура.Вставить("Отпуск",Ложь);
	НачислениеСтруктура.Вставить("БольничныйЛист",Ложь);
	НачислениеСтруктура.Вставить("Дебет",Дебет_69_01);
	НачислениеСтруктура.Вставить("ВПроцентах",Ложь);
	НачислениеСтруктура.Вставить("Взносы",Истина);
	НачислениеСтруктура.Вставить("ФондТравматизма",Ложь);
	НачислениеСтруктура.Вставить("Ст9ФЗ212",Истина);
	НачислениеСтруктура.Вставить("МатериальнаяПомощь",Ложь);
	НачислениеСтруктура.Вставить("ДоходНДФЛ",ДоходНДФЛ_2000);
	НачислениеСтруктура.Вставить("ВычетНДФЛ");
	НачислениеСтруктура.Вставить("КодВСтаройПрограмме","00031");
	ОписатьКодНачисленияСтруктура(НачислениеСтруктура);
	//	

	//	Оплата доп. вых. для ухода за детьми инв:	
	НачислениеСтруктура = Новый Структура;
	НачислениеСтруктура.Вставить("Код","10011");
	НачислениеСтруктура.Вставить("Наименование","Оплата доп. вых. для ухода за детьми инв");
	НачислениеСтруктура.Вставить("ИмяПредопределенныхДанных","ОплатаДопВыходныхДляУходаЗаДетьмиИнвалидами");
  	НачислениеСтруктура.Вставить("РайонныйКоэффициент",Ложь);
	НачислениеСтруктура.Вставить("СевернаяНадбавка",Ложь);
	НачислениеСтруктура.Вставить("Налог",Ложь);
	НачислениеСтруктура.Вставить("Отпуск",Ложь);
	НачислениеСтруктура.Вставить("БольничныйЛист",Ложь);
	НачислениеСтруктура.Вставить("Дебет",ДоходНДФЛ_2000);
	НачислениеСтруктура.Вставить("ВПроцентах",Ложь);
	НачислениеСтруктура.Вставить("Взносы",Истина);
	НачислениеСтруктура.Вставить("ФондТравматизма",Ложь);
	НачислениеСтруктура.Вставить("Ст9ФЗ212",Истина);
	НачислениеСтруктура.Вставить("МатериальнаяПомощь",Ложь);
	НачислениеСтруктура.Вставить("ДоходНДФЛ",ДоходНДФЛ_2000);
	НачислениеСтруктура.Вставить("ВычетНДФЛ");
	НачислениеСтруктура.Вставить("КодВСтаройПрограмме","00033");
	ОписатьКодНачисленияСтруктура(НачислениеСтруктура);	
	//	

	//	Матер. помощь ст. 217 п. 28 НК:	
	НачислениеСтруктура = Новый Структура;
	НачислениеСтруктура.Вставить("Код","10012");
	НачислениеСтруктура.Вставить("Наименование","Матер. помощь ст. 217 п. 28 НК");
	НачислениеСтруктура.Вставить("ИмяПредопределенныхДанных","МатПом217п28НК");
  	НачислениеСтруктура.Вставить("РайонныйКоэффициент",Ложь);
	НачислениеСтруктура.Вставить("СевернаяНадбавка",Ложь);
	НачислениеСтруктура.Вставить("Налог",Истина);
	НачислениеСтруктура.Вставить("Отпуск",Ложь);
	НачислениеСтруктура.Вставить("БольничныйЛист",Ложь);
	НачислениеСтруктура.Вставить("Дебет",Дебет_99_1);
	НачислениеСтруктура.Вставить("ВПроцентах",Ложь);
	НачислениеСтруктура.Вставить("Взносы",Истина);
	НачислениеСтруктура.Вставить("ФондТравматизма",Ложь);
	НачислениеСтруктура.Вставить("Ст9ФЗ212",Ложь);
	НачислениеСтруктура.Вставить("МатериальнаяПомощь",Истина);
	НачислениеСтруктура.Вставить("ДоходНДФЛ",ДоходНДФЛ_2760);
	НачислениеСтруктура.Вставить("ВычетНДФЛ",Справочники.инкВычетыНДФЛ.Код503);
	НачислениеСтруктура.Вставить("КодВСтаройПрограмме","00051");
	ОписатьКодНачисленияСтруктура(НачислениеСтруктура);
	//	

	//	Подарки:	
	НачислениеСтруктура = Новый Структура;
	НачислениеСтруктура.Вставить("Код","10013");
	НачислениеСтруктура.Вставить("Наименование","Подарки");
	НачислениеСтруктура.Вставить("ИмяПредопределенныхДанных","Подарки");
  	НачислениеСтруктура.Вставить("РайонныйКоэффициент",Ложь);
	НачислениеСтруктура.Вставить("СевернаяНадбавка",Ложь);
	НачислениеСтруктура.Вставить("Налог",Истина);
	НачислениеСтруктура.Вставить("Отпуск",Ложь);
	НачислениеСтруктура.Вставить("БольничныйЛист",Истина);
	НачислениеСтруктура.Вставить("Дебет",Дебет_99_1);
	НачислениеСтруктура.Вставить("ВПроцентах",Ложь);
	НачислениеСтруктура.Вставить("Взносы",Истина);
	НачислениеСтруктура.Вставить("ФондТравматизма",Ложь);
	НачислениеСтруктура.Вставить("Ст9ФЗ212",Ложь);
	НачислениеСтруктура.Вставить("МатериальнаяПомощь",Ложь);
	НачислениеСтруктура.Вставить("ДоходНДФЛ",ДоходНДФЛ_2720);
	НачислениеСтруктура.Вставить("ВычетНДФЛ",Справочники.инкВычетыНДФЛ.Код501);
	НачислениеСтруктура.Вставить("КодВСтаройПрограмме","00077");
	ОписатьКодНачисленияСтруктура(НачислениеСтруктура);
	//	

	//	Оплата очередных отпусков:	
	НачислениеСтруктура = Новый Структура;
	НачислениеСтруктура.Вставить("Код","10014");
	НачислениеСтруктура.Вставить("Наименование","Оплата очередных отпусков");
	НачислениеСтруктура.Вставить("ИмяПредопределенныхДанных","ОплатаОчередныхОтпусков");
  	НачислениеСтруктура.Вставить("РайонныйКоэффициент",Ложь);
	НачислениеСтруктура.Вставить("СевернаяНадбавка",Ложь);
	НачислениеСтруктура.Вставить("Налог",Истина);
	НачислениеСтруктура.Вставить("Отпуск",Ложь);
	НачислениеСтруктура.Вставить("БольничныйЛист",Истина);
	НачислениеСтруктура.Вставить("Дебет");
	НачислениеСтруктура.Вставить("ВПроцентах",Ложь);
	НачислениеСтруктура.Вставить("Взносы",Истина);
	НачислениеСтруктура.Вставить("ФондТравматизма",Истина);
	НачислениеСтруктура.Вставить("Ст9ФЗ212",Ложь);
	НачислениеСтруктура.Вставить("МатериальнаяПомощь",Ложь);
	НачислениеСтруктура.Вставить("ДоходНДФЛ",ДоходНДФЛ_2012);
	НачислениеСтруктура.Вставить("ВычетНДФЛ");
	НачислениеСтруктура.Вставить("КодВСтаройПрограмме","00022");
	ОписатьКодНачисленияСтруктура(НачислениеСтруктура);
	//	

	//	Компенсация за неиспользованный отпуск:	
	НачислениеСтруктура = Новый Структура;
	НачислениеСтруктура.Вставить("Код","10015");
	НачислениеСтруктура.Вставить("Наименование","Компенсация за неиспользованный отпуск");
	НачислениеСтруктура.Вставить("ИмяПредопределенныхДанных","КомпенсацияЗаНеиспользованныйОтпуск");
  	НачислениеСтруктура.Вставить("РайонныйКоэффициент",Ложь);
	НачислениеСтруктура.Вставить("СевернаяНадбавка",Ложь);
	НачислениеСтруктура.Вставить("Налог",Истина);
	НачислениеСтруктура.Вставить("Отпуск",Ложь);
	НачислениеСтруктура.Вставить("БольничныйЛист",Истина);
	НачислениеСтруктура.Вставить("Дебет");
	НачислениеСтруктура.Вставить("ВПроцентах",Ложь);
	НачислениеСтруктура.Вставить("Взносы",Истина);
	НачислениеСтруктура.Вставить("ФондТравматизма",Истина);
	НачислениеСтруктура.Вставить("Ст9ФЗ212",Ложь);
	НачислениеСтруктура.Вставить("МатериальнаяПомощь",Ложь);
	НачислениеСтруктура.Вставить("ДоходНДФЛ",Справочники.инкДоходНДФЛ.Код4800);
	НачислениеСтруктура.Вставить("ВычетНДФЛ");
	НачислениеСтруктура.Вставить("КодВСтаройПрограмме","00024");
	ОписатьКодНачисленияСтруктура(НачислениеСтруктура);
	//	

	//	Выходное пособие:	
	НачислениеСтруктура = Новый Структура;
	НачислениеСтруктура.Вставить("Код","10016");
	НачислениеСтруктура.Вставить("Наименование","Выходное пособие");
	НачислениеСтруктура.Вставить("ИмяПредопределенныхДанных","ВыходноеПособие");
  	НачислениеСтруктура.Вставить("РайонныйКоэффициент",Ложь);
	НачислениеСтруктура.Вставить("СевернаяНадбавка",Ложь);
	НачислениеСтруктура.Вставить("Налог",Ложь);
	НачислениеСтруктура.Вставить("Отпуск",Ложь);
	НачислениеСтруктура.Вставить("БольничныйЛист",Ложь);
	НачислениеСтруктура.Вставить("Дебет");
	НачислениеСтруктура.Вставить("ВПроцентах",Ложь);
	НачислениеСтруктура.Вставить("Взносы",Истина);
	НачислениеСтруктура.Вставить("ФондТравматизма",Истина);
	НачислениеСтруктура.Вставить("Ст9ФЗ212",Ложь);
	НачислениеСтруктура.Вставить("МатериальнаяПомощь",Ложь);
	НачислениеСтруктура.Вставить("ДоходНДФЛ",ДоходНДФЛ_2000);
	НачислениеСтруктура.Вставить("ВычетНДФЛ");
	НачислениеСтруктура.Вставить("КодВСтаройПрограмме","00025");
	ОписатьКодНачисленияСтруктура(НачислениеСтруктура);
	//	

	//	Сальдо:	
	НачислениеСтруктура = Новый Структура;
	НачислениеСтруктура.Вставить("Код","10017");
	НачислениеСтруктура.Вставить("Наименование","Сальдо");
	НачислениеСтруктура.Вставить("ИмяПредопределенныхДанных","Сальдо");
  	НачислениеСтруктура.Вставить("РайонныйКоэффициент",Ложь);
	НачислениеСтруктура.Вставить("СевернаяНадбавка",Ложь);
	НачислениеСтруктура.Вставить("Налог",Ложь);
	НачислениеСтруктура.Вставить("Отпуск",Ложь);
	НачислениеСтруктура.Вставить("БольничныйЛист",Ложь);
	НачислениеСтруктура.Вставить("Дебет",Дебет_69_01);
	НачислениеСтруктура.Вставить("ВПроцентах",Ложь);
	НачислениеСтруктура.Вставить("Взносы",Ложь);
	НачислениеСтруктура.Вставить("ФондТравматизма",Ложь);
	НачислениеСтруктура.Вставить("Ст9ФЗ212",Ложь);
	НачислениеСтруктура.Вставить("МатериальнаяПомощь",Ложь);
	НачислениеСтруктура.Вставить("ДоходНДФЛ",Ложь);
	НачислениеСтруктура.Вставить("ВычетНДФЛ",Ложь);
	НачислениеСтруктура.Вставить("КодВСтаройПрограмме","00070");
	ОписатьКодНачисленияСтруктура(НачислениеСтруктура);
	//	
	
КонецПроцедуры

// Процедура - Заполнить коды начислений 11 0 0 12
//
Процедура ЗаполнитьКодыНачислений_11_0_0_12() Экспорт
	
	//
	ДоходНДФЛ_2300 = Справочники.инкДоходНДФЛ.НайтиПоКоду("2300");
	//
	
КонецПроцедуры     

// Процедура - Заполнить коды начислений 11 0 0 13
//
Процедура ЗаполнитьКодыНачислений_11_0_0_13() Экспорт
	
	//
	ДоходНДФЛ_2012 = Справочники.инкДоходНДФЛ.НайтиПоКоду("2012");
	//
	
	//	Оплата по среднему заработку:
	НачислениеСтруктура = Новый Структура;
	НачислениеСтруктура.Вставить("Код","10019");
	НачислениеСтруктура.Вставить("Наименование","Оплата по среднему заработку");
	НачислениеСтруктура.Вставить("ИмяПредопределенныхДанных","ОплатаПоСреднемуЗаработку");
  	НачислениеСтруктура.Вставить("РайонныйКоэффициент",Ложь);
	НачислениеСтруктура.Вставить("СевернаяНадбавка",Ложь);
	НачислениеСтруктура.Вставить("Налог",Истина);
	НачислениеСтруктура.Вставить("Отпуск",Ложь);
	НачислениеСтруктура.Вставить("БольничныйЛист",Истина);
	НачислениеСтруктура.Вставить("Дебет");
	НачислениеСтруктура.Вставить("ВПроцентах",Ложь);
	НачислениеСтруктура.Вставить("Взносы",Истина);
	НачислениеСтруктура.Вставить("ФондТравматизма",Истина);
	НачислениеСтруктура.Вставить("Ст9ФЗ212",Ложь);
	НачислениеСтруктура.Вставить("МатериальнаяПомощь",Ложь);
	НачислениеСтруктура.Вставить("ДоходНДФЛ",ДоходНДФЛ_2012);
	НачислениеСтруктура.Вставить("ВычетНДФЛ");
	НачислениеСтруктура.Вставить("КодВСтаройПрограмме","");
	ОписатьКодНачисленияСтруктура(НачислениеСтруктура);
	//		
	
КонецПроцедуры     
                                           
// Процедура - Заполнить коды начислений 11 0 1 3
//
Процедура ЗаполнитьКодыНачислений_11_0_1_3() Экспорт
	
	//
	ДоходНДФЛ_2000 = Справочники.инкДоходНДФЛ.НайтиПоКоду("2000");
	//
	
	//	Оплата по среднему заработку:
	НачислениеСтруктура = Новый Структура;
	НачислениеСтруктура.Вставить("Код","10020");
	НачислениеСтруктура.Вставить("Наименование","Командировка");
	НачислениеСтруктура.Вставить("ИмяПредопределенныхДанных","Командировка");
  	НачислениеСтруктура.Вставить("РайонныйКоэффициент",Ложь);
	НачислениеСтруктура.Вставить("СевернаяНадбавка",Ложь);
	НачислениеСтруктура.Вставить("Налог",Истина);
	НачислениеСтруктура.Вставить("Отпуск",Истина);
	НачислениеСтруктура.Вставить("БольничныйЛист",Истина);
	НачислениеСтруктура.Вставить("Дебет");
	НачислениеСтруктура.Вставить("ВПроцентах",Ложь);
	НачислениеСтруктура.Вставить("Взносы",Истина);
	НачислениеСтруктура.Вставить("ФондТравматизма",Истина);
	НачислениеСтруктура.Вставить("Ст9ФЗ212",Ложь);
	НачислениеСтруктура.Вставить("МатериальнаяПомощь",Ложь);
	НачислениеСтруктура.Вставить("ДоходНДФЛ",ДоходНДФЛ_2000);
	НачислениеСтруктура.Вставить("ВычетНДФЛ");
	НачислениеСтруктура.Вставить("КодВСтаройПрограмме","34");
	ОписатьКодНачисленияСтруктура(НачислениеСтруктура);
	//		
	
КонецПроцедуры     

// Процедура - Заполнить коды начислений 11 0 2 2
//
Процедура ЗаполнитьКодыНачислений_11_0_2_2() Экспорт
	
	//
	ДоходНДФЛ_2300 = Справочники.инкДоходНДФЛ.НайтиПоКоду("2300");
	ДоходНДФЛ_2000 = Справочники.инкДоходНДФЛ.НайтиПоКоду("2000");
	ДоходНДФЛ_2760 = Справочники.инкДоходНДФЛ.НайтиПоКоду("2760");
	ДоходНДФЛ_2720 = Справочники.инкДоходНДФЛ.НайтиПоКоду("2720");   
	ДоходНДФЛ_2012 = Справочники.инкДоходНДФЛ.НайтиПоКоду("2012");   
	//
	Дебет_69_01	= ПланыСчетов.инкХозрасчетный.ФСС;
	Дебет_99_1  = ПланыСчетов.инкХозрасчетный.ПрибылиИУбыткиБезНалогаНаПрибыль;
	
	// Специальные начисления:
             
	// Оплата по основному окладу:
	НачислениеСтруктура = Новый Структура;
	НачислениеСтруктура.Вставить("Код","10001");
	НачислениеСтруктура.Вставить("Наименование","Оплата по основному окладу");
	НачислениеСтруктура.Вставить("ИмяПредопределенныхДанных","Оклад");
  	НачислениеСтруктура.Вставить("РайонныйКоэффициент",Истина);
	НачислениеСтруктура.Вставить("СевернаяНадбавка",Истина);
	НачислениеСтруктура.Вставить("Налог",Истина);
	НачислениеСтруктура.Вставить("Отпуск",Истина);
	НачислениеСтруктура.Вставить("БольничныйЛист",Истина);
	НачислениеСтруктура.Вставить("Дебет");
	НачислениеСтруктура.Вставить("ВПроцентах",Ложь);
	НачислениеСтруктура.Вставить("Взносы",Истина);
	НачислениеСтруктура.Вставить("ФондТравматизма",Истина);
	НачислениеСтруктура.Вставить("Ст9ФЗ212");
	НачислениеСтруктура.Вставить("МатериальнаяПомощь");
	НачислениеСтруктура.Вставить("ДоходНДФЛ",ДоходНДФЛ_2000);
	НачислениеСтруктура.Вставить("ВычетНДФЛ");
	НачислениеСтруктура.Вставить("КодВСтаройПрограмме","00001");
	ОписатьКодНачисленияСтруктура(НачислениеСтруктура); 
	
	//	Районный коэффициент:
	НачислениеСтруктура = Новый Структура;
	НачислениеСтруктура.Вставить("Код","10013");
	НачислениеСтруктура.Вставить("Наименование","Районный коэффициент");
	НачислениеСтруктура.Вставить("ИмяПредопределенныхДанных","РайонныйКоэффициент");
  	НачислениеСтруктура.Вставить("РайонныйКоэффициент",Ложь);
	НачислениеСтруктура.Вставить("СевернаяНадбавка",Ложь);
	НачислениеСтруктура.Вставить("Налог",Истина);
	НачислениеСтруктура.Вставить("Отпуск",Истина);
	НачислениеСтруктура.Вставить("БольничныйЛист",Истина);
	НачислениеСтруктура.Вставить("Дебет");
	НачислениеСтруктура.Вставить("ВПроцентах");
	НачислениеСтруктура.Вставить("Взносы",Истина);
	НачислениеСтруктура.Вставить("ФондТравматизма",Истина);
	НачислениеСтруктура.Вставить("Ст9ФЗ212");
	НачислениеСтруктура.Вставить("МатериальнаяПомощь");
	НачислениеСтруктура.Вставить("ДоходНДФЛ",ДоходНДФЛ_2000);
	НачислениеСтруктура.Вставить("ВычетНДФЛ");
	НачислениеСтруктура.Вставить("КодВСтаройПрограмме","00013");
	ОписатьКодНачисленияСтруктура(НачислениеСтруктура); 
	
	// Северная надбавка за стаж работы в РКС/МКС:	
	НачислениеСтруктура = Новый Структура;
	НачислениеСтруктура.Вставить("Код","10014");
	НачислениеСтруктура.Вставить("Наименование","Северная надбавка за стаж работы в РКС/МКС");
	НачислениеСтруктура.Вставить("ИмяПредопределенныхДанных","СевернаяНадбавка");
  	НачислениеСтруктура.Вставить("РайонныйКоэффициент",Ложь);
	НачислениеСтруктура.Вставить("СевернаяНадбавка",Ложь);
	НачислениеСтруктура.Вставить("Налог",Истина);
	НачислениеСтруктура.Вставить("Отпуск",Истина);
	НачислениеСтруктура.Вставить("БольничныйЛист",Истина);
	НачислениеСтруктура.Вставить("Дебет");
	НачислениеСтруктура.Вставить("ВПроцентах",Ложь);
	НачислениеСтруктура.Вставить("Взносы",Истина);
	НачислениеСтруктура.Вставить("ФондТравматизма",Истина);
	НачислениеСтруктура.Вставить("Ст9ФЗ212");
	НачислениеСтруктура.Вставить("МатериальнаяПомощь");
	НачислениеСтруктура.Вставить("ДоходНДФЛ",ДоходНДФЛ_2000);
	НачислениеСтруктура.Вставить("ВычетНДФЛ");
	НачислениеСтруктура.Вставить("КодВСтаройПрограмме","00014"); 
	ОписатьКодНачисленияСтруктура(НачислениеСтруктура);
	
	//
	//	Пособие по врем нетрудоспособности за счет работодателя:
	НачислениеСтруктура = Новый Структура;
	НачислениеСтруктура.Вставить("Код","10019");
	НачислениеСтруктура.Вставить("Наименование","Пособие по врем нетрудоспособности за счет. работ-я");
	НачислениеСтруктура.Вставить("ИмяПредопределенныхДанных","ПособиеПоВремНетрудоспособностиЗаСчетРаботодателя");
  	НачислениеСтруктура.Вставить("РайонныйКоэффициент",Ложь);
	НачислениеСтруктура.Вставить("СевернаяНадбавка",Ложь);
	НачислениеСтруктура.Вставить("Налог",Ложь);
	НачислениеСтруктура.Вставить("Отпуск",Ложь);
	НачислениеСтруктура.Вставить("БольничныйЛист",Ложь);
	НачислениеСтруктура.Вставить("Дебет");
	НачислениеСтруктура.Вставить("ВПроцентах");
	НачислениеСтруктура.Вставить("Взносы",Истина);
	НачислениеСтруктура.Вставить("ФондТравматизма",Ложь);
	НачислениеСтруктура.Вставить("Ст9ФЗ212",Истина);
	НачислениеСтруктура.Вставить("МатериальнаяПомощь");
	НачислениеСтруктура.Вставить("ДоходНДФЛ",ДоходНДФЛ_2300);
	НачислениеСтруктура.Вставить("ВычетНДФЛ");
	НачислениеСтруктура.Вставить("КодВСтаройПрограмме","00026");
	ОписатьКодНачисленияСтруктура(НачислениеСтруктура);
	//	
	
	//	Пособие на погребение:	
	НачислениеСтруктура = Новый Структура;
	НачислениеСтруктура.Вставить("Код","10031");
	НачислениеСтруктура.Вставить("Наименование","Пособие на погребение");
	НачислениеСтруктура.Вставить("ИмяПредопределенныхДанных","ПособиеНаПогребение");
  	НачислениеСтруктура.Вставить("РайонныйКоэффициент",Ложь);
	НачислениеСтруктура.Вставить("СевернаяНадбавка",Ложь);
	НачислениеСтруктура.Вставить("Налог",Ложь);
	НачислениеСтруктура.Вставить("Отпуск",Ложь);
	НачислениеСтруктура.Вставить("БольничныйЛист",Ложь);
	НачислениеСтруктура.Вставить("Дебет",Дебет_69_01);
	НачислениеСтруктура.Вставить("ВПроцентах",Ложь);
	НачислениеСтруктура.Вставить("Взносы",Истина);
	НачислениеСтруктура.Вставить("ФондТравматизма",Ложь);
	НачислениеСтруктура.Вставить("Ст9ФЗ212",Истина);
	НачислениеСтруктура.Вставить("МатериальнаяПомощь",Ложь);
	НачислениеСтруктура.Вставить("ДоходНДФЛ",ДоходНДФЛ_2000);
	НачислениеСтруктура.Вставить("ВычетНДФЛ");
	НачислениеСтруктура.Вставить("КодВСтаройПрограмме","00031");
	ОписатьКодНачисленияСтруктура(НачислениеСтруктура);
	//	

	//	Оплата доп. вых. для ухода за детьми инв:	
	НачислениеСтруктура = Новый Структура;
	НачислениеСтруктура.Вставить("Код","10033");
	НачислениеСтруктура.Вставить("Наименование","Оплата доп. вых. для ухода за детьми инв");
	НачислениеСтруктура.Вставить("ИмяПредопределенныхДанных","ОплатаДопВыходныхДляУходаЗаДетьмиИнвалидами");
  	НачислениеСтруктура.Вставить("РайонныйКоэффициент",Ложь);
	НачислениеСтруктура.Вставить("СевернаяНадбавка",Ложь);
	НачислениеСтруктура.Вставить("Налог",Ложь);
	НачислениеСтруктура.Вставить("Отпуск",Ложь);
	НачислениеСтруктура.Вставить("БольничныйЛист",Ложь);
	НачислениеСтруктура.Вставить("Дебет",ДоходНДФЛ_2000);
	НачислениеСтруктура.Вставить("ВПроцентах",Ложь);
	НачислениеСтруктура.Вставить("Взносы",Истина);
	НачислениеСтруктура.Вставить("ФондТравматизма",Ложь);
	НачислениеСтруктура.Вставить("Ст9ФЗ212",Истина);
	НачислениеСтруктура.Вставить("МатериальнаяПомощь",Ложь);
	НачислениеСтруктура.Вставить("ДоходНДФЛ",ДоходНДФЛ_2000);
	НачислениеСтруктура.Вставить("ВычетНДФЛ");
	НачислениеСтруктура.Вставить("КодВСтаройПрограмме","00033");
	ОписатьКодНачисленияСтруктура(НачислениеСтруктура);	
	//	

	//	Матер. помощь ст. 217 п. 28 НК:	
	НачислениеСтруктура = Новый Структура;
	НачислениеСтруктура.Вставить("Код","10051");
	НачислениеСтруктура.Вставить("Наименование","Матер. помощь ст. 217 п. 28 НК");
	НачислениеСтруктура.Вставить("ИмяПредопределенныхДанных","МатПом217п28НК");
  	НачислениеСтруктура.Вставить("РайонныйКоэффициент",Ложь);
	НачислениеСтруктура.Вставить("СевернаяНадбавка",Ложь);
	НачислениеСтруктура.Вставить("Налог",Истина);
	НачислениеСтруктура.Вставить("Отпуск",Ложь);
	НачислениеСтруктура.Вставить("БольничныйЛист",Ложь);
	НачислениеСтруктура.Вставить("Дебет",Дебет_99_1);
	НачислениеСтруктура.Вставить("ВПроцентах",Ложь);
	НачислениеСтруктура.Вставить("Взносы",Истина);
	НачислениеСтруктура.Вставить("ФондТравматизма",Ложь);
	НачислениеСтруктура.Вставить("Ст9ФЗ212",Ложь);
	НачислениеСтруктура.Вставить("МатериальнаяПомощь",Истина);
	НачислениеСтруктура.Вставить("ДоходНДФЛ",ДоходНДФЛ_2760);
	НачислениеСтруктура.Вставить("ВычетНДФЛ",Справочники.инкВычетыНДФЛ.Код503);
	НачислениеСтруктура.Вставить("КодВСтаройПрограмме","00051");
	ОписатьКодНачисленияСтруктура(НачислениеСтруктура);
	//	

	//	Подарки:	
	НачислениеСтруктура = Новый Структура;
	НачислениеСтруктура.Вставить("Код","10077");
	НачислениеСтруктура.Вставить("Наименование","Подарки");
	НачислениеСтруктура.Вставить("ИмяПредопределенныхДанных","Подарки");
  	НачислениеСтруктура.Вставить("РайонныйКоэффициент",Ложь);
	НачислениеСтруктура.Вставить("СевернаяНадбавка",Ложь);
	НачислениеСтруктура.Вставить("Налог",Истина);
	НачислениеСтруктура.Вставить("Отпуск",Ложь);
	НачислениеСтруктура.Вставить("БольничныйЛист",Истина);
	НачислениеСтруктура.Вставить("Дебет",Дебет_99_1);
	НачислениеСтруктура.Вставить("ВПроцентах",Ложь);
	НачислениеСтруктура.Вставить("Взносы",Истина);
	НачислениеСтруктура.Вставить("ФондТравматизма",Ложь);
	НачислениеСтруктура.Вставить("Ст9ФЗ212",Ложь);
	НачислениеСтруктура.Вставить("МатериальнаяПомощь",Ложь);
	НачислениеСтруктура.Вставить("ДоходНДФЛ",ДоходНДФЛ_2720);
	НачислениеСтруктура.Вставить("ВычетНДФЛ",Справочники.инкВычетыНДФЛ.Код501);
	НачислениеСтруктура.Вставить("КодВСтаройПрограмме","00077");
	ОписатьКодНачисленияСтруктура(НачислениеСтруктура);
	//	

	//	Оплата очередных отпусков:	
	НачислениеСтруктура = Новый Структура;
	НачислениеСтруктура.Вставить("Код","10022");
	НачислениеСтруктура.Вставить("Наименование","Оплата очередных отпусков");
	НачислениеСтруктура.Вставить("ИмяПредопределенныхДанных","ОплатаОчередныхОтпусков");
  	НачислениеСтруктура.Вставить("РайонныйКоэффициент",Ложь);
	НачислениеСтруктура.Вставить("СевернаяНадбавка",Ложь);
	НачислениеСтруктура.Вставить("Налог",Истина);
	НачислениеСтруктура.Вставить("Отпуск",Ложь);
	НачислениеСтруктура.Вставить("БольничныйЛист",Истина);
	НачислениеСтруктура.Вставить("Дебет");
	НачислениеСтруктура.Вставить("ВПроцентах",Ложь);
	НачислениеСтруктура.Вставить("Взносы",Истина);
	НачислениеСтруктура.Вставить("ФондТравматизма",Истина);
	НачислениеСтруктура.Вставить("Ст9ФЗ212",Ложь);
	НачислениеСтруктура.Вставить("МатериальнаяПомощь",Ложь);
	НачислениеСтруктура.Вставить("ДоходНДФЛ",ДоходНДФЛ_2012);
	НачислениеСтруктура.Вставить("ВычетНДФЛ");
	НачислениеСтруктура.Вставить("КодВСтаройПрограмме","00022");
	ОписатьКодНачисленияСтруктура(НачислениеСтруктура);
	//	

	//	Компенсация за неиспользованный отпуск:	
	НачислениеСтруктура = Новый Структура;
	НачислениеСтруктура.Вставить("Код","10024");
	НачислениеСтруктура.Вставить("Наименование","Компенсация за неиспользованный отпуск");
	НачислениеСтруктура.Вставить("ИмяПредопределенныхДанных","КомпенсацияЗаНеиспользованныйОтпуск");
  	НачислениеСтруктура.Вставить("РайонныйКоэффициент",Ложь);
	НачислениеСтруктура.Вставить("СевернаяНадбавка",Ложь);
	НачислениеСтруктура.Вставить("Налог",Истина);
	НачислениеСтруктура.Вставить("Отпуск",Ложь);
	НачислениеСтруктура.Вставить("БольничныйЛист",Истина);
	НачислениеСтруктура.Вставить("Дебет");
	НачислениеСтруктура.Вставить("ВПроцентах",Ложь);
	НачислениеСтруктура.Вставить("Взносы",Истина);
	НачислениеСтруктура.Вставить("ФондТравматизма",Истина);
	НачислениеСтруктура.Вставить("Ст9ФЗ212",Ложь);
	НачислениеСтруктура.Вставить("МатериальнаяПомощь",Ложь);
	НачислениеСтруктура.Вставить("ДоходНДФЛ",Справочники.инкДоходНДФЛ.Код4800);
	НачислениеСтруктура.Вставить("ВычетНДФЛ");
	НачислениеСтруктура.Вставить("КодВСтаройПрограмме","00024");
	ОписатьКодНачисленияСтруктура(НачислениеСтруктура);
	//	

	//	Выходное пособие:	
	НачислениеСтруктура = Новый Структура;
	НачислениеСтруктура.Вставить("Код","10025");
	НачислениеСтруктура.Вставить("Наименование","Выходное пособие");
	НачислениеСтруктура.Вставить("ИмяПредопределенныхДанных","ВыходноеПособие");
  	НачислениеСтруктура.Вставить("РайонныйКоэффициент",Ложь);
	НачислениеСтруктура.Вставить("СевернаяНадбавка",Ложь);
	НачислениеСтруктура.Вставить("Налог",Ложь);
	НачислениеСтруктура.Вставить("Отпуск",Ложь);
	НачислениеСтруктура.Вставить("БольничныйЛист",Ложь);
	НачислениеСтруктура.Вставить("Дебет");
	НачислениеСтруктура.Вставить("ВПроцентах",Ложь);
	НачислениеСтруктура.Вставить("Взносы",Истина);
	НачислениеСтруктура.Вставить("ФондТравматизма",Истина);
	НачислениеСтруктура.Вставить("Ст9ФЗ212",Ложь);
	НачислениеСтруктура.Вставить("МатериальнаяПомощь",Ложь);
	НачислениеСтруктура.Вставить("ДоходНДФЛ",ДоходНДФЛ_2000);
	НачислениеСтруктура.Вставить("ВычетНДФЛ");
	НачислениеСтруктура.Вставить("КодВСтаройПрограмме","00025");
	ОписатьКодНачисленияСтруктура(НачислениеСтруктура);
	//	

	//	Сальдо:	
	НачислениеСтруктура = Новый Структура;
	НачислениеСтруктура.Вставить("Код","10070");
	НачислениеСтруктура.Вставить("Наименование","Сальдо");
	НачислениеСтруктура.Вставить("ИмяПредопределенныхДанных","Сальдо");
  	НачислениеСтруктура.Вставить("РайонныйКоэффициент",Ложь);
	НачислениеСтруктура.Вставить("СевернаяНадбавка",Ложь);
	НачислениеСтруктура.Вставить("Налог",Ложь);
	НачислениеСтруктура.Вставить("Отпуск",Ложь);
	НачислениеСтруктура.Вставить("БольничныйЛист",Ложь);
	НачислениеСтруктура.Вставить("Дебет",Дебет_69_01);
	НачислениеСтруктура.Вставить("ВПроцентах",Ложь);
	НачислениеСтруктура.Вставить("Взносы",Ложь);
	НачислениеСтруктура.Вставить("ФондТравматизма",Ложь);
	НачислениеСтруктура.Вставить("Ст9ФЗ212",Ложь);
	НачислениеСтруктура.Вставить("МатериальнаяПомощь",Ложь);
	НачислениеСтруктура.Вставить("ДоходНДФЛ",Ложь);
	НачислениеСтруктура.Вставить("ВычетНДФЛ",Ложь);
	НачислениеСтруктура.Вставить("КодВСтаройПрограмме","00070");
	ОписатьКодНачисленияСтруктура(НачислениеСтруктура);
	//	
	//		
	
КонецПроцедуры     

Процедура ОписатьКодНачисления(ИмяПредопределенныхДанных,Код,Наименование,ВПроцентах,РайонныйКоэффициент,СевернаяНадбавка,Налог,Отпуск,БольничныйЛист,Взносы,Ст9ФЗ212,МатериальнаяПомощь,ФондТравматизма,ДоходНДФЛ,ВычетНДФЛ,Дебет,КодВСтаройПрограмме = "") 

	СсылкаПредопределенного = ОбщегоНазначения.ПредопределенныйЭлемент("ПланВидовРасчета.инкНачисления." + ИмяПредопределенныхДанных);
	Если ЗначениеЗаполнено(СсылкаПредопределенного) Тогда
		Элемент = СсылкаПредопределенного.ПолучитьОбъект();                                      
	Иначе
		Элемент = ПланыВидовРасчета.инкНачисления.СоздатьВидРасчета();
		Элемент.ИмяПредопределенныхДанных = ИмяПредопределенныхДанных;                    
	КонецЕсли;
	
	Если Элемент.Код <> Код Тогда
		Элемент.Код = Код
	КонецЕсли;
	Если Элемент.Наименование <> Наименование Тогда
		Элемент.Наименование = Наименование
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ВПроцентах) Тогда
		Элемент.ВПроцентах = ВПроцентах;
	КонецЕсли; 
	Если ЗначениеЗаполнено(РайонныйКоэффициент) Тогда
		Элемент.РайонныйКоэффициент = РайонныйКоэффициент;
	КонецЕсли; 
	Если ЗначениеЗаполнено(СевернаяНадбавка) Тогда
		Элемент.СевернаяНадбавка = СевернаяНадбавка;
	КонецЕсли;             		
	Если ЗначениеЗаполнено(Налог) Тогда
		Элемент.Налог = Налог;
	КонецЕсли; 
	Если ЗначениеЗаполнено(Отпуск) Тогда
		Элемент.Отпуск = Отпуск;
	КонецЕсли; 
	Если ЗначениеЗаполнено(БольничныйЛист) Тогда
		Элемент.БольничныйЛист = БольничныйЛист;
	КонецЕсли; 
	Если ЗначениеЗаполнено(Взносы) Тогда
		Элемент.Взносы = Взносы;
	КонецЕсли; 
	Если ЗначениеЗаполнено(Ст9ФЗ212) Тогда
		Элемент.Ст9ФЗ212 = Ст9ФЗ212;
	КонецЕсли; 
	Если ЗначениеЗаполнено(МатериальнаяПомощь) Тогда
		Элемент.МатериальнаяПомощь = МатериальнаяПомощь;
	КонецЕсли; 
	Если ЗначениеЗаполнено(ФондТравматизма) Тогда
		Элемент.ФондТравматизма = ФондТравматизма;
	КонецЕсли; 
	Если ЗначениеЗаполнено(ДоходНДФЛ) Тогда
		Элемент.ДоходНДФЛ = ДоходНДФЛ;
	КонецЕсли; 
	Если ЗначениеЗаполнено(ВычетНДФЛ) Тогда
		Элемент.ВычетНДФЛ = ВычетНДФЛ;
	КонецЕсли; 
	Если ЗначениеЗаполнено(Дебет) Тогда
		Элемент.Дебет = Дебет;
	КонецЕсли; 
									   
	Если Элемент.Модифицированность() Тогда
		Элемент.ОбменДанными.Загрузка = Истина;
		Элемент.Записать();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОписатьКодНачисленияСтруктура(НачислениеСтруктура) 

	СсылкаПредопределенного = ОбщегоНазначения.ПредопределенныйЭлемент("ПланВидовРасчета.инкНачисления." + НачислениеСтруктура.ИмяПредопределенныхДанных);
	Если ЗначениеЗаполнено(СсылкаПредопределенного) Тогда
		Элемент = СсылкаПредопределенного.ПолучитьОбъект();                                      
	Иначе
		Элемент = ПланыВидовРасчета.инкНачисления.СоздатьВидРасчета();
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(Элемент,НачислениеСтруктура);	
	Элемент.Записать();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
// Код процедур и функций
#КонецОбласти

#КонецЕсли





             