CREATE OR REPLACE procedure bp_al_IgorByCube( 
  ---
  --- ������ ������� �� ����
  ---
  sTableName   in varChar2,   --- ��� �������
  sColumnList  in varChar2,   --- ������ ������� � ��������
  sFactList    in varChar2,   --- ������ ������
  sWhereClause in varChar2,   --- �������������� ������� �� ����� 
  sLibraryList in varChar2   --- ������ ���������  
  ) is

  ---
  --- ����� ����������
  --- 
  curLibraryList varChar2( 4000) := sLibraryList;
  iPtr           number;
  LibraryList    bp_al_Interface.TVarchar2Table;  
  ColumnList     bp_al_Interface.TVarchar2Table;
  FactColumnList bp_al_Interface.TVarchar2Table;
  curLibraryID   number;
  sFormula   varChar2( 4000);
  sError     varChar2( 4000); 
  tbFormula  bp_al_translator.TFormulaList;
  sSQL       varChar2( 4000);

  type TCubeCursor is ref cursor;
  CubeCursor TCubeCursor;
  CubeRec    ALCREDSVODINFO%rowType;

  
  ---
  --- ��������� ������ � �������
  ---
  procedure UpdateWindow( ACubeRec in ALCREDSVODINFO%rowType) is  
    nDataClass rowid;
	nSign      number;
	sSQL       varChar2( 2000);
	nSumma     number( 24,3);
	nSummaRub  number( 24,3);
	nSummaVal  number( 24,3);
	nOBDRub    number( 24,3);
	nOBDVal    number( 24,3);
	nOBKRub    number( 24,3);
	nOBDVal    number( 24,3);
  begin
     --- ��������� ������ � �������
     begin
	   select rowID into nDataClass from gtt_alCredSvodInfo
	     where curDate    = ACubeRec.CurDate
		   and depCode    = ACubeRec.DepCode
		   and balAccount = ACubeRec.balAccount
		   and CurrencyISO= ACubeRec.CurrencyISO
		   and filType    = ACubeRec.filType
		   and filIdent   = ACubeRec.filIdent
		   and risk       = ACubeRec.risk
		   and schet      = ACubeRec.schet
		   and taxid      = ACubeRec.taxid
		   and kreddog    = ACubeRec.kreddog;
	 exception 
	   when NO_DATA_FOUND then
	     insert into gtt_alCredSvodInfo( 
		   curDate, depCode, balAccount,  CurrencyISO, 
		   filType, filIdent, risk, schet, taxid, kreddog,  
		   Summa1, Summa2,Summa3, Summa4, Summa5, Summa6, Summa7, Summa8, Summa9, Summa10)
		 values( 
		   ACubeRec.CurDate, ACubeRec.DepCode, ACubeRec.balAccount, ACubeRec.CurrencyISO,
		   ACubeRec.filType, ACubeRec.filIdent, ACubeRec.risk, ACubeRec.schet, 
		   ACubeRec.taxid,   ACubeRec.kreddog,	   
		         0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
	     returning rowID into nDataClass;			 		   
     end;
	 ---  
	 --- ������ ������ �� ��������� ������� ����� ������� ��� ��������� �����
	 ---
	 for rec in ( select * from bp_all_GTT where ACubeRec.balAccount like Account || '%') loop
	   nSumma := 0;
	   --- ������� �� ����� � ������
	   if FactColumnList( rec.nOrder) = 'REST' then
  	     if rec.SummaType = 'D' AND ACubeRec.Rest < 0 then nSumma := - ACubeRec.Rest; end if;
         if rec.SummaType = 'K' AND ACubeRec.Rest > 0 then nSumma :=   ACubeRec.Rest; end if;	     
	   end if;
	   --- ������� �� ����� � �����������
	   if FactColumnList( rec.nOrder) = 'RESTRUB' then
  	     if rec.SummaType = 'D' AND ACubeRec.Rest < 0 then nSumma := - ACubeRec.RestRub; end if;
         if rec.SummaType = 'K' AND ACubeRec.Rest > 0 then nSumma :=   ACubeRec.RestRub; end if;	     
	   end if;
	   --- ������� �� ������
	   if FactColumnList( rec.nOrder) = 'OBD'    then nSumma := ACubeRec.OBD; end if;
	   if FactColumnList( rec.nOrder) = 'OBDRUB' then nSumma := ACubeRec.OBDRub; end if;
	   --- ������� �� �������
	   if FactColumnList( rec.nOrder) = 'OBK'    then nSumma := ACubeRec.OBK; end if;
	   if FactColumnList( rec.nOrder) = 'OBKRUB' then nSumma := ACubeRec.OBKRub; end if;
	   if nSumma <> 0 then
    	   dbms_output.put_line( '���� ' || ACubeRec.Schet || ' , ������� ' || nSumma);
	   end if;	     
		 
	   sSQL := 'update gtt_alCredSvodInfo set Summa' || rec.nOrder  ||
        	   ' = Summa' || rec.nOrder || rec.Operation || ' :ncursumma ' ||
        	   'where rowID = :nclass';
	   execute immediate sSQL using nSumma, nDataClass;
	 end loop;
  end;	 
	 
  
begin
  ---  
  --- ������������� �������
  ---
  bp_al_Interface.Tokenize( sFactList,  ',', ColumnList);
  bp_al_Interface.TranslateColumnList( sTableName, ColumnList, FactColumnList, 2);
  
  
  
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
  --- �������� ������ � ������
  ---
  sSQL := 'select * from ALCREDSVODINFO where balAccount in ( select nvl( Account, balAccount) from bp_all_GTT) ';
  
  if sWhereClause is not null then sSQL := sSQL || ' AND ' || sWhereClause; end if;
  dbms_output.put_line( '������ = ' || sSQL);
  ---
  --- ��������� � ����� �� ������ �������
  ---
  begin
    open CubeCursor for sSql;
    loop
      fetch CubeCursor into CubeRec;
      exit when CubeCursor%notfound;
	  ---
	  --- ������ ���� �������� ������ � ������� 
	  ---  
	  UpdateWindow( cubeRec);
    end loop;	
    close CubeCursor;
--  exception 
--    when OTHERS then
--      if CubeCursor%IsOpen then close CubeCursor; end if;
--	  raise;	
  end;	 

end;
/

