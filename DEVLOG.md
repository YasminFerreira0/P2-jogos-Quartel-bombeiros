# Diário de desenvolvimento

## Aula 08 — conclusão em 06/11/2026

- Fiz a arena vista de cima com ruas, grama, quartel e bombeiro com movimento nas quatro direções.
- O atlas tinha fundo escuro e as peças de chão não estavam alinhadas em uma grade regular; a primeira versão também usou uma referência incorreta para as peças.
- Com auxílio do Codex, preparei recortes para o chão, corrigi o TileSet e usei um shader para esconder o fundo nos cantos do quartel.
- Acrescentei câmera, colisão na base do prédio e limites sólidos em volta da arena. A próxima etapa será implementar inimigos, vida e coleta.

## Aula 09 — 08/11/2026

- Acrescentei chamas que perseguem o bombeiro e nascem em intervalos progressivamente menores.
- Implementei três vidas, dano por contato e um segundo de invulnerabilidade com indicação visual.
- Criei equipamentos que surgem em pontos da arena, contador até 20, telas de vitória e derrota e botão para reiniciar.
- Usei desenhos provisórios para as chamas e os itens; a implementação foi feita com auxílio do Codex e testada na Godot.

## Aula 10 — 11/11/2026

- Acrescentei uma região de navegação à arena e um agente em cada chama para contornar a base do quartel.
- Implementei o ataque com Espaço, um efeito visual e um intervalo de 0,4 segundo entre ataques.
- As chamas atingidas são removidas e o placar registra quantas foram apagadas; coletar 20 itens continua sendo o objetivo.
- Com auxílio do Codex, testei o contorno do quartel e o ataque na Godot. O polígono de navegação precisará ser atualizado se os obstáculos mudarem.

## Ajuste da ideia do jogo — 11/11/2026

- Posicionei o bombeiro e os primeiros focos diante do quartel.
- Substituí as chamas que perseguiam o jogador por focos que se espalham pelo cenário e podem surgir à frente do movimento.
- Usei quadros do atlas de efeitos para animar o fogo e mantive o dano por contato e o ataque para apagá-lo.
- Com auxílio do Codex, testei o início, a propagação, o dano e o ataque.

## Variedades de fogo e iluminação — 11/11/2026

- Acrescentei a chama comprida animada do atlas de efeitos, com colisão mais larga e resistência de três ataques.
- Alternei os tipos durante a propagação e apliquei uma iluminação ambiente suave ao cenário, com auxílio do Codex.
- Testei na Godot que três ataques apagam a chama comprida e atualizam o placar.

## Focos maiores e nova animação — 11/11/2026

- Aumentei os focos de fogo e acrescentei uma animação de chama comprida usando sprite-fogo.png.
- Acelerei a propagação e aumentei o limite de focos; mantive uma distância mínima do jogador e dos equipamentos.
- Com auxílio do Codex, testei o surgimento dos focos e os três ataques necessários para apagar a nova chama.

## Iluminação noturna — 11/11/2026

- Escureci o cenário e acrescentei luzes quentes aos focos de incêndio, com auxílio do Codex.
- Ao apagar uma chama, a luz correspondente também desaparece.


## Finalização da versão jogável — 17/11/2026

- Usei recortes dos atlas para os equipamentos, obstáculos e decoração. Cada item vale um ponto e tem uma luz azul.
- Acrescentei efeitos de água, coleta e dano, além de corações, barra de progresso e telas de resultado com reinício.
- Com auxílio do Codex, verifiquei os pontos de coleta, 20 coletas por contato, dano, vitória, derrota e reinício na Godot.
