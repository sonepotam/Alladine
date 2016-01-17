unit Tools;

interface

uses ShellApi, SHLObj, SysUtils, Windows, Forms, Classes, Controls,
     Dialogs, FileCtrl, stdctrls, Registry;


const CRLF =  #13 + #10;

type TMonthArray = array[ 1..12] of String;

const
  MonthArray: TMonthArray = (
    '€нвар€',  'феврал€', 'марта',    'апрел€',  'ма€',    'июн€',
    'июл€',    'августа', 'сент€бр€', 'окт€бр€', 'но€бр€', 'декабр€');

  type
    TLangCodePage = record
     wLanguage: Word;
     wCodePage: Word;
    end;
    PLangCodePage = ^TLangCodePage;

function AddSlash( Path: String): String;
function ResourceConnected( AResourceName: String): Boolean;

function SetFileDateTime( fileName: String; fileDateTime: String): Boolean;

function StrToMin( S: String): Integer;
function curDateToStr: String;

function CharToOemStr(const S: String): String;
function OemToCharStr(const S: String): String;

function StartExecutable( fileName: String): Boolean;
function GetShortPath( sLongPath: String; nBufLen: Integer): String;
function MoveFileWin32( SourceFile, DestFile: String): Boolean;


function RestorePrevInstance( className, wndCaption: String): Boolean;
function checkDir( DirectoryName: String): Boolean;  overload;
function checkDir( Edit: TEdit): Boolean;            overload;
function ConvertFileDateTimeToStr( fileName: String): String;
function SafeFormatDateTime( const Format: String; DateTime: TDateTime): String;
function SafeStringToDateTime( StrDateTime: String): TDateTime;
function SafeStringToInteger( S: String): Integer;
function SafeStringToFloat( S: String): Extended;

procedure Sorry;
procedure OkInfo(mText: string);
procedure OkError(mText: string);
function OkCancel(mText: string): boolean;
function YesNo(mText: string): boolean;
function NoYes(mText: string): boolean;

function GetFolderFromShell(Handle: THandle; Prompt: PChar): String;
function GetErrorMessage( nMessageID: integer = 99999): String;

function GetVersionInfo: Integer;
function ExecuteCommand(UnpackCmdLine, FileName: String): Boolean;

function GetRegistryValue(KeyName, ValueName: string): string;
function ActiveXPath: String;
function VersionInfo( AppName: String) : String;
function ActiveXVersionInfo( OCXName: String): String;




function rDate( curD: TDateTime): String;

implementation

function rDate( curD: TDateTime): String;
var M, D, Y: Word;
begin
  DecodeDate( curD, Y, M, D);
  Result := IntToStr( D) + ' ' + MonthArray[ M] + ' ' + IntToStr( Y) + ' г.';
end;



function AddSlash( Path: String): String;
begin
  Result := Path;
  if Path = '' then Exit;
  if Path[ Length( Path)] <> '\' then Result := Result + '\';
end;


function MoveFileWin32( SourceFile, DestFile: String): Boolean;
begin
  Result := CopyFile(   PChar( SourceFile), PChar( DestFile), False) and
            DeleteFile( PChar( SourceFile));
end;


function ExecuteCommand(UnpackCmdLine, FileName: String): Boolean;
var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  CmdLine: String;
  dwCreate: DWORD;

begin
  Result := False;
  FillChar(StartupInfo, SizeOf(TStartupInfo), 0);
  StartupInfo.cb := SizeOf(TStartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := SW_HIDE;
  dwCreate := NORMAL_PRIORITY_CLASS;
  if Pos(' ', FileName) > 0 then
   CmdLine:= UnpackCmdLine + ' "' + FileName + '"'
  else
   CmdLine:= UnpackCmdLine + ' ' + FileName;
  if CreateProcess(nil, PChar(CmdLine), nil, nil, False,
                   dwCreate, nil, PChar(ExtractFilePath(FileName)), StartupInfo, ProcessInfo) then
   begin
     CloseHandle(ProcessInfo.hThread);
     Result := WaitForSingleObject(ProcessInfo.hProcess, INFINITE) <> WAIT_FAILED;
     CloseHandle(ProcessInfo.hProcess);
   end;
end;



function GetShortPath( sLongPath: String; nBufLen: Integer): String;
var nLeftPad, nRightPad: Integer;
begin
  if Length( sLongPath) <= nBufLen then Result := sLongPath else
   begin
     //
     // должно остатьс€
     //
     nLeftPad  := trunc( ( nBufLen - 3) / 2);
     nRightPad := nBufLen - nLeftPad -3;
     Result    :=
       Copy( sLongPath, 1, nLeftPad) + '...' +
       Copy( sLongPath, Length( sLongPath) - nRightPad + 1, nRightPad);
   end;
end;


function GetVersionInfo: Integer;
var
  InfoSize, Wnd: DWORD;
  VerBuf: Pointer;
  FI: PVSFixedFileInfo;
  VerSize: DWORD;
begin
  Result := 0;
  InfoSize := GetFileVersionInfoSize( PChar( Application.ExeName), Wnd);
  if InfoSize <> 0 then
    begin
      GetMem(VerBuf, InfoSize);
      try
        if GetFileVersionInfo(PChar(  Application.ExeName), Wnd, InfoSize, VerBuf) then
          if VerQueryValue(VerBuf, '\', Pointer(FI), VerSize) then
            Result := FI.dwFileVersionMS;
      finally
        FreeMem(VerBuf);
      end;
    end;
end;

function GetErrorMessage( nMessageID: integer = 99999): String;
var lpMsgBuf: PChar;
    LangID  : Integer;
begin
  if nMessageID = 99999 then  nMessageID := GetLastError();
  GetMem( lpMsgBuf, 501);
  fillChar( lpMsgBuf^, 501, '0');
  LangID := LANG_USER_DEFAULT;
  FormatMessage( FORMAT_MESSAGE_FROM_SYSTEM, nil, nMessageID, LangID, lpMsgBuf,
    500, nil);
  Result := StrPas( lpMsgBuf);
  FreeMem( lpMsgBuf);
end;


function SetFileDateTime( fileName: String; fileDateTime: String): Boolean;
var hHandle : THandle;
    dDate   : TDateTime;
    DateSep, TimeSep: char;
    realDate: Integer;
begin
  Result  := False;
  DateSep := DateSeparator;
  TimeSep := TimeSeparator;
  DateSeparator := '/';
  TimeSeparator := ':';
  dDate := StrToDateTime( fileDateTime);
  DateSeparator := dateSep;
  TimeSeparator := timeSep;
  realDate := DateTimeToFileDate( dDate);
  hHandle := FileOpen( fileName, fmOpenRead or fmOpenWrite);
  if hHandle <> INVALID_HANDLE_VALUE then begin
    Result := FileSetDate( hHandle, realDate) = 0;
    FileClose( hHandle);
  end;
end;


function StrToMin( S: String): Integer;
begin
 try
  Result := StrToInt( Copy( S, 1, 2)) * 60 + StrToInt( Copy( S, 4, 2));
 except on E: Exception do Result := 0;
 end;
end;

function curDateToStr: String;
var TimeSep: Char;
begin
  TimeSep := TimeSeparator;
  TimeSeparator := ':';
  Result := FormatDateTime( 'hh:nn', Time);
  TimeSeparator := TimeSep;
end;


function CharToOemStr(const S: String): String;
var
  OemPtr, AnsiPtr: PChar;

begin
  OemPtr := StrAlloc(Length(S) + 1);
  AnsiPtr := StrAlloc(Length(S) + 1);
  AnsiPtr := StrPCopy(AnsiPtr, S);
  CharToOem(AnsiPtr, OemPtr);
  Result := StrPas(OemPtr);
  StrDispose(OemPtr);
  StrDispose(AnsiPtr);
end;

function OemToCharStr(const S: String): String;
var
  OemPtr, AnsiPtr: PChar;

begin
  OemPtr := StrAlloc(Length(S) + 1);
  AnsiPtr := StrAlloc(Length(S) + 1);
  OemPtr := StrPCopy(OemPtr, S);
  OemToChar(OemPtr, AnsiPtr);
  Result := StrPas(AnsiPtr);
  StrDispose(OemPtr);
  StrDispose(AnsiPtr);
end;


function StartExecutable( fileName: String): Boolean;
begin
  Result := ShellExecute( 0, 'open', PChar( fileName), nil, nil,
     SW_SHOWNORMAL) > 32;
end;



function RestorePrevInstance( className, wndCaption: String): Boolean;
var hWindow: THandle;
    pClassName, pCaption: PChar;
begin
  pClassName := NIL;
  pCaption   := NIL;
  if className  <> '' then pClassName := PChar( className);
  if wndCaption <> '' then pCaption   := PChar( wndCaption);

  hWindow := FindWindow( pClassName, pCaption);
  if hWindow <> 0 then begin
     ShowWindow( hWindow, sw_Maximize);
     SetForegroundWindow( hWindow);
  end;
  Result  := hWindow <> 0;

end;

function checkDir( DirectoryName: String): Boolean;
begin
  Result := True;
  if not DirectoryExists( DirectoryName) then begin
    Result := False;
    MessageDlg( ' аталог ' + DirectoryName + ' не найден !', mtError, [mbOK],0);
  end;
end;

function checkDir( Edit: TEdit): Boolean;
begin
  Result := True;
  if not checkDir( Edit.Text) then begin
    if Edit.Visible then Edit.SetFocus;
    Result := False;
  end;
end;


procedure Sorry;
begin
   OKInfo('»звините, эта функци€ пока недоступна.');
end;

procedure OkInfo(mText: string);
begin
  MessageDlg(mText,mtInformation,[mbOk],0);
end;

procedure OkError(mText: string);
begin
  MessageDlg(mText,mtError,[mbOk],0);
end;

function OkCancel(mText: string): boolean;
begin
  if MessageDlg(mText,mtConfirmation,[mbOk,mbCancel],0) = mrOk then Result := True//, mtConfirmation, [mbYes, mbNo], 0) = mrYes then Result := True
  else Result := False;
end;

function YesNo(mText: string): boolean;
begin
  if MessageDlg(mText,mtConfirmation,[mbYes,mbNo],0) = mrYes then Result := True//, mtConfirmation, [mbYes, mbNo], 0) = mrYes then Result := True
  else Result := False;
end;

function NoYes(mText: string): boolean;
begin
  if MessageDlg(mText,mtConfirmation,[mbNo,mbYes],0) = mrYes then Result := True//, mtConfirmation, [mbYes, mbNo], 0) = mrYes then Result := True
  else Result := False;
end;


function SafeStringToDateTime( StrDateTime: String): TDateTime;
var OldDateSeparator, OldTimeSeparator: Char;
    OldShortDateFormat: String;
begin
  OldDateSeparator   := DateSeparator;
  OldTimeSeparator   := TimeSeparator;
  OldShortDateFormat := ShortDateFormat;

  DateSeparator   := '/';
  TimeSeparator   := ':';
  ShortDateFormat := 'dd/mm/yyyy';

  Result := StrToDateTime( StrDateTime);

  DateSeparator   := OldDateSeparator;
  TimeSeparator   := OldTimeSeparator;
  ShortDateFormat := OldShortDateFormat;
end;




function SafeFormatDateTime( const Format: String; DateTime: TDateTime): String;
var OldDateSeparator, OldTimeSeparator: Char;
begin
  OldDateSeparator := DateSeparator;
  OldTimeSeparator := TimeSeparator;

  DateSeparator := '/';
  TimeSeparator := ':';

  Result := FormatDateTime( 'dd/mm/yyyy hh:nn:ss', DateTime);

  DateSeparator := OldDateSeparator;
  TimeSeparator := OldTimeSeparator;
end;

function ConvertFileDateTimeToStr( fileName: String): String;
var DateTime: TDateTime;
begin
  Result := '';
  if not FileExists( fileName) then Exit;
  DateTime  := FileDateToDateTime( FileAge( fileName));
  Result := SafeFormatDateTime( 'dd/mm/yyyy hh:nn:ss', DateTime);
end;




procedure CallBack(Wnd: HWND; uMsg: UINT; lParam, lpData: LPARAM); stdcall;
begin
  SendMessage(Wnd, BFFM_SETSTATUSTEXT, lpData, lpData);
end;

function GetFolderFromShell(Handle: THandle; Prompt: PChar): String;
var
  BrowseInfo: TBrowseInfo;
  DestBuffer: PChar;
  ResPIDL: PItemIDList;

begin
  FillChar(BrowseInfo, SizeOf(BrowseInfo), 0);
  DestBuffer := StrAlloc(MAX_PATH);
  with BrowseInfo do
   begin
     hwndOwner := Handle;
     pszDisplayName := DestBuffer;
     lpszTitle := Prompt;
     lpfn := @CallBack;
     lParam := LongInt(Prompt);
   end;
  ResPIDL := SHBrowseForFolder(BrowseInfo);
  if ResPIDL = nil then Result := ''
  else
   begin
    SHGetPathFromIDList(ResPIDL, DestBuffer);
    Result := ExpandUNCFileName(StrPas(DestBuffer));
    Result := StrPas(DestBuffer);
   end;
  StrDispose(DestBuffer);
end;

function SafeStringToInteger( S: String): Integer;
begin
  if S = '' then S := '0';
  Result := StrToInt( S);
end;

function SafeStringToFloat( S: String): Extended;
begin
  if S = '' then S := '0';
  Result := StrToFloat( S);
end;

function ActiveXPath: String;
begin
  Result :=  GetRegistryValue(
  'SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings', 'ActiveXCache');
end;


function GetRegistryValue(KeyName, ValueName: string): string;
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create(KEY_READ);
  try
    Registry.RootKey := HKEY_LOCAL_MACHINE;
    Registry.OpenKey(KeyName, False);
    Result := Registry.ReadString( ValueName);
  finally
    Registry.Free;
  end;
end;

function ActiveXVersionInfo( OCXName: String): String;
begin
  Result := VersionInfo( AddSlash( ActiveXPath) + OCXName);
end;


function VersionInfo( AppName: String) : String;
var S, sVersion: String;
    InfoSize   : DWORD;
    Buf, Value : PChar;
    P          : PLangCodePage;
    Len        : DWORD;
    sLang1, sLang2: String;
begin
  Result   := '';
  if AppName = '' then S := Application.ExeName else S := AppName;
  InfoSize := GetFileVersionInfoSize( PChar(S), InfoSize);
  if InfoSize > 0 then begin
    Buf := AllocMem( InfoSize);
    GetFileVersionInfo( PChar( S), 0, InfoSize, Buf);

    GetMem( P, SizeOf( TLangCodePage));
    FillChar( P, SizeOf( TLangCodePage), 0);

    if VerQueryValue( Buf, '\VarFileInfo\Translation', Pointer( P), Len) then
      begin
        sLang1 := Trim( Format( '%4x', [ P^.wLanguage]));
        sLang2 := Trim( Format( '%4x', [ P^.wCodePage]));
        if Length( sLang1) < 4 then sLang1 := '0' + sLang1;
        if Length( sLang2) < 4 then sLang2 := '0' + sLang2;
        sVersion := sLang1 + sLang2;
        if VerQueryValue(Buf,
           PChar('StringFileInfo\' + sVersion + '\FileVersion'),
           Pointer(Value), Len) then Result := Value;
      end;
    FreeMem( Buf, InfoSize);
  end;

end;


function ResourceConnected( AResourceName: String): Boolean;
var nError: dWord;
    hEnum : THandle;
    lpBuffer: Pointer;
    nCount, BufferSize: DWORD;
    S : String;
begin
  Result := False;
  nError := WNetOpenEnum( RESOURCE_CONNECTED, RESOURCETYPE_ANY,
  RESOURCEUSAGE_CONNECTABLE, nil, hEnum);
  if nError = NO_ERROR then begin
    GetMem( lpBuffer, SizeOf( TNetResource));
    fillChar( lpBuffer^, SizeOf( TNetResource), #0);

    nCount := 1;
    BufferSize := SizeOf( TNetResource);
    while True do begin
      nError := WNetEnumResource( hEnum, nCount, lpBuffer, BufferSize);
      if nError = ERROR_MORE_DATA then begin
        nCount := 1;
        FreeMem( lpBuffer);
        GetMem( lpBuffer, BufferSize + 1);
        fillChar( lpBuffer^, BufferSize + 1, #0);
        nError := WNetEnumResource( hEnum, nCount, lpBuffer, BufferSize);
      end;
      //P := lpBuffer;
      if nError = NO_ERROR then begin
         S := PNetResource( lpBuffer)^.lpRemoteName;
         S := S + S;
         Result := True;
      end;
      if nError <> NO_Error then Break;
    //end;
    end;
  end;
  WNetCloseEnum( hEnum);
end;


end.


