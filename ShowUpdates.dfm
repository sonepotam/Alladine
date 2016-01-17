object fmUpdateInfo: TfmUpdateInfo
  Left = 192
  Top = 107
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1054#1073#1085#1086#1074#1083#1077#1085#1080#1077' '#1076#1072#1085#1085#1099#1093
  ClientHeight = 348
  ClientWidth = 536
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
    Width = 536
    Height = 297
    Align = alTop
    BevelInner = bvLowered
    Caption = 'Panel1'
    TabOrder = 0
    object DBGrid1: TDBGrid
      Left = 2
      Top = 2
      Width = 532
      Height = 293
      Align = alClient
      DataSource = dsStartInfo
      Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'curdate'
          Title.Caption = #1044#1072#1090#1072
          Width = 116
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'message'
          Title.Caption = #1057#1086#1086#1073#1097#1077#1085#1080#1077
          Width = 384
          Visible = True
        end>
    end
  end
  object BitBtn1: TBitBtn
    Left = 184
    Top = 312
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 264
    Top = 312
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
  object dsStartInfo: TDataSource
    DataSet = dmData.odsStartInfo
    Left = 16
    Top = 280
  end
end
