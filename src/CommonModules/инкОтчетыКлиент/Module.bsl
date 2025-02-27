
#Область ОписаниеПеременных

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Получить табличный документ на основании таблицы значений
//
// Параметры:
//  Таблица     - ТаблицаЗначений 
// 
// Возвращаемое значение:
//  ТабличныйДокумент 
//
Функция ПолучитьТабличныйДокумент(Таблица) Экспорт
    
    ТабДокумент = Новый ТабличныйДокумент;
    
    // Выводим заголовок таблицы
    КолонкаИндекс = 0;
    Пока КолонкаИндекс < Таблица.Колонки.Количество() Цикл
        Колонка = Таблица.Колонки[КолонкаИндекс];
        ТабДокумент.Область(1, КолонкаИндекс + 1, 1, КолонкаИндекс + 1).Текст = Колонка.Имя;  
        КолонкаИндекс = КолонкаИндекс + 1;
    КонецЦикла;
    
    // Выводим строки таблицы
    СтрокаИндекс = 0;
    Пока СтрокаИндекс < Таблица.Количество() Цикл
        Таблица_Строка = Таблица[СтрокаИндекс];
        КолонкаИндекс = 0;
        Пока КолонкаИндекс < Таблица.Колонки.Количество() Цикл
            Колонка = Таблица.Колонки[КолонкаИндекс];
            ТабДокумент.Область(СтрокаИндекс + 2, КолонкаИндекс + 1, СтрокаИндекс + 2, КолонкаИндекс + 1).Текст = Формат(Таблица_Строка[Колонка.Имя], "ЧГ=0");
            КолонкаИндекс = КолонкаИндекс + 1;
        КонецЦикла;        
        СтрокаИндекс = СтрокаИндекс + 1;
    КонецЦикла;
    
    Возврат ТабДокумент;
    
КонецФункции

// Процедура - Печать табличного документа
//
// Параметры:
//  ТабличныйДокумент	 - ТабличныйДокумент	 - Табличный документ для печати
//  ЗаголовокОтчета		 - Строка	 - Заголовок отчета
//  Форма				 - Форма	 - Форма которая вызывает печать
//
Процедура ПечатьТабличногоДокумента(ТабличныйДокумент,ЗаголовокОтчета,Форма) Экспорт
	
	Если ТабличныйДокумент = Неопределено Тогда
		Возврат;
	КонецЕсли;

	// Создаём новую коллекцию печатных форм
	КоллекцияПечатныхФорм = УправлениеПечатьюКлиент.НоваяКоллекцияПечатныхФорм(ЗаголовокОтчета);
	
	// Добавляем в коллекцию сформированный табличный документ
	КоллекцияПечатныхФорм[0].ТабличныйДокумент = ТабличныйДокумент;
	
	// Устанавливаем параметры печати (при необходимости)
	КоллекцияПечатныхФорм[0].Экземпляров = 1;
	КоллекцияПечатныхФорм[0].СинонимМакета = ЗаголовокОтчета;  // Так будет выглядеть имя файла при сохранении в файл из формы "Печать документов"
	
	// Вывод через стандартную процедуру БСП
 	УправлениеПечатьюКлиент.ПечатьДокументов(КоллекцияПечатныхФорм, Неопределено, Форма);
	
КонецПроцедуры

// Выполняет расчет и вывод показателей выделенных областей ячеек табличного документа.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, в которой выводятся значения расчетных показателей.
//  ИмяТабличногоДокумента - Строка - имя реквизита формы типа ТабличныйДокумент, показатели которого рассчитываются.
//  ТекущаяКоманда - Строка - имя команды расчета показателя, например, "РассчитатьСумму".
//                      Определяет, какой показатель является основным.
//
Процедура РассчитатьПоказатели(Форма, ИмяТабличногоДокумента, ТекущаяКоманда = "") Экспорт 
	
	Элементы = Форма.Элементы;
	ТабличныйДокумент = Форма[ИмяТабличногоДокумента];
	ПолеТабличногоДокумента = Элементы[ИмяТабличногоДокумента];
	
	// Расчет показателей.
	РасчетныеПоказатели = ОбщегоНазначенияКлиентСервер.РасчетныеПоказателиЯчеек(
		ТабличныйДокумент, ПолеТабличногоДокумента);
	
	// Установка значений показателей.
	ЗаполнитьЗначенияСвойств(Форма, РасчетныеПоказатели);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий
// Код процедур и функций
#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс
// Код процедур и функций
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
// Код процедур и функций
#КонецОбласти

#Область Инициализация

#КонецОбласти
