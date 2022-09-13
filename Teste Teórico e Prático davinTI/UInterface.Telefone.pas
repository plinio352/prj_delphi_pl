unit UInterface.Telefone;

interface

uses
  UModel.Telefone, Datasnap.DBClient;

type
  ITelefoneInterface = interface
    ['{F5DAEA2C-E759-47BF-8D19-9CD8D2FB86BE}']
    function GetExcessao: string;
    function Find(Id: integer): TTelefoneModel;overload;
    function Find(Desc: string): TTelefoneModel;overload;
    procedure List(PCds: TClientDataSet);
    function Add(o: TTelefoneModel): Boolean;
    function Update(o: TTelefoneModel): Boolean;
    function Remove(Id: integer): Boolean;

    property excessao: string read GetExcessao;

  end;

implementation

end.
