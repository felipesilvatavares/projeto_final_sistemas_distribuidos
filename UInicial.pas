unit UInicial;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, UConfiguracaoBancoDados,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles,
  dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
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
  dxSkinXmas2008Blue, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxNavigator, Data.DB, cxDBData, cxGridLevel,
  cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, cxContainer, Vcl.StdCtrls, cxButtons,
  cxTextEdit, cxLabel, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Phys.MySQLDef,
  FireDAC.Phys.MySQL, UDao, UCadastroAgenda, dxmdaset, cxMaskEdit,
  dxGDIPlusClasses, cxImage;

type
  TFrmInicial = class(TForm)
    MenuPrincipal: TMainMenu;
    Parmetros1: TMenuItem;
    ParmetrosdeConexoBanco1: TMenuItem;
    GrdAgendaDBTableView1: TcxGridDBTableView;
    GrdAgendaLevel1: TcxGridLevel;
    GrdAgenda: TcxGrid;
    EdtNome: TcxTextEdit;
    EdtEmail: TcxTextEdit;
    BtnGravar: TcxButton;
    ColNome: TcxGridDBColumn;
    ColEmail: TcxGridDBColumn;
    ColTelefone: TcxGridDBColumn;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    Ds: TDataSource;
    Qry: TFDQuery;
    BtnRemover: TcxButton;
    BtnEditar: TcxButton;
    BtnCarregarGrid: TcxButton;
    MemAgenda: TdxMemData;
    EdtIdAgenda: TcxTextEdit;
    EdtTelefone: TcxMaskEdit;
    cxLabel4: TcxLabel;
    cxImage1: TcxImage;
    procedure ParmetrosdeConexoBanco1Click(Sender: TObject);
    procedure BtnGravarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnCarregarGridClick(Sender: TObject);
    procedure BtnRemoverClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BtnEditarClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    procedure InicializaComponentes;
  public
    { Public declarations }
  end;

var
  FrmInicial: TFrmInicial;

implementation

uses
  UDm, UParametrosBanco;

{$R *.dfm}


procedure TFrmInicial.BtnCarregarGridClick(Sender: TObject);
var
  Dao : TDao;
begin
  try
    BtnCarregarGrid.Enabled := False;

    Dao := TDao.Create;

    Ds.DataSet := Dao.CarregarRegistros();

    if Ds.DataSet <> nil then
    if Ds.DataSet.IsEmpty then
    begin
      Application.MessageBox('Não foram encontrados registros no servidor.',
      PChar(Application.Title), MB_OK + MB_ICONWARNING);
    end;
  finally
    FreeAndNil(Dao);

    BtnCarregarGrid.Enabled := True;
  end;
end;

procedure TFrmInicial.BtnEditarClick(Sender: TObject);
var
  Dao : TDao;
  CadastroAgenda : TCadastroAgenda;
begin
  if Ds.DataSet = nil then
  begin
    Application.MessageBox('Selecione um registro para edição.',
    PChar(Application.Title), MB_OK + MB_ICONWARNING);

    Exit();
  end;

  if Ds.DataSet.IsEmpty then
  begin
    Application.MessageBox('Selecione um registro para edição.',
    PChar(Application.Title), MB_OK + MB_ICONWARNING);

    Exit();
  end;

  if BtnEditar.Caption = 'Editar' then
  begin
    BtnEditar.Caption := 'Salvar Edição';

    BtnGravar.Enabled       := False;
    BtnRemover.Enabled      := False;
    BtnCarregarGrid.Enabled := False;

    EdtIdAgenda.Text := Ds.DataSet.FieldByName('id').AsString;
    EdtNome.Text     := Ds.DataSet.FieldByName('nome').AsString;
    EdtEmail.Text    := Ds.DataSet.FieldByName('email').AsString;
    EdtTelefone.Text := Ds.DataSet.FieldByName('telefone').AsString;

    EdtNome.SetFocus;

    Exit();
  end;

  try
    Dao := TDao.Create;

    CadastroAgenda := TCadastroAgenda.Create;

    CadastroAgenda.IdAgenda  := EdtIdAgenda.Text;
    CadastroAgenda.Nome      := EdtNome.Text;
    CadastroAgenda.Email     := EdtEmail.Text;
    CadastroAgenda.Telefone  := EdtTelefone.Text;

    Dao.EditarRegistro(CadastroAgenda);

    BtnCarregarGrid.Click;
  finally
    FreeAndNil(Dao);
    FreeAndNil(CadastroAgenda);

    BtnGravar.Enabled       := True;
    BtnRemover.Enabled      := True;
    BtnCarregarGrid.Enabled := True;
    BtnEditar.Caption       := 'Editar';

    EdtIdAgenda.Clear;
    EdtNome.Clear;
    EdtEmail.Clear;
    EdtTelefone.Clear;
  end;
end;

procedure TFrmInicial.BtnGravarClick(Sender: TObject);
var
  Dao : TDao;
  CadastroAgenda : TCadastroAgenda;
begin
  if Trim(EdtNome.Text) = '' then
  begin
    Application.MessageBox('Informe corretamente o campo nome.',PChar(Application.Title), MB_OK + MB_ICONWARNING);

    EdtNome.SetFocus;

    Exit();
  end;

  if Trim(EdtEmail.Text) = '' then
  begin
    Application.MessageBox('Informe corretamente o campo e-mail.',PChar(Application.Title), MB_OK + MB_ICONWARNING);

    EdtEmail.SetFocus;

    Exit();
  end;

  if Trim(EdtTelefone.Text) = '' then
  begin
    Application.MessageBox('Informe corretamente o campo telefone.',PChar(Application.Title), MB_OK + MB_ICONWARNING);

    EdtTelefone.SetFocus;

    Exit();
  end;

  try
    BtnGravar.Enabled := False;

    Dao := TDao.Create;

    CadastroAgenda := TCadastroAgenda.Create;

    CadastroAgenda.Nome     := EdtNome.Text;
    CadastroAgenda.Email    := EdtEmail.Text;
    CadastroAgenda.Telefone := EdtTelefone.Text;

    if not Dao.InserirRegistro(CadastroAgenda) then
      Exit();

    EdtIdAgenda.Clear;
    EdtNome.Clear;
    EdtEmail.Clear;
    EdtTelefone.Clear;

    BtnCarregarGrid.Click;
  finally
    FreeAndNil(Dao);
    FreeAndNil(CadastroAgenda);

    BtnGravar.Enabled := True;
  end;
end;

procedure TFrmInicial.BtnRemoverClick(Sender: TObject);
var
  Dao : TDao;
  CadastroAgenda : TCadastroAgenda;
begin
  if Ds.DataSet = nil then
  begin
    Application.MessageBox('Selecione um registro para remoção.',
    PChar(Application.Title), MB_OK + MB_ICONWARNING);

    Exit();
  end;

  if Ds.DataSet.IsEmpty then
  begin
    Application.MessageBox('Selecione um registro para remoção.',
    PChar(Application.Title), MB_OK + MB_ICONWARNING);

    Exit();
  end;

  if
    Application.MessageBox('Deseja remover o registro selecionado?',
    PChar(Application.Title), MB_YESNO + MB_ICONQUESTION) = IDNO
  then
    Exit();

  try
    BtnRemover.Enabled := False;

    Dao := TDao.Create;

    Dao.RemoverRegistro(Ds.DataSet.FieldByName('id').AsInteger);

    BtnCarregarGrid.Click;
  finally
    FreeAndNil(Dao);

    BtnRemover.Enabled := True;
  end;
end;

procedure TFrmInicial.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    if
      Application.MessageBox('Deseja encerrar a aplicação?',
      PChar(Application.Title), MB_YESNO + MB_ICONQUESTION) = IDNO
    then
      Exit();

    Close();
  end;
end;

procedure TFrmInicial.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  SelectNext(ActiveControl, True, True);
end;

procedure TFrmInicial.FormShow(Sender: TObject);
begin
  InicializaComponentes();
end;

procedure TFrmInicial.InicializaComponentes;
var
  ParametrosBanco: TParametrosBanco;
begin
  try
    ParametrosBanco := TParametrosBanco.Create;

    Dm.ListaStringConexoes := ParametrosBanco.RetornaArquivoConfig();
  finally
    FreeAndNil(ParametrosBanco);
  end;

  GrdAgendaDBTableView1.OptionsView.NoDataToDisplayInfoText := '';

  EdtNome.SetFocus;
end;

procedure TFrmInicial.ParmetrosdeConexoBanco1Click(Sender: TObject);
begin
  try
    Application.CreateForm(TFrmConfiguracaoBancoDados, FrmConfiguracaoBancoDados);
    FrmConfiguracaoBancoDados.ShowModal;
  finally
    FreeAndNil(FrmConfiguracaoBancoDados);
  end;
end;

end.
