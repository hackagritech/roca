unit Roca.Model.Functions;

interface

uses
  Horse.HTTP, System.SysUtils, Roca.Model.DB, System.JSON, System.Generics.Collections;

procedure Culturas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Variedades(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Atividades(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Operacoes(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Talhao(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Sementes(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Insumos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Tarefas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Produtos_Tarefa(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure InsertSafra(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure InsertTarefa(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure finalizaTarefa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure TarefasImportadas(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure SafraAtual(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure ResumoTalhoes(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure DetalheTalhao(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

uses
  System.Classes;

procedure Culturas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  Res.Send(
    ConsultaQueryArray('select * from cultura')
  );
end;

procedure InsertSafra(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  jsonBody : tjsonobject;
  Talhoes, ProdutoVar : TJSONArray;
  ID_SAFRA, ID_TALHAO : TJSONObject;
  I, J, K : Integer;
begin
  jsonBody := TJSONObject(TJSONObject.ParseJSONValue(Req.Body));

  try
    ExecSQL(
      'insert into PLANEJAMENTO_SAFRA(SAFRA,DATA_INICIO,DATA_FINAL) values ('+
      QuotedStr(jsonBody.GetValue('SAFRA').Value) + ','+
      ' cast('+QuotedStr(jsonBody.GetValue('DATA_INICIO').Value) + ' as date),'+
      ' cast('+QuotedStr(jsonBody.GetValue('DATA_FINAL').Value) + ' as date)'+
      ')');

    ID_SAFRA := ConsultaQuery('select first(1) id from planejamento_safra order by id desc');

    Talhoes := TJSONArray(jsonBody.GetValue('TALHOES'));

    for i := 0 to Pred(Talhoes.Count) do
      begin
        ExecSQL(
          'insert into talhoes (cod_planejamento, descricao, area) values (' +
          ID_SAFRA.GetValue('ID').Value + ', ' +
          QuotedStr(TJSONObject(Talhoes.Items[I]).GetValue('DESCRICAO').Value) + ', ' +
          TJSONObject(Talhoes.Items[I]).GetValue('AREA').Value +
          ')'
        );

        ID_TALHAO := ConsultaQuery('select first(1) id from talhoes order by id desc');

        ProdutoVar := TJSONArray(TJSONObject(Talhoes.Items[I]).GetValue('CULTURAS'));

        for J := 0 to Pred(ProdutoVar.Count) do
          ExecSQL('insert into CULTURA_TALHAO(COD_CULTURA, COD_TALHAO, COD_VARIEDADE) values ('+
            TJSONObject(ProdutoVar.Items[J]).GetValue('ID_CULTURA').Value + ', '+
            ID_TALHAO.GetValue('ID').Value + ', '+
            TJSONObject(ProdutoVar.Items[J]).GetValue('ID_VARIEDADE').Value +
          ')');
      end;

    Res.Send(
      'Registros incluídos com sucesso!'
      );
  except
    Res.Send(
      'Falha ao incluir dados'
    ).Status(500);
  end;
end;

procedure Variedades(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  if not (TJSONObject(TJSONObject.ParseJSONValue(Req.Body)).GetValue('COD_CULTURA').Value = '') then
    Res.Send(
      ConsultaQueryArray('select * from VARIEDADES where cod_cultura = '+TJSONObject(TJSONObject.ParseJSONValue(Req.Body)).GetValue('COD_CULTURA').Value)
    )
  else
    Res.Send('cod_cultura não encontrado!').Status(500);
end;

procedure Atividades(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  if not (TJSONObject(TJSONObject.ParseJSONValue(Req.Body)).GetValue('COD_OPERACAO').Value = '') then
    Res.Send(
      ConsultaQueryArray('select * from ATIVIDADES where cod_operacao = '+TJSONObject(TJSONObject.ParseJSONValue(Req.Body)).GetValue('COD_OPERACAO').Value)
    )
  else
    Res.Send('COD_OPERACAO não encontrado!').Status(500);
end;

procedure Operacoes(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  Res.Send(
    ConsultaQueryArray('select * from operacao')
  );
end;

procedure Talhao(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  if not (TJSONObject(TJSONObject.ParseJSONValue(Req.Body)).GetValue('COD_PLANEJAMENTO').Value = '') then
    Res.Send(
      ConsultaQueryArray('select id, descricao, area from talhoes where cod_planejamento = '+TJSONObject(TJSONObject.ParseJSONValue(Req.Body)).GetValue('COD_PLANEJAMENTO').Value)
    )
  ELSE
    Res.Send('cod_planejamento não encontrado!');
end;

procedure InsertTarefa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  Talhoes, Insumos : TJSONArray;
  ID, Tarefa : TJSONObject;
  i, j : Integer;
  SQL : STRING;
  erro : Boolean;
begin
  erro := false;

  Tarefa := TJSONObject(TJSONObject.ParseJSONValue(Req.Body));

  Talhoes := TJSONArray(Tarefa.GetValue('TALHOES'));

  for I := 0 to Pred(Talhoes.Count) do
    begin
      ExecSQL(
        'insert into TAREFA(COD_OPERACAO, COD_ATIVIDADE, COD_TALHAO, DATA, HORA) values (' +
        Tarefa.GetValue('COD_OPERACAO').Value + ',' +
        Tarefa.GetValue('COD_ATIVIDADE').Value + ',' +
        TJSONObject(Talhoes.Items[i]).GetValue('ID').Value + ',' +
        'current_date, current_time)'
      );

      ID := ConsultaQuery('select first(1) id from tarefa order by id desc');

      Insumos := TJSONArray(Tarefa.GetValue('INSUMOS'));

      for j := 0 to Pred(Insumos.Count) do
        begin
          sql := 'insert into INSUMOS_TAREFA(COD_INSUMO,COD_TAREFA,QUANTIDADE,VAZAO,DOSAGEM) values ('+
              TJSONObject(Insumos.Items[j]).GetValue('ID').Value + ',' +
              ID.GetValue('ID').Value + ',' +
              TJSONObject(Insumos.Items[j]).GetValue('QUANTIDADE').Value + ',' +
              TJSONObject(Insumos.Items[j]).GetValue('VAZAO').Value + ',' +
              TJSONObject(Insumos.Items[j]).GetValue('DOSAGEM').ToJSON +
            ')';

          ExecSQL(
            SQL
          );
        end;
    end;

  if erro then
    res.Send('Não foi possível incluir os itens').Status(500)
  else
    res.Send('Tarefa incluida com sucesso!');
end;

procedure Sementes(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  if not (TJSONObject(TJSONObject.ParseJSONValue(Req.Body)).GetValue('cod_cultura').Value = '') then
    Res.Send(
      ConsultaQueryArray('select * from SEMENTES where cod_cultura = '+TJSONObject(TJSONObject.ParseJSONValue(Req.Body)).GetValue('cod_cultura').Value)
    )
  else
    Res.Send('cod_cultura não encontrado!').Status(500);
end;

procedure Insumos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  Res.Send(
    ConsultaQueryArray('select * from INSUMOS')
  );
end;

procedure Tarefas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  sql, sql_produtos : String;
  Tarefas : TJSONArray;
  i : integer;
begin
  sql :=
    'select tarefa.id, tarefa.cod_talhao, tarefa.cod_operacao, tarefa.cod_atividade,tarefa.data,tarefa.hora,'+
    'talhoes.descricao as talhao,operacao.descricao as operacao, atividades.descricao as atividade,'+
    'talhoes.area from tarefa inner join talhoes on (tarefa.cod_talhao = talhoes.id)'+
    'inner join atividades on (atividades.id = tarefa.cod_atividade)'+
    'inner join operacao on (operacao.id = tarefa.cod_operacao) where tarefa.status = 0';

  Tarefas := ConsultaQueryArray(sql);

  for I := 0 to Pred(Tarefas.Count) do
    begin
      sql_produtos :=
        'select insumos.descricao, insumos.valor,'+
        'insumos_tarefa.vazao * talhoes.area AS LITROS,'+
        'insumos_tarefa.dosagem * talhoes.area AS QTD_PREVISTA from insumos_tarefa '+
        'inner join insumos on (insumos_tarefa.cod_insumo = insumos.id)'+
        'inner join tarefa on (tarefa.id = insumos_tarefa.cod_tarefa)'+
        'inner join talhoes on (talhoes.id = tarefa.cod_talhao)'+
        'where insumos_tarefa.cod_tarefa = '+TJSONObject(Tarefas.ItemS[I]).GetValue('ID').Value+
        ' and tarefa.cod_talhao = '+TJSONObject(Tarefas.ItemS[I]).GetValue('COD_TALHAO').Value;

      TJSONObject(Tarefas.Items[i]).AddPair('PRODUTOS', ConsultaQueryArray(sql_produtos));
    end;

  Res.Send(
    Tarefas
  );
end;

procedure Produtos_Tarefa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  sql : String;
begin
  if TJSONObject(TJSONObject.ParseJSONValue(Req.Body)).GetValue('COD_TAREFA').Value = '' then
    Res.Send('cod_tarefa não informado!').Status(500)
  else
  if TJSONObject(TJSONObject.ParseJSONValue(Req.Body)).GetValue('COD_TALHAO').Value = '' then
    Res.Send('cod_talhao não informado!').Status(500)
  else
    begin
      sql :=
        'select insumos.descricao, insumos.valor, insumos_tarefa.quantidade,'+
        'insumos_tarefa.vazao * talhoes.area AS LITROS,'+
        'insumos_tarefa.dosagem * talhoes.area AS QTD_PREVISTA from insumos_tarefa '+
        'inner join insumos on (insumos_tarefa.cod_insumo = insumos.id)'+
        'inner join tarefa on (tarefa.id = insumos_tarefa.cod_tarefa)'+
        'inner join talhoes on (talhoes.id = tarefa.cod_talhao)'+
        'where insumos_tarefa.cod_tarefa = '+TJSONObject(TJSONObject.ParseJSONValue(Req.Body)).GetValue('COD_TAREFA').Value+
        ' and tarefa.cod_talhao = '+TJSONObject(TJSONObject.ParseJSONValue(Req.Body)).GetValue('COD_TALHAO').Value;

      Res.Send(
        ConsultaQueryArray(sql)
      );
    end;
end;

procedure finalizaTarefa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  if TJSONObject(TJSONObject.ParseJSONValue(Req.Body)).GetValue('HORA_FIN').Value = '' then
    Res.Send('HORA_FINAL não informado!').Status(500)
  else
  if TJSONObject(TJSONObject.ParseJSONValue(Req.Body)).GetValue('DATA_FIN').Value = '' then
    Res.Send('DATA_FINAL não informado!').Status(500)
  else
  if TJSONObject(TJSONObject.ParseJSONValue(Req.Body)).GetValue('COD_TAREFA').Value = '' then
    Res.Send('COD_TAREFA não informado!').Status(500)
  else
    begin
      try
        ExecSQL(
          ' update TAREFA set' +
          ' hora_fin = CAST('+ QuotedStr(TJSONObject(TJSONObject.ParseJSONValue(Req.Body)).GetValue('HORA_FIN').Value) + ' as TIME),'+
          ' DATA_fin = CAST('+ QuotedStr(TJSONObject(TJSONObject.ParseJSONValue(Req.Body)).GetValue('DATA_FIN').Value) + ' as date),'+
          ' STATUS = 2 '+
          ' where id = ' + TJSONObject(TJSONObject.ParseJSONValue(Req.Body)).GetValue('COD_TAREFA').Value
        );

        Res.Send(
          'Tarefa finalizada com sucesso!'
        );
      except
        Res.Send(
          'Falha ao finalizar a tarefa!'
        ).Status(500);
      end;

    end;
end;

procedure TarefasImportadas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  BodyJSON : TJSONArray;
  i : integer;
  erro : Boolean;
begin
  BodyJSON := TJSONArray(TJSONObject.ParseJSONValue(Req.Body));
  Erro := False;

  for I := 0 to Pred(BodyJSON.Count) do
    begin
      try
        ExecSQL(
          'update TAREFA set ' +
          'STATUS = 1 '+
          'where id = ' + TJSONObject(BodyJSON.Items[I]).GetValue('ID').Value
        );
      except
        Erro := True;
      end;
    end;

  if Erro then
    Res.Send(
      'Falha ao finalizar a tarefa!'
    ).Status(500)
  else
    Res.Send(
      'Tarefa Importada!'
    );
end;

procedure SafraAtual(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  Res.Send(
    ConsultaQuery('select * from SP_SAFRA')
  )
end;

procedure ResumoTalhoes(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  if not (TJSONObject(TJSONObject.parseJSONValue(Req.Body)).GetValue('COD_PLANEJAMENTO').Value = '') then

  Res.Send(
    ConsultaQueryArray('select * from SP_RESUMO_TALHAO('+TJSONObject(TJSONObject.parseJSONValue(Req.Body)).GetValue('COD_PLANEJAMENTO').Value+')')
  )
end;

procedure DetalheTalhao(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  if not (TJSONObject(TJSONObject.parseJSONValue(Req.Body)).GetValue('COD_TALHAO').Value = '') then

  Res.Send(
    ConsultaQueryArray('select * from SP_DETALHE_TALHAO('+TJSONObject(TJSONObject.parseJSONValue(Req.Body)).GetValue('COD_TALHAO').Value+')')
  )
end;



end.
