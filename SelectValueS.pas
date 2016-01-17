unit SelectValueS;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Buttons, Grids, DBGrids, ExtCtrls, StdCtrls, Db, OracleData;

type
  TForm1 = class(TForm)
    DataSource1: TDataSource;
    OracleDataSet: TOracleDataSet;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    ListView1: TListView;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

end.
