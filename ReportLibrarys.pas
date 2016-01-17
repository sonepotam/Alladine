unit ReportLibrarys;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, ComCtrls, Buttons, ExtCtrls, StdCtrls, DataModule;

type
  TfmReportLibraryContent = class(TForm)
    pnMain: TPanel;
    pnAvailLibs: TPanel;
    lvInReports: TListView;
    Panel3: TPanel;
    sbAdd: TSpeedButton;
    sbRemove: TSpeedButton;
    Panel4: TPanel;
    dbgAllLibrarys: TDBGrid;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    sbDown: TSpeedButton;
    sbUp: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure sbAddClick(Sender: TObject);
    procedure sbRemoveClick(Sender: TObject);
    procedure sbUpClick(Sender: TObject);
    procedure sbDownClick(Sender: TObject);
  private
    fClassList: TStringList;
  public
    dmData: TDMData;
  end;


function ShowLibsInReport( ADMData: TDMData; nTaskClass: double): TStringList;


implementation
{$R *.DFM}

function ShowLibsInReport( ADMData: TDMData; nTaskClass: double): TStringList;
var newItem: TListItem;
    i      : Integer;
begin
  Result := TStringList.Create;
  with TfmReportLibraryContent.Create( Application) do
    try
      try
        dmData := ADMData;
        sbUp.Enabled     := nTaskClass < 0;
        sbDown.Enabled   := nTaskClass < 0;
        sbRemove.Enabled := nTaskClass < 0;
        sbAdd.Enabled    := nTaskClass < 0;
        //
        // заносим данные о библиотеках в отчете
        //
        with dmData.odsLibsInReport do begin
          Active := False;
          SetVariable( 'pTask', nTaskClass);
          Active := True;
          while not Eof do begin
            newItem := lvInReports.Items.Add;
            newItem.Caption := fieldByName( 'label').asString;
            //newItem.Data    := TObject( fieldByName( 'classified').asFloat);
            Next;
          End;
          Active := False;
        end;
        //
        // откроем библиотеки
        //
        dmData.odsLibrary.Active := True;
        //
        // покажем наш диалог
        //
        if ShowModal = mrOK then begin
          for i := 0 to fClassList.Count - 1 do Result.Add( fClassList[ i]);
        end;

      except
        on E: Exception do ProcessException( E);
      end;
    finally
      dmData.odsLibsInReport.Active := False;
      dmData.odsLibrary.Active      := False;
      Free;
    end;


end;


procedure TfmReportLibraryContent.FormCreate(Sender: TObject);
begin
  fClassList := TStringList.Create;
end;

procedure TfmReportLibraryContent.FormDestroy(Sender: TObject);
begin
  fClassList.Free;
end;

procedure TfmReportLibraryContent.sbAddClick(Sender: TObject);
var
  sLibraryName : String;
  nClassLibrary: double;
  sClassLibrary: String;
  //nCurrentIndex: Integer;
  newItem      : TListItem;
begin
  //
  // если такой библиотеки еще нет, то добавим ее
  //
  sLibraryName  := dmData.odsLibrary.fieldByName( 'label').asString;
  nClassLibrary := dmData.odsLibrary.fieldByName( 'Classified').asFloat;
  sClassLibrary := FloatToStr( nClassLibrary);
  //
  // поищем такую библиотеку в списке
  //
  if fClassList.IndexOf( sClassLibrary) > -1 then begin
    MessageDlg( 'Такая библиотека уже есть', mtError, [ mbOK], 0);
    Exit;
  end;
  //
  // включаем в библиотеку
  //
  newItem := lvInReports.Items.Add;
  newItem.Caption := sLibraryName;
  fClassList.Add( sClassLibrary);

end;



procedure TfmReportLibraryContent.sbRemoveClick(Sender: TObject);
var nCurrentIndex: Integer;
begin
  if lvInReports.Selected = nil then Exit;
  nCurrentIndex := lvInReports.Selected.Index;
  lvInReports.Items.Delete( nCurrentIndex);
  fClassList.Delete( nCurrentIndex);
end;



procedure TfmReportLibraryContent.sbUpClick(Sender: TObject);
var nCurrentIndex: Integer;
    sClassLibrary: String;
    sLibraryName : String;
begin
  if lvInReports.Selected = nil then Exit;
  nCurrentIndex := lvInReports.Selected.Index;
  if nCurrentIndex = 0 then Exit;
  // сохраним значение из верхней строки
  sLibraryName := lvInReports.Items[ nCurrentIndex - 1].Caption;
  sClassLibrary:= fClassList[        nCurrentIndex - 1];
  // в верхнюю строку запишем новое значение
  lvInReports.Items[ nCurrentIndex - 1] := lvInReports.Items[ nCurrentIndex];
  fClassList[        nCurrentIndex - 1] := fClassList[        nCurrentIndex];
  // в нижнюю строку запишем сохраненные значения
  lvInReports.Items[ nCurrentIndex].Caption := sLibraryName;
  fClassList[        nCurrentIndex]         := sClassLibrary;
  lvInReports.Selected := lvInReports.Items[ nCurrentIndex - 1];
end;

procedure TfmReportLibraryContent.sbDownClick(Sender: TObject);
var nCurrentIndex: Integer;
    sClassLibrary: String;
    sLibraryName : String;
begin
  if lvInReports.Selected = nil then Exit;
  nCurrentIndex := lvInReports.Selected.Index;
  if nCurrentIndex = lvInReports.Items.Count - 1 then Exit;
  // сохраним значение из нижней строки
  sLibraryName := lvInReports.Items[ nCurrentIndex + 1].Caption;
  sClassLibrary:= fClassList[        nCurrentIndex + 1];
  // в нижнюю строку запишем новое значение
  lvInReports.Items[ nCurrentIndex + 1] := lvInReports.Items[ nCurrentIndex];
  fClassList[        nCurrentIndex + 1] := fClassList[        nCurrentIndex];
  // в верхнюю строку запишем сохраненные значения
  lvInReports.Items[ nCurrentIndex].Caption := sLibraryName;
  fClassList[        nCurrentIndex]         := sClassLibrary;
  lvInReports.Selected := lvInReports.Items[ nCurrentIndex + 1];
end;

end.
