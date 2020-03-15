
import { Component, OnInit, ElementRef, ViewChild } from '@angular/core';
import { Geolocation } from '@ionic-native/geolocation/ngx';
import { Subscription, BehaviorSubject } from 'rxjs';
import { Platform } from '@ionic/angular';
import { timeout } from 'rxjs/operators';

declare var google;

let optionsView = {
  static: false
};

@Component({
  selector: 'app-tab2',
  templateUrl: 'tab2.page.html',
  styleUrls: ['tab2.page.scss']
})
export class Tab2Page {

  operacaoSelecionada = [];
  positionSubscription: Subscription;
  pararProcesso = false;
  processoFinalizado = false;
  comecarProcesso = true;
  urlMap: any;
  latitude: any;
  longitude: any;
  velocidade: any;
  horario: any;
  horarioDecimal: any;
  distancia: any;
  velocidadeMedia: any;
  horaInicio: any;
  horaFinal: any;
  tempoDeExecucao: any;
  terminado = false;
  tempo = 0;
  tempoFinal = "00:30";
  tempoExecucao: any = "00:00";
  constructor(private geolocation: Geolocation, private platform: Platform) {}
  
  ngOnInit() {
    this.platform.ready().then(() => {
      this.operacaoSelecionada = JSON.parse(localStorage.getItem('operacao-selecionada'));

      this.getGeolocalizacao();

      setInterval(function() {
        this.getGeolocalizacao();
      }.bind(this), 5000)
    });
  }

  getGeolocalizacao() {
    let data = new Date();
    this.geolocation.getCurrentPosition({maximumAge: 1000, timeout: 5000,
      enableHighAccuracy: true}).then((resp) => {
        this.latitude = resp.coords.latitude,
        this.longitude = resp.coords.longitude;
        if(this.velocidade == null) {
          this.velocidade = 0;
        } else {
          this.velocidade = resp.coords.speed;
        }
        this.horario = data.getHours() + ":" + data.getMinutes();
        this.horarioDecimal = data.getHours().toString() + "," + (data.getMinutes()/60).toString().split(".")[1],
        this.distancia = this.velocidade*this.horarioDecimal,
        this.velocidadeMedia = this.distancia/this.horarioDecimal
      })
  }

  comecarOperacao() {

    setInterval(function() {
      this.startTimer();
    }.bind(this), 1000);
    this.pararProcesso = true;
    this.comecarProcesso = false;
    let dataInicio = new Date();
    this.horaInicio = dataInicio.getHours() + ":" + dataInicio.getMinutes();
  }

  pararOperacao() {
    this.processoFinalizado = true;
    this.comecarProcesso = false;
    this.pararProcesso = true;
    let dataFinal = new Date();
    let horaFinalDecimal = dataFinal.getHours() + "," + (dataFinal.getMinutes()/60).toString().split(".")[1];
    this.horaFinal = dataFinal.getHours() + ":" + dataFinal.getMinutes();

    this.tempoDeExecucao = this.horaInicio - this.horaFinal;
  }

  startTimer() {
    if (!this.terminado) {
      this.tempo = this.tempo++;
      let vTempo = this.tempo / 60
    }

    if(this.tempo % 1 === 0) {
      var tempoDecimalSplitado = this.tempo.toString().split(",")[1];

      var tempoDecimal = parseInt(tempoDecimalSplitado)*60;
    }

    var tempoInteiro = this.tempo.toString().split(",")[0];

    this.tempoExecucao = tempoInteiro + ":" + tempoDecimal
  }

  // uploadDeDadosQuandoReconectarInternet() {
  //   let Header = new Headers();
  //   Header.append("Accept", 'application/json');
  //   Header.append('Content-Type', 'application/json' );

  //   let postData = [
  //     {  }
  //   ]

  //   Header.append()
  //   this.http.post
  // }
}

