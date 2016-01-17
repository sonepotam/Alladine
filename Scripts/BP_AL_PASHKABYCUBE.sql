CREATE OR REPLACE procedure bp_al_PashkaByCube( 
  ---
  --- расчет выборки по кубу
  ---
  sColumnList  in varChar2,   --- спикок колонок и столбцов
  sWhereClause in varChar2,   --- дополнительное условие на кубик 
  sLibraryList in varChar2   --- список библиотек  
  ) is

  ---
  --- Новые переменные
  --- 
  curLibraryList varChar2( 4000) := sLibraryList;
  iPtr           number;
  LibraryList    bp_al_Interface.TVarchar2Table;
  curLibraryID   number;
  sFormula   varChar2( 4000);
  sError     varChar2( 4000); 
  tbFormula  bp_al_translator.TFormulaList;
  sSQL       varChar2( 4000);

  type TCubeCursor is ref cursor;
  CubeCursor TCubeCursor;
  CubeRec    alRestInfo%rowType;

  
  ---
  --- занесение данных в витрину
  ---
  procedure UpdateWindow( 
    sDepCode in varChar2, sCurrencyCode in varChar2, nEquivalent in number, 
	sSchet in varChar2,   dtCurDate in DATE, 
	nOBD in number, nOBK in number, nRest in number) is
    nDataClass rowid;
	nSign      number;
	sSQL       varChar2( 2000);
	nSumma     number( 24,3);
  begin
     --- добавляем запись в витрину
     begin
	   select rowID into nDataClass from gtt_alRestInfo
	     where curDate    = dtCurDate
		   and depCode    = sDepCode
		   and balAccount = sSchet
		   and CurrencyISO= sCurrencyCode
		   and TypeRest   = nEquivalent;
	 exception 
	   when NO_DATA_FOUND then
	     insert into gtt_alRestInfo( curDate, depCode, balAccount, CurrencyISO, TypeRest, 
		   Summa1, Summa2,Summa3, Summa4, Summa5, Summa6, Summa7, Summa8, Summa9, Summa10)
		 values( dtCurDate, sDepCode, sSchet, sCurrencyCode, nEquivalent,  
		         0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
	     returning rowID into nDataClass;			 		   
     end;
	 ---  
	 --- теперь поищем во временной таблице номер колонки для занесения суммы
	 ---
	 for rec in ( select * from bp_all_GTT where sSchet like Account || '%') loop
	   nSumma := 0;
	   if rec.SummaType = 'D' AND nRest < 0 then nSumma := - nRest; end if;
       if rec.SummaType = 'K' AND nRest > 0 then nSumma :=   nRest; end if;
       if rec.SummaType = 'OBD' then nSumma :=   nOBD;  end if;
       if rec.SummaType = 'OBK' then nSumma :=   nOBK;  end if;
	     
	   sSQL := 'update gtt_alRestInfo set Summa' || rec.nOrder  ||
        	   ' = Summa' || rec.nOrder || rec.Operation || ' :ncursumma ' ||
        	   'where rowID = :nclass';
	   execute immediate sSQL using nSumma, nDataClass;
	 end loop;	 
  end;	 
	 
  
begin
  ---  
  --- оттранслируем формулы
  ---
  bp_al_Interface.Tokenize( sLibraryList, ',', LibraryList);
  for iPtr in LibraryList.first..LibraryList.last loop
    curLibraryID := to_Number( LibraryList( iPtr));	
    sFormula := bp_al_translator.CreateRealFormula( curLibraryID);
    sError   := bp_al_translator.CheckFormula( sFormula);
	if sError is null then
	  sError := bp_al_translator.TranslateFormula( sFormula, tbFormula);
	  bp_al_translator.UpdateGTT( iPtr, tbFormula);
	end if;
  end loop;
  
  ---
  --- создадим запрос к кубику
  ---
  -- sSQL := 'select * from alRestInfo where balAccount in ( select Account from bp_all_GTT)';
  -- sSQL := 'select * from alRestInfo where balAccount like ( select Account || ''%'' from bp_all_GTT)';
  sSQL := 'select * from alRestInfo where balAccount in ( select nvl( Account, balAccount) from bp_all_GTT) ';
  
  if sWhereClause is not null then sSQL := sSQL || ' AND ' || sWhereClause; end if;
  dbms_output.put_line( 'Запрос = ' || sSQL);
  ---
  --- двигаемся в цикле по счетам запроса
  ---
  begin
    open CubeCursor for sSql;
    loop
      fetch CubeCursor into CubeRec;
      exit when CubeCursor%notfound;
	  ---
	  --- теперь пора заносить данные в таблицу 
	  ---  
      UpdateWindow( cubeRec.depCode, cubeRec.CurrencyISO, cubeRec.TypeRest, 
		cubeRec.balAccount, cubeRec.curDate,
		cubeRec.OBD, cubeRec.OBK, cubeRec.Balance);		   
    end loop;	
    close CubeCursor;
--  exception 
--    when OTHERS then
--      if CubeCursor%IsOpen then close CubeCursor; end if;
--	  raise;	
  end;	 

end;
/
