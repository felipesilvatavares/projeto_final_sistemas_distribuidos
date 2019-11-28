unit UDao;

interface

uses
  UDm, UParametrosBanco, System.SysUtils, Uni, UniProvider, MySQLUniProvider,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Phys.MySQLDef, FireDAC.Phys.MySQL, UCadastroAgenda, Vcl.Forms,
  Winapi.Windows, dxmdaset;

type
  TDao = class
  public
    function RetornaConexaoBanco : TFDConnection;
    function InserirRegistro(CadastroAgenda: TCadastroAgenda) : Boolean;
    function CarregarRegistros: TdxMemData;
    procedure RemoverRegistro(IdRegistro : Integer);
    procedure EditarRegistro(CadastroAgenda: TCadastroAgenda);
    function ConexaoServidorAtiva(DadoConexao: TDadosConexaoBanco) : Boolean;
  private
    function RetornaStringConexaoUtilizada : string;
    function StringConexaoFormatada(DadoConexao: TDadosConexaoBanco) : string;
  end;

implementation

{ TDao }

function TDao.RetornaStringConexaoUtilizada : string;
var
  Retorno : string;
  DadoConexao: TDadosConexaoBanco;
begin
  try
    Retorno := '';

    for DadoConexao in Dm.ListaStringConexoes do
    begin
      if ConexaoServidorAtiva(DadoConexao) then
      begin
        Retorno := StringConexaoFormatada(DadoConexao);

        break;
      end;
    end;
  finally
    Result := Retorno;
  end;
end;

function TDao.StringConexaoFormatada(DadoConexao: TDadosConexaoBanco): string;
var
  StrB: TStringBuilder;
begin
  try
    StrB := TStringBuilder.Create;

    StrB.
    Append('DriverID="MySQL";Server=').Append(DadoConexao.Servidor).
    Append(';Port=').Append(DadoConexao.Porta).
    Append(';Database=').Append(DadoConexao.NomeBanco).
    Append(';User_name=').Append(DadoConexao.Login).
    Append(';Password=').Append(DadoConexao.Senha);
  finally
    Result := StrB.ToString();

    FreeAndNil(StrB);
  end;
end;

function TDao.ConexaoServidorAtiva(DadoConexao: TDadosConexaoBanco) : Boolean;
var
  ConUnidac : TUniConnection;
  StrConexao : TStringBuilder;
begin
  try
    StrConexao := TStringBuilder.Create;

    ConUnidac:= TUniConnection.Create(nil);

    StrConexao.
    Append('Provider Name=mySQL;User ID=').Append(DadoConexao.Login).
    Append(';Password=').Append(DadoConexao.Senha).Append(';Connection Timeout=4;Data Source=').Append(DadoConexao.Servidor).
    Append(';Database=').Append(DadoConexao.NomeBanco).Append(';Port=').Append(StrToIntDef(DadoConexao.Porta, 0));

    ConUnidac.ConnectString := StrConexao.ToString;

    try
      ConUnidac.Connect;

      Result := True;

      ConUnidac.Disconnect;
    except
      on E: Exception do
      begin
        Result := False;
      end;
    end;
  finally
    FreeAndNil(ConUnidac);
    FreeAndNil(StrConexao);
  end;
end;

function TDao.RetornaConexaoBanco: TFDConnection;
var
  Conexao: TFDConnection;
  StringConexao : string;
begin
  try
    try
      Conexao := TFDConnection.Create(nil);

      StringConexao := RetornaStringConexaoUtilizada();

      if Trim(StringConexao) = '' then
      raise Exception.Create('String de conexão vazia');

      Conexao.ConnectionString := StringConexao;

      Conexao.Connected := True;
    except
      Application.MessageBox('Não foi possível estabelecer a conexão com nenhuma das 2 bases de dados disponíveis.',
      PChar(Application.Title), MB_OK + MB_ICONSTOP);

      FreeAndNil(Conexao);
    end;
  finally
    Result := Conexao;
  end;
end;

function TDao.InserirRegistro(CadastroAgenda: TCadastroAgenda) : Boolean;
var
 Conexao: TFDConnection;
 Qry: TFDQuery;
 Retorno : Boolean;
begin
  try
    Conexao := RetornaConexaoBanco();

    if Conexao = nil then
    begin
      Retorno := False;

      Exit();
    end;

    try
      try
        Qry            := TFDQuery.Create(nil);
        Qry.Connection := Conexao;

        Qry.SQL.Text := 'INSERT INTO agenda (nome, email, telefone) VALUES (:nome, :email, :telefone)';

        Qry.Params.ParamByName('nome').AsString     := CadastroAgenda.Nome;
        Qry.Params.ParamByName('email').AsString    := CadastroAgenda.Email;
        Qry.Params.ParamByName('telefone').AsString := CadastroAgenda.Telefone;

        Qry.ExecSQL;

        Retorno := True;

        Application.MessageBox('Cadastro gravado com sucesso!!!',
        PChar(Application.Title), MB_OK + MB_ICONINFORMATION);
      except
        on E : Exception do
        begin
          Application.MessageBox(PChar('Ocorreu um erro ao inserir o registro no banco de dados.' +
          #13 + #13 + 'Erro Original: ' + E.Message), PChar(Application.Title), MB_OK + MB_ICONINFORMATION);
        end;
      end
    finally
      FreeAndNil(Conexao);
      FreeAndNil(Qry);
    end;
  finally
    Result := Retorno;
  end
end;

function TDao.CarregarRegistros: TdxMemData;
var
 Conexao: TFDConnection;
 Qry: TFDQuery;
 MemAgenda : TdxMemData;
begin
  Conexao := RetornaConexaoBanco();

  if Conexao = nil then
  begin
    Result := nil;

    Exit();
  end;

  try
    try
      MemAgenda := TdxMemData.Create(nil);

      Qry            := TFDQuery.Create(nil);
      Qry.Connection := Conexao;

      Qry.SQL.Text := 'SELECT * FROM agenda';

      Qry.Open;

      MemAgenda.LoadFromDataSet(Qry);
    except
      on E : Exception do
      begin
        Application.MessageBox(PChar('Ocorreu um erro ao carregar os registros do banco de dados.' +
        #13 + #13 + 'Erro Original: ' + E.Message), PChar(Application.Title), MB_OK + MB_ICONINFORMATION);
      end;
    end
  finally
    FreeAndNil(Conexao);
    FreeAndNil(Qry);

    Result := MemAgenda;
  end;
end;

procedure TDao.RemoverRegistro(IdRegistro : Integer);
var
 Conexao: TFDConnection;
 Qry: TFDQuery;
begin
  Conexao := RetornaConexaoBanco();

  if Conexao = nil then
    Exit();

  try
    try
      Qry            := TFDQuery.Create(nil);
      Qry.Connection := Conexao;

      Qry.SQL.Text := 'DELETE FROM agenda WHERE id = :id';

      Qry.Params.ParamByName('id').AsInteger := IdRegistro;

      Qry.ExecSQL;

      Application.MessageBox('Cadastro removido com sucesso!!!',
      PChar(Application.Title), MB_OK + MB_ICONINFORMATION);
    except
      on E : Exception do
      begin
        Application.MessageBox(PChar('Ocorreu um erro ao remover o registro no banco de dados.' +
        #13 + #13 + 'Erro Original: ' + E.Message), PChar(Application.Title), MB_OK + MB_ICONINFORMATION);
      end;
    end
  finally
    FreeAndNil(Conexao);
    FreeAndNil(Qry);
  end;
end;

procedure TDao.EditarRegistro(CadastroAgenda: TCadastroAgenda);
var
 Conexao: TFDConnection;
 Qry: TFDQuery;
begin
  Conexao := RetornaConexaoBanco();

  if Conexao = nil then
    Exit();

  try
    try
      Qry            := TFDQuery.Create(nil);
      Qry.Connection := Conexao;

      Qry.SQL.Text := 'UPDATE agenda SET nome = :nome, email = :email, telefone = :telefone WHERE id = :id';

      Qry.Params.ParamByName('id').AsString       := CadastroAgenda.IdAgenda;
      Qry.Params.ParamByName('nome').AsString     := CadastroAgenda.Nome;
      Qry.Params.ParamByName('email').AsString    := CadastroAgenda.Email;
      Qry.Params.ParamByName('telefone').AsString := CadastroAgenda.Telefone;

      Qry.ExecSQL;

      Application.MessageBox('Cadastro editado com sucesso!!!',
      PChar(Application.Title), MB_OK + MB_ICONINFORMATION);
    except
      on E : Exception do
      begin
        Application.MessageBox(PChar('Ocorreu um erro ao atualizar o registro no banco de dados.' +
        #13 + #13 + 'Erro Original: ' + E.Message), PChar(Application.Title), MB_OK + MB_ICONINFORMATION);
      end;
    end
  finally
    FreeAndNil(Conexao);
    FreeAndNil(Qry);
  end;
end;

end.
