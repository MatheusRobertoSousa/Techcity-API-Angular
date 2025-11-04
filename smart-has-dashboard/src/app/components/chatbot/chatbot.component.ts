import { Component } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { Router, RouterModule } from '@angular/router';

@Component({
  selector: 'app-chatbot',
  templateUrl: './chatbot.component.html',
  styleUrls: ['./chatbot.component.scss'],
  imports: [FormsModule, RouterModule, CommonModule]
})
export class ChatbotComponent {
  mensagens: { remetente: string, texto: string }[] = [];
  inputUsuario = '';
  apiUrl = 'http://localhost:8080/ia/chat';

  constructor(private http: HttpClient) {}

  enviarMensagem() {
    if (!this.inputUsuario.trim()) return;

    const mensagem = this.inputUsuario.trim();
    this.mensagens.push({ remetente: 'Cidadão', texto: mensagem });
    this.inputUsuario = '';

    this.http.post(this.apiUrl, mensagem, { responseType: 'text' }).subscribe({
      next: (resposta) => this.mensagens.push({ remetente: 'SmartHAS', texto: resposta }),
      error: () => this.mensagens.push({ remetente: 'SmartHAS', texto: 'Erro ao conectar ao servidor da cidade.' })
    });
  }
}
