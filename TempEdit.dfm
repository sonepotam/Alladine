object fmTempEdit: TfmTempEdit
  Left = 205
  Top = 162
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'fmTempEdit'
  ClientHeight = 224
  ClientWidth = 371
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
    Width = 371
    Height = 177
    Align = alTop
    BevelInner = bvLowered
    Caption = 'Panel1'
    TabOrder = 0
    object Memo: TMemo
      Left = 2
      Top = 2
      Width = 367
      Height = 173
      Align = alClient
      Lines.Strings = (
        '')
      TabOrder = 0
    end
  end
  object BitBtn1: TBitBtn
    Left = 144
    Top = 184
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkOK
  end
end
