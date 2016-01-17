unit StringFilter;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, CubeClasses, Math, DataModule;


type
  TfmFilterString = class(TForm)
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    edList: TEdit;
    cbCompareWith: TComboBox;
    btDetails: TButton;
    procedure edListChange(Sender: TObject);
    procedure btDetailsClick(Sender: TObject);
    procedure edListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edListKeyPress(Sender: TObject; var Key: Char);
  private
    fType: String;
    SQL  : String;
    ALabel: String;
    ACode: String;
    aCodeList: String;
    ALabelList: String;
    dmData    : TDMData;
    procedure fillCompareForFilter;
  public
    { Public declarations }
  end;

//function ShowStringFilter( var S: String; var curCompare: String; AType: String): Boolean;
function TranslateStringFilter( curColumn: TCubeColumn): String;
function TranslateNumberFilter( curColumn: TCubeColumn): String;
function ShowStringFilter( var ADMData: TDMData; var curColumn: TCubeColumn; AType: String): Boolean;

implementation

uses SelectValue, ReportOptionsClass;


{$R *.DFM}


procedure TfmFilterString.fillCompareForFilter;
var oldIndex: Integer;
begin
  oldIndex := Max( 0, cbCompareWith.ItemIndex);
  if fType = ftVarChar2 then begin
    cbCompareWith.Items.Clear;
    if Pos( ',', edList.Text) > 0 then
      cbCompareWith.Items.Add( AFilterTypes[ ftIN      ])
    else begin
      cbCompareWith.Items.Add( AFilterTypes[ ftEqual   ]);
      cbCompareWith.Items.Add( AFilterTypes[ ftNotEqual]);
    end;
  end;
  if fType = ftNumber then begin
    if Pos( ',', edList.Text) > 0 then
      cbCompareWith.Items.Add( AFilterTypes[ ftIN      ])
    else begin
      cbCompareWith.Items.Add( AFilterTypes[ ftGreater      ]);
      cbCompareWith.Items.Add( AFilterTypes[ ftGreateOrEqual]);
      cbCompareWith.Items.Add( AFilterTypes[ ftEqual        ]);
      cbCompareWith.Items.Add( AFilterTypes[ ftLess         ]);
      cbCompareWith.Items.Add( AFilterTypes[ ftLessOrEqual  ]);
      cbCompareWith.Items.Add( AFilterTypes[ ftNotEqual     ]);
    end;
  end;
  if fType = '' then begin
    cbCompareWith.Items.Add( AFilterTypes[ ftEqual        ]);
  end;
  cbCompareWith.ItemIndex := Min( cbCompareWith.Items.Count - 1, oldIndex);
end;


function TranslateStringFilter( curColumn: TCubeColumn): String;
var iPtr: Integer;
    curS: String;
    s1  : String;
begin
  Result := '';
  if curColumn.ColumnFilter = '' then Exit;
  curS := curColumn.ColumnFilter;

  Result := curColumn.ColumnName + ' ' + curColumn.CompareWith;
  if curColumn.CompareWith = aFilterTypes[ ftIN] then Result := Result + '( ';
  if curColumn.FieldType = ftVarChar2 then
    repeat
      iPtr := Pos( ',', curS);
      if iPtr > 0 then begin
        s1   := Copy( curS, 1, iPtr - 1);
        curS := Copy( curS, iPtr + 1, Length( curS));
      end else s1 := curS;
      Result := Result + '''' + s1 + ''',';
     until iPtr = 0;
   Result[ Length( Result)] := ' ';
   if curColumn.CompareWith = aFilterTypes[ ftIN] then Result := Result + ')';
end;



function TranslateNumberFilter( curColumn: TCubeColumn): String;
begin
  Result := '';
  if curColumn.ColumnFilter = '' then Exit;
  Result := curColumn.ColumnName + curColumn.CompareWith;
  if curColumn.CompareWith = aFilterTypes[ ftIN] then Result := Result + '(';
  Result := Result + curColumn.ColumnFilter;
  if curColumn.CompareWith = aFilterTypes[ ftIN] then Result := Result + ')';
end;


function ShowStringFilter( var ADMData: TDMData; var curColumn: TCubeColumn; AType: String): Boolean;
var S, curCompare: String;
begin
  s := curColumn.ColumnFilter;
  curCompare := curColumn.CompareWith;
  Result := False;
  with TfmFilterString.Create( Application) do begin
    dmData := ADMData;
    fType := AType;
    if AType = ftNumber
      then Caption := 'Фильтр для числового поля'
      else Caption := 'Фильтр для текстового поля';
    cbCompareWith.Enabled := fType <> '';
    SQL := curColumn.LookUpSQL;
    ALabel := ''; ALabelList := '';
    ACode  := ''; ACodeList  := '';
    btDetails.Visible     := {( fType = '') and }( SQL <> '');
    fillCompareForFilter;
    edList.Text := S;

    if ShowModal = mrOK then begin
      S := edList.Text;
      //if btDetails.Visible then S := ACodeList;

      curCompare := cbCompareWith.Text;
      curColumn.ColumnFilter := S;
      curColumn.CompareWith  := curCompare;
      if Pos( ',', S) > 0 then curCompare := AFilterTypes[ ftIN];
      // if AType = '' then curCompare := AFilterTypes[ ftEqual];
      Result := True;
    end;
    Free;
  end;


end;

procedure TfmFilterString.edListChange(Sender: TObject);
begin
  fillCompareForFilter;
end;


procedure TfmFilterString.btDetailsClick(Sender: TObject);
  function hasFragment( S, cDelim, sCode: String): Boolean;
  var S1: String;
  begin
    Result := False;
    if S = '' then Exit;
    S1 := S;
    if S1[ 1] <> cDelim then S1 := cDelim + S1;
    if S1[ Length( S1)] <> cDelim then S1 := S1 + cDelim;
    Result := Pos( cDelim + sCode + cDelim, S1) > 0;
  end;
begin
 if JSelectValue( dmData, SQL, ALabel, ACode) then begin
   if hasFragment( edList.Text, ',', ACode) then begin
     ShowMessage( 'Такое значение уже есть !');
     Exit;
   end;
   if edList.Text <> '' then begin
     edList.Text := edList.Text + ',';
   end;
   edList.Text := edList.Text + ACode;
 end;

end;

procedure TfmFilterString.edListKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_Delete then begin
    ACodeList := '';
    edList.Text := '';
  end;
end;

procedure TfmFilterString.edListKeyPress(Sender: TObject; var Key: Char);
begin
  if btDetails.Visible then begin
    Key := #0;
    raise Exception.Create( 'Изменять значения вручную нельзя');
  end;
end;

end.


