unit Roca.Model.Mongo;

interface

uses
  Ugar;

var
  DB : TUgarDatabase;

implementation

initialization

  DB := TUgar.Init('127.0.0.1', 27017, 'roca');

end.
