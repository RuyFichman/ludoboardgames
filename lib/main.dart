// Importa tipos de baixo nível de UI do Dart, como PointerDeviceKind,
// que representa os tipos de dispositivos de entrada (touch, mouse, etc.)
import 'dart:ui';

// Importa o pacote principal do Flutter com todos os widgets do Material Design
import 'package:flutter/material.dart';

// Ponto de entrada do app Flutter — é a primeira função chamada ao iniciar
void main() {
  // runApp recebe o widget raiz e coloca ele na tela
  runApp(const LudoBoardGamesApp());
}

// Widget raiz do aplicativo — StatelessWidget porque não precisa guardar estado
class LudoBoardGamesApp extends StatelessWidget {
  const LudoBoardGamesApp({super.key});

  // O método build descreve como este widget aparece na tela
  @override
  Widget build(BuildContext context) {
    // MaterialApp é o widget que configura o app inteiro: tema, título, rota inicial, etc.
    return MaterialApp(
      title: 'Ludo BoardGames',
      // Remove a faixa vermelha de "DEBUG" que aparece no canto da tela
      debugShowCheckedModeBanner: false,
      // Usa um comportamento de scroll personalizado (definido abaixo)
      scrollBehavior: MouseScrollBehavior(),
      // ThemeData define o visual global do app: fonte, cores, versão do Material
      theme: ThemeData(
        // Usa a versão mais recente do Material Design (Material 3)
        useMaterial3: true,
        fontFamily: 'Arial',
        // Gera uma paleta de cores completa a partir da cor semente (índigo)
        colorSchemeSeed: Colors.indigo,
      ),
      // Define qual tela é exibida ao abrir o app
      home: const BoardGamesScreen(),
    );
  }
}

// Classe que estende o comportamento padrão de scroll do Material Design
// para permitir arrastar com mouse e trackpad, não apenas com toque
class MouseScrollBehavior extends MaterialScrollBehavior {
  // Sobrescreve a propriedade que define quais dispositivos podem fazer scroll/drag
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,    // Telas sensíveis ao toque
    PointerDeviceKind.mouse,    // Mouse
    PointerDeviceKind.trackpad, // Trackpad do notebook
  };
}

// MODELO DA EDITORA
// Classe de dados que representa uma editora de jogos
class GamePublisher {
  final String name;  // Nome da editora
  final String image; // Caminho da imagem/logo da editora

  const GamePublisher({required this.name, required this.image});

  // Sobrescreve o operador == para comparar editoras pelo nome
  // Sem isso, duas instâncias com o mesmo nome seriam consideradas diferentes
  @override
  bool operator ==(Object other) {
    return other is GamePublisher && other.name == name;
  }

  // Sempre que se sobrescreve ==, também é preciso sobrescrever hashCode
  // Garante que objetos iguais tenham o mesmo hash (necessário para usar em Sets/Maps)
  @override
  int get hashCode => name.hashCode;
}

// MODELO DO JOGO
// Classe de dados que representa um jogo de tabuleiro
class BoardGame {
  final String title;           // Título do jogo
  final String subtitle;        // Subtítulo ou categoria
  final String price;           // Preço formatado como texto
  final GamePublisher publisher; // Editora responsável pelo jogo
  final String image;           // Caminho da imagem da capa
  final String description;     // Descrição do jogo

  const BoardGame({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.publisher,
    required this.image,
    required this.description,
  });
}

// DADOS DAS EDITORAS
// Instâncias constantes de cada editora — criadas uma vez e reutilizadas
const asmodee = GamePublisher(
  name: 'Asmodee',
  image: 'assets/images/asmodee.png',
);

const jellyMonster = GamePublisher(
  name: 'Jelly Monster',
  image: 'assets/images/jelly-monster.webp',
);

const paperGames = GamePublisher(
  name: 'PaperGames',
  image: 'assets/images/papergames.png',
);

const devir = GamePublisher(name: 'Devir', image: 'assets/images/devir.png');

// Lista com todas as editoras — usada para montar a fila horizontal de filtros
const publishers = [asmodee, jellyMonster, paperGames, devir];

// DADOS DOS JOGOS
// Lista constante com todos os jogos disponíveis no app
const boardGames = [
  BoardGame(
    title: 'Wandering Towers',
    subtitle: 'Magos das torres',
    price: 'R\$ 399,00',
    publisher: jellyMonster,
    image: 'assets/images/wandering-towers.webp',
    description:
        'Um jogo de estratégia com magos, torres móveis e muita interação entre os jogadores.',
  ),
  BoardGame(
    title: 'Tokyo Highway',
    subtitle: 'Construção de pistas',
    price: 'R\$ 399,00',
    publisher: jellyMonster,
    image: 'assets/images/tokyo-highway.webp',
    description:
        'Construa vias, pontes e rotas em uma disputa visual de habilidade e planejamento.',
  ),
  BoardGame(
    title: 'Dixit',
    subtitle: 'Criatividade visual',
    price: 'R\$ 275,00',
    publisher: asmodee,
    image: 'assets/images/dixit.png',
    description:
        'Um jogo criativo de cartas ilustradas, associação de ideias e imaginação.',
  ),
  BoardGame(
    title: 'Ticket to Ride',
    subtitle: 'Estratégia ferroviária',
    price: 'R\$ 225,00',
    publisher: asmodee,
    image: 'assets/images/ticket-to-ride.png',
    description:
        'Monte rotas ferroviárias, conecte cidades e dispute pontos com estratégia.',
  ),
  BoardGame(
    title: 'Munchkin',
    subtitle: 'RPG humorístico',
    price: 'R\$ 199,00',
    publisher: paperGames,
    image: 'assets/images/munchkin.png',
    description:
        'Um jogo de cartas divertido, com monstros, tesouros e muito humor.',
  ),
  BoardGame(
    title: 'Catan',
    subtitle: 'Negociação estratégica',
    price: 'R\$ 299,00',
    publisher: devir,
    image: 'assets/images/catan.png',
    description:
        'Colete recursos, construa estradas e negocie para dominar a ilha de Catan.',
  ),
];

// TELA PRINCIPAL
// StatefulWidget porque a tela precisa reagir a mudanças (filtro, busca, modo de exibição)
class BoardGamesScreen extends StatefulWidget {
  const BoardGamesScreen({super.key});

  // Cria o objeto de estado associado a este widget
  @override
  State<BoardGamesScreen> createState() => _BoardGamesScreenState();
}

// Estado da tela principal — aqui ficam os dados que mudam em tempo real
class _BoardGamesScreenState extends State<BoardGamesScreen> {
  // Editora selecionada para filtrar os jogos (null = mostrar todos)
  GamePublisher? selectedPublisher = null;

  // Texto digitado pelo usuário no campo de busca
  String searchText = '';

  // Controla se a lista é exibida em grade (true) ou em lista vertical (false)
  bool isGrid = false;

  // Getter que retorna apenas os jogos que batem com o filtro de editora e o texto buscado
  List<BoardGame> get filteredGames {
    return boardGames.where((game) {
      // Se nenhuma editora está selecionada, aceita qualquer jogo; senão compara editoras
      final matchesPublisher =
          selectedPublisher == null || game.publisher == selectedPublisher;

      // Verifica se o título do jogo contém o texto buscado (sem diferenciar maiúsculas)
      final matchesSearch = game.title.toLowerCase().contains(
        searchText.toLowerCase(),
      );

      // O jogo só aparece se passar nos dois filtros ao mesmo tempo
      return matchesPublisher && matchesSearch;
    }).toList();
  }

  // Getter que retorna o título da tela de acordo com o filtro ativo
  String get screenTitle {
    if (selectedPublisher == null) {
      return 'Todos os jogos';
    }

    // Quando uma editora está selecionada, o título muda para "Jogos <nome da editora>"
    return 'Jogos ${selectedPublisher!.name}';
  }

  // Abre a tela de detalhes do jogo passado como argumento
  void openDetails(BoardGame game) {
    // Navigator.push empilha uma nova tela sobre a atual (como abrir uma nova página)
    Navigator.push(
      context,
      // MaterialPageRoute define qual widget será a nova tela
      MaterialPageRoute(
        builder: (context) => BoardGameDetailsScreen(game: game),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold fornece a estrutura básica de uma tela (fundo, corpo, appBar, etc.)
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      // SafeArea garante que o conteúdo não fique atrás do notch ou da barra de status
      body: SafeArea(
        child: Center(
          // ConstrainedBox limita a largura máxima a 430px (bom para telas grandes)
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // BANNER
                const BannerImage(),

                const SizedBox(height: 12),

                // LISTA HORIZONTAL DAS EDITORAS
                SizedBox(
                  height: 92,
                  width: double.infinity,
                  // ListView.separated cria uma lista com espaçadores entre os itens
                  child: ListView.separated(
                    // Axis.horizontal faz a lista rolar para os lados
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: publishers.length,
                    // separatorBuilder constrói o espaço entre cada item da lista
                    separatorBuilder: (context, index) {
                      return const SizedBox(width: 16);
                    },
                    // itemBuilder constrói cada item da lista com base no índice
                    itemBuilder: (context, index) {
                      final publisher = publishers[index];

                      return PublisherCircle(
                        publisher: publisher,
                        // Compara se esta editora é a selecionada para destacar visualmente
                        selected: selectedPublisher == publisher,
                        onTap: () {
                          // setState avisa o Flutter que o estado mudou e redesenha a tela
                          setState(() {
                            selectedPublisher = publisher;
                          });
                        },
                      );
                    },
                  ),
                ),

                // Linha fina horizontal para separar visualmente as seções
                const Divider(height: 1),

                // TÍTULO + BOTÃO DE LIMPAR FILTRO
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 8, 8),
                  child: Row(
                    children: [
                      // Expanded faz o texto ocupar todo o espaço disponível na linha
                      Expanded(
                        child: Text(
                          screenTitle,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF202333),
                          ),
                        ),
                      ),
                      // Botão que alterna entre exibição em lista e em grade
                      IconButton(
                        onPressed: () {
                          setState(() {
                            // Inverte o valor booleano: lista vira grade e vice-versa
                            isGrid = !isGrid;
                          });
                        },
                        // O ícone muda conforme o modo atual
                        icon: Icon(
                          isGrid ? Icons.view_list : Icons.grid_view,
                          color: const Color(0xFF394374),
                        ),
                      ),
                    ],
                  ),
                ),

                // CAMPO DE BUSCA
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    // onChanged é chamado toda vez que o usuário digita algo
                    onChanged: (value) {
                      setState(() {
                        // Atualiza o texto de busca para filtrar os jogos
                        searchText = value;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Nome do Jogo',
                      suffixIcon: Icon(Icons.search),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // LISTA VERTICAL DOS JOGOS
                // Expanded faz a lista ocupar todo o espaço vertical restante
                Expanded(
                  child: filteredGames.isEmpty
                      // Se não há jogos no filtro, exibe uma mensagem de aviso
                      ? const Center(child: Text('Nenhum jogo encontrado'))
                      // Se isGrid for true, exibe em grade; senão, em lista
                      : isGrid
                      // GridView.builder constrói a grade de forma eficiente (sob demanda)
                      ? GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: filteredGames.length,
                          // SliverGridDelegate configura o número de colunas e espaçamentos
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,      // 2 colunas
                                crossAxisSpacing: 12,   // Espaço horizontal entre cards
                                mainAxisSpacing: 12,    // Espaço vertical entre cards
                                childAspectRatio: 0.82, // Proporção largura/altura de cada card
                              ),
                          itemBuilder: (context, index) {
                            final game = filteredGames[index];

                            return BoardGameGridCard(
                              game: game,
                              onTap: () {
                                openDetails(game);
                              },
                            );
                          },
                        )
                      // ListView.builder constrói apenas os itens visíveis (eficiente para listas grandes)
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: filteredGames.length,
                          itemBuilder: (context, index) {
                            final game = filteredGames[index];

                            return BoardGameCard(
                              game: game,
                              onTap: () {
                                openDetails(game);
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// COMPONENTE DO BANNER
// Widget reutilizável que exibe a imagem de banner no topo da tela principal
class BannerImage extends StatelessWidget {
  const BannerImage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Ocupa toda a largura disponível
      height: 95,
      // Image.asset carrega uma imagem que está na pasta assets do projeto
      child: Image.asset(
        'assets/images/banner-boardgames.jpg',
        // BoxFit.cover faz a imagem preencher todo o espaço, cortando as bordas se necessário
        fit: BoxFit.cover,
      ),
    );
  }
}

// COMPONENTE DO CÍRCULO DA EDITORA
// Widget que exibe o logo da editora em formato circular, com destaque quando selecionada
class PublisherCircle extends StatelessWidget {
  final GamePublisher publisher; // Dados da editora
  final bool selected;           // Se está selecionada (exibe borda)
  final VoidCallback onTap;      // Função chamada ao tocar no círculo

  const PublisherCircle({
    super.key,
    required this.publisher,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // GestureDetector detecta gestos do usuário, aqui usamos o toque (onTap)
    return GestureDetector(
      onTap: onTap,
      // AnimatedContainer anima suavemente qualquer mudança de estilo (ex: borda ao selecionar)
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200), // Duração da animação
        width: 72,
        height: 72,
        margin: const EdgeInsets.only(top: 8, bottom: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle, // Forma circular
          // Exibe borda azul escura se a editora estiver selecionada
          border: selected
              ? Border.all(color: const Color(0xFF394374), width: 3)
              : null,
          // Sombra para dar profundidade ao círculo
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.16),
              blurRadius: 8,
              offset: const Offset(0, 3), // Deslocamento da sombra (x, y)
            ),
          ],
        ),
        // ClipOval recorta o conteúdo filho em formato oval/circular
        child: ClipOval(
          child: Image.asset(publisher.image, fit: BoxFit.contain),
        ),
      ),
    );
  }
}

// COMPONENTE DO CARD DO JOGO
// Exibe um jogo em formato de linha horizontal (modo lista)
class BoardGameCard extends StatelessWidget {
  final BoardGame game;     // Dados do jogo
  final VoidCallback onTap; // Função chamada ao tocar no card

  const BoardGameCard({super.key, required this.game, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Card é um widget com fundo branco, bordas arredondadas e sombra opcional
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 0, // Sem sombra (a borda já delimita o card)
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFFE7E7EF)), // Borda cinza suave
      ),
      // InkWell adiciona o efeito de "onda" (ripple) ao tocar no card
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Imagem da capa do jogo
              GameCover(image: game.image, width: 72, height: 72),
              const SizedBox(width: 16),
              // Expanded faz o texto ocupar o espaço restante após a imagem
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF252638),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      game.subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF8B8C98), // Cinza para subtítulo
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      game.price,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3A913F), // Verde para o preço
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// COMPONENTE DO CARD EM GRID
// Exibe um jogo em formato de coluna vertical (modo grade)
class BoardGameGridCard extends StatelessWidget {
  final BoardGame game;     // Dados do jogo
  final VoidCallback onTap; // Função chamada ao tocar no card

  const BoardGameGridCard({super.key, required this.game, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFFE7E7EF)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          // Column empilha os elementos verticalmente (imagem + textos)
          child: Column(
            children: [
              GameCover(image: game.image, width: 100, height: 80),

              const SizedBox(height: 10),

              Text(
                game.title,
                textAlign: TextAlign.center,
                maxLines: 1, // Limita a 1 linha
                // TextOverflow.ellipsis coloca "..." quando o texto é muito longo
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF252638),
                ),
              ),

              const SizedBox(height: 4),

              Text(
                game.subtitle,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: Color(0xFF8B8C98)),
              ),

              const SizedBox(height: 6),

              Text(
                game.price,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3A913F),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// COMPONENTE DA CAPA DO JOGO COM IMAGEM REAL
// Widget reutilizável que exibe a imagem de capa com bordas arredondadas
class GameCover extends StatelessWidget {
  final String image;  // Caminho da imagem no assets
  final double width;  // Largura desejada
  final double height; // Altura desejada

  const GameCover({
    super.key,
    required this.image,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    // ClipRRect recorta o filho com bordas arredondadas
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Image.asset(
        image,
        width: width,
        height: height,
        // BoxFit.cover preenche o espaço inteiro, mantendo a proporção e cortando o excesso
        fit: BoxFit.cover,
      ),
    );
  }
}

// SEGUNDA TELA: DETALHES DO JOGO
// Tela que exibe todas as informações de um jogo específico
class BoardGameDetailsScreen extends StatelessWidget {
  final BoardGame game; // Jogo recebido da tela anterior via navegação

  const BoardGameDetailsScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      // AppBar é a barra superior da tela com título e botão de voltar automático
      appBar: AppBar(
        title: const Text('Detalhes do jogo'),
        backgroundColor: const Color(0xFFF7F7FB),
        elevation: 0, // Sem sombra abaixo da AppBar
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Padding(
              padding: const EdgeInsets.all(16),
              // CrossAxisAlignment.stretch faz os filhos ocuparem toda a largura
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Capa do jogo centralizada e maior do que nos cards
                  Center(
                    child: GameCover(
                      image: game.image,
                      width: 180,
                      height: 180,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Título do jogo em destaque
                  Text(
                    game.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF202333),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Subtítulo em cinza abaixo do título
                  Text(
                    game.subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF8B8C98),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Preço em verde e em tamanho maior
                  Text(
                    game.price,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3A913F),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Card com a descrição do jogo
                  Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: const BorderSide(color: Color(0xFFE7E7EF)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        game.description,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.4, // Espaçamento entre linhas (1.4x o tamanho da fonte)
                          color: Color(0xFF444654),
                        ),
                      ),
                    ),
                  ),

                  // Spacer empurra tudo acima para cima e o botão para o fundo da tela
                  const Spacer(),

                  // Botão preenchido com ícone — FilledButton tem fundo colorido por padrão
                  FilledButton.icon(
                    onPressed: () {
                      // ScaffoldMessenger exibe uma SnackBar (mensagem temporária na base da tela)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${game.title} foi adicionado ao carrinho.',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text('Comprar / Acessar jogo'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
