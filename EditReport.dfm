object fmEditReport: TfmEditReport
  Left = 206
  Top = 198
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1086#1090#1095#1077#1090#1072
  ClientHeight = 143
  ClientWidth = 414
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
    Width = 414
    Height = 97
    Align = alTop
    BevelInner = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 55
      Height = 13
      Caption = #1058#1080#1087' '#1086#1090#1095#1077#1090#1072
    end
    object Label2: TLabel
      Left = 8
      Top = 37
      Width = 86
      Height = 13
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1086#1090#1095#1077#1090#1072
    end
    object edReportName: TEdit
      Left = 103
      Top = 33
      Width = 294
      Height = 21
      TabOrder = 0
    end
    object cbReportType: TComboBox
      Left = 103
      Top = 12
      Width = 294
      Height = 21
      ItemHeight = 13
      TabOrder = 1
    end
    object btDetails: TButton
      Left = 276
      Top = 62
      Width = 121
      Height = 25
      Caption = #1055#1086#1076#1088#1086#1073#1085#1086#1089#1090#1080' >>'
      TabOrder = 2
      OnClick = btDetailsClick
    end
    object btGetReport: TButton
      Left = 104
      Top = 62
      Width = 121
      Height = 25
      Caption = #1055#1086#1083#1091#1095#1080#1090#1100' '#1086#1090#1095#1077#1090
      TabOrder = 3
      OnClick = btGetReportClick
    end
  end
  object BitBtn1: TBitBtn
    Left = 112
    Top = 106
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 216
    Top = 106
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
end
