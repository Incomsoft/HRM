///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Позволяет изменить форматы по умолчанию и установить картинки.
// Для изменения параметров формата смотрите вспомогательный метод РассылкаОтчетов.УстановитьПараметрыФормата.
// Другие примеры использования см. функцию РассылкаОтчетовПовтИсп.СписокФорматов.
//
// Параметры:
//   СписокФорматов - СписокЗначений:
//       * Значение      - ПеречислениеСсылка.ФорматыСохраненияОтчетов - ссылка формата.
//       * Представление - Строка - представление формата.
//       * Пометка       - Булево - признак того, что формат используется по умолчанию.
//       * Картинка      - Картинка - картинка формата.
//
// Пример:
//	РассылкаОтчетов.УстановитьПараметрыФормата(СписокФорматов, "HTML4", , Ложь);
//	РассылкаОтчетов.УстановитьПараметрыФормата(СписокФорматов, "XLS"  , , Истина);
//
Процедура ПереопределитьПараметрыФорматов(СписокФорматов) Экспорт
	
	
	
КонецПроцедуры

// Позволяет добавить описание кросс объектной связи типов для получателей рассылки.
// Для регистрации параметров типа см. РассылкаОтчетов.ДобавитьЭлементВТаблицуТиповПолучателей.
// Другие примеры использования см. функцию РассылкаОтчетовПовтИсп.ТаблицаТиповПолучателей.
// Важно:
//   Использовать данный механизм требуется только в том случае, если:
//   1. Требуется описать и представить несколько типов как один (как в справочнике Пользователи и Группы
//   пользователей).
//   2. Требуется изменить представление типа без изменения синонима метаданных.
//   3. Требуется указать вид контактной информации E-Mail по умолчанию.
//   4. Требуется определить группу контактной информации.
//
// Параметры:
//   ТаблицаТипов  - ТаблицаЗначений - таблица описания типов.
//   ДоступныеТипы - Массив - доступные типы.
//
// Пример:
//	Настройки = Новый Структура;
//	Настройки.Вставить("ОсновнойТип", Тип("СправочникСсылка.Контрагенты"));
//	Настройки.Вставить("ВидКИ", УправлениеКонтактнойИнформацией.ВидКонтактнойИнформацииПоИмени("EmailКонтрагента"));
//	РассылкаОтчетов.ДобавитьЭлементВТаблицуТиповПолучателей(ТаблицаТипов, ДоступныеТипы, Настройки);
//
Процедура ПереопределитьТаблицуТиповПолучателей(ТаблицаТипов, ДоступныеТипы) Экспорт
	
КонецПроцедуры

// Позволяет определить свой обработчик для сохранения табличного документа в формат.
// Важно:
//   Если используется нестандартная обработка (СтандартнаяОбработка меняется на Ложь),
//   тогда ПолноеИмяФайла должно содержать полное имя файла с расширением.
//
// Параметры:
//   СтандартнаяОбработка - Булево - признак использования стандартных механизмов подсистемы для сохранения в формат.
//   ТабличныйДокумент    - ТабличныйДокумент - сохраняемый табличный документ.
//   Формат               - ПеречислениеСсылка.ФорматыСохраненияОтчетов - формат, в котором сохраняется табличный
//                                                                        документ.
//   ПолноеИмяФайла       - Строка - полное имя файла.
//       Передается без расширения, если формат был добавлен в прикладной конфигурации.
//
// Пример:
//	Если Формат = Перечисления.ФорматыСохраненияОтчетов.HTML4 Тогда
//		СтандартнаяОбработка = Ложь;
//		ПолноеИмяФайла = ПолноеИмяФайла +".html";
//		ТабличныйДокумент.Записать(ПолноеИмяФайла, ТипФайлаТабличногоДокумента.HTML4);
//	КонецЕсли;
//
Процедура ПередСохранениемТабличногоДокументаВФормат(СтандартнаяОбработка, ТабличныйДокумент, Формат, ПолноеИмяФайла) Экспорт
	
	
	
КонецПроцедуры

// Позволяет определить свой обработчик формирования списка получателей.
//
// Параметры:
//   ПараметрыПолучателей - Структура - параметры формирования получателей рассылки.
//   Запрос - Запрос - запрос, который будет использован, если значение параметра СтандартнаяОбработка останется Истина.
//   СтандартнаяОбработка - Булево - признак использования стандартных механизмов.
//   Результат - Соответствие - получатели с их E-mail адресами:
//       * Ключ     - СправочникСсылка - получатель.
//       * Значение - Строка - набор E-mail адресов в строке с разделителями.
// 
Процедура ПередФормированиемСпискаПолучателейРассылки(ПараметрыПолучателей, Запрос, СтандартнаяОбработка, Результат) Экспорт
	
КонецПроцедуры

// Позволяет исключить отчеты, которые не готовы к интеграции с рассылкой.
//   Указанные отчеты используются в качестве исключающего фильтра при выборе отчетов.
//
// Параметры:
//   ИсключаемыеОтчеты - Массив - список отчетов в виде объектов с типом ОбъектМетаданных: Отчет,
//                       подключенные к хранилищу "ВариантыОтчетов", но не поддерживающие интеграцию с рассылками.
//
Процедура ОпределитьИсключаемыеОтчеты(ИсключаемыеОтчеты) Экспорт
	
	
	
КонецПроцедуры

// Позволяет переопределить параметры формирования рассылаемого отчета.
//
// Параметры:
//  ПараметрыФормирования - Структура:
//    * ПользовательскиеНастройкиКД - ПользовательскиеНастройкиКомпоновкиДанных - настройки отчета,
//                                    установленные для соответствующей рассылки.
//  ДополнительныеПараметры - Структура:
//    * Отчет - СправочникСсылка.ВариантыОтчетов - ссылка на хранилище настроек варианта рассылаемого отчета.
//    * Объект - ОтчетОбъект - объект рассылаемого отчета.
//    * СКД - Булево - признак того, что отчет строится посредством системы компоновки данных.
//    * КомпоновщикНастроекКД - КомпоновщикНастроекКомпоновкиДанных - компоновщик настроек рассылаемого отчета.
//
Процедура ПриПодготовкеПараметровФормированияОтчета(ПараметрыФормирования, ДополнительныеПараметры) Экспорт 
	
	
	
КонецПроцедуры

#КонецОбласти
