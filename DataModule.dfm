object dmData: TdmData
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 54
  Top = 60
  Height = 515
  Width = 720
  object osMain: TOracleSession
    Cursor = crHourGlass
    DesignConnection = False
    ConnectAs = caNormal
    ThreadSafe = True
    Preferences.FloatPrecision = 0
    Preferences.IntegerPrecision = 0
    Preferences.SmallIntPrecision = -1
    Preferences.UseOCI7 = False
    Preferences.ConvertCRLF = True
    Preferences.TrimStringFields = True
    Preferences.MaxStringFieldSize = 0
    Preferences.ZeroDateIsNull = True
    Preferences.NullLOBIsEmpty = False
    Pooling = spNone
    MTSOptions = [moImplicit, moUniqueServer]
    Connected = False
    RollbackOnDisconnect = False
    NullValue = nvUnAssigned
    SQLTrace = stUnchanged
    OptimizerGoal = ogUnchanged
    IsolationLevel = ilReadCommitted
    BytesPerCharacter = bc1Byte
    Left = 32
    Top = 16
  end
  object OracleLogon: TOracleLogon
    Session = osMain
    Retries = 3
    Options = [ldAuto, ldDatabase, ldDatabaseList, ldLogonHistory]
    AliasDropDownCount = 8
    HistoryRegSection = 'ALLADINE'
    HistorySize = 6
    HistoryWithPassword = True
    Caption = #1057#1086#1077#1076#1080#1085#1077#1085#1080#1077' '#1089' '#1041#1044
    Left = 32
    Top = 72
  end
  object odsFormula: TOracleDataSet
    SQL.Strings = (
      'select Classified, Label, Value from alformula'
      'order by label')
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
    QBEDefinition.QBEFieldDefs = {
      03000000030000000A000000434C41535349464945440100000000050000004C
      4142454C01000000000500000056414C55450100000000}
    Cursor = crDefault
    ReadOnly = True
    LockingMode = lmCheckImmediate
    QueryAllRecords = True
    CountAllRecords = False
    RefreshOptions = []
    CommitOnPost = True
    CachedUpdates = False
    QBEMode = False
    Session = osMain
    DesignActivation = False
    Active = False
    Left = 120
    Top = 16
  end
  object dsFormula: TDataSource
    DataSet = odsFormula
    Left = 120
    Top = 72
  end
  object odsLibrary: TOracleDataSet
    SQL.Strings = (
      'select * from allibrary'
      'order by label')
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
    Session = osMain
    DesignActivation = False
    Active = False
    AfterScroll = odsLibraryAfterScroll
    Left = 208
    Top = 16
  end
  object dsLibrary: TDataSource
    DataSet = odsLibrary
    Left = 208
    Top = 80
  end
  object odsFormulaList: TOracleDataSet
    SQL.Strings = (
      'select * from alformula '
      'order by label')
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
    Session = osMain
    DesignActivation = False
    Active = False
    Left = 272
    Top = 16
  end
  object dsFormulaList: TDataSource
    DataSet = odsFormulaList
    Left = 280
    Top = 72
  end
  object odsAvailFormulas: TOracleDataSet
    SQL.Strings = (
      'select AF.*, LC.Operation '
      'from alformula AF, alLibraryContent LC'
      'where AF.Classified = LC.idFormula'
      '  and LC.idLibrary = :curLibrary'
      'order by label')
    ReadBuffer = 25
    Optimize = True
    Debug = False
    Variables.Data = {
      03000000010000000B0000003A4355524C494252415259040000000000000000
      000000}
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
    Session = osMain
    DesignActivation = False
    Active = False
    Left = 368
    Top = 16
  end
  object dsAvailFormulas: TDataSource
    DataSet = odsAvailFormulas
    Left = 368
    Top = 72
  end
  object odsTaskTypes: TOracleDataSet
    SQL.Strings = (
      'select * from alTasktypes'
      'where enabled = 1 and SQLBlock is not null'
      'order by label'
      ' ')
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
    Session = osMain
    DesignActivation = False
    Active = False
    Left = 120
    Top = 132
  end
  object odsLibsInReport: TOracleDataSet
    SQL.Strings = (
      'select L.Classified, L.label, AL.nOrder'
      'from altaskformulas AL, alLibrary L'
      'where AL.idTask    = :pTask'
      '  and AL.idLibrary = L.Classified'
      'order by AL.nOrder')
    ReadBuffer = 25
    Optimize = True
    Debug = False
    Variables.Data = {0300000001000000060000003A505441534B040000000000000000000000}
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
    Session = osMain
    DesignActivation = False
    Active = False
    Left = 208
    Top = 132
  end
  object odsTasks: TOracleDataSet
    SQL.Strings = (
      'select ATT.idCube, AT.* '
      'from altask AT, alTaskTypes ATT'
      'where AT.idTaskType = ATT.Classified'
      'order by AT.label')
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
    Session = osMain
    DesignActivation = False
    Active = False
    Left = 280
    Top = 136
  end
  object dsTasks: TDataSource
    DataSet = odsTasks
    Left = 280
    Top = 184
  end
  object odsColumnList: TOracleDataSet
    SQL.Strings = (
      'select ATL.*, ATC.Data_Type'
      'from alTableColumns ATL, alTableDesc ATD, all_tab_columns ATC'
      '  where ATD.Classified = ATL.idTable'
      #9'and ATC.Table_Name  = Upper( ATD.TableName)'
      #9'and ATC.Column_Name = Upper( ATL.COLUMNNAME) '
      '      and idTable = :pTable'
      'order by label')
    ReadBuffer = 25
    Optimize = True
    Debug = False
    Variables.Data = {0300000001000000070000003A505441424C45040000000000000000000000}
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
    Session = osMain
    DesignActivation = False
    Active = False
    Left = 120
    Top = 192
  end
  object dsColumnList: TDataSource
    DataSet = odsColumnList
    Left = 120
    Top = 248
  end
  object odsLibraryList: TOracleDataSet
    SQL.Strings = (
      'select * from allibrary'
      'order by label')
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
    Session = osMain
    DesignActivation = False
    Active = False
    Left = 210
    Top = 189
  end
  object odsTableName: TOracleDataSet
    SQL.Strings = (
      'select * from altableDesc '
      'where classified = :pTable')
    ReadBuffer = 25
    Optimize = True
    Debug = False
    Variables.Data = {0300000001000000070000003A505441424C45040000000000000000000000}
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
    Session = osMain
    DesignActivation = False
    Active = False
    Left = 24
    Top = 136
  end
  object odsTaskAttr: TOracleDataSet
    SQL.Strings = (
      'select * from altaskattr'
      'where idTaskClass = :idTask'
      'order by idClassified, nOrder')
    ReadBuffer = 25
    Optimize = True
    Debug = False
    Variables.Data = {0300000001000000070000003A49445441534B040000000000000000000000}
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
    Session = osMain
    DesignActivation = False
    Active = False
    Left = 24
    Top = 192
  end
  object odsTaskAttrDesc: TOracleDataSet
    SQL.Strings = (
      'select ATA.*, ATC.Label'
      'from altaskattr ATA, altablecolumns ATC'
      'where ATA.OBJ = ATC.CLASSIFIED'
      '  and ATA.idTaskClass = :pTask'
      'union all'
      'select ATA.*, L.Label'
      'from altaskattr ATA, alLibrary L'
      'where ATA.OBJ = L.CLASSIFIED'
      '  and ATA.idTaskClass = :pTask'
      'order by 1, 2')
    ReadBuffer = 25
    Optimize = True
    Debug = False
    Variables.Data = {0300000001000000060000003A505441534B040000000000000000000000}
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
    Session = osMain
    DesignActivation = False
    Active = False
    Left = 368
    Top = 136
  end
  object odsLibraryDesc: TOracleDataSet
    SQL.Strings = (
      'select * from allibrary'
      'where classified = :pClass')
    ReadBuffer = 25
    Optimize = True
    Debug = False
    Variables.Data = {0300000001000000070000003A50434C415353040000000000000000000000}
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
    Session = osMain
    DesignActivation = False
    Active = False
    Left = 368
    Top = 192
  end
  object odsInLibrarys: TOracleDataSet
    SQL.Strings = (
      'select LIB.Classified, LIB.Label'
      'from allibrary LIB, allibrarycontent CONTENT'
      'where LIB.Classified = CONTENT.IDLibrary'
      '  and CONTENT.idFormula = :pFormula')
    ReadBuffer = 25
    Optimize = True
    Debug = False
    Variables.Data = {
      0300000001000000090000003A50464F524D554C410400000000000000000000
      00}
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
    Session = osMain
    DesignActivation = False
    Active = False
    Left = 24
    Top = 248
  end
  object dsInLibrarys: TDataSource
    DataSet = odsInLibrarys
    Left = 24
    Top = 296
  end
  object odsCubeDesc: TOracleDataSet
    SQL.Strings = (
      'select * from altasktypes'
      'where idCube = :pCube'
      '  and Enabled = 1')
    ReadBuffer = 25
    Optimize = True
    Debug = False
    Variables.Data = {0300000001000000060000003A5043554245040000000000000000000000}
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
    Session = osMain
    DesignActivation = False
    Active = False
    Left = 213
    Top = 248
  end
  object odsColumnDesc: TOracleDataSet
    SQL.Strings = (
      
        'select ATL.*, ATC.Data_Type, to_Number(Attr1.Value) "isRequiredP' +
        'aram"'
      
        'from alTableColumns ATL, alTableDesc ATD, all_tab_columns ATC, a' +
        'lTabColumnsAttr Attr1'
      'where ATD.Classified = ATL.idTable'
      '  and ATC.Table_Name  = Upper( ATD.TableName)'
      '  and ATC.Column_Name = Upper( ATL.COLUMNNAME)'
      '  and ATL.Classified = Attr1.COLCLASSIFIED(+)'
      '  and Attr1.typClassified(+) = 238'
      '  and atl.classified = :pColumnID'
      ''
      ' ')
    ReadBuffer = 25
    Optimize = True
    Debug = False
    Variables.Data = {
      03000000010000000A0000003A50434F4C554D4E494404000000000000000000
      0000}
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
    Session = osMain
    DesignActivation = False
    Active = False
    Left = 368
    Top = 296
  end
  object odsFilterDesc: TOracleDataSet
    SQL.Strings = (
      'select * from altaskattr  '
      'where idTaskClass = :pTaskClass'
      '  and Obj = :pObj')
    ReadBuffer = 25
    Optimize = True
    Debug = False
    Variables.Data = {
      03000000020000000B0000003A505441534B434C415353040000000000000000
      000000050000003A504F424A040000000000000000000000}
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
    Session = osMain
    DesignActivation = False
    Active = False
    Left = 368
    Top = 248
  end
  object odsFormulasInLibrary: TOracleDataSet
    SQL.Strings = (
      
        'select AF.Classified Classified, AF.Label Label, AF.Value Value,' +
        ' LC.Operation '
      'from alformula AF, alLibraryContent LC'
      'where AF.Classified = LC.idFormula'
      '  and LC.idLibrary = :curLibrary'
      'order by label')
    ReadBuffer = 25
    Optimize = True
    Debug = False
    Variables.Data = {
      03000000010000000B0000003A4355524C494252415259040000000000000000
      000000}
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
    Session = osMain
    DesignActivation = False
    Active = False
    Left = 120
    Top = 304
  end
  object dsFormulasInLibrary: TDataSource
    DataSet = odsFormulasInLibrary
    Left = 120
    Top = 352
  end
  object qrColumnAttrs: TOracleQuery
    SQL.Strings = (
      'select typClassified, Value'
      'from alTabColumnsAttr'
      'where ColClassified = :nClass ')
    Session = osMain
    ReadBuffer = 25
    Optimize = True
    Debug = False
    Variables.Data = {0300000001000000070000003A4E434C415353030000000000000000000000}
    Cursor = crDefault
    StringFieldsOnly = False
    Threaded = False
    ThreadSynchronized = True
    Left = 376
    Top = 352
  end
  object odsStartInfo: TOracleDataSet
    SQL.Strings = (
      'select * from alStartInfo'
      'order by curDate desc')
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
    Session = osMain
    DesignActivation = False
    Active = False
    Left = 280
    Top = 248
  end
  object odsAccList: TOracleDataSet
    SQL.Strings = (
      'select * from alrestInfoAddInfo'
      'order by Account')
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
    Session = osMain
    DesignActivation = False
    Active = False
    Left = 216
    Top = 304
  end
  object dsAccList: TDataSource
    DataSet = odsAccList
    Left = 216
    Top = 352
  end
end
