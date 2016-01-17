unit SelectValue;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, OracleData, Grids, DBGrids, StdCtrls, Buttons, ExtCtrls, DataModule;

type
  TfmSelectValue = class(TForm)
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    OracleDataSet: TOracleDataSet;
    procedure DBGrid1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function JSelectValue( var dmData: TDMData; S: String; var ALabel, ACode: String): Boolean;

implementation

uses CubeClasses;

{$R *.DFM}

function JSelectValue( var dmData: TDMData; S: String; var ALabel, ACode: String): Boolean;
begin
  ALabel := '';
  ACode  := '';
  Result := False;
  with TfmSelectValue.Create( Application) do begin
    OracleDataSet.Session  := dmData.osMain;
    OracleDataSet.SQL.Text := S;
    OracleDataSet.Open;
    if ShowModal = mrOK then begin
      ACode  := OracleDataSet.Fields[ 0].AsString;
      ALabel := OracleDataSet.Fields[ 1].AsString;
      Result := True;
    end;
    OracleDataSet.Close;

  end;

end;

procedure TfmSelectValue.DBGrid1DblClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

end.
