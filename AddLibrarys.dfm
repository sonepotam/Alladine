object AddLibrary: TAddLibrary
  Left = 267
  Top = 222
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1041#1080#1073#1083#1080#1086#1090#1077#1082#1072
  ClientHeight = 104
  ClientWidth = 362
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 362
    Height = 49
    Align = alTop
    BevelInner = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 50
      Height = 13
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077
    end
    object edLibraryName: TEdit
      Left = 67
      Top = 12
      Width = 286
      Height = 21
      TabOrder = 0
    end
  end
  object BitBtn1: TBitBtn
    Left = 109
    Top = 63
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 195
    Top = 62
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
end
