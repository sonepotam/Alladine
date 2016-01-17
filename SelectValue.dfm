object fmSelectValue: TfmSelectValue
  Left = 172
  Top = 169
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1079#1085#1072#1095#1077#1085#1080#1077
  ClientHeight = 179
  ClientWidth = 421
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
    Width = 421
    Height = 129
    Align = alTop
    BevelInner = bvLowered
    Caption = 'Panel1'
    TabOrder = 0
    object DBGrid1: TDBGrid
      Left = 2
      Top = 2
      Width = 417
      Height = 125
      Align = alClient
      DataSource = DataSource1
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnDblClick = DBGrid1DblClick
    end
  end
  object BitBtn1: TBitBtn
    Left = 128
    Top = 144
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 208
    Top = 144
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
  object DataSource1: TDataSource
    DataSet = OracleDataSet
    Left = 24
    Top = 136
  end
  object OracleDataSet: TOracleDataSet
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
    ReadOnly = True
    LockingMode = lmCheckImmediate
    QueryAllRecords = True
    CountAllRecords = False
    RefreshOptions = []
    CommitOnPost = True
    CachedUpdates = False
    QBEMode = False
    DesignActivation = False
    Active = False
    Left = 56
    Top = 136
  end
end
