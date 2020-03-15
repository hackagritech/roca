import { Component, OnInit } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-operacao_id',
  templateUrl: 'operacao_id.page.html',
  styleUrls: ['operacao_id.page.scss']
})
export class OperacaoIdPage {

  item: any = [];
  OperacoesSelecionadas: any = [];

  constructor(private route: ActivatedRoute, private router: Router) {}

  ngOnInit() {
    this.OperacoesSelecionadas = JSON.parse(localStorage.getItem('operacoes'))
  }

  selecionaTarefa(item, index) {
    localStorage.setItem('operacao-selecionada', JSON.stringify(item));

    this.router.navigate(['operacao-ativa']);
  }
}
