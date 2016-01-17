unit MainFrame;

interface


uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ActiveX, AxCtrls, AlladineActiveProj1dpr_TLB, StdVcl, ExtCtrls,
  Grids, DBGrids, ComCtrls, ToolWin, ImgList, ActnList, Menus,
  Buttons, DB,
  StdCtrls, Oracle, OracleData, SHELLAPI, DataModule;


type
  TfrMain = class(TFrame)
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    tbConnect: TToolButton;
    ToolButton1: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton2: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton7: TToolButton;
    tbUpdates: TToolButton;
    tbHelp: TToolButton;
    tbExit: TToolButton;
    PageControl: TPageControl;
    tsFormulas: TTabSheet;
    pnFormulas: TPanel;
    dbgFormula: TDBGrid;
    tsLibrarys: TTabSheet;
    Splitter1: TSplitter;
    dbgLibrary: TDBGrid;
    dbgFormulasInLibrary: TDBGrid;
    tsReports: TTabSheet;
    dbgTasks: TDBGrid;
    MainMenu: TMainMenu;
    N1: TMenuItem;
    miConnect: TMenuItem;
    miDisconnect: TMenuItem;
    N3: TMenuItem;
    miExit: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N2: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    miUpdates: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    ActionList: TActionList;
    acConnect: TAction;
    acExit: TAction;
    acHelp: TAction;
    acAbout: TAction;
    acDisconnect: TAction;
    acFormulas: TAction;
    acLibrary: TAction;
    acReport: TAction;
    acAppend: TAction;
    acDelete: TAction;
    acUpdates: TAction;
    ImageList: TImageList;
    StatusBar: TStatusBar;
    ToolButton10: TToolButton;
    acAccList: TAction;
    tbAccList: TToolButton;
    ToolButton11: TToolButton;
    acFind: TAction;
    procedure acExitExecute(Sender: TObject);
    procedure acAboutExecute(Sender: TObject);
    procedure acConnectExecute(Sender: TObject);
    procedure acDisconnectExecute(Sender: TObject);
    procedure acFormulasExecute(Sender: TObject);
    procedure dbgFormulaDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure dbgFormulaDblClick(Sender: TObject);
    procedure dbgFormulaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure acLibraryExecute(Sender: TObject);
    procedure dbgLibraryDblClick(Sender: TObject);
    procedure dbgLibraryKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure acReportExecute(Sender: TObject);
    procedure dbgTasksDblClick(Sender: TObject);
    procedure dbgTasksKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure acHelpExecute(Sender: TObject);
    procedure acAppendExecute(Sender: TObject);
    procedure acDeleteExecute(Sender: TObject);
    procedure dbgFormulasInLibraryDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure acUpdatesExecute(Sender: TObject);
    procedure acAccListExecute(Sender: TObject);
    procedure acFindExecute(Sender: TObject);
  private
    { Private declarations }
  public
    dmData: TdmData;
    procedure ApplicationTerminate;
    procedure PrepareFrame;
    procedure DestroyFrame;
    procedure EnableButtons;
    procedure DisableButtons;
    procedure RefreshFormulas;
    function EditCurrentFormula( lNewRecord: Boolean): boolean;
    function EditCurrentLibrary( lNewRecord: Boolean): boolean;
    procedure RefreshLibrarys;
    procedure refreshTasks;
    procedure CalculateGridsWidth;
  end;

implementation
uses ComObj, ComServ, About, FormEdit, AddLibrarys, LibraryContentEdit,
  EditReport, Tools, ShowUpdates, AccList;

{$R *.dfm}

procedure TfrMain.PrepareFrame;
begin
  DisableButtons;
  dmData := TDMData.Create( Self);
  CalculateGridsWidth;
end;

procedure TfrMain.DestroyFrame;
begin
//  dmData.Destroy;
end;


procedure TfrMain.ApplicationTerminate;
begin
 dmData.Disconnect;
 if Assigned( dmData.alInterface)  then dmData.alInterface.Destroy;
 if Assigned( dmData.alTranslator) then dmData.alTranslator.Destroy;
 dmData.Destroy;
end;

procedure TfrMain.acExitExecute(Sender: TObject);
begin
  ApplicationTerminate;
end;

procedure TfrMain.acAboutExecute(Sender: TObject);
begin
  ShowAboutBox;
end;

procedure TfrMain.acConnectExecute(Sender: TObject);
begin
  if tbConnect.Down then
    begin
      if dmData.Connect
        then EnableButtons
        else DisableButtons;
    end
  else
    begin
      dmData.DisConnect;
      DisableButtons;
    end;
  tbConnect.Down := dmData.Connected;
end;


procedure TfrMain.EnableButtons;
begin
  acFormulas.Enabled   := True;
  acLibrary.Enabled    := True;
  acReport.Enabled     := True;
  acUpdates.Enabled    := True;
  acAccList.Enabled    := True;
  acFind.Enabled       := True;
  miConnect.Enabled    := False;
  miDisconnect.Enabled := True;
  StatusBar.Panels[ 0].Text := UpperCase( dmData.osMain.LogonDatabase);
end;


procedure TfrMain.DisableButtons;
begin
  acFormulas.Enabled   := False;
  acLibrary.Enabled    := False;
  acReport.Enabled     := False;
  acAppend.Enabled     := False;
  acDelete.Enabled     := False;
  acUpdates.Enabled    := False;
  acAccList.Enabled    := False;
  acFind.Enabled       := False;
  miConnect.Enabled    := True;
  miDisconnect.Enabled := False;
  StatusBar.Panels[ 0].Text := '';
  PageControl.ActivePage := nil;
end;


procedure TfrMain.acDisconnectExecute(Sender: TObject);
begin
  dmData.DisConnect;
  DisableButtons;
end;

procedure TfrMain.RefreshFormulas;
begin
  dbgFormula.DataSource := nil;
  dmData.RefreshFormulas;
  dbgFormula.DataSource := dmData.dsFormula;
  dbgFormula.Refresh;
end;


procedure TfrMain.acFormulasExecute(Sender: TObject);
begin
  PageControl.ActivePage := tsFormulas;
  acAppend.Enabled := True;
  acDelete.Enabled := True;
  RefreshFormulas;
end;


function TfrMain.EditCurrentFormula( lNewRecord: Boolean): boolean;
var sFormula, sValue: String;
    lCreateLibrary  : Boolean;
    nLibraryClass   : Double;
    nFormulaClass   : Double;
begin
  Result   := False;
  sFormula := '';
  sValue   := '';
  nFormulaClass := 0;
  if not lNewRecord then begin
    sFormula := dmData.odsFormula.fieldByName( 'Label').asString;
    sValue   := dmData.odsFormula.fieldByName( 'Value').asString;
    nFormulaClass := dmData.odsFormula.fieldByName( 'Classified').asFloat;
  end;
  if FormulaEdit( dmData, lNewRecord, sFormula, sValue, nFormulaClass, lCreateLibrary) then begin
       try
        try
          with dmData.alInterface do begin
            if lNewRecord
              then nFormulaClass := Addformula( sFormula, sValue)
              else EditFormula( nFormulaClass, sValue);
            if lCreateLibrary then
              begin
                nLibraryClass := Addlibrary( sFormula);
                AddFormula2Library( nFormulaClass, nLibraryClass);
              end;
          end;
          dmData.osMain.Commit;
          Result := True;
          RefreshFormulas;
         except
           on E: Exception do ProcessException( E);
         end;
       finally
       end;
  end;
end;


function TfrMain.EditCurrentLibrary( lNewRecord: Boolean): boolean;
var sLabel: String;
    nClass: Double;
begin
  Result   := False;
  sLabel   := '';
  nClass   := 0;
  if not lNewRecord then begin
    sLabel := dmData.odsLibrary.fieldByName( 'Label').asString;
    nClass := dmData.odsLibrary.fieldByName( 'Classified').asFloat;
  end;
  if AddLibrary( sLabel) then
    try
      try
        if lNewRecord
          then dmData.alInterface.Addlibrary( sLabel)
          else dmData.alInterface.Editlibrary( nClass, sLabel);
        dmData.osMain.Commit;
        Result := True;
        RefreshLibrarys;
      except
        on E: Exception do ProcessException( E);
      end;
    finally
    end;
end;


procedure TfrMain.dbgFormulaDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
  Str: String;
  dbValue: String;
  i : Integer;
  lUseBreak: Boolean;
begin
 if DataCol = 0 then Exit;
 lUseBreak := False;
 with dbgFormula.Canvas do begin
   FillRect( Rect);
   dbValue := dmData.odsFormula.fieldByName( 'Value').asString;
   Str := '';
   for i := 1 to length( dbValue) do begin
     if TextWidth( Str  + dbValue[ i] + '...') < Rect.Right - Rect.Left
        then Str := Str + dbValue[ i]
        else begin lUseBreak := True; break; end;
   end;
   if lUseBreak then Str := Copy( Str, 1, Length( Str) - 1) + '...';
   TextRect( Rect, Rect.Left, Rect.Top, Str);
 end;
end;

procedure TfrMain.dbgFormulaDblClick(Sender: TObject);
begin
  EditCurrentFormula( False);
end;

procedure TfrMain.dbgFormulaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_Insert then EditCurrentFormula( True);
  if Key = vk_Return then EditCurrentFormula( False);
  if ( Key = vk_Delete) and
     ( MessageDlg( 'Удалить формулу ?', mtConfirmation, mbOKCancel, 0) = mrOK)
     then begin
       try
         try
           dmData.alInterface.DeleteFormula(
             dmData.odsFormula.fieldByName( 'Classified').asFloat);
           dmData.osMain.Commit;
           RefreshFormulas;
         except
           on E: Exception do ProcessException( E);
         end;
         finally
         end;
     end;
end;

procedure TfrMain.acLibraryExecute(Sender: TObject);
begin
 PageControl.ActivePage := tsLibrarys;
  acAppend.Enabled := True;
  acDelete.Enabled := True;
  RefreshLibrarys;
end;


procedure TfrMain.RefreshLibrarys;
begin
  dbgLibrary.DataSource := nil;
  dbgFormulasInLibrary.DataSource := nil;
  dmData.RefreshLibrarys;
  dbgLibrary.DataSource := dmData.dsLibrary;
  dbgFormulasInLibrary.DataSource := dmData.dsFormulasInLibrary;
  dbgLibrary.Refresh;
  dbgFormulasInLibrary.Refresh;
end;


procedure TfrMain.dbgLibraryDblClick(Sender: TObject);
begin
 EditLibraryContent( dmData);
end;

procedure TfrMain.dbgLibraryKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_Insert then EditCurrentLibrary( True);
  if Key = vk_Return then EditLibraryContent( dmData);
  if ( Key = vk_Delete) and
     ( MessageDlg( 'Удалить библиотеку ?', mtConfirmation, mbOKCancel, 0) = mrOK)
     then begin
       try
         try
           dmData.alInterface.DeleteLibrary(
             dmData.odsLibrary.fieldByName( 'Classified').asFloat);
           dmData.osMain.Commit;
           RefreshLibrarys;
         except
           on E: Exception do ProcessException( E);
         end;
         finally
       end;
     end;
end;

procedure TfrMain.acReportExecute(Sender: TObject);
begin
  PageControl.ActivePage := tsReports;
  acAppend.Enabled := True;
  acDelete.Enabled := True;
  RefreshTasks;
end;

procedure TfrMain.refreshTasks;
begin
  dbgTasks.DataSource := nil;
  dmData.RefreshTasks;
  dbgTasks.DataSource := dmData.dsTasks;
  dbgTasks.Refresh;
end;


procedure TfrMain.dbgTasksDblClick(Sender: TObject);
begin
  EditCurrentReport( dmData, False);
  RefreshTasks;
end;

procedure TfrMain.dbgTasksKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_Insert then EditCurrentReport( dmData, True);
  if Key = vk_Return then EditCurrentReport( dmData, False);
  if ( Key = vk_Delete) and
     ( MessageDlg( 'Удалить отчет ?', mtConfirmation, mbOKCancel, 0) = mrOK)
     then begin
       try
         try
           dmData.alInterface.DeleteReport(
             dmData.odsTasks.fieldByName( 'Classified').asFloat);
           dmData.osMain.Commit;
           RefreshTasks;
         except
           on E: Exception do ProcessException( E);
         end;
         finally
       end;
     end;
  if Key in[ vk_Insert, vk_Return, vk_Delete] then RefreshTasks;
end;

procedure TfrMain.acHelpExecute(Sender: TObject);
var oldDir, fileName: String;
begin
if isActiveX then
 begin
   oldDir := GetCurrentDir;
   SetCurrentDir( ActiveXPath);
   fileName := AddSlash( ActiveXPath) + 'alladine.hlp';
   ShellExecute( 0, 'open', PChar( fileName), '', '', SW_SHOWNORMAL);
   SetCurrentDir( oldDir);
 end
else ShellExecute( 0, 'open', 'alladine.hlp', '', '', SW_SHOWNORMAL);
end;

procedure TfrMain.acAppendExecute(Sender: TObject);
var Key: Word;
begin
  Key := vk_Insert;
  if PageControl.ActivePage = tsReports  then dbgTasksKeyDown(   Self, Key, []);
  if PageControl.ActivePage = tsLibrarys then dbgLibraryKeyDown( Self, Key, []);
  if PageControl.ActivePage = tsFormulas then dbgFormulaKeyDown( Self, Key, []);
end;

procedure TfrMain.acDeleteExecute(Sender: TObject);
var Key: Word;
begin
  Key := vk_Delete;
  if PageControl.ActivePage = tsReports  then dbgTasksKeyDown(   Self, Key, []);
  if PageControl.ActivePage = tsLibrarys then dbgLibraryKeyDown( Self, Key, []);
  if PageControl.ActivePage = tsFormulas then dbgFormulaKeyDown( Self, Key, []);
end;

procedure TfrMain.CalculateGridsWidth;
  procedure CalculateGridWidth( var Grid: TDBGrid);
  var i, nWidth: Integer;
  begin
    if not Grid.Visible then Exit;
    nWidth := 2;
    for i := 0 to Grid.Columns.Count - 2 do
      nWidth := nWidth + Grid.Columns[ i].Width + 1;
    i := Grid.Columns.Count - 1;
    Grid.Columns[ i].Width := Grid.ClientWidth - nWidth;
  end;
begin
  CalculateGridWidth( dbgTasks);
  CalculateGridWidth( dbgFormula);
  CalculateGridWidth( dbgLibrary);
  CalculateGridWidth( dbgFormulasInLibrary);
end;


procedure TfrMain.dbgFormulasInLibraryDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
  Str: String;
  dbValue: String;
  i : Integer;
  lUseBreak: Boolean;
begin
 if DataCol = 0 then Exit;
 lUseBreak := False;
 with dbgFormula.Canvas do begin
   FillRect( Rect);
   dbValue := dmData.odsFormulasInLibrary.fieldByName( 'Value').asString;
   Str := '';
   for i := 1 to length( dbValue) do begin
     if TextWidth( Str  + dbValue[ i] + '...') < Rect.Right - Rect.Left
        then Str := Str + dbValue[ i]
        else begin lUseBreak := True; break; end;
   end;
   if lUseBreak then Str := Copy( Str, 1, Length( Str) - 1) + '...';
   TextRect( Rect, Rect.Left, Rect.Top, Str);
 end;
end;

procedure TfrMain.acUpdatesExecute(Sender: TObject);
begin
  ShowStartInfo( dmData);
end;

procedure TfrMain.acAccListExecute(Sender: TObject);
begin
  ShowAccList( dmData);
end;

procedure TfrMain.acFindExecute(Sender: TObject);
var ADataSet: TOracleDataSet;
    AGrid   : TDBGrid;
    lFound  : Boolean;
    BookMark: TBookMark;
    ACaption: String;
    AValue  : String;
begin
  ADataSet := nil;
  BookMark := nil;
  if PageControl.ActivePage = tsFormulas  then
    begin
      AGrid    := dbgFormula;
      //ADataSet := dmData.odsFormula;
      ACaption := 'Введите название формулы';
    end;
  if PageControl.ActivePage = tsLibrarys  then
    begin
      AGrid    := dbgLibrary;
      //ADataSet := dmData.odsLibrary;
      ACaption := 'Введите название набора формул';
    end;
  if PageControl.ActivePage = tsReports then
    begin
      AGrid    := dbgTasks;
      //ADataSet := dmData.odsTasks;
      ACaption := 'Введите название отчета';
    end;
  if not InputQuery( ACaption, 'Поиск', AValue) then Exit;
  ADataSet := TOracleDataSet( AGrid.DataSource.DataSet);
  ADataSet.DisableControls;
  try
    try
      BookMark := ADataSet.GetBookMark;
      lFound := ADataSet.SearchRecord( 'label', AValue + '*', [ srWildCards]);
      if not lFound then ADataSet.GotoBookmark( BookMark);
    except
      on E: Exception do ShowMessage( E.Message);
    end;
  finally
    ADataSet.EnableControls;
    AGrid.SetFocus;

    if BookMark <> nil then ADataSet.FreeBookmark( BookMark);
  end;

end;

end.
