object fmFilterString: TfmFilterString
  Left = 145
  Top = 200
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1060#1080#1083#1100#1090#1088' '#1076#1083#1103' '#1090#1077#1082#1089#1090#1086#1074#1086#1075#1086' '#1087#1086#1083#1103
  ClientHeight = 87
  ClientWidth = 367
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
    Width = 367
    Height = 41
    Align = alTop
    BevelInner = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 7
      Top = 12
      Width = 87
      Height = 13
      Caption = #1057#1087#1080#1089#1086#1082' '#1079#1085#1072#1095#1077#1085#1080#1081
    end
    object edList: TEdit
      Left = 167
      Top = 8
      Width = 154
      Height = 21
      Hint = #1042#1074#1077#1076#1080#1090#1077' '#1089#1087#1080#1089#1086#1082' '#1079#1085#1072#1095#1077#1085#1080#1081' '#1095#1077#1088#1077#1079' '#1079#1072#1087#1103#1090#1091#1102
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnChange = edListChange
      OnKeyDown = edListKeyDown
      OnKeyPress = edListKeyPress
    end
    object cbCompareWith: TComboBox
      Left = 111
      Top = 9
      Width = 54
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
    end
    object btDetails: TButton
      Left = 328
      Top = 8
      Width = 33
      Height = 25
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1080#1089#1082#1072
      Caption = '...'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = btDetailsClick
    end
  end
  object BitBtn1: TBitBtn
    Left = 106
    Top = 48
    Width = 75
    Height = 27
    TabOrder = 1
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 194
    Top = 48
    Width = 75
    Height = 27
    TabOrder = 2
    Kind = bkCancel
  end
end
