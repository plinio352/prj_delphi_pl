program Agenda;

uses
  Vcl.Forms,
  UfrmAgenda in 'UfrmAgenda.pas' {frmAgenda},
  UDM in 'UDM.pas' {DM: TDataModule},
  UModel.Contato in 'UModel.Contato.pas',
  UModel.Telefone in 'UModel.Telefone.pas',
  DAO.Contato in 'DAO.Contato.pas',
  DAO.Telefone in 'DAO.Telefone.pas',
  UInterface.Contato in 'UInterface.Contato.pas',
  Controller.Contato in 'Controller.Contato.pas',
  UInterface.Telefone in 'UInterface.Telefone.pas',
  Controller.Telefone in 'Controller.Telefone.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TfrmAgenda, frmAgenda);
  Application.Run;
end.
