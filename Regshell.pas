unit RegShell;

interface

uses Registry;

type
  TRegShell = class(TRegistry)
    function ReadRegString(KeyName: String; DefValue: String): String;
    function ReadRegInteger(KeyName: String; DefValue: Integer): Integer;
    function ReadRegBool(KeyName: String; DefValue: Boolean): Boolean;
    function ReadRegFloat(KeyName: String; DefValue: Double): Double;
  end;

implementation

uses SysUtils;

function TRegShell.ReadRegString(KeyName: String; DefValue: String): String;
begin
  try
    Result := ReadString(KeyName);
  except
    on Exception do Result := DefValue;
  end;
end;

function TRegShell.ReadRegInteger(KeyName: String; DefValue: Integer): Integer;
begin
  try
    Result := ReadInteger(KeyName);
  except
    on Exception do Result := DefValue;
  end;
end;

function TRegShell.ReadRegFloat(KeyName: String; DefValue: Double): Double;
begin
  try
    Result := ReadFloat(KeyName);
  except
    on Exception do Result := DefValue;
  end;
end;


function TRegShell.ReadRegBool(KeyName: String; DefValue: Boolean): Boolean;
begin
  try
    Result := ReadBool(KeyName);
  except
    on Exception do Result := DefValue;
  end;
end;

end.
