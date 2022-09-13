unit UModel.Contato;

interface

uses
  UModel.Telefone, System.SysUtils;

type
  TContatoModel = class
  private
    Fid: Double;
    Fidade: Double;
    Fnome: string;
    Ftelefone: TTelefoneModel;
    procedure Setid(const Value: Double);
    procedure Setidade(const Value: Double);
    procedure Setnome(const Value: string);
    procedure Settelefone(const Value: TTelefoneModel);
  public
    constructor Create;
    destructor Destroy;override;

    property id: Double read Fid write Setid;
    property nome: string read Fnome write Setnome;
    property idade: Double read Fidade write Setidade;
    property telefone: TTelefoneModel read Ftelefone write Settelefone;
  end;

implementation

{ TContatoModel }

constructor TContatoModel.Create;
begin
  inherited;
  Self.Ftelefone := TTelefoneModel.Create;
end;

destructor TContatoModel.Destroy;
begin
  FreeAndNil(Self.Ftelefone);
  inherited;
end;

procedure TContatoModel.Setid(const Value: Double);
begin
  Fid := Value;
end;

procedure TContatoModel.Setidade(const Value: Double);
begin
  Fidade := Value;
end;

procedure TContatoModel.Setnome(const Value: string);
begin
  Fnome := Value;
end;

procedure TContatoModel.Settelefone(const Value: TTelefoneModel);
begin
  Ftelefone := Value;
end;

end.
