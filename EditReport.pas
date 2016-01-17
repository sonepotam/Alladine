unit EditReport;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, CubeClasses, ReportOptionsClass, DataModule;

type
  TfmEditReport = class(TForm)
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    edReportName: TEdit;
    cbReportType: TComboBox;
    btDetails: TButton;
    btGetReport: TButton;
    procedure btDetailsClick(Sender: TObject);
    procedure btGetReportClick(Sender: TObject);
  private
    nTaskClass: Double;
    nIDCube   : Double;
    fValueList: TStringList;
    fLibraryList: TStringList;
    lButtonPressed: Boolean;
    ReportOptions: TReportOptions;
    procedure AfterCreateForm;
  public
    dmData    : TDMData;
    constructor CreateForm( ADMData: TDMData);
    { Public declarations }
  end;

function EditCurrentReport( AdmData: TDMData; lNewReport: Boolean): Boolean;

implementation
uses ReportLibrarys, ReportOptions, ReportView;

{$R *.DFM}

constructor TfmEditReport.CreateForm( ADMData: TDMData);
begin
  inherited Create( Application);
  dmData := ADMData;
  AfterCreateForm;
end;

function EditCurrentReport( AdmData: TDMData; lNewReport: Boolean): Boolean;
var nTaskType: Integer;
begin
  Result := False;
  with TfmEditReport.CreateForm( ADMData) do
    try
      try
        lButtonPressed := False;
        nTaskClass := -1;
        nIDCube    := -1;
        if not lNewReport then
          with dmData.odsTasks do begin
           nTaskClass := fieldByName( 'Classified').asFloat;
           nIDCube    := fieldByName( 'idcube').asFloat;
           cbReportType.ItemIndex := fValueList.indexOf( fieldByName( 'idTaskType').asString);
           edReportName.Text      := fieldByName( 'label').asString;
          end;
        cbReportType.Enabled := lNewReport;
        btDetails.Enabled    := not lNewReport;
        btGetReport.Enabled  := not lNewReport;



        dmData := ADMData;
        ReportOptions := TReportOptions.CreateReport( dmData,
          edReportName.Text, nIDCube, nTaskClass);

        if ShowModal = mrOK then begin
          nTaskType := StrToInt( fValueList[ cbReportType.ItemIndex]);
          if lNewReport
            then nTaskClass := dmData.alInterface.AddReport( nTaskType,
                edReportName.Text)
            else dmData.alInterface.EditReport( nTaskClass, edReportName.Text);

          //
          // удаляем старые данные по отчету и добавляем новые
          //
          dmData.osMain.Commit;
          Result := True;
        end;
      except
        on E: Exception do ProcessException( E);
      end;
    finally
      ReportOptions.Free;
      Free;
    end;



end;



procedure TfmEditReport.AfterCreateForm;
begin
  fValueList   := TStringList.Create;
  fLibraryList := TStringList.Create;
  //
  // добавляем список задач для запуска
  //
  with dmData.odsTaskTypes do
    try
      try
        Active := False;
        Active := True;
        while not Eof do begin
          cbReportType.Items.Add( fieldByName( 'label').asString);
          fValueList.Add( fieldByName( 'classified').asString );
          Next;
        end;
        cbReportType.ItemIndex := 0;
      except
        on E: Exception do ProcessException( E);
      end;
     finally
        Active := False;
     end;
end;

procedure TfmEditReport.btDetailsClick(Sender: TObject);
begin
  lButtonPressed := CreateCubeOption( dmData, ReportOptions);
end;

procedure TfmEditReport.btGetReportClick(Sender: TObject);
begin
  PreviewReport( ReportOptions);
end;

end.
