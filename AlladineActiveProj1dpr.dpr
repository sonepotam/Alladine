library AlladineActiveProj1dpr;

uses
  ComServ,
  AlladineActiveProj1dpr_TLB in 'AlladineActiveProj1dpr_TLB.pas',
  AlladineActiveImpl in 'AlladineActiveImpl.pas' {AlladineActiveX: TActiveForm} {AlladineActiveX: CoClass},
  Tools in 'Tools.pas',
  AddLibrarys in 'AddLibrarys.pas' {AddLibrary},
  BpAlInterface in 'BpAlInterface.pas',
  BpAlTranslator in 'BpAlTranslator.pas',
  CubeClasses in 'CubeClasses.pas',
  DataModule in 'DataModule.pas' {dmData: TDataModule},
  EditReport in 'EditReport.pas' {fmEditReport},
  ErrorForm in 'ErrorForm.pas' {ErrorWindow},
  fmFilterDates in 'fmFilterDates.pas' {fmDateFilter},
  FormEdit in 'FormEdit.pas' {FormulaEdit},
  LibraryContentEdit in 'LibraryContentEdit.pas' {fmLibraryContentEdit},
  LibraryFilter in 'LibraryFilter.pas' {fmLibraryFilter},
  RegShell in 'Regshell.pas',
  ReportLibrarys in 'ReportLibrarys.pas' {fmReportLibraryContent},
  ReportOptions in 'ReportOptions.pas' {fmReportOptions},
  ReportParams in 'ReportParams.pas' {fmReportParams},
  ReportResult in 'ReportResult.pas' {fmReportResult},
  ReportView in 'ReportView.pas' {fmReportView},
  SelectValue in 'SelectValue.pas' {fmSelectValue},
  SelectValueS in 'SelectValueS.pas' {Form1},
  ShowLibraryCont in 'ShowLibraryCont.pas' {fmShowLibraryContent},
  ShowUpdates in 'ShowUpdates.pas' {fmUpdateInfo},
  StringFilter in 'StringFilter.pas' {fmFilterString},
  TempEdit in 'TempEdit.pas' {fmTempEdit},
  About in 'COOLSTUF\About.pas' {AboutBox},
  ReportOptionsClass in 'ReportOptionsClass.pas',
  MainFrame in 'MainFrame.pas' {frMain: TFrame};

{$E ocx}

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
