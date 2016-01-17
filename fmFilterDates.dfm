object fmDateFilter: TfmDateFilter
  Left = 301
  Top = 229
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1044#1072#1090#1089#1082#1080#1081' '#1092#1080#1083#1100#1090#1088
  ClientHeight = 117
  ClientWidth = 292
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
    Width = 292
    Height = 65
    Align = alTop
    BevelInner = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 49
      Height = 13
      Caption = #1048#1085#1090#1077#1088#1074#1072#1083
    end
    object dtStartDate: TDateTimePicker
      Left = 88
      Top = 8
      Width = 186
      Height = 21
      Date = 37614.862243379600000000
      Time = 37614.862243379600000000
      DateFormat = dfLong
      TabOrder = 0
    end
    object dtStopDate: TDateTimePicker
      Left = 87
      Top = 30
      Width = 186
      Height = 21
      Date = 37614.862243379600000000
      Time = 37614.862243379600000000
      DateFormat = dfLong
      TabOrder = 1
    end
  end
  object BitBtn1: TBitBtn
    Left = 48
    Top = 80
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 152
    Top = 80
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
end
