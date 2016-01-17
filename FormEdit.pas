unit FormEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Grids, DBGrids, DataModule;

type
  TFormulaEdit = class(TForm)
    pnMain: TPanel;
    btOK: TBitBtn;
    btCancel: TBitBtn;
    Label1: TLabel;
    edFormula: TEdit;
    Label2: TLabel;
    meFormula: TMemo;
    btCheckFormula: TBitBtn;
    cbCreateLibrary: TCheckBox;
    btInLibrarys: TButton;
    dbgInLibrarys: TDBGrid;
    procedure btCheckFormulaClick(Sender: TObject);
    procedure meFormulaChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btInLibrarysClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    nGridTop, nGridHeight: Integer;
    nClass: Double;
    sOpenedCaption: String;
    sClosedCaption: String;
    dmData: TDMData;

    procedure ToggleGridVisibility;
  public
    { Public declarations }
  end;


function FormulaEdit(
  ADMData: TDMData;
  lNewRecord: Boolean;   var AFormula, AFormulaValue: String;
  nFormulaClass: Double; var lCreateLibrary: Boolean): Boolean;

implementation

{$R *.DFM}

function FormulaEdit(
  ADMData: TDMData;
  lNewRecord: Boolean;   var AFormula, AFormulaValue: String;
  nFormulaClass: Double; var lCreateLibrary: Boolean): Boolean;
begin
 lCreateLibrary := False;
 with TFormulaEdit.Create( Application) do begin
   dmData                  := ADMData;
   nClass                  := nFormulaClass;
   edFormula.Enabled       := lNewRecord;
   cbCreateLibrary.Enabled := lNewRecord;
   btInLibrarys.Enabled    := not lNewRecord;
   edFormula.Text          := AFormula;
   meFormula.Text          := AFormulaValue;
   Result := False;
   if ShowModal = mrOK then begin
     AFormula       := edFormula.Text;
     AFormulaValue  := meFormula.Text;
     lCreateLibrary := cbCreateLibrary.Checked;
     Result := True;
   end;
   Free;
 end;

end;


procedure TFormulaEdit.ToggleGridVisibility;
begin
  if dbgInLibrarys.Height > 0 then
    begin
      dbgInLibrarys.Height := 0;
      cbCreateLibrary.Top  := cbCreateLibrary.Top - nGridHeight;
      pnMain.Height        := pnMain.Height       - nGridHeight;
      btOk.Top             := btOk.Top            - nGridHeight;
      btCancel.Top         := btCancel.Top        - nGridHeight;
      Self.Height          := Self.Height         - nGridHeight;
      btInLibrarys.Caption := sOpenedCaption;
      try
        try
          dmData.odsInLibrarys.Active := False;
        except
          on E: Exception do ProcessException( E);
        end;
      finally
      end;
    end
  else
    begin
      btInLibrarys.Caption := sClosedCaption;
      Self.Height          := Self.Height         + nGridHeight;
      pnMain.Height        := pnMain.Height       + nGridHeight;
      cbCreateLibrary.Top  := cbCreateLibrary.Top + nGridHeight;
      btOk.Top             := btOk.Top            + nGridHeight;
      btCancel.Top         := btCancel.Top        + nGridHeight;
      dbgInLibrarys.Height := nGridHeight;
      try
        try
          dmData.odsInLibrarys.Active := False;
          dmData.odsInLibrarys.SetVariable( 'pFormula', nClass);
          dmData.odsInLibrarys.Active := True;
        except
          on E: Exception do ProcessException( E);
        end;
      finally
      end;
    end;
end;


procedure TFormulaEdit.btCheckFormulaClick(Sender: TObject);
var Str: String;
begin
  Str := dmData.alTranslator.Checkformula( meFormula.Text);
  if Str = ''
    then
      begin
        MessageDlg( 'Все правильно !', mtInformation, [ mbOK], 0);
        btOK.Enabled := True;
      end
    else
      begin
        MessageDlg( Str, mtError, [ mbOK], 0);
        btOK.Enabled := False;
      end;
end;

procedure TFormulaEdit.meFormulaChange(Sender: TObject);
begin
  btOK.Enabled := False;
end;

procedure TFormulaEdit.FormCreate(Sender: TObject);
begin
  nGridTop    := 225;
  nGridHeight := 115;
  sOpenedCaption := 'Включена в наборы >>';
  sClosedCaption := 'Включена в наборы <<';
  btInLibrarys.Caption := sOpenedCaption;
end;

procedure TFormulaEdit.btInLibrarysClick(Sender: TObject);
begin
  ToggleGridVisibility;
end;

procedure TFormulaEdit.FormDestroy(Sender: TObject);
begin
  try
    try
      dmData.odsInLibrarys.Active := False;
    except
      on E: Exception do ProcessException( E);
    end;
  finally
  end;
end;

end.
