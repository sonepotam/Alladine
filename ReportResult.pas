unit ReportResult;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, ExtCtrls, ComCtrls, ToolWin, StdCtrls, Buttons, Oracle, OracleData,
  DB, CubeClasses, ImgList, Math, comObj, OleCtnrs, Halcn6DB, Variants,
  ReportOptionsClass, DataModule, StrUtils;

type
  TfmReportResult = class(TForm)
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    Panel1: TPanel;
    sgResult: TStringGrid;
    pnBottom: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    cbColumns: TComboBox;
    ToolButton1: TToolButton;
    tbExcel: TToolButton;
    tbDBF: TToolButton;
    ImageList: TImageList;
    hdTableCreate: THalcyonDataSet;
    chTableCreate: TCreateHalcyonDataSet;
    SaveDialog: TSaveDialog;
    ToolButton2: TToolButton;
    cbScale: TComboBox;
    procedure cbColumnsChange(Sender: TObject);
    procedure tbExcelClick(Sender: TObject);
    procedure tbDBFClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbScaleChange(Sender: TObject);
  private
    nColsSkipped, nRowsSkipped: Integer;
    nMaxRows, nMaxCols: Integer;
    ReportOptions: TReportOptions;
    Query: TOracleDataSet;
    dmData: TDMData;

    function FindCurrentRow( AQuery: TOracleDataSet): Integer;
    function FindCurrentCol( AQuery: TOracleDataSet; nFact: Integer): Integer;
    procedure CalculateResults( var AQuery: TOracleDataSet);
    procedure CheckForZeroColumns( AQuery: TOracleDataSet);
    procedure ClearGrid;

    procedure Export2Excel;
    procedure Export2DBF;

  public
    { Public declarations }
  end;

function ShowReportResult( ADMData: TDMData; var AReportOptions: TReportOptions;
  var AQuery: TOracleDataSet): Boolean;

function Rat( SubStr: String; Str: String): Integer;

implementation

uses Tools;

const
  xlThin       : LongInt = 2;
  xlContinuous : LongInt = 1;
  xlAutomatic  : LongInt = -4105;

{$R *.DFM}

{
 Делаем так: строки идут подряд начиная с нулевой позиции row
 Мы ищем их в rowCount если не нашли, то такую строку добавляем
 в конец нашей таблицы.


}

//
// поиск и добавление строки, если таковой нет
// Количество колонок для поиска задано в ReportOptions.RowListDesc
// поля им соответствущие есть в AQuery
//
function TfmReportResult.FindCurrentRow( AQuery: TOracleDataSet): Integer;
var iPtr, j  : Integer;
    StrSearch: String;
    curLine  : String;
begin
  Result := -1;
  StrSearch := '';
  for iPtr := 0 to ReportOptions.RowListDesc.Count - 1 do
    StrSearch := StrSearch + AQuery.Fields[ iPtr].asString + '##';
  for iPtr := nRowsSkipped to sgResult.RowCount - 1 do begin
    curLine := '';
    for j := 0 to ReportOptions.RowListDesc.Count - 1 do begin
      curLine := curLine + sgResult.Cells[ j, iPtr] + '##';
    end;
    if curLine = StrSearch then begin
      Result := iPtr;
      Break;
    end;
  end;
  //
  // Если не нашли данных, то добавим в первую пустую строку
  //
  if Result = -1 then begin
    for iPtr := nRowsSkipped to sgResult.RowCount - 1 do begin
       if sgResult.Cells[ 0, iPtr] = '' then begin
         Result := iPtr;
         Break;
       end;
    end;
  end;
  nMaxRows := max( nMaxRows, Result);
  for iPtr := 0 to ReportOptions.RowListDesc.Count - 1 do
    sgResult.Cells[ iPtr, Result] := AQuery.Fields[ iPtr].asString;
end;


//
// поиск и добавление строки, если таковой нет
// Количество колонок для поиска задано в ReportOptions.RowListDesc
// поля им соответствущие есть в AQuery
//
function TfmReportResult.FindCurrentCol( AQuery: TOracleDataSet;
  nFact: Integer): Integer;
var iPtr   : Integer;
    StrSearch : String;
    CubeColumn: TCubeColumn;
begin
  Result := -1;
  StrSearch := '';
  //
  // Определим номер измерения из cbColumns
  //
  if cbColumns.ItemIndex >= 0 then begin
    CubeColumn := TCubeColumn(ReportOptions.ColumnListDesc[ cbColumns.ItemIndex]);
    StrSearch  := AQuery.fieldByName( CubeColumn.ColumnName).asString + '/';
  end;
  //
  // теперь определим номер факта и его значения
  //
  CubeColumn := TCubeColumn(ReportOptions.LibraryListDesc[ nFact]);
  StrSearch := StrSearch + CubeColumn.ColumnFilter + '(' + IntToStr(nFact) +')';
  //
  // поиск в 0 строке такого названия
  //
  for iPtr := 0 to sgResult.ColCount - 1 do begin
    if sgResult.Cells[ iPtr, 0] = StrSearch then begin
      Result := iPtr;
      Break;
    end;
  end;
  //
  // если ничего не нашли, то добавляем колонку
  //
  if Result = - 1 then begin
    for iPtr := nColsSkipped to sgResult.ColCount - 1 do begin
      if sgResult.Cells[ iPtr, 0] = '' then begin
         sgResult.Cells[ iPtr, 0] := StrSearch;
         Result := iPtr;
         Break;
      end;
    end;
  end;
  nMaxCols := max( nMaxCols, Result);

end;


procedure TfmReportResult.ClearGrid;
var i, j: Integer;
begin
  for i := 0 to nMaxRows do
    for j := 0 to nMaxCols do sgResult.Cells[ j, i] := '';
end;

procedure TfmReportResult.CheckForZeroColumns( AQuery: TOracleDataSet);
var i, nSkipped: Integer;
    xResult: Double;
begin
  //
  // заполняем весь массив словами, что он
  // 1 - заполнен, если мы не хотим удалять нулевые колонки
  // 2 - пуст, если хотим удалять нули
  //
  ReportOptions.ZeroColumns.Clear;
  if not ReportOptions.StartOptions.lDeleteZeroColumns then begin
    for i := 0 to AQuery.Fields.Count - 1 do ReportOptions.ZeroColumns.Add( objFalse);
    Exit;
  end;
  nSkipped := ReportOptions.RowListDesc.Count + ReportOptions.ColumnListDesc.Count;
  for i := 0 to AQuery.Fields.Count - 1 do begin
   if i < nSkipped
     then ReportOptions.ZeroColumns.Add( objFalse)
     else ReportOptions.ZeroColumns.Add( objTrue);
  end;
  AQuery.First;
  while not AQuery.Eof do begin
    for i := nSkipped to AQuery.Fields.Count - 1 do begin
      try try
         xResult := AQuery.FieldList.Fields[ i].AsFloat;
         if xResult <> 0 then ReportOptions.ZeroColumns[ i] := objFalse;
       except
         on E: EConvertError do ;
       end;
      finally
      end;
    end;
    AQuery.Next;
  end;
  AQuery.First;
{  for i := nSkipped to ReportOptions.ZeroColumns.Count - 1 do begin
    if ReportOptions.ZeroColumns[ i] = objTrue then
    ShowMessage( 'Обнаружена нулевая колонка ' + IntToStr( i));
  end;
}

end;


procedure TfmReportResult.CalculateResults( var AQuery: TOracleDataSet);
  var iPtr: Integer;
      nRow, nCol: Integer;
      nCurrentValue: Double;
      nPower: Double;
      nColWidth: Integer;
begin
  nPower := 1;
  case cbScale.ItemIndex of
    0: nPower := 1;
    1: nPower := 1000;
    2: nPower := 1000000;
  end;
  ClearGrid;
  nRowsSkipped := 0;
  nColsSkipped  := ReportOptions.RowListDesc.Count;
  sgResult.FixedCols := nColsSkipped;
  for iPtr := 0 to ReportOptions.RowListDesc.Count - 1 do begin
    if ReportOptions.StartOptions.lDeleteZeroColumns then
      begin
       if ReportOptions.ZeroColumns[ iPtr] = objFalse then begin
         sgResult.Cells[ iPtr, nRowsSkipped] :=
           TCubeColumn( ReportOptions.RowListDesc[ iPtr]).ColumnLabel;
       end;
      end
    else
      sgResult.Cells[ iPtr, nRowsSkipped] :=
        TCubeColumn( ReportOptions.RowListDesc[ iPtr]).ColumnLabel;
  end;
  with AQuery do begin
    First;
    while not Eof do begin
      FindCurrentRow( AQuery);
      Next;
    end;
    First;
    while not Eof do begin
      for iPtr := 0 to ReportOptions.LibraryListDesc.Count - 1 do
        FindCurrentCol( AQuery, iPtr);
        Next;
      end;

    First;
    while not Eof do begin
      nRow := FindCurrentRow( AQuery);
      for iPtr := 0 to ReportOptions.LibraryListDesc.Count - 1 do begin
        nCol := FindCurrentCol( AQuery, iPtr);
        nCurrentValue := AQuery.fieldByName('fact' + IntToStr( 1 + iPtr)).asFloat;
        //
        // множитель
        //
        nCurrentValue := round( nCurrentValue/ nPower * 100)/ 100;

        if sgResult.Cells[ nCol, nRow] <> '' then begin
          nCurrentValue := nCurrentValue + StrToFloat( sgResult.Cells[ nCol, nRow]);
        end;
        sgResult.Cells[ nCol, nRow] := FloatToStr( nCurrentValue);
        // nColWidth := max( nColWidth, sgResult.Canvas.TextWidth( sgResult.Cells[ nCol, nRow]));

      end;
      Next;
    end;
  end;
  //
  // Определим максимальную ширину для 1 колонки
  //
  for nCol := 0 to sgResult.ColCount - 1 do begin
    nColWidth := 0;
    for nRow := 0 to sgResult.RowCount - 1 do begin
     nColWidth := max( nColWidth, sgResult.Canvas.TextWidth( sgResult.Cells[ nCol, nRow]));
    end;
    if nColWidth > 0 then sgResult.ColWidths[ nCol] := nColWidth + 5;
    if ReportOptions.StartOptions.lDeleteZeroColumns and
       ( ReportOptions.ZeroColumns.Count > nCol) and
       ( ReportOptions.ZeroColumns[ nCol] = objTrue) then begin
      sgResult.ColWidths[ nCol] := 0;
    end;

  end;
  //
  //
end;


function ShowReportResult( ADMData: TDMData; var AReportOptions: TReportOptions;
  var AQuery: TOracleDataSet): Boolean;
  var iPtr: Integer;
begin
  Result := False;
  with TfmReportResult.Create( Application) do
   try
     try
       dmData := ADMData;
       ReportOptions := AReportOptions;
       Query         := AQuery;
       sgResult.RowCount := 1000;
       sgResult.ColCount := 1000;
       nMaxCols := 0; nMaxRows := 0;
       for iPtr := 0 to ReportOptions.ColumnListDesc.Count - 1 do begin
         cbColumns.Items.Add(
            TCubeColumn( ReportOptions.ColumnListDesc[ iPtr]).ColumnLabel);
       end;
       cbColumns.ItemIndex := 0;
       CheckForZeroColumns( AQuery);
       CalculateResults( AQuery);
       SetForegroundWindow( Handle);
       ShowModal;
      except
        on E: Exception do ProcessException( E);
      end;
    finally
      Free;
    end;

end;


procedure TfmReportResult.Export2DBF;
var i, j: Integer;
    StrField : String;
    fileName : String;
begin
 if not SaveDialog.Execute then Exit;
 fileName := SaveDialog.FileName;
 try
   try
     chTableCreate.CreateFields.Clear;
     //
     // добавляем измерение
     //
     for i := 0 to ReportOptions.RowListDesc.Count - 1 do begin
       StrField := 'izm' + IntToStr( i + 1) + ';C;20;0';
       chTableCreate.CreateFields.Add( StrField);
     end;
     //
     // добавляем факты
     //
     for i := 1 to nMaxCols do begin
       StrField := 'fact' + IntToStr( i) + ';N;15;2';
       chTableCreate.CreateFields.Add( StrField);
     end;
     hdTableCreate.TableName := fileName;
     chTableCreate.Execute;
     hdTableCreate.Active := True;
     for i := 1 to nMaxRows do begin
       hdTableCreate.Insert;
       for j := 0 to nMaxCols do begin
         if j < ReportOptions.RowListDesc.Count
           then hdTableCreate.StringPut( 'izm' + IntToStr( j+1), sgResult.Cells[ j, i])
           else hdTableCreate.FloatPut( 'fact' + IntToStr( j),
              StrToFloat( sgResult.Cells[ j, i]));
       end;
       hdTableCreate.Post;
     end;
   except
     on E: Exception do ProcessException( E);
   end;
 finally
   hdTableCreate.Active := False;
 end;


end;

function Rat( SubStr: String; Str: String): Integer;
var Offset: Integer;
    Ptr   : Integer;
begin
  OffSet := 0;
  Result := 0;
  while True do begin
    Ptr := PosEx( SubStr, Str, OffSet + 1);
    if Ptr = 0 then Break;
    OffSet := Ptr;
  end;
  Result := OffSet;
end;


function ExtractFormulaName( AHeader: String): String;
var nPos1, nPos2: Integer;
begin
  nPos1 := Pos( '/', AHeader);
  nPos2 := Rat( '(', AHeader);
  if nPos2 = 0 then nPos2 := Length( AHeader) + 1;
  Result := Copy( AHeader, nPos1 + 1, nPos2 - 1 - nPos1);
end;

procedure TfmReportResult.Export2Excel;
var XL: Variant;
    i, j, jPtr, LibraryPtr: Integer;
    CubeColumn: TCubeColumn;
    nSkipped: Integer;
    SFormula: String;

begin
  nSkipped := ReportOptions.RowListDesc.Count;
  try
    try
     XL := CreateOleObject( 'Excel.Application');
     XL.Workbooks.Add;
     XL.WorkBooks[ 1].WorkSheets[ 1].Cells[ 1, 4] := ReportOptions.ReportName;
     XL.Visible := True;
     //
     // выводим строки с названием колонок и формул
     //
     jPtr := nSkipped;
     for j := nSkipped to nMaxCols do begin
         if ReportOptions.StartOptions.lDeleteZeroColumns and
           ( sgResult.ColWidths[ j] = 0) then Continue;
       XL.Workbooks[ 1].WorkSheets[ 1].Cells[ 2, jPtr + 1].Borders.LineStyle := xlContinuous;
       XL.Workbooks[ 1].WorkSheets[ 1].Cells[ 2, jPtr + 1].Borders.Weight := xlThin;
       XL.Workbooks[ 1].WorkSheets[ 1].Cells[ 2, jPtr + 1].Borders.ColorIndex := xlAutomatic;
       //
       // вывод названия формулы
       //
       XL.Workbooks[ 1].WorkSheets[ 1].Cells[ 2, jPtr + 1].NumberFormat := '@';
       XL.Workbooks[ 1].WorkSheets[ 1].Cells[ 2, jPtr + 1] := sgResult.Cells[ j, 0];
       //
       // вывод текста формулы
       //
       XL.Workbooks[ 1].WorkSheets[ 1].Cells[ 3, jPtr + 1].Borders.LineStyle := xlContinuous;
       XL.Workbooks[ 1].WorkSheets[ 1].Cells[ 3, jPtr + 1].Borders.Weight := xlThin;
       XL.Workbooks[ 1].WorkSheets[ 1].Cells[ 3, jPtr + 1].Borders.ColorIndex := xlAutomatic;
       //
       // вывод названия формулы
       //
       SFormula   := ExtractFormulaName( sgResult.Cells[ j, 0]);
       LibraryPtr := ReportOptions.LibraryListDesc.findByName( SFormula);
       SFormula := dmData.alTranslator.CreateRealFormula(
         TCubeColumn( ReportOptions.LibraryListDesc[ LibraryPtr]).LibraryID);
       {
       if j - nSkipped >= ReportOptions.LibraryListDesc.Count then
         begin
           SFormula   := ExtractFormulaName( sgResult.Cells[ j, 0]);
           LibraryPtr := ReportOptions.LibraryListDesc.findByName( SFormula);
           SFormula := dmData.alTranslator.CreateRealFormula(
            TCubeColumn( ReportOptions.LibraryListDesc[ LibraryPtr]).LibraryID);
         end
       else
         begin
       SFormula := dmData.alTranslator.CreateRealFormula(
            TCubeColumn( ReportOptions.LibraryListDesc[ j - nSkipped]).LibraryID);
         end;

       SFormula := Copy( SFormula, 2, Length( SFormula) -1);
       }
       XL.Workbooks[ 1].WorkSheets[ 1].Cells[ 3, jPtr + 1].NumberFormat := '@';
       XL.Workbooks[ 1].WorkSheets[ 1].Cells[ 3, jPtr + 1] := SFormula;
       Inc( jPtr);
     end;

     XL.Visible := True;
     for i := 0 to nMaxRows do begin
       jPtr := 0;
       for j := 0 to nMaxCols do begin
         if ReportOptions.StartOptions.lDeleteZeroColumns and
           ( sgResult.ColWidths[ j] = 0) then Continue;

         XL.Workbooks[ 1].WorkSheets[ 1].Cells[ i + 3, jPtr + 1].Borders.LineStyle := xlContinuous;
         XL.Workbooks[ 1].WorkSheets[ 1].Cells[ i + 3, jPtr + 1].Borders.Weight := xlThin;
         XL.Workbooks[ 1].WorkSheets[ 1].Cells[ i + 3, jPtr + 1].Borders.ColorIndex := xlAutomatic;

         cubeColumn := ReportOptions.RowListDesc[ 0];
         if ( j > nSkipped - 1) and( i > 0) then
          begin
            XL.Workbooks[ 1].WorkSheets[ 1].Cells[ i + 3, jPtr + 1].NumberFormat := '0,00';
            XL.Workbooks[ 1].WorkSheets[ 1].Cells[ i + 3, jPtr + 1] :=
              SafeStringToFloat( sgResult.Cells[ j, i]);
          end
         else
          begin
           if j < nSkipped then begin
             XL.Workbooks[ 1].WorkSheets[ 1].Cells[ i + 3, jPtr + 1].NumberFormat := '@';
             XL.Workbooks[ 1].WorkSheets[ 1].Cells[ i + 3, jPtr + 1] := sgResult.Cells[ j, i];
            end;
          end;
         Inc( jPtr);
       end;
     end;
     XL.Visible := True;
    except
      on E: Exception do ProcessException( E);
    end;
  finally
    XL := UnAssigned;
  end;



end;


procedure TfmReportResult.cbColumnsChange(Sender: TObject);
begin
  CalculateResults( Query);
end;

procedure TfmReportResult.tbExcelClick(Sender: TObject);
begin
  Export2Excel;
end;

procedure TfmReportResult.tbDBFClick(Sender: TObject);
begin
  Export2DBF;
end;

procedure TfmReportResult.FormCreate(Sender: TObject);
begin
  cbScale.ItemIndex := 0;
end;

procedure TfmReportResult.cbScaleChange(Sender: TObject);
begin
  CalculateResults( Query);
end;

end.

