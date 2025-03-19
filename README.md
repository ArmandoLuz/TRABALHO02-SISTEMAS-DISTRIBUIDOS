# Documentação do Projeto

## 📌 Visão Geral
Este projeto é um aplicativo desenvolvido em **Flutter** que utiliza **sensores do dispositivo** para detectar proximidade e enviar imagens a um servidor de segurança. O sistema possui uma **interface gráfica responsiva** e suporte a operações em **tempo real**.

## 🚀 Tecnologias Utilizadas
- **Flutter (Dart)** - Desenvolvimento do aplicativo
- **Python (Sockets)** - Backend para processamento de requisições

## 📂 Estrutura do Projeto
```
client/  # Aplicação Flutter
│── lib/
│   ├── main.dart  # Entrada principal do app
│── android/  # Código nativo para Android
│── pubspec.yaml  # Dependências do Flutter
│
server/  # Backend em Python
|── data # Diretório de armazenamento das imagens
│── main.py  # Servidor
│── helpers.py  # Funções auxiliares para processamento de imagem
```

## 📱 Funcionalidades
- **Detecção de proximidade**: O app usa o **sensor de proximidade** do Android para ativar o monitoramento.
- **Captura de imagem**: Quando o sensor detecta um objeto próximo, o app usa a **câmera** para tirar uma foto.
- **Envio para o servidor**: A imagem é **processada e enviada** via **socket** para o servidor Python.
- **Interface interativa**: O usuário pode ativar/desativar o modo de segurança diretamente no app.

## 🔧 Instalação e Configuração
### **1️⃣ Configurar o Cliente Flutter**
```bash
cd client/
flutter pub get
flutter run
```

### **2️⃣ Configurar o Backend**
```bash
poetry install
poetry env activate
python3 server/main.py
```
