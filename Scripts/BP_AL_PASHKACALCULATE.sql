CREATE OR REPLACE procedure bp_al_PashkaCalculate( dtStart in DATE, dtStop in DATE) is
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
  nOBD       number;
  nOBK       number;
  nCount     number := 1;
  
  ---
  --- занесение данных в витрину
  ---
  procedure UpdateWindow( dtCurDate in DATE, sDepCode in varChar2, 
     sSchet in varChar2, sCurrencyCode in varChar2, nTypeRest in number, 
	 nRest in number, nOBD in number, nOBK in number) is
  begin
    --- добавляем запись в витрину
    update alRestInfo
  	   set Balance = Balance + nvl( nRest, 0),
	       OBD     = OBD     + nvl( nOBD, 0),
		   OBK     = OBK     + nvl( nOBK, 0)
	   where curDate     = dtCurDate
		 and depCode     = sDepCode
		 and balAccount  = sSchet
		 and CurrencyISO = sCurrencyCode
		 and TypeRest    = nTypeRest;
	if SQL%rowCount = 0 then		   
       insert into alRestInfo( curDate, depCode, balAccount, CurrencyISO, typeRest, Balance, OBD, OBK)
	   values( dtCurDate, sDepCode, sSchet, sCurrencyCode, nTypeRest, nvl( nRest, 0), 
	     nvl( nOBD, 0), nvl( nOBK, 0));
    end if;
  end;	 
	 
  
  
begin
  --- удаляем старое разбиение
  delete from alRestInfo
    where curDate >= dtStart AND curDate <= dtStop;
	
  --- по дороге заносится в счетчик

  for rec in ( 
     select  --+FIRST_ROWS 
       Acc.Classified , Acc.Doc, GAT.Code balCode, CR.CodeIsoAlph 
       from  Account ACC, GeneralAccTree GAT, Currency CR
       where ACC.mainGeneralAcc = GAT.Classified
         and Acc.Currency = CR.Classified
	     -- and rownum < 100
		 ) loop
	 curDate := dtStart;
	 sDepart := bp_pm_GetDocumentDep( rec.Doc);
	 if sDepart is null then
	   dbms_output.put_line( 'Не привязан счет ' || rec.Classified);
	   sDepart := 'ZZZZ';
	 end if;    
	 
	 nCount := nCount + 1;
	 if Mod( nCount, 10) = 0 then
	   delete from bp_tracing
	     where taskinfo = 'olap';
	   bp_trace( 'olap', nCount);
	 end if;  
	 

	 while curDate <= dtStop loop
       --- получим данные в валюте	    
	   nBalance:= AccRestOut( rec.Classified, curDate, 1, 0);
	   select sum( TurnOverDe), sum( TurnOverCr) into nOBD, nOBK
	     from TurnOver
		 where Account  = rec.Classified  and TurnDate = curdate and EndTurn = 0     		 
		   and Type = 1;
	   UpdateWindow( curDate, sDepart, rec.balCode, rec.CodeIsoAlph, 1, nBalance, nOBD, nOBK);	   
     	 
       --- получим данные в эквиваленте	    
	   nBalance:= AccRestOut( rec.Classified, curDate, 5, 0);
	   select sum( TurnOverDe), sum( TurnOverCr) into nOBD, nOBK
	     from TurnOver
		 where Account  = rec.Classified  and TurnDate = curdate and EndTurn = 0     		 
		   and Type = 5;
	   UpdateWindow( curDate, sDepart, rec.balCode, rec.CodeIsoAlph, 5, nBalance, nOBD, nOBK);
	   ---
	   --- к следующей дате
	   ---	   
	   curDate := curDate + 1;
	 end loop;	 
  end loop;		  

end;
/
