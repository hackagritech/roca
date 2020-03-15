import { NgModule } from '@angular/core';
import { PreloadAllModules, RouterModule, Routes } from '@angular/router';

const routes: Routes = [
  {
    path: '',
    loadChildren: () => import('./login/login.module').then( m => m.LoginPageModule)
  },
  {
    path: 'operacoes',
    loadChildren: () => import('./operacoes/operacoes.module').then(m => m.OperacoesPageModule)
  },
  {
    path: 'operacoes-selecionadas',
    loadChildren: () => import('./operacao_id/operacao_id.module').then( m => m.OperacaoIdPageModule)
  },
  {
    path: 'operacao-ativa',
    loadChildren: () => import('./tab2/tab2.module').then( m => m.Tab2PageModule)
  },
  {
    path: 'login',
    loadChildren: () => import('./login/login.module').then( m => m.LoginPageModule)
  }
];
@NgModule({
  imports: [
    RouterModule.forRoot(routes, { preloadingStrategy: PreloadAllModules })
  ],
  exports: [RouterModule]
})
export class AppRoutingModule {}
