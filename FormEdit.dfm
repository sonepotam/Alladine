object FormulaEdit: TFormulaEdit
  Left = 202
  Top = 68
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1092#1086#1088#1084#1091#1083#1099
  ClientHeight = 301
  ClientWidth = 388
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
  object pnMain: TPanel
    Left = 0
    Top = 0
    Width = 388
    Height = 255
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
    object Label2: TLabel
      Left = 8
      Top = 38
      Width = 80
      Height = 13
      Caption = #1058#1077#1082#1089#1090' '#1092#1086#1088#1084#1091#1083#1099
    end
    object edFormula: TEdit
      Left = 64
      Top = 12
      Width = 305
      Height = 21
      TabOrder = 0
    end
    object meFormula: TMemo
      Left = 8
      Top = 53
      Width = 361
      Height = 129
      TabOrder = 1
      OnChange = meFormulaChange
    end
    object btCheckFormula: TBitBtn
      Left = 9
      Top = 188
      Width = 75
      Height = 25
      Caption = #1055#1088#1086#1074#1077#1088#1082#1072
      TabOrder = 2
      OnClick = btCheckFormulaClick
    end
    object cbCreateLibrary: TCheckBox
      Left = 8
      Top = 230
      Width = 361
      Height = 17
      Caption = #1057#1086#1079#1076#1072#1090#1100' '#1085#1086#1074#1099#1081' '#1085#1072#1073#1086#1088
      TabOrder = 3
    end
    object btInLibrarys: TButton
      Left = 95
      Top = 188
      Width = 274
      Height = 25
      Caption = #1042#1082#1083#1102#1095#1077#1085#1072' '#1074' '#1073#1080#1073#1083#1080#1086#1090#1077#1082#1080' >>'
      TabOrder = 4
      OnClick = btInLibrarysClick
    end
    object dbgInLibrarys: TDBGrid
      Left = 8
      Top = 225
      Width = 361
      Height = 0
      DataSource = dmData.dsInLibrarys
      Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
      ReadOnly = True
      TabOrder = 5
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'label'
          Title.Caption = #1053#1072#1073#1086#1088#1099
          Visible = True
        end>
    end
  end
  object btOK: TBitBtn
    Left = 104
    Top = 260
    Width = 75
    Height = 25
    Enabled = False
    TabOrder = 1
    Kind = bkOK
  end
  object btCancel: TBitBtn
    Left = 192
    Top = 260
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
end
