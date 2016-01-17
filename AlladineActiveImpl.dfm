object AlladineActiveX: TAlladineActiveX
  Left = 109
  Top = 122
  Width = 544
  Height = 375
  Caption = 'AlladineActiveX'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = ActiveFormActivate
  OnCreate = ActiveFormCreate
  OnDestroy = ActiveFormDestroy
  OnDeactivate = ActiveFormDeactivate
  PixelsPerInch = 96
  TextHeight = 13
  inline RealFrame: TfrMain
    Left = 0
    Top = 0
    Width = 536
    Height = 348
    Align = alClient
    TabOrder = 0
    inherited CoolBar1: TCoolBar
      Width = 536
      Bands = <
        item
          Control = RealFrame.ToolBar1
          ImageIndex = -1
          Width = 532
        end>
      inherited ToolBar1: TToolBar
        Width = 519
        inherited tbHelp: TToolButton
          Action = RealFrame.acAbout
        end
        inherited tbExit: TToolButton
          Action = RealFrame.acHelp
        end
      end
    end
    inherited PageControl: TPageControl
      Width = 536
      Height = 298
      ActivePage = RealFrame.tsFormulas
      inherited tsFormulas: TTabSheet
        inherited pnFormulas: TPanel
          Width = 528
          Height = 288
          inherited dbgFormula: TDBGrid
            Width = 526
            Height = 286
          end
        end
      end
      inherited tsLibrarys: TTabSheet
        inherited Splitter1: TSplitter
          Width = 528
        end
        inherited dbgLibrary: TDBGrid
          Width = 528
        end
        inherited dbgFormulasInLibrary: TDBGrid
          Width = 528
          Height = 122
        end
      end
      inherited tsReports: TTabSheet
        inherited dbgTasks: TDBGrid
          Width = 528
          Height = 288
        end
      end
    end
    inherited StatusBar: TStatusBar
      Top = 329
      Width = 536
    end
  end
end
