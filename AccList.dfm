object fmAccList: TfmAccList
  Left = 186
  Top = 54
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1052#1072#1089#1082#1080' '#1083#1080#1094#1077#1074#1099#1093' '#1089#1095#1077#1090#1086#1074
  ClientHeight = 394
  ClientWidth = 231
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
    Width = 231
    Height = 345
    Align = alTop
    BevelInner = bvLowered
    TabOrder = 0
    object dbgAccList: TDBGrid
      Left = 2
      Top = 2
      Width = 227
      Height = 341
      Align = alClient
      DataSource = dmData.dsAccList
      Options = [dgEditing, dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'Account'
          Title.Caption = #1057#1095#1077#1090
          Width = 218
          Visible = True
        end>
    end
  end
  object BitBtn1: TBitBtn
    Left = 32
    Top = 360
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 112
    Top = 360
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
end
