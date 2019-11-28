unit UCadastroAgenda;

interface

type
  TCadastroAgenda = class
  public
  private
    FEmail: string;
    FNome: string;
    FTelefone: string;
    FIdAgenda: string;
  published
    property IdAgenda : string read FIdAgenda write FIdAgenda;
    property Nome : string read FNome write FNome;
    property Email : string read FEmail write FEmail;
    property Telefone : string read FTelefone write FTelefone;
  end;

implementation

end.
