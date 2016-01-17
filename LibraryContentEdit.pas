unit LibraryContentEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, StdCtrls, Buttons, ExtCtrls, DataModule;

type
  TfmLibraryContentEdit = class(TForm)
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Panel2: TPanel;
    Label1: TLabel;
    edFormula: TEdit;
    Panel3: TPanel;
    dbgAllFormulas: TDBGrid;
    btAddFormula: TButton;
    btRemoveFormula: TButton;
    dbgAvailFormulas: TDBGrid;
    procedure btAddFormulaClick(Sender: TObject);
    procedure btRemoveFormulaClick(Sender: TObject);
    procedure dbgAvailFormulasDblClick(Sender: TObject);
  private
    { Private declarations }
    dmData : TDMData;
  public
    { Public declarations }
  end;

function EditLibraryContent( ADMData: TDMData): Boolean;

implementation

{$R *.DFM}

function EditLibraryContent( ADMData: TDMData): Boolean;
begin
  Result := False;
  with TfmLibraryContentEdit.Create( Application) do
    try
      try
        dmData := ADMData;
        edFormula.Text := dmData.odsLibrary.fieldByName( 'Label').asString;
        dmData.OpenFormulaList;

        if ShowModal = mrOK then begin
          dmData.osMain.Commit;
          Result := True;
        end;
        dmData.osMain.Rollback;
      except
        on E: Exception do ProcessException( E);
      end;
    finally
      dmData.CloseFormulaList;
      Free;
    end;
end;

procedure TfmLibraryContentEdit.btAddFormulaClick(Sender: TObject);
begin
 try
  try
    dmData.alInterface.Addformula2library(
      dmData.odsFormulaList.fieldByName( 'Classified').asFloat,
      dmData.odsLibrary.fieldByName( 'Classified').asFloat
    );
  except
    on E: Exception do ProcessException( E);
  end;
  finally
    dmData.OpenFormulaList;
  end;
end;

procedure TfmLibraryContentEdit.btRemoveFormulaClick(Sender: TObject);
begin
  try
    try
      dmData.alInterface.DeleteFormulaFromLibrary(
        dmData.odsAvailFormulas.fieldByName( 'Classified').asFloat,
        dmData.odsLibrary.fieldByName( 'Classified').asFloat
      );
    except
      on E: Exception do ProcessException( E);
    end;
   finally
     dmData.OpenFormulaList;
   end;
end;

procedure TfmLibraryContentEdit.dbgAvailFormulasDblClick(Sender: TObject);
var curOperation: String;
begin
  with dmData do begin
    if dmData.odsAvailFormulas.fieldByName( 'Operation').asString = '+'
      then curOperation := '-'
      else curOperation := '+';
    alInterface.ChangeformulaOperation(
        odsAvailFormulas.fieldByName( 'Classified').asFloat,
        odsLibrary.fieldByName( 'Classified').asFloat, curOperation);
    RefreshLibrarys;
  end;
end;

end.
