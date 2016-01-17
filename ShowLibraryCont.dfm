object fmShowLibraryContent: TfmShowLibraryContent
  Left = 194
  Top = 186
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1057#1086#1076#1077#1088#1078#1080#1084#1086#1077' '#1073#1080#1073#1083#1080#1086#1090#1077#1082#1080
  ClientHeight = 196
  ClientWidth = 447
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 447
    Height = 153
    Align = alTop
    BevelInner = bvLowered
    Caption = 'Panel1'
    TabOrder = 0
    object dbgFormulasInLibrary: TDBGrid
      Left = 2
      Top = 2
      Width = 443
      Height = 149
      Align = alClient
      DataSource = dmData.dsFormulasInLibrary
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
          FieldName = 'LABEL'
          ReadOnly = True
          Title.Caption = #1060#1086#1088#1084#1091#1083#1072
          Width = 197
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'VALUE'
          Title.Caption = #1047#1085#1072#1095#1077#1085#1080#1077
          Width = 236
          Visible = True
        end>
    end
  end
  object BitBtn1: TBitBtn
    Left = 184
    Top = 164
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkOK
  end
end
