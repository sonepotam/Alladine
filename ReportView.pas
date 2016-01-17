unit ReportView;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, OracleData, Grids, DBGrids, StdCtrls, Buttons, CubeClasses, ExtCtrls,
  Oracle, ReportOptionsClass;

type
  TfmReportView = class(TForm)
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    dbgReport: TDBGrid;
    dsReport: TDataSource;
    odsReport: TOracleDataSet;
    oqFillCube: TOracleQuery;
    btSQL: TBitBtn;
    procedure btSQLClick(Sender: TObject);
  private
    SQLString: String;
    { Private declarations }
  public
    { Public declarations }
  end;

procedure PreviewReport( ReportOptions: TReportOptions);

implementation

uses DataModule, ReportOptions, TempEdit, ReportResult;

{$R *.DFM}


procedure PreviewReport( ReportOptions: TReportOptions);
var sSQL: String;
    iPtr: Integer;
    sTmp: String;
    nCnt: Integer;
begin
  with ReportOptions do begin
   fillParams;
   if not ParamsCreated then Exit;
   sTmp := LibraryList; nCnt := 0;
   sSQL := ' select ' + ColumnList + ',';
   repeat
     iPtr := Pos( ',', sTmp);
     sTmp := Copy( sTmp, iPtr + 1, Length( sTmp));
     Inc( nCnt);
     sSQL := sSQL + 'sum( summa' + IntToStr( nCnt) + ') fact' +
             IntToStr( nCnt)+ ',';
   until iPtr = 0;
   sSQL := Copy( sSQL, 1, Length( sSQL) - 1);
   sSQL := sSQL + ' from gtt_' +TableName + ' ';
   // if WhereClause <> '' then sSQL := sSQL + ' where ' + WhereClause;
   sSQL := sSQL + ' group by ' + ColumnList;
   sSQL := sSQL + ' order by ' + ColumnList;
   with TfmReportView.Create( Application) do
   try
     try
       SQLString := sSQL;
       //
       // очередная времянка для вызова конкретной функции
       //
       oqFillCube.SetVariable( 'columnlist',  ColumnList);
       oqFillCube.SetVariable( 'factlist',    FactList);
       oqFillCube.SetVariable( 'whereclause', WhereClause);
       oqFillCube.SetVariable( 'formulalist', LibraryList);
       oqFillCube.SetVariable( 'tablename',   TableName);

       with dmData.odsCubeDesc do begin
         Active := False;
         SetVariable( 'pCube', ReportOptions.idCube);
         Active := True;
         if Eof then Exception.Create( 'Не найдена процедура для расчета ');

         oqFillCube.SQL.Add( 'begin ');
         oqFillCube.SQL.Add( fieldByName( 'sqlBlock').asString +
             '( :tableName, :ColumnList, :FactList, :WhereClause, :FormulaList);');
         oqFillCube.SQL.Add( ' end;');
       end;


       oqFillCube.Execute;


       odsReport.Active := False;
       odsReport.SQL.Add( sSQL);
       odsReport.Active := True;
       if ReportOptions.StartOptions.lPreview then
         begin
           if ShowModal = mrOk then ShowReportResult( dmData, ReportOptions, odsReport);
         end
        else
          begin
            ShowReportResult( dmData, ReportOptions, odsReport);
          end;

     except
       on E: Exception do ProcessException( E);
     end;
     finally
       odsReport.Active := False;
       ReportOptions.dmData.odsCubeDesc.Active := False;
     end;

  end;
end;

procedure TfmReportView.btSQLClick(Sender: TObject);
begin
   ShowTextInfo( 'Готовый запрос', SQLString);
end;

end.
