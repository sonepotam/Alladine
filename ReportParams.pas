unit ReportParams;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, ExtCtrls, CubeClasses, DataModule;

type
  TfmReportParams = class(TForm)
    Panel1: TPanel;
    lvFilter: TListView;
    btOK: TBitBtn;
    btCancel: TBitBtn;
    cbPreview: TCheckBox;
    cbDeleteZeroCols: TCheckBox;
    procedure lvFilterDblClick(Sender: TObject);
    procedure btOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    dmData: TDMData;
  end;

function fillReportParams( var ADMData: TDMData; var ParamList: TList;
  var StartingOptions: TStartingOptions): Boolean;

implementation
uses fmFilterDates, StringFilter,
     LibraryFilter, TempEdit, ReportView, ReportOptionsClass;

{$R *.DFM}

function fillReportParams( var ADMData: TDMData; var ParamList: TList;
  var StartingOptions: TStartingOptions): Boolean;
var iPtr: Integer;
    curColumn: TCubeColumn;
    newColumn: TCubeColumn;
    newItem  : TListItem;
begin
  Result := False;
  if ParamList.Count = 0 then begin
    Result := True;
    Exit;
  end;
  with TfmReportParams.Create( Application) do begin
    cbPreview.Checked        := StartingOptions.lPreview;
    cbDeleteZeroCols.Checked := StartingOptions.lDeleteZeroColumns;
    dmData := ADMData;
    for iPtr := 0 to ParamList.Count - 1 do begin
      curColumn := ParamList[ iPtr];
      newColumn := TCubeColumn.Create;
      curColumn.AssignTo( newColumn);
      newItem   := lvFilter.Items.Add;
      newItem.Caption := curColumn.ColumnLabel;
      newItem.SubItems.Add( curColumn.ColumnFilter);
      newItem.Data := newColumn;
    end;
    if ShowModal = mrOK then begin
      Result   := True;
      StartingOptions.lPreview           := cbPreview.Checked;
      StartingOptions.lDeleteZeroColumns := cbDeleteZeroCols.Checked;
      for iPtr := 0 to ParamList.Count - 1 do begin
        curColumn := ParamList[ iPtr];
        newItem   := lvFilter.Items[ iPtr];
        newColumn := newItem.Data;
        curColumn.ColumnFilter := newItem.SubItems[ 0];
        curColumn.CompareWith  := newColumn.CompareWith;
        newColumn.Free;
      end;
    end;
    Free;
  end;

end;


procedure TfmReportParams.lvFilterDblClick(Sender: TObject);
var curColumn : TCubeColumn;
    curFilter : String;
    curCompare: String;
    lChanged  : Boolean;
begin
  lChanged := False;
  if lvFilter.Selected = nil then Exit;
  curColumn := lvFilter.Selected.Data;
  curFilter := lvFilter.Selected.SubItems[ 0];
  if curColumn.FieldType = 'DATE' then begin
    lChanged := ShowDateFilter( dmData, curColumn);
  end;
  if curColumn.FieldType = ftVarChar2 then begin
    lChanged := ShowStringFilter( dmData, curColumn,  ftVarChar2);
  end;
  if curColumn.FieldType = ftNumber then begin
    lChanged := ShowStringFilter( dmData, curColumn, '');
  end;
  if lChanged then begin
    lvFilter.Selected.SubItems[ 0] := curColumn.ColumnFilter;
  end;


end;

procedure TfmReportParams.btOKClick(Sender: TObject);
var i: Integer;
    curColumn: TCubeColumn;
begin
  for i := 0 to lvFilter.Items.Count - 1 do begin
    curColumn := lvFilter.Items[ i].Data;
    if curColumn.isRequiredParam and
       (lvFilter.Items[ i].SubItems[ 0] = '') then begin
       MessageDlg( '¬ведите параметр ' + lvFilter.Items[ i].Caption,
         mtError, [mbOK], 0);
       ModalResult := mrNone;
       Exit;
    end;
  end;
end;

end.
