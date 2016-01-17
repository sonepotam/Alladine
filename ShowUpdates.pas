unit ShowUpdates;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Db, ExtCtrls, Grids, DBGrids, DataModule;

type
  TfmUpdateInfo = class(TForm)
    Panel1: TPanel;
    dsStartInfo: TDataSource;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    DBGrid1: TDBGrid;
  private
    dmData: TDMData;
  public
    { Public declarations }
  end;

procedure ShowStartInfo( ADMData: TDMData);

implementation

uses ErrorForm, Tools;

{$R *.DFM}

procedure ShowStartInfo( ADMData: TDMData);
begin
 with TfmUpdateInfo.Create( Application) do
  try
    try
      dmData := ADMData;
      dmData.odsStartInfo.Active := True;
      ShowModal;
    except
     on E: Exception do ProcessException( E);
    end;
   finally;
     dmData.odsStartInfo.Active := False;
     Free;
   end;
end;

end.
