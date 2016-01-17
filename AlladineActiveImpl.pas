unit AlladineActiveImpl;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ActiveX, AxCtrls, AlladineActiveProj1dpr_TLB, StdVcl, MainUnit, ExtCtrls,
  Grids, DBGrids, ComCtrls, ToolWin, ImgList, ActnList, Menus,
  Buttons,
  StdCtrls, Oracle, SHELLAPI, DataModule, MainFrame;

type
  TAlladineActiveX = class(TActiveForm, IAlladineActiveX)
    RealFrame: TfrMain;
    procedure ActiveFormCreate(Sender: TObject);
    procedure ActiveFormDestroy(Sender: TObject);
    procedure ActiveFormDeactivate(Sender: TObject);
    procedure ActiveFormActivate(Sender: TObject);
  private
    { Private declarations }
    FEvents: IAlladineActiveXEvents;
    procedure ActivateEvent(Sender: TObject);
    procedure ClickEvent(Sender: TObject);
    procedure CreateEvent(Sender: TObject);
    procedure DblClickEvent(Sender: TObject);
    procedure DeactivateEvent(Sender: TObject);
    procedure DestroyEvent(Sender: TObject);
    procedure KeyPressEvent(Sender: TObject; var Key: Char);
    procedure PaintEvent(Sender: TObject);
  protected
    { Protected declarations }
    procedure DefinePropertyPages(DefinePropertyPage: TDefinePropertyPage); override;
    procedure EventSinkChanged(const EventSink: IUnknown); override;
    function Get_Active: WordBool; safecall;
    function Get_AutoScroll: WordBool; safecall;
    function Get_AutoSize: WordBool; safecall;
    function Get_AxBorderStyle: TxActiveFormBorderStyle; safecall;
    function Get_Caption: WideString; safecall;
    function Get_Color: OLE_COLOR; safecall;
    function Get_Cursor: Smallint; safecall;
    function Get_DoubleBuffered: WordBool; safecall;
    function Get_DropTarget: WordBool; safecall;
    function Get_Enabled: WordBool; safecall;
    function Get_Font: IFontDisp; safecall;
    function Get_HelpFile: WideString; safecall;
    function Get_KeyPreview: WordBool; safecall;
    function Get_PixelsPerInch: Integer; safecall;
    function Get_PrintScale: TxPrintScale; safecall;
    function Get_Scaled: WordBool; safecall;
    function Get_Visible: WordBool; safecall;
    function Get_VisibleDockClientCount: Integer; safecall;
    procedure _Set_Font(var Value: IFontDisp); safecall;
    procedure Set_AutoScroll(Value: WordBool); safecall;
    procedure Set_AutoSize(Value: WordBool); safecall;
    procedure Set_AxBorderStyle(Value: TxActiveFormBorderStyle); safecall;
    procedure Set_Caption(const Value: WideString); safecall;
    procedure Set_Color(Value: OLE_COLOR); safecall;
    procedure Set_Cursor(Value: Smallint); safecall;
    procedure Set_DoubleBuffered(Value: WordBool); safecall;
    procedure Set_DropTarget(Value: WordBool); safecall;
    procedure Set_Enabled(Value: WordBool); safecall;
    procedure Set_Font(const Value: IFontDisp); safecall;
    procedure Set_HelpFile(const Value: WideString); safecall;
    procedure Set_KeyPreview(Value: WordBool); safecall;
    procedure Set_PixelsPerInch(Value: Integer); safecall;
    procedure Set_PrintScale(Value: TxPrintScale); safecall;
    procedure Set_Scaled(Value: WordBool); safecall;
    procedure Set_Visible(Value: WordBool); safecall;
  public
    procedure Initialize; override;
    procedure Free;

  end;

implementation

uses ComObj, ComServ, About, FormEdit, AddLibrarys, LibraryContentEdit,
  EditReport, Tools, ShowUpdates;
{$R *.DFM}

{ TAlladineActiveX }

procedure TAlladineActiveX.DefinePropertyPages(DefinePropertyPage: TDefinePropertyPage);
begin
  { Define property pages here.  Property pages are defined by calling
    DefinePropertyPage with the class id of the page.  For example,
      DefinePropertyPage(Class_AlladineActiveXPage); }
end;

procedure TAlladineActiveX.EventSinkChanged(const EventSink: IUnknown);
begin
  FEvents := EventSink as IAlladineActiveXEvents;
end;


procedure TAlladineActiveX.Free;
begin
  //ShowMessage( 'Free ActiveX');
  inherited Free;
end;

procedure TAlladineActiveX.Initialize;
begin
  inherited Initialize;
  OnActivate := ActivateEvent;
  OnClick := ClickEvent;
  OnCreate := CreateEvent;
  OnDblClick := DblClickEvent;
  OnDeactivate := DeactivateEvent;
  OnDestroy := DestroyEvent;
  OnKeyPress := KeyPressEvent;
  OnPaint := PaintEvent;

end;

function TAlladineActiveX.Get_Active: WordBool;
begin
  Result := Active;
end;

function TAlladineActiveX.Get_AutoScroll: WordBool;
begin
  Result := AutoScroll;
end;

function TAlladineActiveX.Get_AutoSize: WordBool;
begin
  Result := AutoSize;
end;

function TAlladineActiveX.Get_AxBorderStyle: TxActiveFormBorderStyle;
begin
  Result := Ord(AxBorderStyle);
end;

function TAlladineActiveX.Get_Caption: WideString;
begin
  Result := WideString(Caption);
end;

function TAlladineActiveX.Get_Color: OLE_COLOR;
begin
  Result := OLE_COLOR(Color);
end;

function TAlladineActiveX.Get_Cursor: Smallint;
begin
  Result := Smallint(Cursor);
end;

function TAlladineActiveX.Get_DoubleBuffered: WordBool;
begin
  Result := DoubleBuffered;
end;

function TAlladineActiveX.Get_DropTarget: WordBool;
begin
  Result := DropTarget;
end;

function TAlladineActiveX.Get_Enabled: WordBool;
begin
  Result := Enabled;
end;

function TAlladineActiveX.Get_Font: IFontDisp;
begin
  GetOleFont(Font, Result);
end;

function TAlladineActiveX.Get_HelpFile: WideString;
begin
  Result := WideString(HelpFile);
end;

function TAlladineActiveX.Get_KeyPreview: WordBool;
begin
  Result := KeyPreview;
end;

function TAlladineActiveX.Get_PixelsPerInch: Integer;
begin
  Result := PixelsPerInch;
end;

function TAlladineActiveX.Get_PrintScale: TxPrintScale;
begin
  Result := Ord(PrintScale);
end;

function TAlladineActiveX.Get_Scaled: WordBool;
begin
  Result := Scaled;
end;

function TAlladineActiveX.Get_Visible: WordBool;
begin
  Result := Visible;
end;

function TAlladineActiveX.Get_VisibleDockClientCount: Integer;
begin
  Result := VisibleDockClientCount;
end;

procedure TAlladineActiveX._Set_Font(var Value: IFontDisp);
begin
  SetOleFont(Font, Value);
end;

procedure TAlladineActiveX.ActivateEvent(Sender: TObject);
begin
  if FEvents <> nil then FEvents.OnActivate;
end;

procedure TAlladineActiveX.ClickEvent(Sender: TObject);
begin
  if FEvents <> nil then FEvents.OnClick;
end;

procedure TAlladineActiveX.CreateEvent(Sender: TObject);
begin
  if FEvents <> nil then FEvents.OnCreate;
end;

procedure TAlladineActiveX.DblClickEvent(Sender: TObject);
begin
  if FEvents <> nil then FEvents.OnDblClick;
end;

procedure TAlladineActiveX.DeactivateEvent(Sender: TObject);
begin
  if FEvents <> nil then FEvents.OnDeactivate;
end;

procedure TAlladineActiveX.DestroyEvent(Sender: TObject);
begin
  if FEvents <> nil then FEvents.OnDestroy;
end;

procedure TAlladineActiveX.KeyPressEvent(Sender: TObject; var Key: Char);
var
  TempKey: Smallint;
begin
  TempKey := Smallint(Key);
  if FEvents <> nil then FEvents.OnKeyPress(TempKey);
  Key := Char(TempKey);
end;

procedure TAlladineActiveX.PaintEvent(Sender: TObject);
begin
  if FEvents <> nil then FEvents.OnPaint;
end;

procedure TAlladineActiveX.Set_AutoScroll(Value: WordBool);
begin
  AutoScroll := Value;
end;

procedure TAlladineActiveX.Set_AutoSize(Value: WordBool);
begin
  AutoSize := Value;
end;

procedure TAlladineActiveX.Set_AxBorderStyle(
  Value: TxActiveFormBorderStyle);
begin
  AxBorderStyle := TActiveFormBorderStyle(Value);
end;

procedure TAlladineActiveX.Set_Caption(const Value: WideString);
begin
  Caption := TCaption(Value);
end;

procedure TAlladineActiveX.Set_Color(Value: OLE_COLOR);
begin
  Color := TColor(Value);
end;

procedure TAlladineActiveX.Set_Cursor(Value: Smallint);
begin
  Cursor := TCursor(Value);
end;

procedure TAlladineActiveX.Set_DoubleBuffered(Value: WordBool);
begin
  DoubleBuffered := Value;
end;

procedure TAlladineActiveX.Set_DropTarget(Value: WordBool);
begin
  DropTarget := Value;
end;

procedure TAlladineActiveX.Set_Enabled(Value: WordBool);
begin
  Enabled := Value;
end;

procedure TAlladineActiveX.Set_Font(const Value: IFontDisp);
begin
  SetOleFont(Font, Value);
end;

procedure TAlladineActiveX.Set_HelpFile(const Value: WideString);
begin
  HelpFile := String(Value);
end;

procedure TAlladineActiveX.Set_KeyPreview(Value: WordBool);
begin
  KeyPreview := Value;
end;

procedure TAlladineActiveX.Set_PixelsPerInch(Value: Integer);
begin
  PixelsPerInch := Value;
end;

procedure TAlladineActiveX.Set_PrintScale(Value: TxPrintScale);
begin
  PrintScale := TPrintScale(Value);
end;

procedure TAlladineActiveX.Set_Scaled(Value: WordBool);
begin
  Scaled := Value;
end;

procedure TAlladineActiveX.Set_Visible(Value: WordBool);
begin
  Visible := Value;
end;

procedure TAlladineActiveX.ActiveFormCreate(Sender: TObject);
begin
//  ShowMessage( 'Create Main Form');
  ShortDateFormat := 'dd.mm.yyyy';
  DateSeparator   := '.';
  RealFrame.PrepareFrame;
end;

procedure TAlladineActiveX.ActiveFormDestroy(Sender: TObject);
begin
  RealFrame.DestroyFrame;
//  ShowMessage( 'Destroy ActiveX');
end;

procedure TAlladineActiveX.ActiveFormDeactivate(Sender: TObject);
begin
//  ShowMessage( 'Deactivate ActiveX');
end;

procedure TAlladineActiveX.ActiveFormActivate(Sender: TObject);
begin
//  ShowMessage( 'Activate ActiveX');
end;



initialization
  TActiveFormFactory.Create(
    ComServer,
    TActiveFormControl,
    TAlladineActiveX,
    Class_AlladineActiveX,
    1,
    '',
    OLEMISC_SIMPLEFRAME or OLEMISC_ACTSLIKELABEL,
    tmBoth);
end.
