import { Component, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'app-login',
  templateUrl: './login.page.html',
  styleUrls: ['./login.page.scss'],
})
export class LoginPage implements OnInit {

  constructor(private http: HttpClient) { }

  ngOnInit() {
  }

  takeToken() {
    // let Header = new Headers();
    // Header.append("Accept", 'application/json');
    // Header.append('Content-Type', 'application/json' );

    let postData = {
      "USERNAME": "Operador004"
    }

    this.http.post("http://172.16.7.172:9000/auth/", postData)
      .subscribe(data => {
        localStorage.setItem('token', data['token'])
        console.log(data['token']);
       }, error => {
        console.log(error);
      });
  }

}
