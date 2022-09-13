unit UDM;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.SqlExpr, Data.DBXOdbc;

type
  TDM = class(TDataModule)
    conexao: TSQLConnection;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

end.
