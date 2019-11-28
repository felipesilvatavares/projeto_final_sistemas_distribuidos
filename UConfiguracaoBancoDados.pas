unit UConfiguracaoBancoDados;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans,
  dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky,
  dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMetropolis,
  dxSkinMetropolisDark, dxSkinMoneyTwins, dxSkinOffice2007Black,
  dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink,
  dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinOffice2013DarkGray,
  dxSkinOffice2013LightGray, dxSkinOffice2013White,
  dxSkinOffice2016Colorful, dxSkinOffice2016Dark, dxSkinPumpkin,
  dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinsDefaultPainters, dxSkinValentine,
  dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, cxGroupBox, cxLabel, cxTextEdit, cxMaskEdit,
  Vcl.Menus, Vcl.StdCtrls, cxButtons, dxGDIPlusClasses, cxImage, IniFiles,
  UParametrosBanco, UDao;

type
  TFrmConfiguracaoBancoDados = class(TForm)
    GrpServidorA: TcxGroupBox;
    EdtPortaAzure: TcxMaskEdit;
    EdtServidorAzure: TcxTextEdit;
    cxLabel1: TcxLabel;
    EdtLoginAzure: TcxTextEdit;
    EdtSenhaAzure: TcxTextEdit;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    GrpServidorB: TcxGroupBox;
    EdtPortaAmazon: TcxMaskEdit;
    EdtServidorAmazon: TcxTextEdit;
    cxLabel5: TcxLabel;
    EdtLoginAmazon: TcxTextEdit;
    EdtSenhaAmazon: TcxTextEdit;
    cxLabel6: TcxLabel;
    cxLabel7: TcxLabel;
    cxLabel8: TcxLabel;
    BtnGravarConfiguracao: TcxButton;
    BtnTestarConexaoAmazon: TcxButton;
    BtnTestarConexaoAzure: TcxButton;
    cxImage1: TcxImage;
    cxImage2: TcxImage;
    EdtBancoAzure: TcxTextEdit;
    cxLabel9: TcxLabel;
    EdtBancoAmazon: TcxTextEdit;
    cxLabel10: TcxLabel;
    procedure BtnGravarConfiguracaoClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure BtnTestarConexaoAzureClick(Sender: TObject);
    procedure BtnTestarConexaoAmazonClick(Sender: TObject);
  private
    { Private declarations }
    procedure LerArquivoIni;
  public
    { Public declarations }
  end;

var
  FrmConfiguracaoBancoDados: TFrmConfiguracaoBancoDados;

implementation

uses
  UDm;

{$R *.dfm}

procedure TFrmConfiguracaoBancoDados.BtnGravarConfiguracaoClick(Sender: TObject);
var
  ArquivoINI  : TIniFile;
  ParametrosBanco: TParametrosBanco;
begin
  try
    ParametrosBanco := TParametrosBanco.Create;

    ArquivoINI := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'config_banco.ini');

    with TIniFile.Create(ExtractFilePath(Application.ExeName) + 'config_banco.ini') do
    begin
      try
        WriteString('BANCO_AMAZON','Servidor',EdtServidorAmazon.Text);
        WriteString('BANCO_AMAZON','NomeBanco',EdtBancoAmazon.Text);
        WriteString('BANCO_AMAZON','Porta',EdtPortaAmazon.Text);
        WriteString('BANCO_AMAZON','UsuarioBD',EdtLoginAmazon.Text);
        WriteString('BANCO_AMAZON','SenhaBD',EdtSenhaAmazon.Text);

        WriteString('BANCO_AZURE','Servidor',EdtServidorAzure.Text);
        WriteString('BANCO_AZURE','NomeBanco',EdtBancoAzure.Text);
        WriteString('BANCO_AZURE','Porta',EdtPortaAzure.Text);
        WriteString('BANCO_AZURE','UsuarioBD',EdtLoginAzure.Text);
        WriteString('BANCO_AZURE','SenhaBD',EdtSenhaAzure.Text);
      finally
        Free;
      end;
    end;

    Dm.ListaStringConexoes := ParametrosBanco.RetornaArquivoConfig();
  finally
    FreeAndNil(ArquivoINI);
  end;

  Application.MessageBox('Parâmetro de configuração salvo com sucesso!!!',
  PChar(Application.Title), MB_OK + MB_ICONINFORMATION);

  Close();
end;

procedure TFrmConfiguracaoBancoDados.BtnTestarConexaoAmazonClick(Sender: TObject);
var
  Dao : TDao;
  DadoConexao: TDadosConexaoBanco;
begin
  if Trim(EdtServidorAmazon.Text) = '' then
  begin
    Application.MessageBox('Informe o endereço do servidor AMAZOM AWS.',
    PChar(Application.Title), MB_OK + MB_ICONWARNING);

    EdtServidorAmazon.SetFocus;

    Exit();
  end;

  if Trim(EdtBancoAmazon.Text) = '' then
  begin
    Application.MessageBox('Informe o nome do banco AMAZOM AWS.',
    PChar(Application.Title), MB_OK + MB_ICONWARNING);

    EdtBancoAmazon.SetFocus;

    Exit();
  end;

  if Trim(EdtLoginAmazon.Text) = '' then
  begin
    Application.MessageBox('Informe o nome de usuário do banco AMAZOM AWS.',
    PChar(Application.Title), MB_OK + MB_ICONWARNING);

    EdtLoginAmazon.SetFocus;

    Exit();
  end;

  if Trim(EdtSenhaAmazon.Text) = '' then
  begin
    Application.MessageBox('Informe a senha de usuário do banco AMAZOM AWS.',
    PChar(Application.Title), MB_OK + MB_ICONWARNING);

    EdtSenhaAmazon.SetFocus;

    Exit();
  end;

  if Trim(EdtPortaAmazon.Text) = '' then
  begin
    Application.MessageBox('Informe a porta de acesso do banco AMAZOM AWS.',
    PChar(Application.Title), MB_OK + MB_ICONWARNING);

    EdtPortaAmazon.SetFocus;

    Exit();
  end;

  try
    BtnTestarConexaoAmazon.Enabled := False;

    Dao := TDao.Create;

    DadoConexao := TDadosConexaoBanco.Create;

    DadoConexao.Servidor  := EdtServidorAmazon.Text;
    DadoConexao.NomeBanco := EdtBancoAmazon.Text;
    DadoConexao.Login     := EdtLoginAmazon.Text;
    DadoConexao.Senha     := EdtSenhaAmazon.Text;
    DadoConexao.Porta     := EdtPortaAmazon.Text;

    if Dao.ConexaoServidorAtiva(DadoConexao) then
    begin
      Application.MessageBox('Conexão com o AMAZOM AWS estabelecida com sucesso!!!',
      PChar(Application.Title), MB_OK + MB_ICONINFORMATION);
    end
    else
    begin
      Application.MessageBox('Conexão com o AMAZOM AWS falhou.',
      PChar(Application.Title), MB_OK + MB_ICONERROR);
    end;
  finally
    FreeAndNil(Dao);
    FreeAndNil(DadoConexao);

    BtnTestarConexaoAmazon.Enabled := True;
  end;
end;

procedure TFrmConfiguracaoBancoDados.BtnTestarConexaoAzureClick(Sender: TObject);
var
  Dao : TDao;
  DadoConexao: TDadosConexaoBanco;
begin
  if Trim(EdtServidorAzure.Text) = '' then
  begin
    Application.MessageBox('Informe o endereço do servidor AZURE.',
    PChar(Application.Title), MB_OK + MB_ICONWARNING);

    EdtServidorAzure.SetFocus;

    Exit();
  end;

  if Trim(EdtBancoAzure.Text) = '' then
  begin
    Application.MessageBox('Informe o nome do banco AZURE.',
    PChar(Application.Title), MB_OK + MB_ICONWARNING);

    EdtBancoAzure.SetFocus;

    Exit();
  end;

  if Trim(EdtLoginAzure.Text) = '' then
  begin
    Application.MessageBox('Informe o nome de usuário do banco AZURE.',
    PChar(Application.Title), MB_OK + MB_ICONWARNING);

    EdtLoginAzure.SetFocus;

    Exit();
  end;

  if Trim(EdtSenhaAzure.Text) = '' then
  begin
    Application.MessageBox('Informe a senha de usuário do banco AZURE.',
    PChar(Application.Title), MB_OK + MB_ICONWARNING);

    EdtSenhaAzure.SetFocus;

    Exit();
  end;

  if Trim(EdtPortaAzure.Text) = '' then
  begin
    Application.MessageBox('Informe a porta de acesso do banco AZURE.',
    PChar(Application.Title), MB_OK + MB_ICONWARNING);

    EdtPortaAzure.SetFocus;

    Exit();
  end;

  try
    BtnTestarConexaoAzure.Enabled := False;

    Dao := TDao.Create;

    DadoConexao := TDadosConexaoBanco.Create;

    DadoConexao.Servidor  := EdtServidorAzure.Text;
    DadoConexao.NomeBanco := EdtBancoAzure.Text;
    DadoConexao.Login     := EdtLoginAzure.Text;
    DadoConexao.Senha     := EdtSenhaAzure.Text;
    DadoConexao.Porta     := EdtPortaAzure.Text;

    if Dao.ConexaoServidorAtiva(DadoConexao) then
    begin
      Application.MessageBox('Conexão com o AZURE estabelecida com sucesso!!!',
      PChar(Application.Title), MB_OK + MB_ICONINFORMATION);
    end
    else
    begin
      Application.MessageBox('Conexão com o AZURE falhou.',
      PChar(Application.Title), MB_OK + MB_ICONERROR);
    end;
  finally
    FreeAndNil(Dao);
    FreeAndNil(DadoConexao);

    BtnTestarConexaoAzure.Enabled := True;
  end;
end;

procedure TFrmConfiguracaoBancoDados.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    SelectNext(ActiveControl, True, True);
end;

procedure TFrmConfiguracaoBancoDados.FormShow(Sender: TObject);
begin
  LerArquivoIni();
end;

procedure TFrmConfiguracaoBancoDados.LerArquivoIni;
var
  ArquivoINI  : TIniFile;
begin
  try
    ArquivoINI := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'config_banco.ini');

    with TIniFile.Create(ExtractFilePath(Application.ExeName) + 'config_banco.ini') do
    begin
      try
        EdtServidorAmazon.Text := ReadString('BANCO_AMAZON','Servidor','');
        EdtBancoAmazon.Text    := ReadString('BANCO_AMAZON','NomeBanco','');
        EdtPortaAmazon.Text    := ReadString('BANCO_AMAZON','Porta','');
        EdtLoginAmazon.Text    := ReadString('BANCO_AMAZON','UsuarioBD','');
        EdtSenhaAmazon.Text    := ReadString('BANCO_AMAZON','SenhaBD','');

        EdtServidorAzure.Text  := ReadString('BANCO_AZURE','Servidor','');
        EdtBancoAzure.Text     := ReadString('BANCO_AZURE','NomeBanco','');
        EdtPortaAzure.Text     := ReadString('BANCO_AZURE','Porta','');
        EdtLoginAzure.Text     := ReadString('BANCO_AZURE','UsuarioBD','');
        EdtSenhaAzure.Text     := ReadString('BANCO_AZURE','SenhaBD','');
      finally
        Free;
      end;
    end;
  finally
    FreeAndNil(ArquivoINI);
  end;
end;

end.
