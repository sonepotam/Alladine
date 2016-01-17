object fmLibraryFilter: TfmLibraryFilter
  Left = 235
  Top = 214
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1042#1099#1073#1086#1088' '#1085#1072#1073#1088#1072' '#1092#1086#1088#1084#1091#1083
  ClientHeight = 96
  ClientWidth = 480
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 480
    Height = 49
    Align = alTop
    BevelInner = bvLowered
    Caption = 'Panel1'
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 74
      Height = 13
      Caption = #1053#1072#1073#1086#1088' '#1092#1086#1088#1084#1091#1083
    end
    object cbLibrary: TComboBox
      Left = 118
      Top = 12
      Width = 355
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
    end
  end
  object BitBtn1: TBitBtn
    Left = 161
    Top = 59
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 249
    Top = 59
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
end
