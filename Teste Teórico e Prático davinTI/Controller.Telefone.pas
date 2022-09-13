unit Controller.Telefone;

interface

uses
  System.Classes, System.Generics.Collections, UModel.Telefone,
  DAO.Telefone, UInterface.Telefone, Data.DB, Datasnap.DBClient, System.SysUtils;

type
  TTelefoneController = class(TInterfacedObject, ITelefoneInterface)
  private
    FTelefoneDao: TTelefoneDao;
    FExcessao: string;

    function GetExcessao: string;

  public
    constructor Create;
    destructor Destroy; override;
    class function New: ITelefoneInterface;

    function Find(Id: integer): TTelefoneModel;overload;
    function Find(Desc: string): TTelefoneModel;overload;
    procedure List(PCds: TClientDataSet);
    function Add(o: TTelefoneModel): Boolean;
    function Update(o: TTelefoneModel): Boolean;
    function Remove(Id: integer): Boolean;

    property excessao: string read GetExcessao;

  end;

implementation

uses
  UDM;

{ TTelefoneDao }

function TTelefoneController.Add(o: TTelefoneModel): Boolean;
begin
  Result := True;
  try
    if not Self.FTelefoneDao.Add(o) then
      raise Exception.Create('Error Message');

  except
    on E: Exception do
    begin
      Result         := False;
      Self.FExcessao := 'Falha inclusão.'#13+e.Message;

    end;
  end;
end;

constructor TTelefoneController.Create;
begin
  inherited;
  Self.FTelefoneDao := TTelefoneDao.Create(DM.conexao);
end;

destructor TTelefoneController.Destroy;
begin
  FreeAndNil(Self.FTelefoneDao);
  inherited;
end;

function TTelefoneController.Find(Desc: string): TTelefoneModel;
begin
  Result := nil;
  try
    Result := Self.FTelefoneDao.Find(Desc);
    if Self.FExcessao <> EmptyStr then
      raise Exception.Create('Error Message');

  except
    on E: Exception do
    begin
      Self.FExcessao := 'Falha localizar.'#13+e.Message;
    end;
  end;

end;

function TTelefoneController.Find(Id: integer): TTelefoneModel;
begin
  Result := nil;
  try
    Result := Self.FTelefoneDao.Find(Id);
    if Self.FExcessao <> EmptyStr then
      raise Exception.Create('Error Message');

  except
    on E: Exception do
    begin
      Self.FExcessao := 'Falha localizar.'#13+e.Message;
    end;
  end;

end;

function TTelefoneController.GetExcessao: string;
begin
  Result := Self.FExcessao
end;

procedure TTelefoneController.List(PCds: TClientDataSet);
var
  LstTelefone: TList<TTelefoneModel>;
  MdlTelefone: TTelefoneModel;
begin
  try
    PCds.Close;
    PCds.FieldDefs.Clear;
    PCds.FieldDefs.Add('id'             ,ftFloat      );
    PCds.FieldDefs.Add('numero'         ,ftString,  14);
    PCds.FieldDefs.Add('idcontato'      ,ftFloat      );
    PCds.CreateDataSet;

    LstTelefone := Self.FTelefoneDao.List;
    for MdlTelefone in LstTelefone do
    begin
      PCds.Append;
      PCds.FieldByName('id'         ).Value := MdlTelefone.id;
      PCds.FieldByName('numero'     ).Value := MdlTelefone.numero;
      PCds.FieldByName('idcontato'  ).Value := MdlTelefone.idcontato;
      PCds.Post;
    end;

  except
    on E: Exception do
    begin
      Self.FExcessao := 'Falha lista.'#13+e.Message;
    end;
  end;

end;

class function TTelefoneController.New: ITelefoneInterface;
begin
  Result := Self.Create;
end;

function TTelefoneController.Remove(Id: integer): Boolean;
begin
  Result := True;
  try
    if not Self.FTelefoneDao.Remove(Id) then
      raise Exception.Create('Error Message');

  except
    on E: Exception do
    begin
      Self.FExcessao := 'Falha excluir.'#13+e.Message;
      Result := False;
    end;
  end;

end;

function TTelefoneController.Update(o: TTelefoneModel): Boolean;
begin
  Result := True;
  try
    if not Self.FTelefoneDao.Update(o) then
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
