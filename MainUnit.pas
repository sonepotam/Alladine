unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ActnList, ImgList, ComCtrls, Grids, DBGrids, ExtCtrls, Buttons,
  ToolWin, StdCtrls, Oracle, SHELLAPI, DataModule, MainFrame;

type
  TMainForm = class(TForm)
    RealFrame: TfrMain;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure RealFrametbExitClick(Sender: TObject);
  private
    { Private declarations }
  public
  end;


implementation

uses About,  FormEdit, BpAlInterface, AddLibrarys,
     LibraryContentEdit, ErrorForm, ReportOptions, CubeClasses,
  ReportView, EditReport, ShowUpdates, Tools, ReportResult;
{$R *.DFM}



procedure TMainForm.FormCreate(Sender: TObject);
begin

  ShortDateFormat := 'dd.mm.yyyy';
  DateSeparator   := '.';
  RealFrame.PrepareFrame;
end;


procedure TMainForm.FormDestroy(Sender: TObject);
begin
//  ShowMessage( 'Destroy Main Form');
  RealFrame.DestroyFrame;
end;


procedure TMainForm.RealFrametbExitClick(Sender: TObject);
begin
//  RealFrame.acExitExecute(Sender);
  Application.Terminate;
end;

end.


