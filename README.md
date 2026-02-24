# AppMB

App iOS que lista exchanges de criptomoedas e exibe detalhes/ativos, consumindo a API da CoinMarketCap. A interface inclui busca, ordenação por volume e paginação, além de um fluxo de detalhes com abertura do site da exchange.

## Funcionalidades
- Lista de exchanges com busca e ordenação por volume (24h).
- Paginação incremental (até 100 itens) com indicador de carregamento.
- Detalhes da exchange, incluindo descrição, taxas e data de lançamento.
- Listagem de ativos disponíveis por exchange.
- Abertura do site oficial da exchange.

## Arquitetura
- UIKit com padrão MVVM + Coordinator.
- Camada de rede com `async/await` e endpoints centralizados.
- Componentes reutilizáveis para loading, shimmer e download de imagens com cache.

## Stack e versões
- Swift 5.0 (conforme `SWIFT_VERSION` no projeto).
- iOS Deployment Target 26.2 (conforme `IPHONEOS_DEPLOYMENT_TARGET` no projeto).
- UIKit, URLSession e Foundation.

## Detalhes técnicos
- Fluxo principal em `SceneDelegate` com `UINavigationController` e Coordinator.
- Paginação com `start/limit`, limite máximo de 100 itens e ordenação por volume (24h).
- Busca local por nome e slug.
- API CoinMarketCap: endpoints `/exchange/map`, `/exchange/info` e `/exchange/assets`.
- Cache de imagens em memória via `NSCache` no `DownloadImage`.

## Requisitos
- macOS com Xcode instalado.
- Acesso a uma chave da API da CoinMarketCap.

## Como rodar
1. Abra o projeto em `AppMB.xcodeproj`.
2. Configure a chave da API em `AppMB/Infrastructure/Enuns/Constants.swift` (`ApplicationConstants.PathAPI.apiKey`).
3. Selecione o target `AppMB` e execute em um simulador ou dispositivo.

## Testes
- Unitários: `AppMBTests`
- UI Tests: `AppMBUITests`

## Cobertura de testes
- 95%.
