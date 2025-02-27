
#Область ОписаниеПеременных

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура СотрудникПриИзменении(Элемент)
	
	СотрудникПриИзмененииНаСервере();

КонецПроцедуры

&НаСервере
Процедура СотрудникПриИзмененииНаСервере()
	
	инкКадровыйУчетСервер.ЗагрузитьДанныеПоСотрудникуНаСервере(Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодСПриИзменении(Элемент)
	РасчетКоличестваДней();
КонецПроцедуры

&НаКлиенте
Процедура ПериодПОПриИзменении(Элемент)
	РасчетКоличестваДней();
КонецПроцедуры

&НаКлиенте
Процедура РасчетКоличестваДней()
	
	Объект.КоличествоДнейОтпуска = инкУчетВремениСервер.ПолучитьРазницуВДнях(Объект.ПериодС,Объект.ПериодПО,Ложь);	

КонецПроцедуры

&НаКлиенте
Процедура Печать(Команда)
	
	ТабличныйДокумент = ПолучитьТабличныйДокумент(); 
	инкОтчетыКлиент.ПечатьТабличногоДокумента(ТабличныйДокумент,"Приказ на выплату компенсации",ЭтаФорма);

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
Функция ПолучитьТабличныйДокумент()
	
	ТабличныйДокумент = Документы.инкПриказНаВыплатуКомпенсации.ПолучитьПриказНаВыплатуКомпенсации(Объект);
	
	Возврат ТабличныйДокумент; 
	
КонецФункции

#КонецОбласти
