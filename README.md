# PokéApp - VersoTech Challenge

Este é um aplicativo mobile desenvolvido em **Flutter** como parte do processo seletivo para a **VersoTech**. O projeto consiste em um catálogo de Pokémons que consome a [PokeAPI](https://pokeapi.co/), demonstrando a implementação de fluxos assíncronos, gerenciamento de estado reativo e boas práticas de arquitetura.

## 🚀 Funcionalidades

- **Lista de Pokémons:** Visualização em grid/lista com carregamento dinâmico
- **Detalhes Avançados:** Exibição de estatísticas como altura, peso, habilidades e tipos
- **Cache de Imagens:** Implementação do `cached_network_image` para garantir performance e navegação offline para imagens já carregadas
- **Tratamento de Erros:** Fluxos de exceção para falhas de conexão ou timeouts, com feedback claro para o usuário

---

## 🛠 Tecnologias e Bibliotecas

- **Linguagem:** Dart
- **Framework:** Flutter
- **Gerenciamento de Estado:** [MobX](https://pub.dev/packages/mobx) com `flutter_mobx`
- **Client HTTP:** [Dio](https://pub.dev/packages/dio) (escolhido pela robustez em interceptors e gerenciamento de erros)
- **Injeção de Dependência:** [GetIt](https://pub.dev/packages/get_it)
- **Gerador de Código:** `build_runner` e `mobx_codegen`

---

## 🏗 Arquitetura

O projeto foi estruturado seguindo princípios de **Clean Architecture** simplificada para garantir a testabilidade e separação de responsabilidades:
```text
lib/
│
├── core/                     # Configurações globais
│   ├── di/                   # Injeção de dependência (GetIt)
│   │    └── injection.dart
│   │
│   ├── errors/               # Exceptions customizadas
│   │    └── app_exception.dart
│   │
│   └── network/              # Configuração de API
│        └── api_service.dart
│
├── features/
│   └── pokemon_list/
│        │
│        ├── data/                   # Camada de dados
│        │   ├── datasource/
│        │   │    └── pokemon_remote_datasource.dart
│        │   │
│        │   ├── models/
│        │   │    └── model_pokemon.dart
│        │   │
│        │   └── repositories/
│        │        └── pokemon_repository.dart
│        │
│        └── presentation/            # Camada de UI
│             │
│             ├── screens/
│             │   ├── pokemon_list_screen.dart
│             │   └── pokemon_detail_screen.dart
│             │
│             ├── widgets/
│             │   ├── pokedex_card.dart
│             │   └── pokemon_info.dart
│             │
│             └── stores/
│                  ├── pokemon_store.dart
│                  └── pokemon_store.g.dart
│
└── main.dart
```

---

## 🧪 Testes de Interface (Widget Tests)

Para garantir que a interface responda corretamente aos diferentes estados da API, foram implementados Widget Tests focados em comportamento.

**Abordagem**
- **Injeção de Dependência:** Os testes utilizam o GetIt para injetar as Stores fakes, garantindo que o widget testado esteja isolado de camadas externas.
- **Image Mocking:** Uso do network_image_mock para validar a renderização de imagens e ícones sem disparar erros de requisição HTTP real durante os testes.

**O que está sendo testado?**
- **Estados de UI:** Verificação se o CircularProgressIndicator aparece durante o carregamento.
- **Tratamento de Erros:** Validação se a mensagem de erro correta é exibida em caso de falha na Store.
- **Renderização de Dados:** Verificação se os dados do Pokémon (nome, ID, imagem) são exibidos corretamente após o carregamento.

## ⚙️ Como Executar os Testes

Como o projeto possui arquivos auxiliares (helpers e fakes) que não contêm o método main(), o comando padrão flutter test pode tentar executá-los e retornar erro. Para rodar apenas os testes funcionais, utilize:

**Para testar screens:**
```bash
flutter test test/screens
```

**Para testar widgets:**
```bash
flutter test test/widgets
```
---

## ⚙️ Como Executar o Projeto

### Pré-requisitos

- Flutter SDK (versão estável)
- Dispositivo Android/iOS ou Emulador

### 1. Clone o repositório

**HTTPS:**
```bash
git clone https://github.com/Viniciusfflores/teste_verso_tech.git
cd teste_verso_tech
```

**SSH:**
```bash
git clone git@github.com:Viniciusfflores/teste_verso_tech.git
cd teste_verso_tech
```

### 2. Instale as dependências
```bash
flutter pub get
```

### 3. Gere os arquivos do MobX

Como o projeto utiliza geração de código, execute:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. Inicie o App
```bash
flutter run
```

---

**Desenvolvido por:** Vinicius Fortes Flores
