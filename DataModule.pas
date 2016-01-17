unit DataModule;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Oracle, Db, OracleData, BpAlInterface, BpAlTranslator, CubeClasses;

type
  TdmData = class(TDataModule)
    osMain: TOracleSession;
    OracleLogon: TOracleLogon;
    odsFormula: TOracleDataSet;
    dsFormula: TDataSource;
    odsLibrary: TOracleDataSet;
    dsLibrary: TDataSource;
    odsFormulaList: TOracleDataSet;
    dsFormulaList: TDataSource;
    odsAvailFormulas: TOracleDataSet;
    dsAvailFormulas: TDataSource;
    odsTaskTypes: TOracleDataSet;
    odsLibsInReport: TOracleDataSet;
    odsTasks: TOracleDataSet;
    dsTasks: TDataSource;
    odsColumnList: TOracleDataSet;
    dsColumnList: TDataSource;
    odsLibraryList: TOracleDataSet;
    odsTableName: TOracleDataSet;
    odsTaskAttr: TOracleDataSet;
    odsTaskAttrDesc: TOracleDataSet;
    odsLibraryDesc: TOracleDataSet;
    odsInLibrarys: TOracleDataSet;
    dsInLibrarys: TDataSource;
    odsCubeDesc: TOracleDataSet;
    odsColumnDesc: TOracleDataSet;
    odsFilterDesc: TOracleDataSet;
    odsFormulasInLibrary: TOracleDataSet;
    dsFormulasInLibrary: TDataSource;
    qrColumnAttrs: TOracleQuery;
    odsStartInfo: TOracleDataSet;
    odsAccList: TOracleDataSet;
    dsAccList: TDataSource;
    procedure odsLibraryAfterScroll(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
  public
     alInterface : TBpAlInterface;
     alTranslator: TBpAlTranslator;


     procedure RefreshFormulas;
     procedure RefreshLibrarys;
     procedure RefreshTasks;

     function  Connect: Boolean;
     function  Connected: Boolean;
     procedure Disconnect;


     procedure OpenFormulaList;
     procedure CloseFormulaList;

     function GetDescTable( ColumnID: Double): TLookUpTable;
     function CreateColumn( ColumnID: Double): TCubeColumn;
  end;

function isActiveX: Boolean;
procedure ProcessException( E: Exception);


implementation

uses ErrorForm;

{$R *.DFM}


procedure ProcessException( E: Exception);
begin
  if E is EOracleError
    then ShowOracleError( nil, EOracleError(E))
    else ShowMessage( E.Message);
end;


procedure TDMData.RefreshFormulas;
begin
  odsFormula.Active := False;
  odsFormula.Active := True;
  odsFormula.Refresh;
end;

procedure TDMData.RefreshLibrarys;
begin
  odsLibrary.Active := False;
  odsLibrary.Active := True;
  odsAvailFormulas.Active := False;
  odsAvailFormulas.Active := True;
end;


procedure TDMData.RefreshTasks;
begin
  odsTasks.Active := False;
  odsTasks.Active := True;
end;


function TDMData.Connect: Boolean;
begin
  Result := osMain.Connected;
  if not osMain.Connected then begin
    if OracleLogon.Execute then begin
      Result := osMain.Connected;
      if Result then begin
        alInterface  := TBPALInterface.Create( nil);
        alTranslator := TBpAlTranslator.Create( nil);
        alInterface.Session  := osMain;
        alTranslator.Session := osMain;
      end;
    end;
  end;
end;

function TDMData.Connected: Boolean;
begin
  Result := osMain.Connected;
end;


procedure TDMData.Disconnect;
begin
  //ShowMessage( 'DMData Disconnected');
  osMain.Connected := False;
  // alInterface.Destroy;
  // alTranslator.Destroy;
end;


procedure TDMData.OpenFormulaList;
begin
  CloseFormulaList;
  odsAvailFormulas.SetVariable( 'CURLIBRARY',
    odsLibrary.fieldByName( 'Classified').asFloat);
  odsFormulaList.Active   := True;
  odsAvailFormulas.Active := True;
end;


procedure TDMData.CloseFormulaList;
begin
  odsFormulaList.Active   := False;
  odsAvailFormulas.Active := False;
end;

function TDMData.GetDescTable( ColumnID: Double): TLookUpTable;
begin
  with qrColumnAttrs do begin
    Close;
    SetVariable( 'nClass', ColumnID);
    Execute;
    while not EOF do begin
      if fieldAsInteger( 'typClassified') = 3 then
        Result.TableName := fieldAsString( 'Value');
      if fieldAsInteger( 'typClassified') = 4 then
        Result.CodeName := fieldAsString( 'Value');
      if fieldAsInteger( 'typClassified') = 5 then
        Result.LabelName := fieldAsString( 'Value');
      Next;
    end;
    Close;
  end;
end;

function TDMData.CreateColumn( ColumnID: Double): TCubeColumn;
begin
  Result := TCubeColumn.Create;
  with odsColumnDesc do begin
    Active := False;
    SetVariable( 'pColumnID', ColumnID);
    Active := True;
    Result.Classified  := fieldByName( 'Classified').asFloat;
    Result.ColumnName  := fieldByName( 'columnname').asString;
    Result.ColumnDesc  := fieldByName( 'description').asString;
    Result.ColumnLabel := fieldByName( 'label'     ).asString;
    Result.ColumnType  := ctDimension;
    if fieldByName( 'columnType').asFloat = 2 then Result.ColumnType := ctFact;
    Result.ColumnFilter:= '';
    Result.FieldType   := fieldByName( 'data_type').asString;
    Result.isRequiredParam := fieldByName( 'isRequiredParam').asInteger = 1;
    Result.LibraryID   := 0;
  end;
  Result.DescTable := GetDescTable( ColumnID);
end;

procedure TdmData.odsLibraryAfterScroll(DataSet: TDataSet);
begin
 try
   try
     odsFormulasInLibrary.Active := False;
     odsFormulasInLibrary.SetVariable( 'curLibrary',
       odsLibrary.fieldByName( 'Classified').asFloat);
     odsFormulasInLibrary.Active := True;
   except
     on E: Exception do ProcessException( E);
   end;
 finally
 end;
end;

procedure TdmData.DataModuleCreate(Sender: TObject);
begin
  //ShowMessage( 'DMData Created');
  alInterface  := nil;
  alTranslator := nil;
end;

procedure TdmData.DataModuleDestroy(Sender: TObject);
begin
  //ShowMessage( 'DMData Destroyed');
  alInterface  := nil;
  alTranslator := nil;
end;

function isActiveX: Boolean;
var AppName: String;
begin
  AppName := UpperCase( ExtractFileName( Application.ExeName));
  Result  := AppName <> 'ALLADINE.EXE';
end;


end.

