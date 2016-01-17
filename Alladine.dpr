program Alladine;

uses
  Forms,
  MainUnit in 'MainUnit.pas' {MainForm},
  About in 'COOLSTUF\About.pas' {AboutBox},
  DataModule in 'DataModule.pas' {dmData: TDataModule},
  FormEdit in 'FormEdit.pas' {FormulaEdit},
  BpAlInterface in 'BpAlInterface.pas',
  BpAlTranslator in 'BpAlTranslator.pas',
  AddLibrarys in 'AddLibrarys.pas' {AddLibrary},
  LibraryContentEdit in 'LibraryContentEdit.pas' {fmLibraryContentEdit},
  ErrorForm in 'ErrorForm.pas' {ErrorWindow},
  ReportLibrarys in 'ReportLibrarys.pas' {fmReportLibraryContent},
  ReportOptions in 'ReportOptions.pas' {fmReportOptions},
  CubeClasses in 'CubeClasses.pas',
  fmFilterDates in 'fmFilterDates.pas' {fmDateFilter},
  StringFilter in 'StringFilter.pas' {fmFilterString},
  LibraryFilter in 'LibraryFilter.pas' {fmLibraryFilter},
  TempEdit in 'TempEdit.pas' {fmTempEdit},
  ReportView in 'ReportView.pas' {fmReportView},
  EditReport in 'EditReport.pas' {fmEditReport},
  ReportResult in 'ReportResult.pas' {fmReportResult},
  ReportParams in 'ReportParams.pas' {fmReportParams},
  ShowLibraryCont in 'ShowLibraryCont.pas' {fmShowLibraryContent},
  Tools in 'Tools.pas',
  SelectValue in 'SelectValue.pas' {fmSelectValue},
  SelectValueS in 'SelectValueS.pas' {Form1},
  ShowUpdates in 'ShowUpdates.pas' {fmUpdateInfo},
  MainFrame in 'MainFrame.pas' {frMain: TFrame},
  AccList in 'AccList.pas' {fmAccList};

{$R *.RES}
var
 MainForm: TMainForm;
begin
  Application.Initialize;
  Application.Title := 'Аналитика ';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
