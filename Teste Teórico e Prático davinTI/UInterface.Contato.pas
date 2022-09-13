unit UInterface.Contato;

interface

uses
  UModel.Contato, Datasnap.DBClient;

type
  IContatoInterface = interface
    ['{0D410368-1601-4CD7-A91F-6A70A45E0B34}']
    function GetExcessao: string;
    function Find(Id: integer): TContatoModel;overload;
    function Find(Desc: string): TContatoModel;overload;
    procedure List(PCds: TClientDataSet);
    function Add(o: TContatoModel): Boolean;
    function Update(o: TContatoModel): Boolean;
    function Remove(Id: integer): Boolean;

    property excessao: string read GetExcessao;

  end;

implementation

end.
