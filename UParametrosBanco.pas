unit UParametrosBanco;

interface

uses IniFiles, Vcl.Forms, System.SysUtils;

type
  TDadosConexaoBanco = class
  private
    FServidor: string;
    FNomeBanco: string;
    FLogin: string;
    FSenha: string;
    FPorta: string;
  published
    property Servidor : string read FServidor write FServidor;
    property NomeBanco : string read FNomeBanco write FNomeBanco;
    property Login : string read FLogin write FLogin;
    property Senha : string read FSenha write FSenha;
    property Porta : string read FPorta write FPorta;
  end;

  TParametrosBanco = class
  public
    function RetornaArquivoConfig : TArray<TDadosConexaoBanco>;
  end;

implementation

{ TParametrosBanco }

function TParametrosBanco.RetornaArquivoConfig : TArray<TDadosConexaoBanco>;
var
  ArquivoINI  : TIniFile;
  ConexaoAmazon,
  ConexaoAzure : TDadosConexaoBanco;
begin
  try
    SetLength(Result, 2);

    ConexaoAmazon := TDadosConexaoBanco.Create;
    ConexaoAzure  := TDadosConexaoBanco.Create;

    ArquivoINI := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'config_banco.ini');

    with TIniFile.Create(ExtractFilePath(Application.ExeName) + 'config_banco.ini') do
    begin
      try
        ConexaoAmazon.Servidor  := ReadString('BANCO_AMAZON','Servidor','');
        ConexaoAmazon.NomeBanco := ReadString('BANCO_AMAZON','NomeBanco','');
        ConexaoAmazon.Porta     := ReadString('BANCO_AMAZON','Porta','');
        ConexaoAmazon.Login     := ReadString('BANCO_AMAZON','UsuarioBD','');
        ConexaoAmazon.Senha     := ReadString('BANCO_AMAZON','SenhaBD','');

        ConexaoAzure.Servidor  := ReadString('BANCO_AZURE','Servidor','');
        ConexaoAzure.NomeBanco := ReadString('BANCO_AZURE','NomeBanco','');
        ConexaoAzure.Porta     := ReadString('BANCO_AZURE','Porta','');
        ConexaoAzure.Login     := ReadString('BANCO_AZURE','UsuarioBD','');
        ConexaoAzure.Senha     := ReadString('BANCO_AZURE','SenhaBD','');

        Result[0] := ConexaoAmazon;
        Result[1] := ConexaoAzure;
      finally
        Free;
      end;
    end;
  finally
    FreeAndNil(ArquivoINI);
  end;
end;

end.
