unit AddJob;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Buttons, DB;

type
  TfmStartJob = class(TForm)
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    cbUseDeps: TCheckBox;
    cbUseCurrency: TCheckBox;
    dtStartDate: TDateTimePicker;
    dtStopDate: TDateTimePicker;
    Label2: TLabel;
    Label3: TLabel;
    rgStartPlace: TRadioGroup;
    btAddData: TButton;
    cbTaskType: TComboBox;
    procedure FormCreate(Sender: TObject);
  private
    fValueList: TStringList;
  public
    { Public declarations }
  end;

function StartNewJob: boolean;

implementation

uses DataModule, MainUnit;

{$R *.DFM}

function StartNewJob: boolean;
var curField: TField;
    nUseDeps, nUseCurrency, nIndex: Integer;
    nTaskType: Double;
    sWhereRun: String;
    obj      : TObject;
begin
  Result := False;
  with TfmStartJob.Create( Application) do
    try
      try
        if ShowModal = mrOK then begin
          nIndex    := cbTaskType.ItemIndex;
          nTaskType := StrToInt( fValueList[ nIndex]);
          if cbUseDeps.Checked     then nUseDeps := 1 else nUseDeps := 0;
          if cbUseCurrency.Checked then nUseCurrency := 1 else nUseCurrency := 0;
          sWhereRun := IntToStr( rgStartPlace.ItemIndex);
          sWhereRun := '1';

          //dmData.alInterface.Addjob( nTaskType, sWhereRun, nUseCurrency,
          //  nUseDeps, dtStartDate.DateTime, dtStopDate.DateTime);
          //dmData.osMain.Commit;
          Result := True;
        end;

      except
        on E: Exception do ProcessException( E);
      end;
    finally
      Free;
    end;


end;


procedure TfmStartJob.FormCreate(Sender: TObject);
begin
  fValueList := TStringList.Create;
  dtStartDate.DateTime := Now - 7;
  dtStopDate.DateTime  := Now - 7;
  //
  // добавляем список задач для запуска
  //
  with dmData.odsTaskTypes do
    try
      try
        Active := False;
        Active := True;
        while not Eof do begin
          cbTaskType.Items.Add( fieldByName( 'label').asString);
          fValueList.Add( fieldByName( 'classified').asString );
          Next;
        end;
        cbTaskType.ItemIndex := 0;
      except
        on E: Exception do ProcessException( E);
      end;
     finally
        Active := False;
     end;


end;

end.
