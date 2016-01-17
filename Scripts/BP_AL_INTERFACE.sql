CREATE OR REPLACE package bp_al_interface is
   ---
   --- добавление формулы
   ---
   function AddFormula( sFormulaName in varChar2, sFormula in varChar2) return number;  
   ---
   --- редактирование формулы
   ---
   function EditFormula( nClass in number, sFormula in varChar2) return varChar2;
   ---
   --- удаление формулы
   ---
   function DeleteFormula( idFormula in number) return varChar2;
   ---
   --- удаление формулы из библиотек
   ---
   function DeleteFormulaAnyWay( idFormula in number) return varChar2;
   ---
   --- добавление формулы в библиотеку
   ---
   function AddFormula2Library( idFormula in number, idLibrary in number) return varChar2;
   ---
   --- удаление формулы в библиотеку
   ---
   function DeleteFormulaFromLibrary( idFormula in number, idLibrary in number) return varChar2;   
   ---
   --- добавление новой библиотеки
   ---
   function AddLibrary( sLibraryName in varChar2) return number;
   ---
   --- изменение названия библиотеки
   ---
   function EditLibrary( nClass in number, sLibraryName in varChar2) return varChar2;
   ---
   --- изменение удаление библиотеки
   ---
   function DeleteLibrary( nClass in number) return varChar2;


   ---
   --- добавление задачи
   ---
   function AddReport( nTaskType in number, sLabel in varChar2) return number; 
   ---
   --- редактирование названия отчета
   ---
   function EditReport( nTaskClass in number, sLabel in varChar2) return varChar2;
   ---
   --- удаление задачи
   ---
   function DeleteReport( nTaskClass in number) return varChar2;
   ---
   --- добавление библиотеки в задачу
   ---
   function AddLibrary2Job( nTaskClass in number, nLibClass in number, nOrder in number) 
     return varChar2;
	 
   ---
   --- удаление библиотек из задачи
   ---
   function DeleteLibrarysFromJob( nTaskClass in number) return varChar2;


   ---
   --- добавление таблицы
   ---
   function AddTableDesc( sTableName in varChar2, sTableDesc in varChar2) return number;

   ---
   --- добавление колонки к таблице   
   ---
   function AddColumn2Table( nIdTable in number, sColumnName in varChar2, 
      sColumnLabel in varChar2, sColumnDesc in varChar2, nColumnType in number) return number;   
   ---
   --- удаление колонки
   ---   
   function DeleteColumn( nColumnClass in number) return varChar2;
   
   ---
   --- разбиение строки по морфемам
   ---
   type TVarchar2Table is table of varChar2( 4000) index by binary_integer;
   procedure Tokenize( S in varChar2, sDelim in varChar2, ATable in out TVarChar2Table); 



   ---
   --- добавление нового типа атрибута
   ---
   function AddTaskAttrType( nClass in number, sLabel in varChar2) return varChar2;
   ---
   --- удаление всех атрибутов отчета
   ---
   function DeleteTaskAttrs( nTaskClass in number) return varChar2;
   ---
   --- добавление нового атрибута в отчет
   ---
   function AddTaskAttr( nTaskClass in number, nTaskAttrType in number, naOrder in number,
      nObj in number, sValue in varChar2) return varChar2;
   
end;
/
CREATE OR REPLACE package body bp_al_interface is

  procedure Tokenize( S in varChar2, sDelim in varChar2, ATable in out TVarChar2Table) is
    iPtr number;
	curL number := 1;
	curS varChar2( 4000) := S;
  begin
    ATable.Delete;
	loop
	  iPtr := InStr( curS, sDelim);
	  if iPtr > 0 then
	    ATable( curL) := SubStr( curS, 1, iPtr - 1);
		iPtr := iPtr + Length( sDelim);
		curS := SubStr( curS, iPtr, Length( curS));
		curL := curL + 1;
	  else
	    ATable( curL) := curS;
        return;	    
	  end if;
	end loop;
  end;	 



   ---
   --- добавление формулы
   ---
   function AddFormula( sFormulaName in varChar2, sFormula in varChar2) return number is
     nResult number;
   begin
     if Length( sFormula) > 2000 then 
	   raise_application_error( -20000, 'Длина формулы не может быть больше 2000 символов');
	 end if;
	 begin  
       select 1 into nResult
	     from alFormula
	     where Label = sFormulaName;
       raise_application_error( -20000, 'Формула ' || sFormulaName || ' уже есть в системе');
     exception
	   when NO_DATA_FOUND then
    	 insert into alFormula( Label, Value)  values( sFormulaName, sFormula)
         returning Classified into nResult;	  
	 end;      
     return nResult;
   end;
   
   ---
   --- добавление формулы
   ---
   function EditFormula( nClass in number, sFormula in varChar2) return varChar2 is
     sResult varChar2( 1) := '1';
   begin
     if Length( sFormula) > 2000 then 
	   raise_application_error( -20000, 'Длина формулы не может быть больше 2000 символов');
	 end if;
     update alFormula set Value = sFormula where Classified = nClass;
	 if SQL%rowCount = 0 then sResult := '0'; end if;
     return sResult;
   end;
   
   
   ---
   --- удаление формулы
   ---
   function DeleteFormula( idFormula in number) return varChar2 is
     sResult varChar2( 1) := '1';
	 sDummy  varChar2( 1) := '0';
   begin
     begin
	   select '1' into sDummy 
         from alLibraryContent LC
         where LC.idFormula = DeleteFormula.idFormula;
	 exception 
	   when NO_DATA_FOUND then sDummy := '0';
	   when TOO_MANY_ROWS then sDummy := '1';
	 end;
	 if sDummy = '1' then
	   raise_application_error( -20000, 'Формула входит в состав библиотек');
	 end if;
	 delete from alFormula 
	   where Classified = idFormula;  
     return sResult;
   end;
   
   
   ---
   --- удаление формулы из библиотек
   ---
   function DeleteFormulaAnyWay( idFormula in number) return varChar2 is
     sResult varChar2( 1) := '1';
   begin
     delete from alLibraryContent LC
	   where LC.idFormula = DeleteFormulaAnyWay.idFormula;
	 delete from alFormula 
	   where Classified = idFormula;  
     return sResult;
   end;
   ---
   --- удаление формулы из библиотек
   ---
   function DeleteFormulaFromLibrary( idFormula in number, idLibrary in number) return varChar2 is
     sResult varChar2( 1) := '1';
   begin
     delete from alLibraryContent LC
	   where LC.idFormula = DeleteFormulaFromLibrary.idFormula
	     and LC.idLibrary = DeleteFormulaFromLibrary.idLibrary;
     return sResult;
   end;
   ---
   --- добавление формулы в библиотеку
   ---
   function AddFormula2Library( idFormula in number, idLibrary in number) return varChar2 is
     nDummy number := 0;
	 sRealFormula  varChar2( 4000);
	 sFormula2Add  varChar2( 4000);
   begin
     select count(*) into nDummy
	   from alLibraryContent LC 
	   where LC.IDLIBRARY = AddFormula2Library.idLibrary
	     and LC.IDFORMULA = AddFormula2Library.idFormula;
	 if nDummy > 0 then
	   raise_application_error( -20000, 'Такая формула уже есть в библиотеке');
	 end if;
	 sRealFormula := bp_al_Translator.CreateRealFormula( idLibrary);
     select Value into sFormula2Add 
	   from alFormula
	   where Classified = idFormula;
	 if Length( sRealFormula) + 1 + Length( sFormula2Add) > 4000 then
	   raise_application_error( -20000, 'Длина формул в библиотеке не может быть больше 4000 символов');	 
	 end if;
	 insert into alLibraryContent( idFormula, idLibrary)
	  values( AddFormula2Library.idFormula, AddFormula2Library.idLibrary); 
	 
	 return '1';  	 
   end;

   ---
   --- добавление библиотеки
   ---   
   function AddLibrary( sLibraryName in varChar2) return number is
     nResult number;
   begin
     select 1 into nResult
	   from alLibrary
	   where Label = sLibraryName;
	 raise_application_error( -20000, 'Библиотека ' || sLibraryName || ' уже есть в системе');
   exception
       when NO_DATA_FOUND then
	     insert into alLibrary( Label) values( sLibraryName)
		   returning Classified into nResult;
		 return nResult;		 	   
   end;
   
   function EditLibrary( nClass in number, sLibraryName in varChar2) return varChar2 is
   begin
     update alLibrary
	   set Label = sLibraryName
	   where Classified = nClass;
	 if SQL%rowCount = 1 then return '1'; else return '0'; end if;  
   end;
   
   function DeleteLibrary( nClass in number) return varChar2 is
   begin
     delete from alLibraryContent where idLibrary = nClass;
	 delete from alLibrary where Classified = nClass;
     return '1';
   end;
   
   ---
   --- добавление задачи
   ---
   function AddReport( nTaskType in number, sLabel in varChar2) return number is
     nResult number;
   begin
	 insert into alTask( idTaskType, Label, CreateDate)
	   values( nTaskType, sLabel, sysdate)
	   returning Classified into nResult;
	 return nResult;
   end;	 	 
   ---
   --- редактирование названия отчета
   ---
   function EditReport( nTaskClass in number, sLabel in varChar2) return varChar2 is
    sResult varChar2( 1):= '1';
   begin
     update alTask set Label = sLabel where Classified = nTaskClass;
	 return '1';
   end;
      
	  
	  
   /*
   ---
   --- запуск задачи
   ---
   function RunJob( nTaskClass in number) return varChar2 is
     RowTask alTask%rowType;
     nResult number;
	 sSQLBlock alTaskTypes.SQLBlock%type;
	 nJobNumber BINARY_INTEGER;
   begin
     select * into rowTask from alTask where Classified = nTaskClass;
     select SQLBlock into sSQLBlock from alTaskTypes where Classified = rowTask.idTaskType;
	 if rowTask.StartAsJob = '0' then
	   sSQLBlock := 'begin ' || Trim( sSQLBlock) || '( :p1); end; ';
	   execute immediate sSQLBlock using nTaskClass;
	 else
	   sSQLBlock := 'begin ' || Trim( sSQLBlock) || '( ' || to_char( nTaskClass) || '); commit; end;';
	   commit;
	   dbms_job.submit( nJobNumber, sSQLBlock); 
	 end if;
     dbms_output.put_line( sSQLBlock);
	 return '1';
   end;	 	 
   */
   
   ---
   --- удаление задачи
   ---
   function DeleteReport( nTaskClass in number) return varChar2 is
   begin
	 delete from alTaskFormulas where idTask      = nTaskClass;
	 delete from alTaskAttr     where idTaskClass = nTaskClass;
	 delete from alTask         where Classified  = nTaskClass;  
     return '1';
   end;

   ---
   --- добавление библиотеки в задачу
   ---
   function AddLibrary2Job( nTaskClass in number, nLibClass in number, nOrder in number) 
     return varChar2 is
     sResult varChar2( 1) := '1';
	 nLibCount number;
   begin
	 --- если такая библиотека уже есть, то в пень
     select count(*) into nLibCount from alTaskFormulas 
	   where idTask    = nTaskClass 
	     and idLibrary = nLibClass;
	 if nLibCount > 0 then
	   raise_application_error( -20000, 'Такая библиотека уже есть.');
	 end if;
	 --- если этот номер уже занят, то в пень
     select count(*) into nLibCount from alTaskFormulas 
	   where idTask    = nTaskClass 
	     and idLibrary = nLibClass;
	 if nLibCount > 0 then
	   raise_application_error( -20000, 'Такой номер уже занят');
	 end if;	 
	 insert into alTaskFormulas( nOrder, idLibrary, idTask)
	    values( AddLibrary2Job.nOrder, AddLibrary2Job.nLibClass, AddLibrary2Job.nTaskClass);
     return sResult;
   end;	 

   ---
   --- удаление библиотек из задачи
   ---
   function DeleteLibrarysFromJob( nTaskClass in number) return varChar2 is
   begin
     delete from alTaskFormulas
	   where idTask = nTaskClass;
	 return '1';  
   end;	  	  
   
   ---
   --- добавление таблицы
   ---
   function AddTableDesc( sTableName in varChar2, sTableDesc in varChar2) return number is
     nResult number;
   begin
     select count(*) into nResult from alTableDesc where TableName = sTableName;
	 if nResult > 0 then
	   raise_application_error( -20000, 'Такая таблица уже есть');
	 end if;
	 insert into alTableDesc( TableName, TableDesc)
	    values( sTableName, sTableDesc)
		returning Classified into nResult;
	 return nResult;	      
   end;
   ---
   --- добавление колонки к таблице   
   ---
   function AddColumn2Table( 
      nIdTable in number, sColumnName in varChar2, 
      sColumnLabel in varChar2, sColumnDesc in varChar2, 
	  nColumnType in number) return number is
	  nResult number;  
   begin
     begin
	   select Classified into nResult from alTableColumns
	     where ColumnName = sColumnName 
		   and idTable    = nIDTable;
	   update alTableColumns
   	      set Label = sColumnLabel,
		      Description = sColumnDesc,
			  ColumnType = nColumnType
    	 where Classified = nResult;	  	   
		   
	 exception
	    when NO_DATA_FOUND then 
		  insert into alTableColumns( idTable, ColumnName, Label, Description, ColumnType)
		     values( nIDTable, sColumnName, sColumnLabel, sColumnDesc, nColumnType)
			 returning Classified into nResult; 		 
	 end;
	 return nResult;   
   end;	   

   ---
   --- удаление колонки
   ---   
   function DeleteColumn( nColumnClass in number) return varChar2 is
     nResult varChar2(1) := '1';
   begin
     delete from alTableColumns where Classified = nColumnClass;
	 if SQL%rowCount = 0 then nResult := '0'; end if;
	 return nResult;
   end;	    
   
   
   ---
   --- добавление нового типа атрибута
   ---
   function AddTaskAttrType( nClass in number, sLabel in varChar2) return varChar2 is
   begin
     insert into alTaskAttrTypes( idClassified, Label) values( nClass, sLabel);
	 return '1';  
   end;
   ---
   --- удаление всех атрибутов отчета
   ---
   function DeleteTaskAttrs( nTaskClass in number) return varChar2 is
     sResult varChar2( 1) := '1';
   begin
     delete from alTaskAttr where idTaskClass = nTaskClass;
	 if SQL%rowCount = 0 then sResult := '0'; end if;
	 return sResult;
   end;
   ---
   --- добавление нового атрибута в отчет
   ---
   function AddTaskAttr( nTaskClass in number, nTaskAttrType in number, naOrder in number,
      nObj in number, sValue in varChar2) return varChar2 is
   begin
     insert into alTaskAttr( idTaskClass, idClassified, nOrder, Obj, Value)
	    values( nTaskClass, nTaskAttrType, naOrder, nObj, sValue);
	 return '1';	
   
   end;	  

   
end;
/
