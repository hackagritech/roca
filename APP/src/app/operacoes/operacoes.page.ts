import { Component, OnInit } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { map } from 'rxjs/operators';
import { Observable } from 'rxjs';
import { Router, NavigationExtras } from '@angular/router';

@Component({
  selector: 'app-operacoes',
  templateUrl: 'operacoes.page.html',
  styleUrls: ['operacoes.page.scss']
})
export class OperacoesPage implements OnInit {
  Processos: any = [];
  arrSelecionados = [];

  constructor(private http: HttpClient, private router: Router) {}

  ngOnInit() {
    this.getProcessos()
  }
  
  getProcessos () {
    let token = localStorage.getItem('token');
    
    this.http.get('http://172.16.7.172:9002/tarefa', {
      headers: { 'Authorization': 'Bearer ' + token}}).subscribe(data=>{
        console.log(data)
        this.Processos = data;
      });
  }

  // selecionaTarefa(item) {
  //   localStorage.setItem('operacao', JSON.stringify(item));

  //   this.router.navigate(['operacao']);
  // }

  selecionaTarefa(item, index) {
    this.Processos.splice(index, 1)
    this.arrSelecionados.push(item)
    console.log(this.arrSelecionados)
  }

  next() {
  let token = localStorage.getItem('token');

  this.http.post("http://172.16.7.172:9002/importado", this.arrSelecionados, {
    headers: { 'Authorization': 'Bearer ' + token}}).subscribe(data=>{
      console.log(data)
    });
    
    localStorage.setItem('operacoes', JSON.stringify(this.arrSelecionados));

    this.router.navigate(['operacoes-selecionadas']);
  }
}
