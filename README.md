# Quartel em Chamas

Projeto de Jogos Digitais II — Yasmin Da Cunha Ferreira, matrícula 802.481.

## Carta

- Tema: quartel de bombeiros com chamas vivas.
- Tipo: coleta.
- Modo: horda, visto de cima.

## Objetivo do jogo

Colete 20 equipamentos que surgem pela arena enquanto o bombeiro evita as chamas vivas. A partida termina em vitória ao coletar os 20 itens e em derrota quando a vida acaba.

## Como jogar

A cena inicial apresenta a arena, o quartel e o bombeiro. O personagem anda em quatro direções, a câmera acompanha o movimento e as colisões impedem a passagem pelo limite da arena e pela base do quartel.

O bombeiro e os primeiros focos de fogo começam diante do quartel. O incêndio se espalha em novos focos pela arena; enquanto o jogador se movimenta, alguns podem surgir à frente do seu caminho. Os focos permanecem no lugar e podem ser contornados ou apagados. Há focos pequenos, apagados com um ataque, e chamas compridas, que precisam de três ataques. O bombeiro começa com quatro corações e recupera um ao coletar o 5º, o 10º e o 15º equipamento, até o máximo de quatro. Após receber dano, ele fica invulnerável por um segundo. Há até três equipamentos disponíveis por vez; novos itens surgem ao longo da partida. As chamas usam os atlas de fogo e de efeitos. Há dez visuais de equipamentos, todos valendo um ponto. A luz azul indica onde encontrar um equipamento. O cenário tem iluminação noturna, e cada foco de fogo ilumina a área ao seu redor.

Para testar, abra `project.godot` na Godot 4.6 e pressione **F5**. Leia as instruções na tela inicial e selecione **Jogar** para começar. Use **WASD** ou as **setas** para movimentar o bombeiro e **Espaço** para apagar chamas próximas. Os corações mostram a vida, e um clarão vermelho indica que você sofreu dano. O placar acompanha o progresso da coleta e os focos apagados. Árvores, barreiras e suprimentos nas quadras têm colisões que podem ser contornadas. A vitória continua dependendo da coleta de 20 itens.

A região `Navegacao` permanece na cena para mecânicas futuras. Os focos atuais ficam parados e se espalham pela criação de novos focos, sem usar perseguição.

## Créditos e processo

- O cenário e o personagem utilizam os arquivos de arte presentes na pasta `sprites/`. A origem, autoria e licença desses arquivos ainda precisam ser registradas pela autora do projeto.
- A organização do cenário, as colisões e o shader de transparência foram desenvolvidos com auxílio do Codex (OpenAI). O shader mantém o atlas original intacto.
- As técnicas de movimentação, câmera, colisão, horda, vida e coleta seguem os roteiros das aulas 08, 09 e 10 de Jogos Digitais II, do professor Ezéfferth C. A. Fernandes, com auxílio do Codex (OpenAI).
