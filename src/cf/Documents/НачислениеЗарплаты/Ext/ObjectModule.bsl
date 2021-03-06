
Процедура Рассчитать() Экспорт
	
	НачатьТранзакцию();
	
	Движения.ОсновныеНачисления.Записывать = Истина;
	Движения.ДополнительныеНачисления.Записывать = Истина;
	
	// Запрос для формирования рабочих наборов записей
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НачислениеЗарплатыОсновныеНачисления.Сотрудник КАК Сотрудник,
	|	НачислениеЗарплатыОсновныеНачисления.ВидРасчета КАК ВидРасчета,
	|	НачислениеЗарплатыОсновныеНачисления.ДатаНачала КАК ПериодДействияНачало,
	|	НачислениеЗарплатыОсновныеНачисления.ДатаОкончания КАК ПериодДействияКонец,
	|	НачислениеЗарплатыОсновныеНачисления.График КАК График,
	|	НачислениеЗарплатыОсновныеНачисления.НомерСтроки КАК НомерСтроки
	|ПОМЕСТИТЬ ВТ_ДанныеПоОкладу
	|ИЗ
	|	Документ.НачислениеЗарплаты.ОсновныеНачисления КАК НачислениеЗарплатыОсновныеНачисления
	|ГДЕ
	|	НачислениеЗарплатыОсновныеНачисления.ВидРасчета = &ВидРасчетаОклад
	|	И НачислениеЗарплатыОсновныеНачисления.Ссылка = &Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Сотрудник
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ДанныеПоОкладу.Сотрудник КАК Сотрудник,
	|	ВТ_ДанныеПоОкладу.ВидРасчета КАК ВидРасчета,
	|	ВТ_ДанныеПоОкладу.ПериодДействияНачало КАК ПериодДействияНачало,
	|	ВТ_ДанныеПоОкладу.ПериодДействияКонец КАК ПериодДействияКонец,
	|	&ПериодРегистрации КАК ПериодРегистрации,
	|	ЕСТЬNULL(СведенияОСотрудникахСрезПоследних.Оклад, 0) КАК Параметр,
	|	ВТ_ДанныеПоОкладу.График КАК График,
	|	ВТ_ДанныеПоОкладу.НомерСтроки КАК НомерСтроки
	|ИЗ
	|	ВТ_ДанныеПоОкладу КАК ВТ_ДанныеПоОкладу
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СведенияОСотрудниках.СрезПоследних(
	|				&ПериодРегистрации,
	|				Сотрудник В
	|					(ВЫБРАТЬ
	|						ВТ_ДанныеПоОкладу.Сотрудник КАК Сотрудник
	|					ИЗ
	|						ВТ_ДанныеПоОкладу КАК ВТ_ДанныеПоОкладу)) КАК СведенияОСотрудникахСрезПоследних
	|		ПО ВТ_ДанныеПоОкладу.Сотрудник = СведенияОСотрудникахСрезПоследних.Сотрудник
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НачислениеЗарплатыДополнительныеНачисления.Сотрудник КАК Сотрудник,
	|	НачислениеЗарплатыДополнительныеНачисления.ВидРасчета КАК ВидРасчета,
	|	&ПериодРегистрации КАК БазовыйПериодНачало,
	|	КОНЕЦПЕРИОДА(&ПериодРегистрации, МЕСЯЦ) КАК БазовыйПериодКонец,
	|	РАЗНОСТЬДАТ(НачислениеЗарплатыДополнительныеНачисления.Сотрудник.ДатаПриема, &ПериодРегистрации, ГОД) + НачислениеЗарплатыДополнительныеНачисления.Сотрудник.НачальныйСтаж КАК Стаж,
	|	НачислениеЗарплатыДополнительныеНачисления.НомерСтроки КАК НомерСтроки,
	|	&ПериодРегистрации КАК ПериодРегистрации,
	|	ЕСТЬNULL(ПроцентыПремии.Процент, 0) КАК Параметр
	|ИЗ
	|	Документ.НачислениеЗарплаты.ДополнительныеНачисления КАК НачислениеЗарплатыДополнительныеНачисления
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПроцентыПремии КАК ПроцентыПремии
	|		ПО (РАЗНОСТЬДАТ(НачислениеЗарплатыДополнительныеНачисления.Сотрудник.ДатаПриема, &ПериодРегистрации, ГОД) + НачислениеЗарплатыДополнительныеНачисления.Сотрудник.НачальныйСтаж >= ПроцентыПремии.СтажОт)
	|			И (РАЗНОСТЬДАТ(НачислениеЗарплатыДополнительныеНачисления.Сотрудник.ДатаПриема, &ПериодРегистрации, ГОД) + НачислениеЗарплатыДополнительныеНачисления.Сотрудник.НачальныйСтаж < ПроцентыПремии.СтажДо)
	|ГДЕ
	|	НачислениеЗарплатыДополнительныеНачисления.Ссылка = &Ссылка
	|	И НачислениеЗарплатыДополнительныеНачисления.ВидРасчета = &ВидРасчетаПремия";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ВидРасчетаОклад", ПланыВидовРасчета.ОсновныеНачисления.Оклад);
	Запрос.УстановитьПараметр("ВидРасчетаПремия", ПланыВидовРасчета.ДополнительныеНачисления.Премия);
	Запрос.УстановитьПараметр("ПериодРегистрации", НачалоМесяца(Дата));
	
	МассивПакетов = Запрос.ВыполнитьПакет();
	
	Выборка = МассивПакетов [1].Выбрать();
	Пока Выборка.Следующий() Цикл
		Движение = Движения.ОсновныеНачисления.Добавить();
		ЗаполнитьЗначенияСвойств(Движение, Выборка);
	КонецЦикла;
	
	Выборка = МассивПакетов[2].Выбрать();
	Пока Выборка.Следующий() Цикл
		Движение = Движения.ДополнительныеНачисления.Добавить();
		ЗаполнитьЗначенияСвойств(Движение, Выборка);
	КонецЦикла;
	
	// Запись рабочих наборов записей
	Движения.Записать();
	
	// В процедуре общего модуля выполняется окончательный расчет данных и заполнение табличных частей
	Расчет.РассчитатьНачисления(Ссылка, Движения, ОсновныеНачисления, ДополнительныеНачисления);   
	
	// После заполнения табличной части необходимо очистить записанные ранее движения в регистрах
	Движения.ОсновныеНачисления.Очистить();
	Движения.ОсновныеНачисления.Записать();
	
	Движения.ДополнительныеНачисления.Очистить();
	Движения.ДополнительныеНачисления.Записать();
	
	ЗафиксироватьТранзакцию();    				 
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)

	// регистр ОсновныеНачисления
	Движения.ОсновныеНачисления.Записывать = Истина;
	
	ПериодРегистрации = НачалоМесяца(Дата);
	КонецБазовогоПериодаПремии = КонецМесяца (Дата);
	
	// Данные из табличной части Основные начисления помещаем в соответствующий регистр
	Для Каждого ТекСтрокаОсновныеНачисления Из ОсновныеНачисления Цикл
		Движение = Движения.ОсновныеНачисления.Добавить();
		Движение.Сторно = Ложь;
		Движение.ВидРасчета = ТекСтрокаОсновныеНачисления.ВидРасчета;
		Движение.ПериодДействияНачало = ТекСтрокаОсновныеНачисления.ДатаНачала;
		Движение.ПериодДействияКонец = ТекСтрокаОсновныеНачисления.ДатаОкончания;
		Движение.ПериодРегистрации = ПериодРегистрации;
		Движение.Сотрудник = ТекСтрокаОсновныеНачисления.Сотрудник;
		Движение.Результат = ТекСтрокаОсновныеНачисления.Результат;
		Движение.График = ТекСтрокаОсновныеНачисления.График;
		Движение.Параметр = ТекСтрокаОсновныеНачисления.Параметр;
	КонецЦикла;

	// регистр ДополнительныеНачисления
	Движения.ДополнительныеНачисления.Записывать = Истина;
	
	// Данные из табличной части Дополнительные Начисления помещаем в соответствующий регистр
	Для Каждого ТекСтрокаДополнительныеНачисления Из ДополнительныеНачисления Цикл
		Движение = Движения.ДополнительныеНачисления.Добавить();
		Движение.Сторно = Ложь;
		Движение.ВидРасчета = ТекСтрокаДополнительныеНачисления.ВидРасчета;
		Движение.ПериодРегистрации = ПериодРегистрации;
		Движение.БазовыйПериодНачало = ПериодРегистрации;
		Движение.БазовыйПериодКонец = КонецБазовогоПериодаПремии;
		Движение.Сотрудник = ТекСтрокаДополнительныеНачисления.Сотрудник;
		Движение.Результат = ТекСтрокаДополнительныеНачисления.Результат;
		Движение.Параметр = ТекСтрокаДополнительныеНачисления.Параметр;
		Движение.Стаж = ТекСтрокаДополнительныеНачисления.Стаж;
	КонецЦикла;

КонецПроцедуры


