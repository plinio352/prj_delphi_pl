object DM: TDM
  OldCreateOrder = False
  Height = 211
  Width = 304
  object conexao: TSQLConnection
    ConnectionName = 'DSPOSTGRE01'
    DriverName = 'ODBC'
    LoginPrompt = False
    Params.Strings = (
      'drivername=ODBC'
      'hostname=127.0.0.1'
      'database=dsPostgre01'
      'User_Name=postgres'
      'password=7737plin')
    Left = 96
    Top = 64
  end
end
