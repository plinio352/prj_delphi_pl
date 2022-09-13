object frmAgenda: TfrmAgenda
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Agenda'
  ClientHeight = 382
  ClientWidth = 578
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object pn1: TPanel
    Left = 0
    Top = 0
    Width = 578
    Height = 377
    Align = alTop
    TabOrder = 0
    object pgAgenda: TPageControl
      Left = 1
      Top = 1
      Width = 576
      Height = 375
      ActivePage = tsConsultar
      Align = alClient
      TabOrder = 0
      object tsConsultar: TTabSheet
        Caption = 'Consultar'
        object Panel1: TPanel
          Left = 0
          Top = 0
          Width = 568
          Height = 59
          Align = alTop
          TabOrder = 0
          object rgCampo: TRadioGroup
            AlignWithMargins = True
            Left = 4
            Top = 4
            Width = 144
            Height = 51
            Align = alLeft
            Caption = 'Campo:'
            Columns = 2
            Items.Strings = (
              'Nome'
              'Telefone')
            TabOrder = 0
          end
          object grPesq: TGroupBox
            AlignWithMargins = True
            Left = 154
            Top = 4
            Width = 351
            Height = 51
            Align = alLeft
            Caption = 'Pesquisa:'
            TabOrder = 1
            object edtPesq: TEdit
              AlignWithMargins = True
              Left = 5
              Top = 21
              Width = 341
              Height = 25
              Align = alClient
              TabOrder = 0
              Text = 'edtPesq'
              OnChange = edtPesqChange
              ExplicitHeight = 24
            end
          end
        end
        object pnl1: TPanel
          AlignWithMargins = True
          Left = 3
          Top = 62
          Width = 562
          Height = 195
          Align = alTop
          TabOrder = 1
          object dbgPesq: TDBGrid
            Left = 1
            Top = 1
            Width = 560
            Height = 193
            Align = alClient
            DataSource = dsAgenda
            TabOrder = 0
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -13
            TitleFont.Name = 'Tahoma'
            TitleFont.Style = []
            OnCellClick = dbgPesqCellClick
            Columns = <
              item
                Expanded = False
                FieldName = 'id'
                Title.Caption = 'C'#243'digo'
                Width = 45
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'nome'
                Title.Caption = 'Nome'
                Width = 300
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'numero'
                Title.Caption = 'Telefone'
                Width = 150
                Visible = True
              end>
          end
        end
        object Panel3: TPanel
          Left = 0
          Top = 303
          Width = 568
          Height = 41
          Align = alBottom
          TabOrder = 2
          object btnAlterar: TButton
            Left = 24
            Top = 8
            Width = 75
            Height = 25
            Caption = 'Alterar'
            TabOrder = 0
            OnClick = btnAlterarClick
          end
          object btnExcluir: TButton
            Left = 121
            Top = 8
            Width = 75
            Height = 25
            Caption = 'Excluir'
            TabOrder = 1
            OnClick = btnExcluirClick
          end
        end
      end
      object tsCadastrar: TTabSheet
        Caption = 'Cadastrar'
        ImageIndex = 1
        object pnl2: TPanel
          Left = 0
          Top = 0
          Width = 568
          Height = 153
          Align = alTop
          TabOrder = 0
          object Label1: TLabel
            Left = 45
            Top = 16
            Width = 38
            Height = 16
            Caption = 'Nome:'
          end
          object Label2: TLabel
            Left = 28
            Top = 79
            Width = 55
            Height = 16
            Caption = 'Telefone:'
          end
          object Label3: TLabel
            Left = 39
            Top = 51
            Width = 44
            Height = 16
            Caption = 'Idadde:'
          end
          object edtNome: TEdit
            Left = 88
            Top = 13
            Width = 417
            Height = 24
            CharCase = ecUpperCase
            MaxLength = 100
            TabOrder = 0
            Text = 'EDTNOME'
            OnExit = edtNomeExit
          end
          object edtTelefone: TEdit
            Left = 89
            Top = 75
            Width = 121
            Height = 24
            MaxLength = 14
            TabOrder = 2
            Text = 'edtNome'
            OnExit = edtTelefoneExit
          end
          object seIdade: TSpinEdit
            Left = 88
            Top = 43
            Width = 49
            Height = 26
            MaxValue = 0
            MinValue = 0
            TabOrder = 1
            Value = 0
          end
        end
        object Panel2: TPanel
          Left = 0
          Top = 303
          Width = 568
          Height = 41
          Align = alBottom
          TabOrder = 1
          object btnIncluir: TButton
            Left = 28
            Top = 8
            Width = 75
            Height = 25
            Caption = 'Incluir'
            TabOrder = 0
            OnClick = btnIncluirClick
          end
          object btnSalvar: TButton
            Left = 121
            Top = 8
            Width = 75
            Height = 25
            Caption = 'Salvar'
            TabOrder = 1
            OnClick = btnSalvarClick
          end
        end
      end
    end
  end
  object dsAgenda: TDataSource
    DataSet = cdsAgenda
    Left = 280
    Top = 304
  end
  object cdsAgenda: TClientDataSet
    Aggregates = <>
    Params = <>
    AfterScroll = cdsAgendaAfterScroll
    Left = 336
    Top = 304
  end
end
