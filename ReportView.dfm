object fmReportView: TfmReportView
  Left = 142
  Top = 109
  BorderStyle = bsDialog
  Caption = #1054#1073#1088#1072#1073#1086#1090#1082#1072' '#1086#1090#1095#1077#1090#1072
  ClientHeight = 351
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
    object dbgReport: TDBGrid
      Left = 2
      Top = 2
      Width = 532
      Height = 293
      Align = alClient
      DataSource = dsReport
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
    end
  end
  object BitBtn1: TBitBtn
    Left = 192
    Top = 304
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 280
    Top = 304
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
  object btSQL: TBitBtn
    Left = 24
    Top = 304
    Width = 145
    Height = 25
    Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1079#1072#1087#1088#1086#1089#1072
    TabOrder = 3
    OnClick = btSQLClick
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000130B0000130B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      333333333333333FF3FF3333333333CC30003333333333773777333333333C33
      3000333FF33337F33777339933333C3333333377F33337F3333F339933333C33
      33003377333337F33377333333333C333300333F333337F33377339333333C33
      3333337FF3333733333F33993333C33333003377FF33733333773339933C3333
      330033377FF73F33337733339933C33333333FF377F373F3333F993399333C33
      330077F377F337F33377993399333C33330077FF773337F33377399993333C33
      33333777733337F333FF333333333C33300033333333373FF7773333333333CC
      3000333333333377377733333333333333333333333333333333}
    NumGlyphs = 2
  end
  object dsReport: TDataSource
    DataSet = odsReport
    Left = 436
    Top = 256
  end
  object odsReport: TOracleDataSet
    ReadBuffer = 25
    Optimize = True
    Debug = False
    StringFieldsOnly = False
    SequenceField.ApplyMoment = amOnPost
    OracleDictionary.EnforceConstraints = False
    OracleDictionary.UseMessageTable = False
    OracleDictionary.DefaultValues = False
    OracleDictionary.DynamicDefaults = False
    OracleDictionary.FieldKinds = False
    OracleDictionary.DisplayFormats = False
    OracleDictionary.RangeValues = False
    OracleDictionary.RequiredFields = True
    QBEDefinition.SaveQBEValues = True
    QBEDefinition.AllowFileWildCards = True
    QBEDefinition.QBEFontColor = clNone
    QBEDefinition.QBEBackgroundColor = clNone
    Cursor = crDefault
    ReadOnly = False
    LockingMode = lmCheckImmediate
    QueryAllRecords = True
    CountAllRecords = False
    RefreshOptions = []
    CommitOnPost = True
    CachedUpdates = False
    QBEMode = False
    Session = dmData.osMain
    DesignActivation = False
    Active = False
    Left = 468
    Top = 256
  end
  object oqFillCube: TOracleQuery
    Session = dmData.osMain
    ReadBuffer = 25
    Optimize = True
    Debug = False
    Variables.Data = {
      03000000050000000B0000003A434F4C554D4E4C495354050000000000000000
      0000000C0000003A5748455245434C415553450500000000000000000000000C
      0000003A464F524D554C414C495354050000000000000000000000090000003A
      464143544C4953540500000000000000000000000A0000003A5441424C454E41
      4D45050000000000000000000000}
    Cursor = crDefault
    StringFieldsOnly = False
    Threaded = False
    ThreadSynchronized = True
    Left = 500
    Top = 256
  end
end
