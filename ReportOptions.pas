unit ReportOptions;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, ExtCtrls, Grids, CubeClasses, DBGrids, Math,
  Menus, ReportOptionsClass, DataModule;

type
  TfmReportOptions = class(TForm)
    pnMain: TPanel;
    pnRight: TPanel;
    pnLeft: TPanel;
    pnTop: TPanel;
    lvFilter: TListView;
    lvParams: TListView;
    lvColumnList: TListView;
    Splitter1: TSplitter;
    Panel2: TPanel;
    btOK: TBitBtn;
    btCancel: TBitBtn;
    pnRightBottom: TPanel;
    lvDimRows: TListView;
    pnFactAndColumns: TPanel;
    lvFacts: TListView;
    lvDimColumns: TListView;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    Splitter4: TSplitter;
    Splitter5: TSplitter;
    pmFacts: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    procedure lvDimColumnsDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure lvDimRowsDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure lvDimColumnsDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lvDimRowsDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure FormDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure FormDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lvColumnListDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure lvColumnListDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lvDimColumnsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lvDimRowsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lvFactsDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure lvFactsDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lvFactsDblClick(Sender: TObject);
    procedure lvFilterDblClick(Sender: TObject);
    procedure lvFilterDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure lvFilterDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lvFilterKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lvFactsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lvFactsStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure lvParamsDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure lvParamsDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lvParamsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure N1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
  private
    SelectedItem : TListItem;
    ReportOptions: TReportOptions;
    procedure PrepareSQL;
    procedure WriteTaskAttributes;
    procedure ReadTaskAttributes;

    constructor CreateOptions( ADMData: TDMData; AOwner: TComponent; AReportOptions: TReportOptions);
  public
    dmData       : TDMData;
  end;

function CreateCubeOption( var ADMData: TDMData; var ReportOptions: TReportOptions): Boolean;

implementation
uses fmFilterDates, StringFilter,
  LibraryFilter, TempEdit, ReportView, ShowLibraryCont;
{$R *.DFM}

function ScanLabel( ListView: TListView; S: String): Integer;
var i: Integer;
    curItem: TListItem;
begin
  Result := -1;
  for i := 0 to ListView.Items.Count - 1 do begin
    curItem := ListView.Items[ i];
    if curItem.Caption = S then begin
      Result := i;
      Exit;
    end;
  end;
end;


function GetListViewMaxCaptionWidth( List: TListView): Integer;
var i, curWidth: Integer;
begin
  Result := 0;
  for i := 0 to List.Items.Count - 1 do begin
    curWidth := List.Canvas.TextWidth( List.Items[ i].Caption);
    Result   := Max( Result, curWidth);
  end;
end;

function CreateCubeOption( var ADMData: TDMData; var ReportOptions: TReportOptions): Boolean;
var newColumn : TCubeColumn;
    newItem   : TListItem;
begin
  Result := False;
  with TfmReportOptions.CreateOptions( ADMData, Application, ReportOptions) do
    try
      try
       // dmData := ADMData;
        with dmData.odsColumnList do begin
          Active := False;
          SetVariable( 'pTable', ReportOptions.idCube);
          Active := True;
          while not Eof do begin
            newColumn := TCubeColumn.Create;
            newColumn.Classified  := fieldByName( 'Classified').asFloat;
            newColumn.ColumnName  := fieldByName( 'columnname').asString;
            newColumn.ColumnDesc  := fieldByName( 'description').asString;
            newColumn.ColumnLabel := fieldByName( 'label'     ).asString;
            newColumn.ColumnType  := ctDimension;
            if fieldByName( 'columnType').asFloat = 2
               then newColumn.ColumnType  := ctFact;
            newColumn.ColumnFilter:= '';
            newColumn.FieldType   := fieldByName( 'data_type').asString;
            newColumn.LibraryID   := 0;
            newColumn.DescTable   := dmData.GetDescTable( newColumn.Classified);
            newItem := lvColumnList.Items.Add;
            newItem.Caption := newColumn.ColumnLabel;
            newItem.Data    := newColumn;
            Next;
          end;
        end;
        lvColumnList.Refresh;
        ReadTaskAttributes;
        if ShowModal = mrOK then begin
          Result := True;
          prepareSQL;
          WriteTaskAttributes;
          dmData.osMain.Commit;
          //
          // просмотр результатов
          //
          //PreviewReport( ReportOptions);

        end;
      except
        on E: Exception do ProcessException( E);
      end;
    finally
      dmData.odsColumnList.Active := False;
      Free;
    end;
end;


constructor TfmReportOptions.CreateOptions( ADMData: TDMData; AOwner: TComponent; AReportOptions: TReportOptions);
begin
  inherited Create( AOwner);
  ReportOptions := AReportOptions;
  dmData := ADMData;
end;


procedure TfmReportOptions.ReadTaskAttributes; // ( var ReportOptions: TReportOptions);
var
    iPtr        : Integer;
    curColumn   : TCubeColumn;
    newItem     : TListItem;
begin
  if ReportOptions.idTask = -1 then Exit;
  //
  // перенос колонок
  //
  for iPtr := 0 to ReportOptions.ColumnListDesc.Count - 1 do begin
    curColumn := TCubeColumn.Create;
    TCubeColumn( ReportOptions.ColumnListDesc[ iPtr]).AssignTo( curColumn);
    newItem := lvDimColumns.Items.Add;
    newItem.Caption := curColumn.ColumnLabel;
    newItem.Data    := curColumn;
  end;
  //
  // перенос столбцов
  //
  for iPtr := 0 to ReportOptions.RowListDesc.Count - 1 do begin
    curColumn := TCubeColumn.Create;
    TCubeColumn( ReportOptions.RowListDesc[ iPtr]).AssignTo( curColumn);
    newItem := lvDimRows.Items.Add;
    newItem.Caption := curColumn.ColumnLabel;
    newItem.Data    := curColumn;
  end;
  //
  // перенос фильтров
  //
  for iPtr := 0 to ReportOptions.FilterListDesc.Count - 1 do begin
    curColumn := TCubeColumn.Create;
    TCubeColumn( ReportOptions.FilterListDesc[ iPtr]).AssignTo( curColumn);
    newItem := lvFilter.Items.Add;
    newItem.Caption := curColumn.ColumnLabel;
    newItem.Data    := curColumn;
    newItem.SubItems.Add( curColumn.CompareWith );
    newItem.SubItems.Add( curColumn.ColumnFilter);
  end;
  //
  // перенос параметров
  //
  for iPtr := 0 to ReportOptions.ParamListDesc.Count - 1 do begin
    curColumn := TCubeColumn.Create;
    TCubeColumn( ReportOptions.ParamListDesc[ iPtr]).AssignTo( curColumn);
    newItem := lvParams.Items.Add;
    newItem.Caption := curColumn.ColumnLabel;
    newItem.Data    := curColumn;
  end;
  //
  // перенос фактов
  //
  for iPtr := 0 to ReportOptions.LibraryListDesc.Count - 1 do begin
    curColumn := TCubeColumn.Create;
    TCubeColumn( ReportOptions.LibraryListDesc[ iPtr]).AssignTo( curColumn);
    newItem := lvFacts.Items.Add;
    newItem.Caption := curColumn.ColumnLabel;
    newItem.Data    := curColumn;
    // newItem.SubItems.Add( curColumn.ColumnFilter);
  end;




end;

procedure TfmReportOptions.WriteTaskAttributes; //( var ReportOptions: TReportOptions);
var i: Integer;
    curColumn : TCubeColumn;
begin
  try
    try
      //
      // переносим данные о фильтрах
      //
      dmData.alInterface.DeleteTaskAttrs( ReportOptions.idTask);
      for i := 0 to ReportOptions.FilterListDesc.Count - 1 do begin
        curColumn := ReportOptions.FilterListDesc[ i];
        dmData.alInterface.AddTaskAttr( ReportOptions.idTask, taAttrFilter, i,
          curColumn.Classified, curColumn.ColumnFilter, curColumn.CompareWith);
      end;
      //
      // переносим данные о колонках
      //
      for i := 0 to ReportOptions.ColumnListDesc.Count - 1 do begin
        curColumn := ReportOptions.ColumnListDesc[ i];
        dmData.alInterface.AddTaskAttr( ReportOptions.idTask, taAttrColumn, i,
          curColumn.Classified, '', '');
      end;
      //
      // переносим данные о строках
      //
      for i := 0 to ReportOptions.RowListDesc.Count - 1 do begin
        curColumn := ReportOptions.RowListDesc[ i];
        dmData.alInterface.AddTaskAttr( ReportOptions.idTask, taAttrRow, i,
          curColumn.Classified, '', '');
      end;
      //
      // переносим данные о фактах
      //
      for i := 0 to ReportOptions.LibraryListDesc.Count - 1 do begin
        curColumn := ReportOptions.LibraryListDesc[ i];
        dmData.alInterface.AddTaskAttr( ReportOptions.idTask, taAttrFact, i,
          curColumn.LibraryID, FloatToStr( curColumn.LibraryID), '');
      end;
      //
      // переносим данные о параметрах
      //
      for i := 0 to ReportOptions.ParamListDesc.Count - 1 do begin
        curColumn := ReportOptions.ParamListDesc[ i];
        dmData.alInterface.AddTaskAttr( ReportOptions.idTask, taAttrParam, i,
          curColumn.Classified, '', '');
      end;
      except
        on E: Exception do ProcessException( E);
      end;
    finally
    end;

end;


procedure TfmReportOptions.PrepareSQL; //( var ReportOptions: TReportOptions);
var iPtr: Integer;
    AColumn: TCubeColumn;
begin

  ReportOptions.RowListDesc.Clear;
  ReportOptions.ColumnListDesc.Clear;
  ReportOptions.LibraryListDesc.Clear;
  ReportOptions.ParamListDesc.Clear;
  ReportOptions.FilterListDesc.Clear;

  for iPtr := 0 to lvDimRows.Items.Count - 1 do begin
    AColumn := TCubeColumn.Create;
    TCubeColumn( lvDimRows.Items[ iPtr].Data).AssignTo( AColumn);
    ReportOptions.RowListDesc.Add( AColumn);
  end;
  for iPtr := 0 to lvDimColumns.Items.Count - 1 do begin
    AColumn := TCubeColumn.Create;
    TCubeColumn( lvDimColumns.Items[ iPtr].Data).AssignTo( AColumn);
    ReportOptions.ColumnListDesc.Add( AColumn);
  end;
  for iPtr := 0 to lvFacts.Items.Count - 1 do begin
    AColumn := TCubeColumn.Create;
    TCubeColumn( lvFacts.Items[ iPtr].Data).AssignTo( AColumn);
    ReportOptions.LibraryListDesc.Add( AColumn);
  end;
  for iPtr := 0 to lvParams.Items.Count - 1 do begin
    AColumn := TCubeColumn.Create;
    TCubeColumn( lvParams.Items[ iPtr].Data).AssignTo( AColumn);
    ReportOptions.ParamListDesc.Add( AColumn);
  end;
  for iPtr := 0 to lvFilter.Items.Count - 1 do begin
    AColumn := TCubeColumn.Create;
    TCubeColumn( lvFilter.Items[ iPtr].Data).AssignTo( AColumn);
    ReportOptions.FilterListDesc.Add( AColumn);
  end;

end;


procedure TfmReportOptions.lvDimColumnsDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
    newItem  : TListItem;
    curItem  : TListItem;
    selItem  : TListItem;

    sCaption : String;
    curColumn: TCubeColumn;
begin
  if Source = lvColumnList then begin
    curItem := lvColumnList.Selected;
    if curItem = nil then Exit;
    if ScanLabel( lvDimColumns, curItem.Caption) >= 0 then Exit;
    if ScanLabel( lvDimRows,    curItem.Caption) >= 0 then Exit;
    if ScanLabel( lvFacts  ,    curItem.Caption) >= 0 then Exit;
    if TCubeColumn(curItem.Data).COlumnType <> ctDimension then Exit;

    curItem := lvDimColumns.GetItemAt( X, Y);
    if curItem <> nil
      then newItem := lvDimColumns.Items.Insert( curItem.Index)
      else newItem := lvDimColumns.Items.Add;
    newItem.Caption := lvColumnList.Selected.Caption;
    newItem.Data    := lvColumnList.Selected.Data;
  end;
  if Source = lvDimColumns then begin
    curItem  := lvDimColumns.GetItemAt( X, Y);
    selItem  := lvDimColumns.Selected;
    if selItem =  nil then Exit;
    if curItem =  nil then Exit;
    if curItem = selItem then Exit;

    sCaption := selItem.Caption;
    curColumn := TCubeColumn.Create;
    TCubeColumn(selItem.Data).AssignTo( curColumn);

    lvDimColumns.Items.Delete( selItem.Index);
    newItem := lvDimColumns.Items.Insert( curItem.Index);
    newItem.Caption := sCaption;
    newItem.Data := curColumn;
  end;

end;

procedure TfmReportOptions.lvDimRowsDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
    newItem  : TListItem;
    curItem  : TListItem;
    selItem  : TListItem;

    sCaption : String;
    curColumn: TCubeColumn;
begin
  if Source = lvColumnList then begin
    curItem := lvColumnList.Selected;
    if curItem = nil then Exit;
    if ScanLabel( lvDimColumns, curItem.Caption) >= 0 then Exit;
    if ScanLabel( lvDimRows,    curItem.Caption) >= 0 then Exit;
    if ScanLabel( lvFacts  ,    curItem.Caption) >= 0 then Exit;
    if TCubeColumn(curItem.Data).ColumnType <> ctDimension then Exit;

    curItem := lvDimRows.GetItemAt( X, Y);
    if curItem <> nil
      then newItem := lvDimRows.Items.Insert( curItem.Index)
      else newItem := lvDimRows.Items.Add;
    newItem.Caption := lvColumnList.Selected.Caption;
    newItem.Data    := lvColumnList.Selected.Data;
    // newItem.SubItems.Add( '');
  end;
  if Source = lvDimRows then begin
    curItem  := lvDimRows.GetItemAt( X, Y);
    selItem  := lvDimRows.Selected;
    if selItem =  nil then Exit;
    if curItem =  nil then Exit;
    if curItem = selItem then Exit;

    sCaption := selItem.Caption;
    curColumn := TCubeColumn.Create;
    TCubeColumn(selItem.Data).AssignTo( curColumn);

    lvDimRows.Items.Delete( selItem.Index);
    newItem := lvDimRows.Items.Insert( curItem.Index);
    newItem.Caption := sCaption;
    newItem.Data := curColumn;
  end;

end;

procedure TfmReportOptions.lvDimColumnsDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var curItem: TListItem;
begin
  Accept := False;
  if Source = lvColumnList then begin
     curItem := lvColumnList.Selected;
    if curItem = nil then Exit;
    if ScanLabel( lvDimColumns, curItem.Caption) >= 0 then Exit;
    if ScanLabel( lvDimRows,    curItem.Caption) >= 0 then Exit;
    if ScanLabel( lvFacts  ,    curItem.Caption) >= 0 then Exit;
    if TCubeColumn(curItem.Data).ColumnType <> ctDimension then Exit;
    Accept := True;
  end;
  if Source = lvDimColumns then begin
    Accept := True;
  end;
end;

procedure TfmReportOptions.lvDimRowsDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var curItem: TListItem;
begin
  Accept := False;
  if Source = lvColumnList then begin
     curItem := lvColumnList.Selected;
    if curItem = nil then Exit;
    if ScanLabel( lvDimColumns, curItem.Caption) >= 0 then Exit;
    if ScanLabel( lvDimRows,    curItem.Caption) >= 0 then Exit;
    if ScanLabel( lvFacts  ,    curItem.Caption) >= 0 then Exit;
    if TCubeColumn(curItem.Data).ColumnType <> ctDimension then Exit;
    Accept := True;
  end;
  if Source = lvDimRows then begin
    Accept := True;
  end;

end;

procedure TfmReportOptions.FormDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
//
end;

procedure TfmReportOptions.FormDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
//
end;

procedure TfmReportOptions.lvColumnListDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var ListView: TListView;
begin
 if ( Source is TListView) and ( Source <> lvColumnList) then begin
   ListView := TListView(Source);
   if ListView.Selected = nil then Exit;
   ListView.Items.Delete( ListView.Selected.Index);
 end;
end;

procedure TfmReportOptions.lvColumnListDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
 Accept := Source <> lvFacts;
end;

procedure TfmReportOptions.lvDimColumnsKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = vk_Delete then begin
    if lvDimColumns.Selected = nil then Exit;
    lvDimColumns.Items.Delete( lvDimColumns.Selected.Index);
  end;
end;

procedure TfmReportOptions.lvDimRowsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_Delete then begin
    if lvDimRows.Selected = nil then Exit;
    lvDimRows.Items.Delete( lvDimRows.Selected.Index);
  end;

end;

procedure TfmReportOptions.lvFactsDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
    newItem  : TListItem;
    selItem  : TListItem;
    curItem  : TListItem;
    curColumn: TCubeColumn;
    sCaption : String;
    sFormula : String;
begin
  {
  if Source = lvColumnList then begin
    curItem := lvColumnList.Selected;
    if curItem = nil then Exit;
    if ScanLabel( lvDimColumns, curItem.Caption) >= 0 then Exit;
    if ScanLabel( lvDimRows,    curItem.Caption) >= 0 then Exit;
    if TCubeColumn(curItem.Data).ColumnType <> ctFact then Exit;

    curItem := lvFacts.GetItemAt( X, Y);
    if curItem <> nil
      then newItem := lvFacts.Items.Insert( curItem.Index)
      else newItem := lvFacts.Items.Add;
    curColumn := TCubeColumn.Create;
    TCubeColumn( lvColumnList.Selected.Data).AssignTo( curColumn);
    newItem.Caption := lvColumnList.Selected.Caption;
    newItem.Data    := curColumn;
    newItem.SubItems.Add( '');
  end;
  }

  if Source = lvFacts then begin
    curItem  := lvFacts.GetItemAt( X, Y);
    selItem  := lvFacts.Selected;
    if selItem =  nil then Exit;
    if curItem =  nil then Exit;
    if curItem = selItem then Exit;

    sCaption := selItem.Caption;
    //sFormula := selItem.SubItems[ 0];
    curColumn := TCubeColumn.Create;
    TCubeColumn(selItem.Data).AssignTo( curColumn);

    lvFacts.Items.Delete( selItem.Index);
    newItem := lvFacts.Items.Insert( curItem.Index);
    newItem.Caption := sCaption;
    //newItem.SubItems.Add( sFormula);
    newItem.Data := curColumn;
  end;
end;

procedure TfmReportOptions.lvFactsDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
//var curItem: TListItem;
begin
  Accept := False;
{  if Source = lvColumnList then begin
     curItem := lvColumnList.Selected;
    if curItem = nil then Exit;
    if ScanLabel( lvDimColumns, curItem.Caption) >= 0 then Exit;
    if ScanLabel( lvDimRows,    curItem.Caption) >= 0 then Exit;
    if TCubeColumn(curItem.Data).ColumnType <> ctFact then Exit;
    Accept := True;
  end;
 }
  if Source = lvFacts then begin
    Accept := True;
  end;
end;



procedure TfmReportOptions.lvFactsDblClick(Sender: TObject);
var curColumn: TCubeColumn;
    curFilter: String;
    curID    : Double;
begin
  if lvFacts.Selected = nil then Exit;
  curColumn := lvFacts.Selected.Data;
  // curFilter := lvFacts.Selected.SubItems[ 0];
  curFilter := lvFacts.Selected.Caption;
  curID     := curColumn.LibraryID;
  if ShowLibraryFilter( dmData, curFilter, curID) then
    try
     try
      dmData.alTranslator.CheckLibraryByCube( curID, ReportOptions.idCube);
      // lvFacts.Selected.SubItems[ 0] := curFilter;
      lvFacts.Selected.Caption := curFilter;
      curColumn.LibraryID      := curID;
      curColumn.ColumnFilter   := curFilter;
     except
      on E: Exception do ProcessException( E);
     end;
    finally
    end;
end;



procedure TfmReportOptions.lvFilterDblClick(Sender: TObject);
var curColumn : TCubeColumn;
    curFilter : String;
    curCompare: String;
begin
  if lvFilter.Selected = nil then Exit;
  curColumn  := lvFilter.Selected.Data;
  curCompare := lvFilter.Selected.SubItems[ 0];
  curFilter  := lvFilter.Selected.SubItems[ 1];
  if curColumn.FieldType = 'DATE' then begin
    if ShowDateFilter( dmData, curColumn) then
      lvFilter.Selected.SubItems[ 0] := curCompare;
      lvFilter.Selected.SubItems[ 1] := curFilter;
      //curColumn.ColumnFilter := curFilter;
      //curColumn.CompareWith  := curCompare;
  end;
  if curColumn.FieldType = ftVarChar2 then begin
    if ShowStringFilter( dmData, curColumn, ftVarChar2) then
      lvFilter.Selected.SubItems[ 0] := curColumn.CompareWith; // curCompare;
      lvFilter.Selected.SubItems[ 1] := curColumn.ColumnFilter;//curFilter;
      // curColumn.CompareWith  := curCompare;
      // curColumn.ColumnFilter := curFilter;
  end;

  if curColumn.FieldType = ftNumber then begin
    if ShowStringFilter( dmData, curColumn, ftNumber) then
      lvFilter.Selected.SubItems[ 0] := curCompare;
      lvFilter.Selected.SubItems[ 1] := curFilter;
      curColumn.ColumnFilter := curFilter;
      curColumn.CompareWith  := curCompare;
  end;

end;

procedure TfmReportOptions.lvFilterDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  newItem  : TListItem;
  curItem  : TListItem;
  curColumn: TCubeColumn;
begin
  if Source = lvColumnList then begin
    curItem := lvColumnList.Selected;
    if curItem = nil then Exit;
    curItem := lvFilter.GetItemAt( X, Y);
    if curItem <> nil
      then newItem := lvFilter.Items.Insert( curItem.Index)
      else newItem := lvFilter.Items.Add;
    newItem.Caption := lvColumnList.Selected.Caption;
    curColumn := TCubeColumn.Create;
    TCubeColumn( lvColumnList.Selected.Data).AssignTo( curColumn);
    newItem.Data    := curColumn;
    newItem.SubItems.Add( '');
    newItem.SubItems.Add( '');
  end;


end;

procedure TfmReportOptions.lvFilterDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var curItem: TListItem;
begin
  Accept := False;
  if Source = lvColumnList then begin
     curItem := lvColumnList.Selected;
    if curItem = nil then Exit;
    if ScanLabel( lvFilter, curItem.Caption) >= 0 then Exit;
//    if TCubeColumn( curItem.Data).ColumnType <> ctDimension then Exit;
    Accept := True;
  end;

end;

procedure TfmReportOptions.lvFilterKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_Delete then begin
    if lvFilter.Selected = nil then Exit;
    lvFilter.Items.Delete( lvFilter.Selected.Index);
  end;
end;

procedure TfmReportOptions.lvFactsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_Delete then begin
    if lvFacts.Selected = nil then Exit;
    lvFacts.Items.Delete( lvFacts.Selected.Index);
  end;
end;

procedure TfmReportOptions.lvFactsStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  SelectedItem := lvFacts.Selected;
end;

procedure TfmReportOptions.lvParamsDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  newItem  : TListItem;
  curItem  : TListItem;
  curColumn: TCubeColumn;
begin
  if Source = lvColumnList then begin
    curItem := lvColumnList.Selected;
    if curItem = nil then Exit;
    curItem := lvParams.GetItemAt( X, Y);
    if curItem <> nil
      then newItem := lvParams.Items.Insert( curItem.Index)
      else newItem := lvParams.Items.Add;
    newItem.Caption := lvColumnList.Selected.Caption;
    curColumn := TCubeColumn.Create;
    TCubeColumn( lvColumnList.Selected.Data).AssignTo( curColumn);
    newItem.Data    := curColumn;
    newItem.SubItems.Add( '');
  end;
end;

procedure TfmReportOptions.lvParamsDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var curItem: TListItem;
begin
  Accept := False;
  if Source = lvColumnList then begin
     curItem := lvColumnList.Selected;
    if curItem = nil then Exit;
    if ScanLabel( lvParams, curItem.Caption) >= 0 then Exit;
    if TCubeColumn( curItem.Data).ColumnType <> ctDimension then Exit;
    Accept := True;
  end;
end;

procedure TfmReportOptions.lvParamsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_Delete then begin
    if lvParams.Selected = nil then Exit;
    lvParams.Items.Delete( lvParams.Selected.Index);
  end;
end;


procedure TfmReportOptions.N1Click(Sender: TObject);
var curColumn: TCubeColumn;
    curFilter: String;
    curID    : Double;
begin
  if lvFacts.Selected = nil then Exit;
  curColumn := lvFacts.Selected.Data;
  curFilter := lvFacts.Selected.Caption;
  curID     := curColumn.LibraryID;
  ShowLibraryContent( dmData, curID);
end;

procedure TfmReportOptions.N3Click(Sender: TObject);
begin
  lvFactsDblClick( Self);
end;

procedure TfmReportOptions.N4Click(Sender: TObject);
var curFilter: String;
    curID    : Double;
    newColumn: TCubeColumn;
    newItem  : TListItem;
    iPtr     : Integer;
begin
  curFilter := '';
  curID     := 0;
  if ShowLibraryFilter( dmData, curFilter, curID) then
    try
     try
      dmData.alTranslator.CheckLibraryByCube( curID, ReportOptions.idCube);

      if ScanLabel( lvFacts, curFilter) > -1 then begin
        ShowMessage( '“акой набор уже есть !');
        Exit;
      end;

      newColumn := dmData.CreateColumn( curID);
      newColumn.ColumnFilter := curFilter;
      newColumn.ColumnLabel  := curFilter;
      newColumn.LibraryID    := curID;
      newItem := lvFacts.Items.Add;
      newItem.Caption := curFilter;
      newItem.Data    := newColumn;


     except
      on E: Exception do ProcessException( E);
     end;
    finally
    end;

end;

end.
