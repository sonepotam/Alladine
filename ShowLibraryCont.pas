unit ShowLibraryCont;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Grids, DBGrids, ExtCtrls, DataModule;

type
  TfmShowLibraryContent = class(TForm)
    Panel1: TPanel;
    dbgFormulasInLibrary: TDBGrid;
    BitBtn1: TBitBtn;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    dmData: TDMData;
  public
    { Public declarations }
  end;

procedure ShowLibraryContent( ADMData: TDMData; idLibrary: Double);

implementation

{$R *.DFM}

procedure ShowLibraryContent( ADMData: TDMData; idLibrary: Double);
begin
  if idLibrary = 0 then begin
    MessageDlg( 'Нет библиотеки', mtError, [mbOK], 0);
    Exit;
  end;
  with TfmShowLibraryContent.Create( Application) do
   try
     try
       dmData := ADMData;
       dmData.odsFormulasInLibrary.Active := False;
       dmData.odsFormulasInLibrary.SetVariable( 'curLibrary', idLibrary);
       dmData.odsFormulasInLibrary.Active := True;
       ShowModal;
     except
       on E: Exception do ProcessException( E);
     end;
   finally
    Free;
   end;
end;

procedure TfmShowLibraryContent.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_Escape then Close;
end;

end.
