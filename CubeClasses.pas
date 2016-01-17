unit CubeClasses;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, DB, Oracle;


type
   TLookUpTable = record
     TableName, CodeName, LabelName: String;
   end;

   TColumnType = ( ctDimension, ctFact);
   TCubeColumn = class
     Classified: Double;
     ColumnName, ColumnDesc, ColumnLabel: String;
     FieldType        : String;
     ColumnFilter     : String;
     CompareWith      : String;
     ColumnType       : TColumnType;
     LibraryID        : Double;
     isRequiredParam  : Boolean;
     DescTable        : TLookUpTable;
   public
     procedure AssignTo( var ACubeColumn: TCubeColumn);
     function LookUpSQL: String;
   end;


   TStartingOptions = record
     lPreview, lDeleteZeroColumns: Boolean;
   end;

   TInteger = class
     private
       value: Integer;
     public
       constructor Create( AValue: Integer);
       property getValue: Integer read value;
   end;


   TString = class
     private
       value: String;
     public
       constructor Create( AValue: String);
       property getValue: String read value;
   end;




implementation

uses fmFilterDates, StringFilter,
     LibraryFilter, TempEdit, ReportView, ReportParams;


constructor TInteger.Create( AValue: Integer);
begin
  value := AValue;
end;

constructor TString.Create( AValue: String);
begin
  value := AValue;
end;


function TCubeColumn.LookUpSQL: String;
begin
  Result := '';
  with DescTable do
  if ( TableName <> '') and ( CodeName <> '') and ( LabelName <> '')
    then Result := 'select ' + CodeName + ',' + LabelName + ' from ' +
                   TableName + ' order by ' + LabelName;
end;


procedure TCubeColumn.AssignTo( var ACubeColumn: TCubeColumn);
begin
  ACubeColumn.Classified      := Classified;
  ACubeColumn.ColumnName      := ColumnName;
  ACubeColumn.ColumnDesc      := ColumnDesc;
  ACubeColumn.ColumnLabel     := ColumnLabel;
  ACubeColumn.FieldType       := FieldType;
  ACubeColumn.ColumnType      := COlumnType;
  ACubeColumn.LibraryID       := LibraryID;
  ACubeColumn.ColumnFilter    := ColumnFilter;
  ACubeColumn.CompareWith     := CompareWith;
  AcubeColumn.isRequiredParam := isRequiredParam;
  ACubeColumn.DescTable.TableName := DescTable.TableName;
  ACubeColumn.DescTable.CodeName  := DescTable.CodeName;
  ACubeColumn.DescTable.LabelName := DescTable.LabelName;
end;


end.
