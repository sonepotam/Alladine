object fmReportParams: TfmReportParams
  Left = 168
  Top = 192
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
  ClientHeight = 191
  ClientWidth = 418
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
    Width = 418
    Height = 105
    Align = alTop
    BevelInner = bvLowered
    TabOrder = 0
    object lvFilter: TListView
      Left = 2
      Top = 2
      Width = 414
      Height = 101
      Align = alClient
      Columns = <
        item
          Caption = #1055#1072#1088#1072#1084#1077#1090#1088
          Width = 150
        end
        item
          Caption = #1047#1085#1072#1095#1077#1085#1080#1077
          Width = 250
        end>
      ColumnClick = False
      DragMode = dmAutomatic
      ReadOnly = True
      TabOrder = 0
      ViewStyle = vsReport
      OnDblClick = lvFilterDblClick
    end
  end
  object btOK: TBitBtn
    Left = 100
    Top = 154
    Width = 75
    Height = 24
    TabOrder = 1
    OnClick = btOKClick
    Kind = bkOK
  end
  object btCancel: TBitBtn
    Left = 196
    Top = 154
    Width = 75
    Height = 24
    TabOrder = 2
    Kind = bkCancel
  end
  object cbPreview: TCheckBox
    Left = 8
    Top = 112
    Width = 401
    Height = 17
    Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1087#1088#1077#1076#1074#1072#1088#1080#1090#1077#1083#1100#1085#1099#1077' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1099
    TabOrder = 3
  end
  object cbDeleteZeroCols: TCheckBox
    Left = 8
    Top = 129
    Width = 401
    Height = 17
    Caption = #1059#1076#1072#1083#1103#1090#1100' '#1082#1086#1083#1086#1085#1082#1080' '#1089' '#1085#1091#1083#1077#1074#1099#1084#1080' '#1076#1072#1085#1085#1099#1084#1080
    TabOrder = 4
  end
end
