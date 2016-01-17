object fmReportOptions: TfmReportOptions
  Left = 109
  Top = 98
  Width = 544
  Height = 451
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1086#1090#1095#1077#1090#1072
  Color = clBtnFace
  DragMode = dmAutomatic
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnDragDrop = FormDragDrop
  OnDragOver = FormDragOver
  PixelsPerInch = 96
  TextHeight = 13
  object pnMain: TPanel
    Left = 0
    Top = 0
    Width = 536
    Height = 383
    Align = alClient
    BevelInner = bvLowered
    Caption = 'pnMain'
    TabOrder = 0
    object Splitter1: TSplitter
      Left = 144
      Top = 2
      Height = 379
    end
    object pnRight: TPanel
      Left = 147
      Top = 2
      Width = 387
      Height = 379
      Align = alClient
      BevelInner = bvLowered
      BevelOuter = bvNone
      Caption = 'pnRight'
      TabOrder = 0
      object Splitter2: TSplitter
        Left = 1
        Top = 145
        Width = 385
        Height = 3
        Cursor = crVSplit
        Align = alTop
      end
      object pnTop: TPanel
        Left = 1
        Top = 1
        Width = 385
        Height = 144
        Align = alTop
        Caption = 'pnRow'
        TabOrder = 0
        object Splitter3: TSplitter
          Left = 1
          Top = 73
          Width = 383
          Height = 3
          Cursor = crVSplit
          Align = alTop
        end
        object lvFilter: TListView
          Left = 1
          Top = 1
          Width = 383
          Height = 72
          Align = alTop
          BorderStyle = bsNone
          Columns = <
            item
              Caption = #1060#1080#1083#1100#1090#1088
              Width = 150
            end
            item
              MaxWidth = 30
              MinWidth = 30
              Width = 30
            end
            item
              Caption = #1047#1085#1072#1095#1077#1085#1080#1077
              Width = 150
            end>
          ColumnClick = False
          DragMode = dmAutomatic
          ReadOnly = True
          TabOrder = 0
          ViewStyle = vsReport
          OnDblClick = lvFilterDblClick
          OnDragDrop = lvFilterDragDrop
          OnDragOver = lvFilterDragOver
          OnKeyDown = lvFilterKeyDown
        end
        object lvParams: TListView
          Left = 1
          Top = 76
          Width = 383
          Height = 67
          Align = alClient
          Columns = <
            item
              Caption = #1055#1072#1088#1072#1084#1077#1090#1088
              Width = 150
            end>
          ColumnClick = False
          DragMode = dmAutomatic
          ReadOnly = True
          TabOrder = 1
          ViewStyle = vsReport
          OnDragDrop = lvParamsDragDrop
          OnDragOver = lvParamsDragOver
          OnKeyDown = lvParamsKeyDown
        end
      end
      object pnRightBottom: TPanel
        Left = 1
        Top = 148
        Width = 385
        Height = 230
        Align = alClient
        Caption = 'pnRightBottom'
        TabOrder = 1
        object Splitter5: TSplitter
          Left = 121
          Top = 1
          Height = 228
        end
        object lvDimRows: TListView
          Left = 1
          Top = 1
          Width = 120
          Height = 228
          Align = alLeft
          Columns = <
            item
              Caption = #1057#1090#1088#1086#1082#1072
              Width = 110
            end>
          ColumnClick = False
          DragMode = dmAutomatic
          ReadOnly = True
          TabOrder = 0
          ViewStyle = vsReport
          OnDragDrop = lvDimRowsDragDrop
          OnDragOver = lvDimRowsDragOver
          OnKeyDown = lvDimRowsKeyDown
        end
        object pnFactAndColumns: TPanel
          Left = 124
          Top = 1
          Width = 260
          Height = 228
          Align = alClient
          Caption = 'pnFactAndColumns'
          TabOrder = 1
          object Splitter4: TSplitter
            Left = 1
            Top = 105
            Width = 258
            Height = 3
            Cursor = crVSplit
            Align = alTop
          end
          object lvFacts: TListView
            Left = 1
            Top = 108
            Width = 258
            Height = 119
            Align = alClient
            Columns = <
              item
                Caption = #1053#1072#1073#1086#1088' '#1092#1086#1088#1084#1091#1083
                Width = 250
              end>
            ColumnClick = False
            DragMode = dmAutomatic
            ReadOnly = True
            PopupMenu = pmFacts
            TabOrder = 0
            ViewStyle = vsReport
            OnDblClick = lvFactsDblClick
            OnDragDrop = lvFactsDragDrop
            OnDragOver = lvFactsDragOver
            OnKeyDown = lvFactsKeyDown
            OnStartDrag = lvFactsStartDrag
          end
          object lvDimColumns: TListView
            Left = 1
            Top = 1
            Width = 258
            Height = 104
            Align = alTop
            Columns = <
              item
                Caption = #1050#1086#1083#1086#1085#1082#1072
                Width = 150
              end>
            ColumnClick = False
            DragMode = dmAutomatic
            ReadOnly = True
            TabOrder = 1
            ViewStyle = vsReport
            OnDragDrop = lvDimColumnsDragDrop
            OnDragOver = lvDimColumnsDragOver
            OnKeyDown = lvDimColumnsKeyDown
          end
        end
      end
    end
    object pnLeft: TPanel
      Left = 2
      Top = 2
      Width = 142
      Height = 379
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'pnLeft'
      TabOrder = 1
      object lvColumnList: TListView
        Left = 0
        Top = 0
        Width = 142
        Height = 379
        Align = alClient
        BorderStyle = bsNone
        Columns = <
          item
            Caption = #1054#1087#1080#1089#1072#1085#1080#1077' '#1082#1091#1073#1080#1082#1072
            Width = -1
            WidthType = (
              -1)
          end>
        ColumnClick = False
        DragMode = dmAutomatic
        ReadOnly = True
        TabOrder = 0
        ViewStyle = vsReport
        OnDragDrop = lvColumnListDragDrop
        OnDragOver = lvColumnListDragOver
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 383
    Width = 536
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btOK: TBitBtn
      Left = 190
      Top = 8
      Width = 75
      Height = 25
      TabOrder = 0
      Kind = bkOK
    end
    object btCancel: TBitBtn
      Left = 286
      Top = 8
      Width = 75
      Height = 25
      TabOrder = 1
      Kind = bkCancel
    end
  end
  object pmFacts: TPopupMenu
    Left = 488
    Top = 386
    object N4: TMenuItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1085#1072#1073#1086#1088
      OnClick = N4Click
    end
    object N3: TMenuItem
      Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100
      OnClick = N3Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object N1: TMenuItem
      Caption = #1057#1086#1076#1077#1088#1078#1080#1084#1086#1077' '#1085#1072#1073#1086#1088#1072' '#1092#1086#1088#1084#1091#1083
      OnClick = N1Click
    end
  end
end
