unit Controller.Contato;

interface

uses
  System.Classes, System.Generics.Collections, UModel.Contato,
  DAO.Contato, UInterface.Contato, Data.DB, Datasnap.DBClient, System.SysUtils;

type
  TOperacao = (opIincluir, opAlaterar);

  TContatoController = class(TInterfacedObject, IContatoInterface)
  private
    FContatoDao: TContatoDao;
    FExcessao: string;

    function GetExcessao: string;

  public
    constructor Create;
    destructor Destroy; override;
    class function New: IContatoInterface;

    function Find(Id: integer): TContatoModel;overload;
    function Find(Desc: string): TContatoModel;overload;
    procedure List(PCds: TClientDataSet);
    function Add(o: TContatoModel): Boolean;
    function Update(o: TContatoModel): Boolean;
    function Remove(Id: integer): Boolean;

    property excessao: string read GetExcessao;

  end;

implementation

uses
  UDM;

{ TContatoDao }

function TContatoController.Add(o: TContatoModel): Boolean;
begin
  Result := True;
  try
    if not Self.FContatoDao.Add(o) then
      raise Exception.Create('Error Message');

  except
    on E: Exception do
    begin
      Result         := False;
      Self.FExcessao := 'Falha inclusão.'#13+e.Message;

    end;
  end;
end;

constructor TContatoController.Create;
begin
  inherited;
  Self.FContatoDao := TContatoDao.Create(DM.conexao);
end;

destructor TContatoController.Destroy;
begin
  FreeAndNil(Self.FContatoDao);
  inherited;
end;

function TContatoController.Find(Desc: string): TContatoModel;
begin
  Result := nil;
  try
    Result := Self.FContatoDao.Find(Desc);
    if Self.FExcessao <> EmptyStr then
      raise Exception.Create('Error Message');

  except
    on E: Exception do
    begin
      Self.FExcessao := 'Falha localizar.'#13+e.Message;
    end;
  end;

end;

function TContatoController.Find(Id: integer): TContatoModel;
begin
  Result := nil;
  try
    Result := Self.FContatoDao.Find(Id);
    if Self.FExcessao <> EmptyStr then
      raise Exception.Create('Error Message');

  except
    on E: Exception do
    begin
      Self.FExcessao := 'Falha localizar.'#13+e.Message;
    end;
  end;

end;

function TContatoController.GetExcessao: string;
begin
  Result := Self.FExcessao
end;

procedure TContatoController.List(PCds: TClientDataSet);
var
  LstContato: TList<TContatoModel>;
  MdlContato: TContatoModel;
begin
  try
    PCds.Close;
    PCds.FieldDefs.Clear;
    PCds.FieldDefs.Add('id'             ,ftFloat      );
    PCds.FieldDefs.Add('nome'           ,ftString,  50);
    PCds.FieldDefs.Add('idade'          ,ftFloat      );
    PCds.FieldDefs.Add('telefone_id'    ,ftFloat      );
    PCds.FieldDefs.Add('numero'         ,ftString,  14);
    PCds.CreateDataSet;

    LstContato := Self.FContatoDao.List;
    for MdlContato in LstContato do
    begin
      PCds.Append;
      PCds.FieldByName('id'           ).Value := MdlContato.id;
      PCds.FieldByName('nome'         ).Value := MdlContato.nome;
      PCds.FieldByName('idade'        ).Value := MdlContato.idade;
      PCds.FieldByName('telefone_id'  ).Value := MdlContato.telefone.id;
      PCds.FieldByName('numero'       ).Value := MdlContato.telefone.numero;
      PCds.Post;
    end;

  except
    on E: Exception do
    begin
      Self.FExcessao := 'Falha lista.'#13+e.Message;
    end;
  end;

end;

class function TContatoController.New: IContatoInterface;
begin
  Result := Self.Create;
end;

function TContatoController.Remove(Id: integer): Boolean;
begin
  Result := True;
  try
    if not Self.FContatoDao.Remove(Id) then
      raise Exception.Create('Error Message');

  except
    on E: Exception do
    begin
      Self.FExcessao := 'Falha excluir.'#13+e.Message;
      Result := False;
    end;
  end;

end;

function TContatoController.Update(o: TContatoModel): Boolean;
begin
  Result := True;
  try
    if not Self.FContatoDao.Update(o) then
      raise Exception.Create('Error Message');

  except
    on E: Exception do
    begin
      Result         := False;
      Self.FExcessao := 'Falha alteração.'#13+e.Message;

    end;
  end;

end;

end.
