object fmStartJob: TfmStartJob
  Left = 224
  Top = 200
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Запуск задания'
  ClientHeight = 244
  ClientWidth = 363
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 363
    Height = 201
    Align = alTop
    BevelInner = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 18
      Top = 16
      Width = 43
      Height = 13
      Caption = 'Задание'
    end
    object Label2: TLabel
      Left = 18
      Top = 41
      Width = 45
      Height = 13
      Caption = 'Расчет С'
    end
    object Label3: TLabel
      Left = 18
      Top = 63
      Width = 16
      Height = 13
      Caption = 'ПО'
    end
    object cbUseDeps: TCheckBox
      Left = 18
      Top = 84
      Width = 156
      Height = 17
      Caption = 'Разбивка по филиалам'
      TabOrder = 0
    end
    object cbUseCurrency: TCheckBox
      Left = 18
      Top = 102
      Width = 144
      Height = 17
      Caption = 'Разбивка по валютам'
      TabOrder = 1
    end
    object dtStartDate: TDateTimePicker
      Left = 92
      Top = 36
      Width = 186
      Height = 21
      CalAlignment = dtaLeft
      Date = 0.443102523146081
      Time = 0.443102523146081
      DateFormat = dfShort
      DateMode = dmComboBox
      Kind = dtkDate
      ParseInput = False
      TabOrder = 2
    end
    object dtStopDate: TDateTimePicker
      Left = 91
      Top = 58
      Width = 187
      Height = 21
      CalAlignment = dtaLeft
      Date = 37613.4431025231
      Time = 37613.4431025231
      DateFormat = dfShort
      DateMode = dmComboBox
      Kind = dtkDate
      ParseInput = False
      TabOrder = 3
    end
    object rgStartPlace: TRadioGroup
      Left = 15
      Top = 123
      Width = 338
      Height = 63
      Caption = 'Расчет задания'
      ItemIndex = 0
      Items.Strings = (
        'На этом компьютере'
        'На сервере (удаленно)')
      TabOrder = 4
    end
    object btAddData: TButton
      Left = 178
      Top = 82
      Width = 99
      Height = 25
      Caption = 'Библиотеки >>'
      Enabled = False
      TabOrder = 5
    end
    object cbTaskType: TComboBox
      Left = 92
      Top = 13
      Width = 261
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 6
    end
  end
  object BitBtn1: TBitBtn
    Left = 106
    Top = 208
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 194
    Top = 208
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
end
