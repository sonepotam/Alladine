unit AddLibrarys;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  TAddLibrary = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    edLibraryName: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function AddLibrary( var ALibraryName: String): Boolean;

implementation
{$R *.DFM}

function AddLibrary( var ALibraryName: String): Boolean;
begin
  Result := False;
  with TAddLibrary.Create( Application) do begin
    edLibraryName.Text := ALibraryName;
    if ShowModal = mrOK then begin
       ALibraryName := edLibraryName.Text;
       Result := True;
    end;
  end;
end;


end.
