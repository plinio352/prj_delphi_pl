unit UfrmAgenda;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls,
  Vcl.ComCtrls, Data.DB, Datasnap.DBClient, UInterface.Contato, Controller.Contato,
  Controller.Telefone, UInterface.Telefone, Vcl.Samples.Spin;

type
  TfrmAgenda = class(TForm)
    pn1: TPanel;
    pgAgenda: TPageControl;
    tsConsultar: TTabSheet;
    tsCadastrar: TTabSheet;
    Panel1: TPanel;
    rgCampo: TRadioGroup;
    grPesq: TGroupBox;
    edtPesq: TEdit;
    pnl1: TPanel;
    dbgPesq: TDBGrid;
    pnl2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    edtNome: TEdit;
    edtTelefone: TEdit;
    Panel2: TPanel;
    btnIncluir: TButton;
    btnSalvar: TButton;
    Panel3: TPanel;
    btnAlterar: TButton;
    btnExcluir: TButton;
    dsAgenda: TDataSource;
    cdsAgenda: TClientDataSet;
    seIdade: TSpinEdit;
    Label3: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure edtNomeExit(Sender: TObject);
    procedure edtTelefoneExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cdsAgendaAfterScroll(DataSet: TDataSet);
    procedure dbgPesqCellClick(Column: TColumn);
    procedure btnExcluirClick(Sender: TObject);
    procedure edtPesqChange(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
  private
    { Private declarations }
    operacao: TOperacao;
    CtrContato: IContatoInterface;
    CtrTelefone: ITelefoneInterface;
    procedure Limpar;
    procedure AbrirCds;
    function Vazio(AEdit: TEdit): Boolean;
    procedure SetCampo;
    procedure Painel(const AValue: Boolean);
  public
    { Public declarations }
  end;

var
  frmAgenda: TfrmAgenda;

implementation

uses
  UModel.Contato, UModel.Telefone;

{$R *.dfm}

{ TfrmAgenda }

procedure TfrmAgenda.AbrirCds;
begin
  CtrContato.List(cdsAgenda);
end;

procedure TfrmAgenda.btnAlterarClick(Sender: TObject);
begin
  pgAgenda.TabIndex := 1;
  Painel(True);
  btnSalvar.Enabled   := True;
  btnIncluir.Enabled  := False;
  operacao := opAlaterar;
  edtNome.SetFocus;

end;

procedure TfrmAgenda.btnExcluirClick(Sender: TObject);
begin
  If MessageDlg('Confirmar exclusão?', mtConfirmation, mbOkCancel, 0) = ID_OK then
  begin
    if cdsAgenda.FieldByName('numero').AsString <> EmptyStr then
      CtrTelefone.Remove(cdsAgenda.FieldByName('telefone_id').AsInteger)
    else
      CtrContato.Remove(cdsAgenda.FieldByName('id').AsInteger);

    AbrirCds;
    Limpar;
    Painel(False);
  end;

end;

procedure TfrmAgenda.btnIncluirClick(Sender: TObject);
begin
  Painel(True);
  btnSalvar.Enabled := True;
  operacao := opIincluir;
  edtNome.SetFocus;

end;

procedure TfrmAgenda.btnSalvarClick(Sender: TObject);
var
  ObjCto: TContatoModel;
begin
  if Vazio(edtNome) then
  begin
    ShowMessage('Campo "Nome" vazio.');
    edtNome.SetFocus;
    Exit;
  end;

  if Vazio(edtTelefone) then
  begin
    ShowMessage('Campo "Telefone" vazio.');
    edtTelefone.SetFocus;
    Exit;
  end;

  case operacao of
    opIincluir: begin
      ObjCto := CtrContato.Find(edtNome.Text);
      if ObjCto.id <> 0 then
      begin
        ObjCto.telefone := CtrTelefone.Find(edtTelefone.Text);
        if ObjCto.telefone.id <> 0 then
        begin
          ObjCto.telefone.numero := edtTelefone.Text;
          CtrTelefone.Update(ObjCto.telefone);
        end
        else
        begin
          ObjCto.telefone.numero    := edtTelefone.Text;
          ObjCto.telefone.idcontato := ObjCto.id;
          CtrTelefone.Add(ObjCto.telefone);

        end;
      end
      else
      begin
          ObjCto.nome  := edtNome.Text;
          ObjCto.idade := seIdade.Value;
          CtrContato.Add(ObjCto);

          ObjCto.telefone.numero    := edtTelefone.Text;
          ObjCto.telefone.idcontato := ObjCto.id;
          CtrTelefone.Add(ObjCto.telefone);

      end;

    end;
    opAlaterar: begin
      ObjCto := CtrContato.Find(edtNome.Text);
      ObjCto.id     := cdsAgenda.FieldByName('id').AsFloat;
      ObjCto.nome   := edtNome.Text;
      ObjCto.idade  := seIdade.Value;
      CtrContato.Update(ObjCto);

      ObjCto.telefone.numero    := edtTelefone.Text;
      ObjCto.telefone.idcontato := ObjCto.id;
      ObjCto.telefone.id        := cdsAgenda.FieldByName('telefone_id').AsFloat;
      CtrTelefone.Update(ObjCto.telefone);
    end;
  end;

  AbrirCds;
  Limpar;
  Painel(False);

end;

procedure TfrmAgenda.cdsAgendaAfterScroll(DataSet: TDataSet);
begin
  SetCampo;
end;

procedure TfrmAgenda.dbgPesqCellClick(Column: TColumn);
begin
  SetCampo;
end;

procedure TfrmAgenda.edtNomeExit(Sender: TObject);
begin
  if Vazio(TEdit(Sender)) then
    ShowMessage('Campo vazio.');
end;

procedure TfrmAgenda.edtPesqChange(Sender: TObject);
begin
  if Length(Trim(edtPesq.Text)) > 2 then
  begin
    case rgCampo.ItemIndex of
      0: begin
        cdsAgenda.Locate('nome', Trim(edtPesq.Text), [loCaseInsensitive, loPartialKey]);
      end;
      1: begin
        cdsAgenda.Locate('numero', Trim(edtPesq.Text), [loCaseInsensitive, loPartialKey]);
      end;
    end;
  end;

end;

procedure TfrmAgenda.edtTelefoneExit(Sender: TObject);
begin
  if Vazio(TEdit(Sender)) then
    ShowMessage('Campo vazio.')
  else
    if btnSalvar.Enabled then
      btnSalvar.SetFocus;

end;

procedure TfrmAgenda.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmAgenda.FormCreate(Sender: TObject);
begin
  CtrContato  := TContatoController.New;
  CtrTelefone := TTelefoneController.New;
end;

procedure TfrmAgenda.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    vk_return:
    begin
      Perform(Wm_NextDlgCtl,0,0);
    end;
  end;

end;

procedure TfrmAgenda.FormShow(Sender: TObject);
begin
  Painel(False);
  Limpar;
  AbrirCds;
end;

procedure TfrmAgenda.Limpar;
var
  I: Integer;
  ObjCto: TContatoModel;
begin
  pgAgenda.TabIndex := 0;
  rgCampo.ItemIndex := 0;
  seIdade.Value     := 1;

  btnIncluir.Enabled  := True;
  btnSalvar.Enabled   := False;
  btnAlterar.Enabled  := True;
  btnExcluir.Enabled  := True;


  for I := 0 to Pred(ComponentCount) do
  begin
    if Components[I] is TEdit then
      TEdit(Components[I]).Clear;
  end;

end;

procedure TfrmAgenda.Painel(const AValue: Boolean);
begin
  edtNome.Enabled := AValue;
  seIdade.Enabled := AValue;
  edtTelefone.Enabled := AValue;
end;

procedure TfrmAgenda.SetCampo;
begin
  edtNome.Text      := cdsAgenda.FieldByName('nome').AsString;
  seIdade.Value     := cdsAgenda.FieldByName('idade').AsInteger;
  edtTelefone.Text  := cdsAgenda.FieldByName('numero').AsString;
end;

function TfrmAgenda.Vazio(AEdit: TEdit): Boolean;
begin
  Result := False;
  if AEdit.Text = EmptyStr then
    Result := True;
end;

end.
