object FrmPrincipal: TFrmPrincipal
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Agenda'
  ClientHeight = 443
  ClientWidth = 716
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MenuPrincipal
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid1: TcxGrid
    Left = 8
    Top = 176
    Width = 700
    Height = 216
    TabOrder = 0
    object GrdAgenda: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = Ds
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      object ColNome: TcxGridDBColumn
        DataBinding.FieldName = 'nome'
      end
      object ColEmail: TcxGridDBColumn
        DataBinding.FieldName = 'email'
      end
      object ColTelefone: TcxGridDBColumn
        DataBinding.FieldName = 'telefone'
      end
    end
    object cxGrid1Level1: TcxGridLevel
      GridView = GrdAgenda
    end
  end
  object EdtNome: TcxTextEdit
    Left = 16
    Top = 88
    TabOrder = 1
    Width = 121
  end
  object EdtEmail: TcxTextEdit
    Left = 143
    Top = 88
    TabOrder = 2
    Width = 121
  end
  object EdtTelefone: TcxTextEdit
    Left = 270
    Top = 88
    TabOrder = 3
    Width = 121
  end
  object cxButton1: TcxButton
    Left = 397
    Top = 86
    Width = 75
    Height = 25
    Caption = 'Gravar'
    TabOrder = 4
  end
  object cxLabel1: TcxLabel
    Left = 16
    Top = 65
    Caption = 'Nome'
  end
  object cxLabel2: TcxLabel
    Left = 143
    Top = 65
    Caption = 'E-Mail'
  end
  object cxLabel3: TcxLabel
    Left = 270
    Top = 65
    Caption = 'Telefone'
  end
  object Ds: TDataSource
    DataSet = QryGrid
    Left = 584
    Top = 104
  end
  object QryGrid: TFDQuery
    Connection = ConMySQL
    Left = 544
    Top = 56
  end
  object ConMySQL: TFDConnection
    Left = 640
    Top = 40
  end
  object MenuPrincipal: TMainMenu
    Left = 456
    Top = 8
    object ParmetrosConexo1: TMenuItem
      Caption = 'Op'#231#245'es'
      object ParmetrosConexo2: TMenuItem
        Caption = 'Par'#226'metros Conex'#227'o'
        OnClick = ParmetrosConexo2Click
      end
    end
  end
end
