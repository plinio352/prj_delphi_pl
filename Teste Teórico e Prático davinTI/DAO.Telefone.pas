unit DAO.Telefone;

interface

uses
  System.Classes, System.Generics.Collections, UModel.Telefone,
  Data.DB, Data.SqlExpr, System.SysUtils;

type
  TTelefoneDao = class
  private
    FSQL: string;
    FExcessao: string;
    FCon: TSQLConnection;
    FCmd: TSQLQuery;

    procedure Log(const AValue: string);

  public
    constructor Create(PConexao: TSQLConnection);
    destructor Destroy; override;

    function Find(Id: integer): TTelefoneModel;overload;
    function Find(Desc: string): TTelefoneModel;overload;
    function List: Tlist<TTelefoneModel>;
    function Add(o: TTelefoneModel): Boolean;
    function Update(o: TTelefoneModel): Boolean;
    function Remove(Id: integer): Boolean;
    function ProxCod: Double;

    property excessao: string read FExcessao;

  end;

implementation

{ TTelefoneDao }

function TTelefoneDao.Add(o: TTelefoneModel): Boolean;
begin
  try
    o.id      := ProxCod;
    Self.FSQL :=
      'insert into telefone(id, idcontato, numero)'#13+
      '              values(:id, :idcontato, :numero)';
    Self.FCmd.SQL.Clear;
    Self.FCmd.SQL.Text := Self.FSQL;
    Self.FCmd.ParamByName('id'       ).Value := o.id;
    Self.FCmd.ParamByName('idcontato').Value := o.idcontato;
    Self.FCmd.ParamByName('numero'   ).Value := o.numero;
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

constructor TTelefoneDao.Create(PConexao: TSQLConnection);
begin
  Self.FCon := PConexao;
  Self.FCmd := TSQLQuery.Create(nil);
  Self.FCmd.SQLConnection := Self.FCon;
end;

destructor TTelefoneDao.Destroy;
begin
  FreeAndNil(Self.FCmd);
  inherited;
end;

function TTelefoneDao.Find(Desc: string): TTelefoneModel;
begin
  Result := nil;
  Result := TTelefoneModel.Create;
  try
    Self.FSQL :=
      'select * from telefone   '#13+
      ' where numero = :numero  ';
    Self.FCmd.SQL.Clear;
    Self.FCmd.SQL.Text := Self.FSQL;
    Self.FCmd.ParamByName('numero').Value := Desc;
    Self.FCmd.Open;

    if Self.FCmd.IsEmpty = False then
    begin
      Result.id         := Self.FCmd.FieldByName('id').AsFloat;
      Result.idcontato  := Self.FCmd.FieldByName('idcontato').AsFloat;
      Result.numero     := Self.FCmd.FieldByName('numero').AsString;
    end;

  except
    on E: Exception do
    begin
      Self.FExcessao := 'Falha localizar.'#13+e.Message;
    end;
  end;

end;

function TTelefoneDao.Find(Id: integer): TTelefoneModel;
begin
  Result := nil;
  Result := TTelefoneModel.Create;
  try
    Self.FSQL :=
      'select * from telefone'#13+
      ' where id=:id';
    Self.FCmd.SQL.Clear;
    Self.FCmd.SQL.Text := Self.FSQL;
    Self.FCmd.ParamByName('id').Value := Id;
    Self.FCmd.Open;

    if Self.FCmd.IsEmpty = False then
    begin
      Result.id         := Self.FCmd.FieldByName('id').AsFloat;
      Result.idcontato  := Self.FCmd.FieldByName('idcontato').AsFloat;
      Result.numero     := Self.FCmd.FieldByName('numero').AsString;
    end;

  except
    on E: Exception do
    begin
      Self.FExcessao := 'Falha localizar.'#13+e.Message;
    end;
  end;

end;

function TTelefoneDao.List: Tlist<TTelefoneModel>;
var
  LModelo: TTelefoneModel;
begin
  Result := nil;
  Result := TList<TTelefoneModel>.Create;

  try
    Self.FSQL :=
      'select * from telefone'#13+
      '';
    Self.FCmd.SQL.Clear;
    Self.FCmd.SQL.Text := Self.FSQL;
    Self.FCmd.Open;

    if Self.FCmd.IsEmpty = False then
    begin
      Self.FCmd.First;
      while not(Self.FCmd.Eof) do begin
        LModelo           := TTelefoneModel.Create;
        LModelo.id        := Self.FCmd.FieldByName('id').AsFloat;
        LModelo.idcontato := Self.FCmd.FieldByName('idcontato').AsFloat;
        LModelo.numero    := Self.FCmd.FieldByName('numero').AsString;
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

procedure TTelefoneDao.Log(const AValue: string);
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

function TTelefoneDao.ProxCod: Double;
begin
  Result := 0;

  try
    Self.FSQL :=
      'select (case when max(id) is null then 0 else max(id) end)+1 as proximo from telefone'#13+
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

function TTelefoneDao.Remove(Id: integer): Boolean;
var
  ObjTel: TTelefoneModel;
begin
  Result := True;
  try
    ObjTel := Find(Id);
    Log(
      'Exclusão; '+
      FormatDateTime('yyyymmddhhnnss', Now)         +
      ' ; id='       +FloatToStr(ObjTel.id)         +
      ' ; numero='   +ObjTel.numero +
      ' ; idcontato='+FloatToStr(ObjTel.idcontato)
    );

    Self.FSQL := 'delete from telefone where id = :id';
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

function TTelefoneDao.Update(o: TTelefoneModel): Boolean;
begin
  Result := True;
  try
    Self.FSQL :=
      'update telefone set idcontato = :idcontato, '#13+
      '                       numero = :numero     '#13+
      ' where id = :id                             ';
    Self.FCmd.SQL.Clear;
    Self.FCmd.SQL.Text := Self.FSQL;
    Self.FCmd.ParamByName('id'       ).Value := o.id;
    Self.FCmd.ParamByName('idcontato').Value := o.idcontato;
    Self.FCmd.ParamByName('numero'   ).Value := o.numero;
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
