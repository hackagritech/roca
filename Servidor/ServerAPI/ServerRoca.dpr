program ServerRoca;

{$APPTYPE CONSOLE}

uses
  Horse,
  Horse.JWT,
  Horse.Jhonson,
  System.JSON,
  Horse.CORS,
  Roca.Model.Functions in 'model\Roca.Model.Functions.pas',
  Roca.Model.DB in 'model\Roca.Model.DB.pas';

{$R *.res}

var
  App: THorse;

begin
  App := THorse.Create(9002);

  App.Use(CORS);

  App.Use(HorseJWT('Roca.WeAre'));

  App.Use(Jhonson);

  App.Get('/cultura', Culturas);

  App.Post('/variedade', Variedades);

  App.Get('/operacao', Operacoes);

  App.Post('/atividade', Atividades);

  App.Post('/sementes', Sementes);

  App.Get('/insumos', Insumos);

  App.Post('/talhoes', Talhao);

  App.Post('/planejamento', InsertSafra);

  App.Post('/tarefa', InsertTarefa);

  App.Get('/tarefa', Tarefas);

  App.Put('/tarefa', finalizaTarefa);

  App.Post('/importado', TarefasImportadas);

  App.Get('/safra_atual', SafraAtual);

  App.Post('/resumo_talhao', ResumoTalhoes);

  App.Post('/detalhar_talhao', DetalheTalhao);

  App.Start;
end.
