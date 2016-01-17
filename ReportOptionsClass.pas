unit ReportOptionsClass;

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, DB, Oracle, CubeClasses, DataModule;





type
 TLibraryList = class( TList)
    public
      function findByName( ALibraryName: String): Integer;
    end;


   TReportOptions = class
     private
       fIDCube, fIDTask: Double;
       fTableName      : String;
       fReportName     : String;
       lCreateParams   : Boolean;
       fPreview        : TStartingOptions;
       fZeroColumns    : TStringList;

       fColumnListDesc, fRowListDesc, fFilterListDesc, fParamListDesc: Tlist;
       fLibraryListDesc: TLibraryList;

       function GetWhereClause : String;
       function GetColumnList  : String;
       function GetParamList   : String;
       function GetFactList    : String;
       function GetLibraryList : String;
     public
       dmData          : TDMData;

       property idCube: Double    read fIDCube    write fIDCube;
       property idTask: Double    read fIDTask    write fIDTask;
       property TableName: String read fTableName write fTableName;
       property WhereClause: String read GetWhereClause;
       property ColumnList : String read GetColumnList;
       property ParamList  : String read GetParamList;
       property FactList   : String read GetFactList;
       property LibraryList: String read GetLibraryList;
       property ColumnListDesc : TList read fColumnListDesc  write fColumnListDesc;
       property RowListDesc    : TList read fRowListDesc     write fRowListDesc ;
       property FilterListDesc : TList read fFilterListDesc  write fFilterListDesc ;
       property ParamListDesc  : TList read fParamListDesc   write fParamListDesc ;
       property LibraryListDesc: TLibraryList read fLibraryListDesc write fLibraryListDesc ;
       property ParamsCreated  : boolean read lCreateParams;
       property StartOptions   : TStartingOptions read fPreview;
       property ReportName     : String read fReportName;
       property ZeroColumns    : TStringList read fZeroColumns write fZeroColumns;

       procedure ReadTaskAttributes;
       procedure WriteTaskAttributes;
       procedure fillParams;

       constructor CreateReport( ADMData: TDMData; AReportName: String; AIDCube, AIDTask: Double);
       destructor Free;

   end;

   TFilterTypes = ( ftGreater, ftGreateOrEqual, ftEqual, ftLess, ftLessOrEqual,
                    ftIN, ftNotEqual);
   TFilterTypesStr = array[ TFilterTypes] of String;


const
  AFilterTypes: TFilterTypesStr = ( '>', '>=', '=', '<', '<=', 'IN', '<>');
  objTrue   : String = 'TRUE';
  objFalse  : String = 'FALSE';


var
  taAttrFilter: Integer = 1;
  taAttrColumn: Integer = 2;
  taAttrRow   : Integer = 3;
  taAttrFact  : Integer = 4;
  taAttrParam : Integer = 5;

  ftVarChar2  : String = 'VARCHAR2';
  ftNumber    : String = 'NUMBER';
  ftDate      : String = 'DATE';




implementation

uses ReportParams, fmFilterDates, StringFilter;


constructor TReportOptions.CreateReport( ADMData: TDMData; AReportName: String; AIDCube, AIDTask: Double);
begin
  fReportName := AReportName;
  idCube := AIDCube;
  idTask := AIDTask;
  fColumnListDesc   := TList.Create;
  fRowListDesc      := TList.Create;
  fFilterListDesc   := TList.Create;
  fParamListDesc    := TList.Create;
  fLibraryListDesc  := TLibraryList.Create;
  lCreateParams     := False;
  fPreview.lPreview           := False;
  fPreview.lDeleteZeroColumns := False;
  fZeroColumns      := TStringList.Create;
  dmData           := ADMData;
  ReadTaskAttributes;
end;

destructor TReportOptions.Free;
begin
  fColumnListDesc.Free;
  fRowListDesc.Free;
  fFilterListDesc.Free;
  fParamListDesc.Free;
  fLibraryListDesc.Free;
  fZeroColumns.Free;
end;

procedure TReportOptions.ReadTaskAttributes;
var newColumn   : TCubeColumn;
    nLibraryID  : Double;
begin
  if idTask = -1 then Exit;
  lCreateParams := False;
  ColumnListDesc.Clear;
  fRowListDesc.Clear;
  fFilterListDesc.Clear;
  fParamListDesc.Clear;
  fLibraryListDesc.Clear;

  with dmData.odsTaskAttrDesc do
   try
     try

      with dmData.odsTableName do begin
        Active := False;
        SetVariable( 'pTable', idCube);
        Active    := True;
        TableName := fieldByName( 'TableName').asString;
        Active    := False;
      end;


      Active := False;
      SetVariable( 'pTask', idTask);
      Active := True;
      while not Eof do begin
        newColumn := dmData.CreateColumn( fieldByName( 'obj').asFloat);
        if fieldByName( 'idClassified').asFloat = taAttrFilter then begin
          with dmData.odsFilterDesc do begin
            Active := False;
            SetVariable( 'pTaskClass', idTask);
            SetVariable( 'pObj',       newColumn.Classified);
            Active := True;
            newColumn.ColumnFilter := fieldByName( 'value').asString;
            newColumn.CompareWith  := fieldByName( 'CompareWith').asString;
            Active := False;
          end;
          FilterListDesc.Add( newColumn);
        end;
        if fieldByName( 'idClassified').asFloat = taAttrColumn then begin
          ColumnListDesc.Add( newColumn);
        end;
        if fieldByName( 'idClassified').asFloat = taAttrRow then begin
          RowListDesc.Add( newColumn);
        end;
        if fieldByName( 'idClassified').asFloat = taAttrFact then begin
          nLibraryID := StrToFloat( fieldByName( 'obj').asString);
          newColumn.ColumnLabel  := fieldByName( 'label').asString;
          newColumn.LibraryID    := nLibraryID;
          newColumn.ColumnFilter := fieldByName( 'label').asString;
          LibraryListDesc.Add( newColumn);
        end;
        if fieldByName( 'idClassified').asFloat = taAttrParam then begin
          ParamListDesc.Add( newColumn);
        end;
        Next;
      end;
      except
        on E: Exception do ProcessException( E);
      end;
    finally
      dmData.odsFilterDesc.Active := False;
      Active := False;
    end;
end;


procedure TReportOptions.fillParams;
begin
  if fillReportParams( dmData, fParamListDesc, fPreview) then lCreateParams := True;
end;


procedure TReportOptions.WriteTaskAttributes;
var i: Integer;
    curColumn : TCubeColumn;
begin
  try
    try
      //
      // переносим данные о фильтрах
      //
      dmData.alInterface.DeleteTaskAttrs( idTask);
      for i := 0 to FilterListDesc.Count - 1 do begin
        curColumn := TCubeColumn( FilterListDesc[ i]);
        dmData.alInterface.AddTaskAttr( idTask, taAttrFilter, i,
          curColumn.Classified, curColumn.ColumnFilter, curColumn.CompareWith);
      end;
      //
      // переносим данные о колонках
      //
      for i := 0 to ColumnListDesc.Count - 1 do begin
        curColumn := TCubeColumn( ColumnListDesc[ i]);
        dmData.alInterface.AddTaskAttr( idTask, taAttrColumn, i,
          curColumn.Classified, '', '');
      end;
      //
      // переносим данные о строках
      //
      for i := 0 to RowListDesc.Count - 1 do begin
        curColumn := TCubeColumn( RowListDesc[ i]);
        dmData.alInterface.AddTaskAttr( idTask, taAttrRow, i,
          curColumn.Classified, '', '');
      end;
      //
      // переносим данные о фактах
      //
      for i := 0 to LibraryListDesc.Count - 1 do begin
        curColumn := TCubeColumn( LibraryListDesc[ i]);
        dmData.alInterface.AddTaskAttr( idTask, taAttrFact, i,
          curColumn.Classified, FloatToStr( curColumn.LibraryID), '');
      end;
      //
      // переносим данные о параметрах
      //
      for i := 0 to ParamListDesc.Count - 1 do begin
        curColumn := TCubeColumn( ParamListDesc[ i]);
        dmData.alInterface.AddTaskAttr( idTask, taAttrParam, i,
          curColumn.Classified, '', '');
      end;

      except
        on E: Exception do ProcessException( E);
      end;
    finally
    end;

end;



function TReportOptions.GetWhereClause : String;
var sWhereClause: String;
   procedure TranslateList( List: TList);
   var i: Integer;
      curColumn   : TCubeColumn;
      curFilter   : String;
   begin
     for i := 0 to List.Count -1 do begin
       curColumn   := TCubeColumn( List[ i]);
       curFilter   := '';
       if curColumn.FieldType = ftDate
         then curFilter := TranslateDateFilter( curColumn);
       if curColumn.FieldType = ftVarChar2
         then curFilter := TranslateStringFilter(curColumn);
       if curColumn.FieldType = ftNumber
         then curFilter := TranslateNumberFilter(curColumn);
       if curFilter <> ''
         then sWhereClause := sWhereClause + curFilter + ' AND ';
     end;
  end;
begin
  sWhereClause := '';
  Result := '';
  TranslateList( FilterListDesc);
  if lCreateParams then TranslateList( ParamListDesc);
  Result := Copy( sWhereClause, 1, Length( sWhereClause) - 4);
end;

function TReportOptions.GetColumnList  : String;
var i: Integer;
    curColumn: TCubeColumn;
begin
  Result := '';
  //
  // перекидываем строки
  //
  for i := 0 to RowListDesc.Count -1 do begin
    curColumn   := TCubeColumn( RowListDesc[ i]);
    Result      := Result + curColumn.ColumnName + ',';
  end;
  //
  // перекидываем колонки
  //
  for i := 0 to ColumnListDesc.Count -1 do begin
    curColumn   := TCubeColumn( ColumnListDesc[ i]);
    Result      := Result + curColumn.ColumnName + ',';
  end;
  Result := Copy( Result, 1, Length( Result) - 1);
end;

function TReportOptions.GetParamList   : String;
var i: Integer;
    curColumn: TCubeColumn;
begin
  for i := 0 to ParamListDesc.Count -1 do begin
    curColumn   := TCubeColumn( ParamListDesc[ i]);
    Result      := Result + curColumn.ColumnName + ',';
  end;
  Result := Copy( Result, 1, Length( Result) - 1);
end;

function TReportOptions.GetFactList   : String;
var i: Integer;
    curColumn: TCubeColumn;
begin
  for i := 0 to LibraryListDesc.Count -1 do begin
    curColumn   := TCubeColumn( LibraryListDesc[ i]);
    Result      := Result + curColumn.ColumnName + ',';
  end;
  Result := Copy( Result, 1, Length( Result) - 1);
end;

function TReportOptions.GetLibraryList   : String;
var i: Integer;
    curColumn: TCubeColumn;
begin
  for i := 0 to LibraryListDesc.Count -1 do begin
    curColumn   := TCubeColumn( LibraryListDesc[ i]);
    Result      := Result + FloatToStr( curColumn.LibraryID) + ',';
  end;
  Result := Copy( Result, 1, Length( Result) - 1);
end;


function TLibraryList.findByName( ALibraryName: String): Integer;
var i: Integer;
begin
  Result := -1;
  for i := 0 to Count -1 do begin
    if TCubeColumn( Items[ i]).ColumnLabel = ALibraryName then begin
      Result := i;
      Exit;
    end;
  end;
end;

end.
