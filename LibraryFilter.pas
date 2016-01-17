unit LibraryFilter;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, DataModule;

type
  TfmLibraryFilter = class(TForm)
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    cbLibrary: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    fLibraryIDList: TStringList;
  public
    { Public declarations }
  end;


function ShowLibraryFilter( var dmData: TDMData; var S: String; var nLibraryID: Double): boolean;

implementation

{$R *.DFM}

function ShowLibraryFilter( var dmData: TDMData; var S: String; var nLibraryID: Double): boolean;
begin
  Result := False;
  with dmData, TfmLibraryFilter.Create( Application) do
    try
      try
        odsLibraryList.Active := False;
        odsLibraryList.Active := True;
        while not odsLibraryList.Eof do begin
          cbLibrary.Items.Add( odsLibraryList.fieldByName( 'label').asString);
          fLibraryIDList.Add(  odsLibraryList.fieldByName( 'Classified').asString);
          odsLibraryList.Next;
        end;
        odsLibraryList.Active := False;
        cbLibrary.ItemIndex := cbLibrary.Items.IndexOf( S);
        if ShowModal = mrOK then begin
          S   := cbLibrary.Text;
          nLibraryID := StrToFloat( fLibraryIDList[ cbLibrary.ItemIndex]);
          Result := True;
        end;
      except
       on E: Exception do ProcessException( E);
      end;
    finally
      odsLibraryList.Active := False;
      Free;
    end;


end;

procedure TfmLibraryFilter.FormCreate(Sender: TObject);
begin
  fLibraryIDList := TStringList.Create;
end;

procedure TfmLibraryFilter.FormDestroy(Sender: TObject);
begin
  fLibraryIDList.Free;
end;

end.
