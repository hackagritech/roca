unit Roca.Model.DB;

interface

uses
  FireDAC.Stan.Intf, FireDAC.Stan.Option, System.JSON, System.NetEncoding,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, IdBaseComponent, IdCoder, IdCoder3to4,
  IdCoderMIME, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  DataSetConverter4D, DataSetConverter4D.Helper, DataSetConverter4D.Impl, DataSetConverter4D.Util;

function ConnectFD : TFDConnection;
function ConsultaQuery(sql : String) : TJSONObject;
function ConsultaQueryArray(sql : String) : TJSONArray;

function ExecSQL(sql : String) : Boolean;

implementation

uses
  System.Classes, System.SysUtils;

function ConnectFD : TFDConnection;
var
  netdir : TStringList;
begin
  netdir := TStringList.Create;

  try
    netdir.LoadFromFile('dir.conf');

    result := TFDConnection.Create(nil);

    result.LoginPrompt := False;
    result.Close;
    result.Params.Clear;

    result.Params.Add('Database='+ExtractFilePath(ParamStr(0))+'db.fdb');
    result.Params.Add('User_Name=sysdba');
    result.Params.Add('Password=masterkey');
    result.Params.Add('Server=localhost');
    result.Params.Add('DriverID=FB');
  finally
    FreeAndNil(netdir);
  end;
end;

function ConsultaQuery(sql : String) : TJSONObject;
var
  Query : TFDQuery;
  Conn : TFDConnection;
begin
  Conn := ConnectFD;

  try
    Query := TFDQuery.Create(nil);

    try
      Query.Connection := Conn;
      Query.SQL.Clear;
      Query.SQL.Add(sql);
      Query.Open;

      Result := Query.AsJSONObject;

    finally
      FreeAndNil(Query);
    end;

  finally
    FreeAndNil(Conn);
  end;
end;

function ConsultaQueryArray(sql : String) : TJSONArray;
var
  Query : TFDQuery;
  Conn : TFDConnection;
begin
  Conn := ConnectFD;

  try
    Query := TFDQuery.Create(nil);

    try
      Query.Connection := Conn;
      Query.SQL.Clear;
      Query.SQL.Add(sql);
      Query.Open;

      Result := Query.AsJSONArray;

    finally
      FreeAndNil(Query);
    end;

  finally
    FreeAndNil(Conn);
  end;

end;

function ExecSQL(sql : String) : Boolean;
var
  Query : TFDQuery;
  Conn : TFDConnection;
begin
  Conn := ConnectFD;

  try
    Query := TFDQuery.Create(nil);

    try
      Query.Connection := Conn;
      Query.SQL.Clear;
      Query.SQL.Add(sql);

      try
        Query.ExecSQL;
      finally
        Result := True;
      end;

    finally
      FreeAndNil(Query);
    end;

  finally
    FreeAndNil(Conn);
  end
end;

end.
