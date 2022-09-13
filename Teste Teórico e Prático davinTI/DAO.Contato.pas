unit DAO.Contato;

interface

uses
  System.Classes, System.Generics.Collections, UModel.Contato,
  Data.DB, Data.SqlExpr, System.SysUtils;

type
  TContatoDao = class
  private
    FSQL: string;
    FExcessao: string;
    FCon: TSQLConnection;
    FCmd: TSQLQuery;

    procedure Log(const AValue: string);

  public
    constructor Create(PConexao: TSQLConnection);
    destructor Destroy; override;

    function Find(Id: integer): TContatoModel;overload;
    function Find(Desc: string): TContatoModel;overload;
    function List: Tlist<TContatoModel>;
    function Add(o: TContatoModel): Boolean;
    function Update(o: TContatoModel): Boolean;
    function Remove(Id: integer): Boolean;
    function ProxCod: Double;

    property excessao: string read FExcessao;

  end;

implementation

{ TContatoDao }

function TContatoDao.Add(o: TContatoModel): Boolean;
begin
  try
    o.id      := ProxCod;
    Self.FSQL :=
      'insert into contato(id, idade, nome)   '#13+
      '             values(:id, :idade, :nome)'#13+
      '';

    Self.FCmd.SQL.Clear;
    Self.FCmd.SQL.Text := Self.FSQL;
    Self.FCmd.ParamByName('id'   ).Value := o.id;
    Self.FCmd.ParamByName('idade').Value := o.idade;
    Self.FCmd.ParamByName('nome' ).Value := o.nome;
    Self.FCmd.ExecSQL;

    Result := True;

  except
    on E: Exception do
    begin
      Result         := False;
      Self.FExcessao := 'Falha inclusão.'#13+e.Message;

    end;
  end;
end;

constructor TContatoDao.Create(PConexao: TSQLConnection);
begin
  Self.FCon := PConexao;
  Self.FCmd := TSQLQuery.Create(nil);
  Self.FCmd.SQLConnection := Self.FCon;
end;

destructor TContatoDao.Destroy;
begin
  FreeAndNil(Self.FCmd);
  FreeAndNil(Self.FCon);
  inherited;
end;

function TContatoDao.Find(Desc: string): TContatoModel;
begin
  Result := nil;
  Result := TContatoModel.Create;
  try
    Self.FSQL :=
      'select * from contato where nome=:nome'#13+
      '';
    Self.FCmd.SQL.Clear;
    Self.FCmd.SQL.Text := Self.FSQL;
    Self.FCmd.ParamByName('nome').Value := Desc;
    Self.FCmd.Open;

    if Self.FCmd.IsEmpty = False then
    begin
      Result.id     := Self.FCmd.FieldByName('id').AsFloat;
      Result.idade  := Self.FCmd.FieldByName('idade').AsFloat;
      Result.nome   := Self.FCmd.FieldByName('nome').AsString;
    end;

  except
    on E: Exception do
    begin
      Self.FExcessao := 'Falha localizar.'#13+e.Message;
    end;
  end;

end;

function TContatoDao.Find(Id: integer): TContatoModel;
begin
  Result := nil;
  Result := TContatoModel.Create;
  try
    Self.FSQL :=
      'select * from contato where id=:id'#13+
      '';
    Self.FCmd.SQL.Clear;
    Self.FCmd.SQL.Text := Self.FSQL;
    Self.FCmd.ParamByName('id').Value := Id;
    Self.FCmd.Open;

    if Self.FCmd.IsEmpty = False then
    begin
      Result.id     := Self.FCmd.FieldByName('id').AsFloat;
      Result.idade  := Self.FCmd.FieldByName('idade').AsFloat;
      Result.nome   := Self.FCmd.FieldByName('nome').AsString;
    end;

  except
    on E: Exception do
    begin
      Self.FExcessao := 'Falha localizar.'#13+e.Message;
    end;
  end;

end;

function TContatoDao.List: Tlist<TContatoModel>;
var
  LModelo: TContatoModel;
begin
  Result := nil;
  Result := TList<TContatoModel>.Create;

  try
    Self.FSQL :=
      'select a.id as cdcontato, a.nome, a.idade, b.id as cdtelefone, b.numero'#13+
      '  from contato a                                                       '#13+
      '  left join telefone b on(b.idcontato = a.id) ';
    Self.FCmd.SQL.Clear;
    Self.FCmd.SQL.Text := Self.FSQL;
    Self.FCmd.Open;

    if Self.FCmd.IsEmpty = False then
    begin
      Self.FCmd.First;
      while not(Self.FCmd.Eof) do begin
        LModelo                     := TContatoModel.Create;
        LModelo.id                  := Self.FCmd.FieldByName('cdcontato').AsFloat;
        LModelo.idade               := Self.FCmd.FieldByName('idade').AsFloat;
        LModelo.nome                := Self.FCmd.FieldByName('nome').AsString;
        LModelo.telefone.id         := Self.FCmd.FieldByName('cdtelefone').AsFloat;
        LModelo.telefone.numero     := Self.FCmd.FieldByName('numero').AsString;
        LModelo.telefone.idcontato  := Self.FCmd.FieldByName('cdcontato').AsFloat;

        Result.Add(LModelo);
        Self.FCmd.Next;
      end;
    end;

  except
    on E: Exception do
    begin
      Self.FExcessao := 'Falha lista.'#13+e.Message;
    end;
  end;

end;

procedure TContatoDao.Log(const AValue: string);
var
  arq: string;
  local: TextFile;
begin
  arq := 'log.txt';
  AssignFile(local, arq);

  if FileExists(arq) then
    Append(local)
  else
    Rewrite(local);

  Writeln(local, AValue);

  CloseFile(local);

end;

function TContatoDao.ProxCod: Double;
begin
  Result := 0;

  try
    Self.FSQL :=
      'select (case when max(id) is null then 0 else max(id) end)+1 as proximo from contato '#13+
      '';
    Self.FCmd.SQL.Clear;
    Self.FCmd.SQL.Text := Self.FSQL;
    Self.FCmd.Open;

    Result := Self.FCmd.FieldByName('proximo').AsFloat;

  except
    on E: Exception do
    begin
      Self.FExcessao := 'Falha lista.'#13+e.Message;
    end;
  end;

end;

function TContatoDao.Remove(Id: integer): Boolean;
var
  ObjCto: TContatoModel;
begin
  Result := True;
  try
    ObjCto := Find(Id);
    Log(
      'Exclusão; '+
      FormatDateTime('yyyymmddhhnnss', Now)         +
      ' ; id='       +FloatToStr(ObjCto.id)         +
      ' ; nome='   +ObjCto.nome +
      ' ; idade='+FloatToStr(ObjCto.idade)
    );

    Self.FSQL := 'delete from contato where id = :id';
    Self.FCmd.SQL.Clear;
    Self.FCmd.SQL.Text := Self.FSQL;
    Self.FCmd.ParamByName('id').Value := Id;
    Self.FCmd.ExecSQL;

  except
    on E: Exception do
    begin
      Self.FExcessao := 'Falha excluir.'#13+e.Message;
      Result := False;
    end;
  end;

end;

function TContatoDao.Update(o: TContatoModel): Boolean;
begin
  Result := True;
  try
    Self.FSQL :=
      'update contato set idade=:idade, nome=:nome where id=:id'#13+
      '';
    Self.FCmd.SQL.Clear;
    Self.FCmd.SQL.Text := Self.FSQL;
    Self.FCmd.ParamByName('id'    ).Value := o.id;
    Self.FCmd.ParamByName('idade' ).Value := o.idade;
    Self.FCmd.ParamByName('nome'  ).Value := o.nome;
    Self.FCmd.ExecSQL;

  except
    on E: Exception do
    begin
      Result         := False;
      Self.FExcessao := 'Falha alteração.'#13+e.Message;

    end;
  end;

end;

end.
