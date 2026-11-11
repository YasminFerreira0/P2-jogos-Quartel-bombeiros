# Quartel em Chamas

Projeto de Jogos Digitais II — Yasmin Da Cunha Ferreira, matrícula 802.481.

## Carta

- Tema: quartel de bombeiros com chamas vivas.
- Tipo: coleta.
- Modo: horda, visto de cima.

## Objetivo do jogo

Colete 20 equipamentos que surgem pela arena enquanto o bombeiro evita as chamas vivas. A partida termina em vitória ao coletar os 20 itens e em derrota quando a vida acaba.

## Estado das aulas 08 a 10

A cena inicial apresenta a arena, o quartel e o bombeiro. O personagem anda em quatro direções, a câmera acompanha o movimento e as colisões impedem a passagem pelo limite da arena e pela base do quartel.

As chamas perseguem o bombeiro, contornam a base do quartel e surgem em intervalos cada vez menores. O bombeiro começa com três vidas e fica invulnerável por um segundo após receber dano. Há até três equipamentos disponíveis por vez; novos itens surgem ao longo da partida. As chamas e os equipamentos usam desenhos provisórios.

Para testar, abra `project.godot` na Godot 4.6 e pressione **F5**. Use **WASD** ou as **setas** para movimentar o bombeiro e **Espaço** para apagar chamas próximas. O placar mostra a vida, os itens coletados e as chamas apagadas. A vitória continua dependendo da coleta de 20 itens.

A navegação foi desenhada para os limites atuais da arena e para a base do quartel. Se esses obstáculos forem alterados ou novos obstáculos forem adicionados, é necessário atualizar o polígono do nó `Navegacao`.

## Créditos e processo

- O cenário e o personagem utilizam os arquivos de arte presentes na pasta `sprites/`. A origem, autoria e licença desses arquivos ainda precisam ser registradas pela autora do projeto.
- A organização do cenário, as colisões e o shader de transparência foram desenvolvidos com auxílio do Codex (OpenAI). O shader mantém o atlas original intacto.
- As técnicas de movimentação, câmera, colisão, horda, vida e coleta seguem os roteiros das aulas 08, 09 e 10 de Jogos Digitais II, do professor Ezéfferth C. A. Fernandes, com auxílio do Codex (OpenAI).
