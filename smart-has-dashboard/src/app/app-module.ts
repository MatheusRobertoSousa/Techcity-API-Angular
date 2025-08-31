import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { RouterModule } from '@angular/router'; // para rotas
import { AppComponent } from './app.component';

import { LoginComponent } from './components/login/login.component';
import { DashboardComponent } from './components/dashboard/dashboard.component';
import { OcorrenciaListComponent } from './components/ocorrencia-list/ocorrencia-list.component';
import { ReactiveFormsModule } from '@angular/forms';

import { routes } from './app.routes';

@NgModule({
  declarations: [
    
  ],
  imports: [
    BrowserModule,
    RouterModule.forRoot(routes),  
    LoginComponent,
    AppComponent,  
    DashboardComponent,
    ReactiveFormsModule,
    OcorrenciaListComponent
  ],
  
})
export class AppModule { }