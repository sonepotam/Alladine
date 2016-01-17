unit TempEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  TfmTempEdit = class(TForm)
    Panel1: TPanel;
    Memo: TMemo;
    BitBtn1: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure ShowTextInfo( ACaption: String; S: String);

implementation

{$R *.DFM}

procedure ShowTextInfo( ACaption: String; S: String);
begin
  with TfmTempEdit.Create( Application) do begin
    Caption := ACaption;
    Memo.Text := S;
    ShowModal;
    Free;
  end;
end;

end.
