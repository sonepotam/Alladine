CREATE OR REPLACE package bp_al_translator is

   endl varChar2( 2) := chr( 13) || chr( 10);

   subtype TOperation is varChar2(1);
   subtype TSummaType is varChar2(3); 

   ---
   --- операции доступные внутри формулы
   ---
   opPlus  TOperation := '+';
   opMinus TOperation := '-';
   
   ---
   --- типы суммы
   ---
   
   
   --- 
   --- описатель одного счета в формуле
   ---
   type
     TFormulaToken is record(
	    sAccount   Account.code%type,
		sOperation TOperation,
		sSummaType TSummaType
   );
   ---
   --- таблица со счетами
   ---
   type
     TFormulaList is table of TFormulaToken index by binary_integer;

  ---	 	 
  --- разбор формулы
  --- 1 формула оттраснлирована/ 0 - оракловые ошибки
  ---   	 
  function TranslateFormula( sFormula in varChar2, tbFormula in out TFormulaList) return varchar2;

  ---
  --- сборка формулы из библиотеки.
  --- Возвращает строку с формулой
  function CreateRealFormula( nLibClass in number) return varChar2;

  ---
  --- проверка библиотеки  
  --- Возвращает строку с описанием ошибки, null - если ОК
  ---
  function CheckLibrary( nLibClass in number) return varChar2;

  ---
  --- проверка формулы 
  --- Возвращает строку с описанием ошибки, null - если ОК
  ---
  function CheckFormula( sFormula in varChar2) return varChar2;

  ---
  --- набивка временной таблицы 
  ---
  procedure UpdateGTT( nOrder in number, tbFormula in TFormulaList);
  
	 
end;
/
CREATE OR REPLACE package body bp_al_translator is

   ---
   --- список разделителей
   ---
   type
     TDelimList is table of TOperation index by binary_integer;
	 
   DelimList TDelimList;  		 

  ---
  --- поиск ближайшего разделителя в строке
  ---   
  function findDelimiter( sFormula in varChar2) return number is
    nResult number := 999999;
	nCurPtr number := 0;
	iPtr    number;
  begin
    for iPtr in DelimList.first..DelimList.last loop
	  nCurPtr := inStr( sFormula, DelimList( iPtr));
	  if nCurPtr > 0 AND nCurPtr < nResult then
	    nResult := nCurPtr;
	  end if;
	end loop;  
    --dbms_output.put_line( 'iPtr = ' || nResult);
	if nResult = 999999 then nResult := 0; end if;  
    return nResult;
  end;
  
  ---	
  --- трансляция формулы
  ---    
  function TranslateFormula( sFormula in varChar2, tbFormula in out TFormulaList) return varchar2 is
    iPtr       number;
	curWord    varChar2( 254);
	curFormula varChar2( 2000) := sFormula;
	curDelim   TOperation      := opPlus;   
	curToken   TFormulaToken;
	curPtr     number          := 1;
	curSumma   TSummaType;
	curIdent   varChar2( 254);
	
	---
	--- разделение идетификатора на счет и тип суммы по счету
	---
	procedure ExtractAccountAndSummaType( curIdent in varChar2, 
	  curAccount out varChar2, curSummaType out varChar2) is
	  iPtr number;
	  lUseAccount boolean := True;
 	begin
      curAccount   := '';
	  curSummaType := '';
	  for iPtr in 1..Length( curIdent) loop
	    if lUseAccount then
		  if subStr( curIdent, iPtr, 1) >= '0' AND subStr( curIdent, iPtr, 1) <= '9' then
		    curAccount := curAccount || subStr( curIdent, iPtr, 1);
		  else
   		    curSummaType := curSummaType || subStr( curIdent, iPtr, 1);
		    lUseAccount  := False;
		  end if;
		else
		  curSummaType := curSummaType || subStr( curIdent, iPtr, 1);
		end if;  
	  end loop;
	end;
	
  begin    
    if subStr( curFormula, 1, 1) <> '+' then 
	  curFormula := '+' || curFormula; 
	end if;
    while curFormula is not null loop
      curDelim   := subStr( curFormula, 1, 1);
	  curFormula := subStr( curFormula, 2);
	  iPtr    := findDelimiter( curFormula);	  
	  if iPtr > 0 then 
    	curWord    := subStr( curFormula, 1, iPtr - 1);
		curFormula := subStr( curFormula, iPtr);
	  else
	    curWord    := curFormula;
		curFormula := null;
	  end if;
	  
	  ---curSumma := subStr( curWord, - 1, 1);
	  ---curWord  := subStr( curWord, 1, length( curWord) -1);
	  curIdent := curWord;
      ExtractAccountAndSummaType( curIdent, curWord, curSumma); 	  
	  dbms_output.put_line( 'Слово        = ' || curWord );	   
	  dbms_output.put_line( 'Тип суммы    = ' || curSumma);	   
	  dbms_output.put_line( 'Разделитель  = ' || curDelim);
	  
	  curToken.sAccount   := curWord; 	   
	  curToken.sOperation := curDelim;	   
	  curToken.sSummaType := curSumma;	   
	  tbFormula( curPtr)  := curToken;
	  curPtr := curPtr + 1;
		   
	  dbms_output.put_line( '');	   
	end loop;	
    return '1';
  exception
    when OTHERS then return '0';	
  end; 

  ---
  --- создание формулы из библиотеки
  ---
  function CreateRealFormula( nLibClass in number) return varChar2 is
    sResult varChar2( 4000);
  begin
    for rec in ( select F.Value 
	               from alFormula F, alLibraryContent LC
				   where LC.idLibrary = nLibClass 
				     and LC.idFormula = F.Classified) loop
	   sResult := sResult || '+' || rec.Value;				 
    end loop;					 
	return sResult;
  end;
  
  
  
  function CheckTranslatedFormula( tbFormula in TFormulaList, sStr in out varChar2) return varChar2 is
    sResult  varChar2( 1) := '1';
	iPtr     integer;
	nAccount number;	
  begin
    sStr := '';
    for iPtr in tbFormula.first .. tbFormula.last loop
	  begin
	    nAccount := to_Number( tbFormula( iPtr).sAccount);
	    exception
	    when OTHERS then
		  sStr := sStr || endl || 'В ' || iPtr || 
		     ' элементе не удалось преобразовать счет ' || tbFormula( iPtr).sAccount;  
	  end;  
	  if tbFormula( iPtr).sSummaType not in ( 'D', 'K', 'OBD', 'OBK') then 
   	    sStr := sStr || endl || 'В ' || iPtr || 
		     ' элементе неизвестный тип суммы ' || tbFormula( iPtr).sSummaType;  	    
	  end if;
      if findDelimiter( tbFormula( iPtr).sOperation) = 0 then 
		  sStr := sStr || endl || 'В ' || iPtr || 
		     ' элементе неизвестная операция' || tbFormula( iPtr).sOperation;  	  
	  end if;
	end loop;
	if sStr is not null then 
	  sResult := '0';
	  sStr    := subStr( sStr, 3); 
	end if;
	
    return sResult;
  end;	

  
  function CheckLibrary( nLibClass in number) return varChar2 is
   sResult   varChar2( 4000);
   sFormula  varChar2( 4000);
   tbFormula TFormulaList;
  begin
    sFormula := CreateRealFormula( nLibClass);
    sResult  := TranslateFormula(  sFormula, tbFormula);
	if sResult = '1' then 
	  sFormula := CheckTranslatedFormula( tbFormula, sResult);
	end if;
	return sResult;
  end;  


  function CheckFormula( sFormula in varChar2) return varChar2 is
   sResult   varChar2( 4000);
   ch        varChar2( 1);
   tbFormula TFormulaList;
  begin
    sResult  := TranslateFormula(  sFormula, tbFormula);
	if sResult = '1' then 
	  ch := CheckTranslatedFormula( tbFormula, sResult);
	else
	  sResult := 'Формулу не удалось оттранслировать';  
	end if;
	return sResult;
  end;  

  
  procedure UpdateGTT( nOrder in number, tbFormula in TFormulaList) is
    iPtr number; 
  begin
    for iPtr in tbFormula.first .. tbFormula.last loop
	  insert into BP_ALL_GTT( Account, Operation, SummaType, nOrder)
        values( tbFormula( iPtr).sAccount,   tbFormula( iPtr).sOperation,
		        tbFormula( iPtr).sSummaType, nOrder);   	
	end loop;
  end;
  
begin
  DelimList( 1) := opPlus;
  DelimList( 2) := opMinus;
  dbms_output.put_line( 'init');
  
  
end;
/
