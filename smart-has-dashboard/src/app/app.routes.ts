import { Routes } from '@angular/router';
import { LoginComponent } from './components/login/login.component';
import { DashboardComponent } from './components/dashboard/dashboard.component';
import { OcorrenciaListComponent } from './components/ocorrencia-list/ocorrencia-list.component';
import { RegisterComponent } from './components/register/register.component'; // 👈 importa o Register
import { AdminUsuariosComponent } from './components/admin/admin-usuarios.component';

export const routes: Routes = [
  { path: '', component: LoginComponent },

  { path: 'register', component: RegisterComponent }, // 👈 nova rota para registro

  { path: 'admin', component: AdminUsuariosComponent },

  { path: 'dashboard', component: DashboardComponent },
  { path: 'dashboard/ocorrencias', component: OcorrenciaListComponent },

  { path: '**', redirectTo: '' }
];
