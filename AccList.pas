unit AccList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, DBGrids, ExtCtrls,
  DataModule;

type
  TfmAccList = class(TForm)
    Panel1: TPanel;
    dbgAccList: TDBGrid;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure ShowAccList( ADMData: TDMData);

implementation


{$R *.dfm}

procedure ShowAccList( ADMData: TDMData);
begin
  with TfmAccList.Create( Application) do
  try
    try
      ADMData.odsAccList.Open;
      ShowModal;
    except
      on E: Exception do ProcessException( E);
    end;
  finally
    ADMData.odsAccList.Close;
    Free;
  end;
end;



end.
