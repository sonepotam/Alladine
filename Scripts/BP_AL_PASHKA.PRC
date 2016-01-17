CREATE OR REPLACE procedure bp_al_Pashka( nTaskClass in number) is
  type TAccountCursor is ref cursor;
  AccountCursor TAccountCursor;
  AccountRec    account%rowtype;

  rowTask    alTask%rowtype;
  sFormula   varChar2( 4000);
  sError     varChar2( 4000); 
  tbFormula  bp_al_translator.TFormulaList;
  sSQL       varChar2( 4000);
  curDate    DATE;
  nBalance   number;
  sDepart    varChar2( 10);
  sCurrency  varChar2( 3);
  ---
  --- занесение данных в витрину
  ---
  procedure UpdateWindow( nTaskClass in number, sDepCode in varChar2, 
     sCurrencyCode in varChar2, nEquivalent in number, 
	 sSchet in varChar2, dtCurDate in DATE, nSumma in number) is
    nDataClass alReadyTasks.Classified%type;
	nSign      number;
	sSQL       varChar2( 2000);
  begin
     --- добавляем запись в витрину
     begin
	   select Classified into nDataClass from alReadyTasks
	     where idTask     = nTaskClass 
		   and CodeDep    = sDepCode
		   and CodeCB     = sCurrencyCode
		   and Equivalent = nEquivalent
		   and curDate    = dtCurDate;
	 exception 
	   when NO_DATA_FOUND then
	     insert into alReadyTasks( idTask, CodeDep, CodeCB, Equivalent, curDate, 
		   Summa1, Summa2,Summa3, Summa4, Summa5, Summa6, Summa7, Summa8, Summa9, Summa10)
		 values( nTaskClass, sDepCode, sCurrencyCode, nEquivalent, dtCurDate, 
		         0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
	     returning Classified into nDataClass;			 		   
     end;
	 ---  
	 --- теперь поищем во временной таблице номер колонки для занесения суммы
	 ---
	 for rec in ( select * from bp_all_GTT where sSchet like Account || '%') loop
       nSign := 1;
	   if rec.SummaType = 'D' then nSign := - 1; end if;
	   sSQL := 'update alReadyTasks set Summa' || rec.nOrder  ||
        	   ' = Summa' || rec.nOrder || rec.Operation || ' :ncursumma ' ||
        	   'where Classified = :nclass';
       dbms_output.put_line( 'Есть захват = ' || sSQL );
	   if nSumma is null then 
	     dbms_output.put_line( 'По счету ' || sSchet || ' остаток null');	
	   end if;	    
	   execute immediate sSQL using nvl( nSumma * nSign, 0), nDataClass;
	 end loop;	 
  end;	 
	 
  
begin
  --- найдем задание  
  select * into rowTask from alTask where Classified = nTaskClass;
  
  --- оттранслируем формулы
  for rec in ( select * from alTaskFormulas where idTask = nTaskClass) loop
    sFormula := bp_al_translator.CreateRealFormula( rec.idLibrary);
    sError   := bp_al_translator.CheckFormula( sFormula);
	if sError is null then
	  sError := bp_al_translator.TranslateFormula( sFormula, tbFormula);
	  bp_al_translator.UpdateGTT( rec.nOrder, tbFormula);
	end if;
  end loop;
  
  --- создадим запрос по счетам
  sSQL := 'select * from account where ';
  for rec in ( select Account from bp_all_GTT) loop
    sSQL := sSQL || ' code like ''' || rec.Account;
	if subStr( rec.Account, -1, 1) <> '%' then sSQL := sSQL || '%'; end if;
	sSQL := sSQL || ''' or'; 
  end loop;
  sSQL := subStr( sSQL, 1, Length( sSQL) - 3);
  dbms_output.put_line( 'Запрос = ' || sSQL);

  --- двигаемся в цикле по счетам запроса
  begin
    open AccountCursor for sSql;
    loop
      fetch AccountCursor into AccountRec;
      exit when AccountCursor%notfound;
      dbms_output.put_line( 'счет = ' || AccountRec.Code);	  

	 --- находим все остатки в нац. эквиваленте по счету за период
     for rec in ( 
       select trunc(DatList.curDate) curDate, 
	          AccountNationBalance( AccountRec.Classified, DatList.CurDate) RubBalance
       from  
           (
             select ( trunc( rowTask.dtStart) + rownum - 1/ 86400 ) curDate 
               from  account ad
               where rownum <= trunc( rowTask.dtStop) + 1 - trunc( rowTask.dtStart)
           ) 
		   DatList) loop
		---   
		--- если нужны данные в разрезе валют, то получим остаток в валюте
		---     
      	nBalance := 0;
		if rowTask.UseCurrency = 1 then
		  nBalance := AccountBalance( AccountRec.Classified, rec.curDate);
		end if;
		---
		--- получим данные о подразделении счета
		--- 
		sDepart := 'BANK';
		if rowTask.useDeps = 1 then
		  sDepart := nvl( bp_pm_GetDocumentDep( AccountRec.Doc), 'NO_DEP');  
		end if;
		sCurrency := 'RUR';
		if rowTask.useCurrency = 1 then
		  select  CodeISOAlph into sCurrency 
		    from  Currency
			where Classified = AccountRec.Currency;
		end if;  
		
		---
		--- теперь пора заносить данные в таблицу 
		---  
        UpdateWindow( nTaskClass, sDepart, sCurrency, 1, AccountRec.Code, rec.curDate, nBalance); 
        UpdateWindow( nTaskClass, sDepart, sCurrency, 5, AccountRec.Code, rec.curDate, rec.RubBalance); 
		  
     end loop;	
	  
    end loop;	
    close AccountCursor;
  exception 
    when OTHERS then
      if AccountCursor%IsOpen then close AccountCursor; end if;
	  raise;	
  end;	 

end;
/
