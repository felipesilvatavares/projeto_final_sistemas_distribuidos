program Agenda;

uses
  Vcl.Forms,
  UConfiguracaoBancoDados in 'UConfiguracaoBancoDados.pas' {FrmConfiguracaoBancoDados},
  UDao in 'UDao.pas',
  UInicial in 'UInicial.pas' {FrmInicial},
  UParametrosBanco in 'UParametrosBanco.pas',
  UDm in 'UDm.pas' {Dm: TDataModule},
  UCadastroAgenda in 'UCadastroAgenda.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmInicial, FrmInicial);
  Application.CreateForm(TDm, Dm);
  Application.Run;
end.
