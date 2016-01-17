unit ErrorForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, DB, DBTables, Oracle;



type
  TErrorWindow = class(TForm)
    pnDetails: TPanel;
    pnButtons: TPanel;
    pnMessage: TPanel;
    imIcon: TImage;
    meMessage: TMemo;
    lbServer: TLabel;
    edServerCode: TEdit;
    bbClose: TBitBtn;
    bbPrev: TBitBtn;
    bbNext: TBitBtn;
    meCommonMsg: TMemo;
    procedure bbPrevClick(Sender: TObject);
    procedure bbNextClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    ErrorNames  : TStringList;
    ErrorCodes  : TStringList;
    Exception   : EOracleError;
    CurrentError: Integer;
    procedure ShowErrorInfo;
    procedure TranslateError;
  public
    { Public declarations }
    constructor CreateForm(AOwner: TForm; AnException: EOracleError);
    procedure SetException(E: EOracleError);
  end;


//var
//  ErrorWindow: TErrorWindow;
procedure ShowOracleError( AOwner: TForm; E: EOracleError);

implementation

{$R *.DFM}


procedure ShowOracleError( AOwner: TForm; E: EOracleError);
var S: String;
    iPtr: Integer;
begin
  if E.ErrorCode = 20000 then begin
    S := E.Message;
    iPtr := Pos( #10, S);
    if iPtr > 0 then S := Copy( S, 1, iPtr - 1);
    S := Copy( S, 11, Length( S));
    ShowMessage( S);
    Exit;
  end;
  with TErrorWindow.CreateForm( AOwner, E) do
    begin
      ShowModal;
      Free;
    end;
end;

constructor TErrorWindow.CreateForm(AOwner: TForm; AnException: EOracleError);
begin
  inherited Create(AOwner);
  Exception := AnException;
  ErrorNames:= TStringList.Create;
  ErrorCodes:= TStringList.Create;
  CurrentError := 0;
  TranslateError;
end;

procedure TErrorWindow.TranslateError;
var S,s1: String;
    iPtr: Integer;
   procedure AddLine( sLine: String);
     var p1: Integer;
   begin
     if sLine = '' then Exit;
     p1 := Pos( ':', sLine);
     ErrorNames.Add( Copy( sLine, 1, p1 - 1));
     ErrorCodes.Add( Copy( sLine, p1 + 1, Length( sLine)));
   end;
begin
  ErrorNames.Clear;
  ErrorCodes.Clear;
  S := Exception.Message;
  repeat
    iPtr := Pos( #10, S);
    if iPtr > 0 then
      begin
        s1 := Copy( S, 1, iPtr - 1);
        S  := Copy( S, iPtr + 1, Length( S));
      end
    else
      begin
        s1 := S;
      end;
    AddLine( s1);
  until iPtr = 0;
end;


procedure TErrorWindow.SetException(E: EOracleError);
begin
  Exception := E;
  CurrentError := 0;
  TranslateError;
end;


procedure TErrorWindow.ShowErrorInfo;
var
  S: String;

begin
  bbPrev.Enabled := CurrentError > 0;
  bbNext.Enabled := CurrentError < (ErrorNames.Count - 1);
  S := ErrorNames[ CurrentError];
  if S[Length(S)] in [#10] then Delete(S, Length(S), 1);
  edServerCode.Text := S;
  meMessage.Text    := ErrorCodes[ CurrentError];
end;

procedure TErrorWindow.bbPrevClick(Sender: TObject);
begin
  Dec(CurrentError);
  ShowErrorInfo;
end;

procedure TErrorWindow.bbNextClick(Sender: TObject);
begin
  Inc(CurrentError);
  ShowErrorInfo;
end;

procedure TErrorWindow.FormActivate(Sender: TObject);
var
  S: String;

begin
  with Exception do
   begin
     S := Exception.Message;
     if S[Length(S)] in [#10] then Delete(S, Length(S), 1);
     meCommonMsg.Lines.Clear;
     meCommonMsg.Lines.Add(S);
     ShowErrorInfo;
   end;
end;

end.
