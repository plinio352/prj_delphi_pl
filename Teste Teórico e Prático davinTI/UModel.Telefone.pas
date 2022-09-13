unit UModel.Telefone;

interface

type
  TTelefoneModel = class
  private
    Fidcontato: Double;
    Fid: Double;
    Fnumero: string;
    procedure Setid(const Value: Double);
    procedure Setidcontato(const Value: Double);
    procedure Setnumero(const Value: string);
  public
    property id: Double read Fid write Setid;
    property idcontato: Double read Fidcontato write Setidcontato;
    property numero: string read Fnumero write Setnumero;
  end;

implementation

{ TTelefoneModel }

procedure TTelefoneModel.Setid(const Value: Double);
begin
  Fid := Value;
end;

procedure TTelefoneModel.Setidcontato(const Value: Double);
begin
  Fidcontato := Value;
end;

procedure TTelefoneModel.Setnumero(const Value: string);
begin
  Fnumero := Value;
end;

end.
