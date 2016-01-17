unit fmFilterDates;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, CubeClasses, DataModule;


type
  TfmDateFilter = class(TForm)
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    dtStartDate: TDateTimePicker;
    dtStopDate: TDateTimePicker;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ShowDateFilter( var dmData: TDMData; var curColumn: TCubeColumn): Boolean;
function TranslateDateFilter( curColumn: TCubeColumn): String;

implementation

uses ReportOptionsClass;


{$R *.DFM}

function TranslateDateFilter( curColumn: TCubeColumn): String;
begin
  Result := '';
  if curColumn.ColumnFilter = '' then Exit;
  if curColumn.FieldType = 'DATE' then begin
    Result :=
      curColumn.ColumnName +
      ' >= to_Date( ''' + Copy( curColumn.ColumnFilter, 1, 10) + ''',''dd.mm.yyyy'') AND ' +
      curColumn.ColumnName +
      ' <= to_Date( ''' + Copy( curColumn.ColumnFilter,12, 22) + ''',''dd.mm.yyyy'') ';
  end;
end;

function ShowDateFilter( var dmData: TDMData; var curColumn: TCubeColumn): Boolean;
var S: String;
    ACompare: String;
begin

  s := curColumn.ColumnFilter;
  ACompare := curColumn.CompareWith;
  Result := False;
  with TfmDateFilter.Create( Application) do begin
    if S = '' then
      begin
        dtStartDate.DateTime := Now - 7;
        dtStopDate.DateTime  := Now;
      end
    else
      begin
        dtStartDate.DateTime  := StrToDate( Copy( S, 1, 10 ));
        dtStopDate.DateTime   := StrToDate( Copy( S, 12, 22));
      end;
    if ShowModal = mrOK then begin
      S := FormatDateTime( 'dd.mm.yyyy', dtStartDate.DateTime) + '-' +
           FormatDateTime( 'dd.mm.yyyy', dtStopDate.DateTime);
      ACompare := AFilterTypes[ ftIn];
      curColumn.CompareWith  := ACompare;
      curColumn.ColumnFilter := S;
      Result := True;
    end;
    Free;
  end;

end;

end.
