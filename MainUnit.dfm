object MainForm: TMainForm
  Left = 166
  Top = 122
  Width = 551
  Height = 375
  Caption = #1055#1086#1083#1091#1095#1077#1085#1080#1077' '#1072#1085#1072#1083#1080#1090#1080#1095#1077#1089#1082#1086#1081' '#1086#1090#1095#1077#1090#1085#1086#1089#1090#1080
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = RealFrame.MainMenu
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 16
  inline RealFrame: TfrMain
    Left = 0
    Top = 0
    Width = 543
    Height = 329
    Align = alClient
    TabOrder = 0
    inherited CoolBar1: TCoolBar
      Width = 543
      Bands = <
        item
          Control = RealFrame.ToolBar1
          ImageIndex = -1
          Width = 539
        end>
      inherited ToolBar1: TToolBar
        Width = 526
        inherited tbExit: TToolButton
          Action = RealFrame.acExit
        end
      end
    end
    inherited PageControl: TPageControl
      Width = 543
      Height = 279
      inherited tsLibrarys: TTabSheet
        inherited Splitter1: TSplitter
          Width = 535
        end
        inherited dbgLibrary: TDBGrid
          Width = 535
        end
        inherited dbgFormulasInLibrary: TDBGrid
          Width = 535
          Height = 103
        end
      end
      inherited tsReports: TTabSheet
        inherited dbgTasks: TDBGrid
          Width = 535
          Height = 269
        end
      end
    end
    inherited StatusBar: TStatusBar
      Top = 310
      Width = 543
    end
  end
end
