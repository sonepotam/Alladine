object fmLibraryContentEdit: TfmLibraryContentEdit
  Left = 91
  Top = 145
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1060#1086#1088#1084#1091#1083#1099' '#1074' '#1085#1072#1073#1086#1088#1077
  ClientHeight = 348
  ClientWidth = 550
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
    Width = 550
    Height = 305
    Align = alTop
    BevelInner = bvLowered
    TabOrder = 0
    object Panel2: TPanel
      Left = 2
      Top = 2
      Width = 546
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      Caption = 'Panel2'
      TabOrder = 1
      object Label1: TLabel
        Left = 16
        Top = 16
        Width = 48
        Height = 13
        Caption = #1060#1086#1088#1084#1091#1083#1072
      end
      object edFormula: TEdit
        Left = 73
        Top = 12
        Width = 455
        Height = 21
        Enabled = False
        ReadOnly = True
        TabOrder = 0
        Text = 'edFormula'
      end
    end
    object Panel3: TPanel
      Left = 2
      Top = 43
      Width = 546
      Height = 260
      Align = alClient
      BevelOuter = bvLowered
      TabOrder = 0
      object dbgAllFormulas: TDBGrid
        Left = 1
        Top = 1
        Width = 232
        Height = 258
        Align = alLeft
        DataSource = dmData.dsFormulaList
        Options = [dgEditing, dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'Label'
            Title.Caption = #1060#1086#1088#1084#1091#1083#1099
            Width = 213
            Visible = True
          end>
      end
      object btAddFormula: TButton
        Left = 239
        Top = 88
        Width = 24
        Height = 25
        Caption = '>'
        TabOrder = 1
        OnClick = btAddFormulaClick
      end
      object btRemoveFormula: TButton
        Left = 240
        Top = 123
        Width = 24
        Height = 25
        Caption = '<'
        TabOrder = 2
        OnClick = btRemoveFormulaClick
      end
      object dbgAvailFormulas: TDBGrid
        Left = 272
        Top = 1
        Width = 273
        Height = 258
        Align = alRight
        DataSource = dmData.dsAvailFormulas
        Options = [dgEditing, dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
        ReadOnly = True
        TabOrder = 3
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        OnDblClick = dbgAvailFormulasDblClick
        Columns = <
          item
            Expanded = False
            FieldName = 'operation'
            Title.Caption = '+/-'
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -13
            Title.Font.Name = 'MS Sans Serif'
            Title.Font.Style = [fsBold]
            Width = 20
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Label'
            Title.Caption = #1060#1086#1088#1084#1091#1083#1099' '#1074' '#1085#1072#1073#1086#1088#1077
            Width = 242
            Visible = True
          end>
      end
    end
  end
  object BitBtn1: TBitBtn
    Left = 184
    Top = 320
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 273
    Top = 320
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
end
