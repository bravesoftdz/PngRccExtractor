object FrmMain: TFrmMain
  Left = 0
  Top = 0
  Caption = 'FrmMain'
  ClientHeight = 456
  ClientWidth = 649
  Color = clBtnFace
  Constraints.MaxWidth = 665
  Constraints.MinHeight = 495
  Constraints.MinWidth = 665
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Tahoma'
  Font.Style = []
  Font.Quality = fqClearTypeNatural
  OldCreateOrder = False
  Position = poDesktopCenter
  DesignSize = (
    649
    456)
  PixelsPerInch = 96
  TextHeight = 19
  object Lbl_ExtractProgress: TLabel
    Left = 423
    Top = 130
    Width = 120
    Height = 19
    Caption = 'Prgoress: Png(0)'
  end
  object SynEdt_HEX: TSynEdit
    Left = 8
    Top = 8
    Width = 409
    Height = 154
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Consolas'
    Font.Style = []
    Font.Quality = fqClearTypeNatural
    TabOrder = 0
    UseCodeFolding = False
    Gutter.Font.Charset = DEFAULT_CHARSET
    Gutter.Font.Color = clWindowText
    Gutter.Font.Height = -11
    Gutter.Font.Name = 'Consolas'
    Gutter.Font.Style = []
    Gutter.LeadingZeros = True
    Gutter.ShowLineNumbers = True
    Gutter.Gradient = True
    Options = [eoAutoIndent, eoEnhanceEndKey, eoGroupUndo, eoScrollPastEol, eoShowScrollHint, eoSmartTabDelete, eoSmartTabs, eoTabsToSpaces]
  end
  object Btn_Load: TButton
    Left = 423
    Top = 8
    Width = 217
    Height = 49
    Cursor = crHandPoint
    Caption = 'Load RCC File'
    TabOrder = 1
    WordWrap = True
    OnClick = Btn_LoadClick
  end
  object ProgsBar_Extract: TProgressBar
    Left = 423
    Top = 155
    Width = 217
    Height = 7
    TabOrder = 2
  end
  object ProgsBar_Divider: TProgressBar
    Left = 423
    Top = 63
    Width = 217
    Height = 5
    Smooth = True
    Style = pbstMarquee
    SmoothReverse = True
    TabOrder = 3
  end
  object Btn_Extract: TButton
    Left = 423
    Top = 75
    Width = 217
    Height = 49
    Cursor = crHandPoint
    Caption = 'Extract Png'#39's'
    Enabled = False
    TabOrder = 4
    WordWrap = True
    OnClick = Btn_ExtractClick
  end
  object LV_PNG_List: TListView
    Left = 8
    Top = 174
    Width = 633
    Height = 138
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        Caption = 'ID'
      end
      item
        Caption = 'PNG HEX DATA'
        Width = 3000
      end>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    Font.Quality = fqClearTypeNatural
    FlatScrollBars = True
    GridLines = True
    ParentFont = False
    TabOrder = 5
    ViewStyle = vsReport
    ExplicitHeight = 139
  end
  object Pnl_Images: TPanel
    Left = 0
    Top = 318
    Width = 649
    Height = 138
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 6
    ExplicitTop = 319
    object CtrlList_Pngs: TControlList
      Left = 0
      Top = 0
      Width = 649
      Height = 138
      Align = alClient
      ItemColor = clBtnFace
      ItemWidth = 200
      ItemMargins.Left = 2
      ItemMargins.Top = 2
      ItemMargins.Right = 2
      ItemMargins.Bottom = 2
      ColumnLayout = cltMultiTopToBottom
      ItemSelectionOptions.HotColorAlpha = 20
      ItemSelectionOptions.SelectedColorAlpha = 30
      ItemSelectionOptions.FocusedColorAlpha = 40
      ParentColor = False
      TabOrder = 0
      object Lbl_Detail: TLabel
        AlignWithMargins = True
        Left = 48
        Top = 25
        Width = 146
        Height = 45
        Margins.Left = 10
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        AutoSize = False
        Caption = 'This is example of item with multi-line text.'
        ShowAccelChar = False
        Transparent = True
        WordWrap = True
      end
      object Virt_Img_Png: TVirtualImage
        AlignWithMargins = True
        Left = 4
        Top = 5
        Width = 30
        Height = 30
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        ImageWidth = 0
        ImageHeight = 0
        ImageIndex = -1
      end
      object Lbl_Title: TLabel
        Left = 41
        Top = 4
        Width = 25
        Height = 16
        Caption = 'Title'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
    end
  end
  object Btn_Copy: TButton
    Left = 344
    Top = 117
    Width = 49
    Height = 25
    Cursor = crHandPoint
    Caption = 'Copy'
    TabOrder = 7
    OnClick = Btn_CopyClick
  end
end
