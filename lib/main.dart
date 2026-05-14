import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const LudoBoardGamesApp());
}

class LudoBoardGamesApp extends StatelessWidget {
  const LudoBoardGamesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ludo BoardGames',
      debugShowCheckedModeBanner: false,
      scrollBehavior: MouseScrollBehavior(),
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        colorSchemeSeed: Colors.indigo,
      ),
      home: const BoardGamesScreen(),
    );
  }
}

class MouseScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}

// MODELO DA EDITORA
class GamePublisher {
  final String name;
  final String image;

  const GamePublisher({required this.name, required this.image});

  @override
  bool operator ==(Object other) {
    return other is GamePublisher && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}

// MODELO DO JOGO
class BoardGame {
  final String title;
  final String subtitle;
  final String price;
  final GamePublisher publisher;
  final String image;
  final String description;

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

const publishers = [asmodee, jellyMonster, paperGames, devir];

// DADOS DOS JOGOS
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
class BoardGamesScreen extends StatefulWidget {
  const BoardGamesScreen({super.key});

  @override
  State<BoardGamesScreen> createState() => _BoardGamesScreenState();
}

class _BoardGamesScreenState extends State<BoardGamesScreen> {
  GamePublisher? selectedPublisher = null;
  String searchText = '';
  bool isGrid = false;

  List<BoardGame> get filteredGames {
    return boardGames.where((game) {
      final matchesPublisher =
          selectedPublisher == null || game.publisher == selectedPublisher;

      final matchesSearch = game.title.toLowerCase().contains(
        searchText.toLowerCase(),
      );

      return matchesPublisher && matchesSearch;
    }).toList();
  }

  String get screenTitle {
    if (selectedPublisher == null) {
      return 'Todos os jogos';
    }

    return 'Jogos ${selectedPublisher!.name}';
  }

  void openDetails(BoardGame game) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BoardGameDetailsScreen(game: game),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      body: SafeArea(
        child: Center(
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
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: publishers.length,
                    separatorBuilder: (context, index) {
                      return const SizedBox(width: 16);
                    },
                    itemBuilder: (context, index) {
                      final publisher = publishers[index];

                      return PublisherCircle(
                        publisher: publisher,
                        selected: selectedPublisher == publisher,
                        onTap: () {
                          setState(() {
                            selectedPublisher = publisher;
                          });
                        },
                      );
                    },
                  ),
                ),

                const Divider(height: 1),

                // TÍTULO + BOTÃO DE LIMPAR FILTRO
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 8, 8),
                  child: Row(
                    children: [
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
                      IconButton(
                        onPressed: () {
                          setState(() {
                            isGrid = !isGrid;
                          });
                        },
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
                    onChanged: (value) {
                      setState(() {
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
                Expanded(
                  child: filteredGames.isEmpty
                      ? const Center(child: Text('Nenhum jogo encontrado'))
                      : isGrid
                      ? GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: filteredGames.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.82,
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
class BannerImage extends StatelessWidget {
  const BannerImage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 95,
      child: Image.asset(
        'assets/images/banner-boardgames.jpg',
        fit: BoxFit.cover,
      ),
    );
  }
}

// COMPONENTE DO CÍRCULO DA EDITORA
class PublisherCircle extends StatelessWidget {
  final GamePublisher publisher;
  final bool selected;
  final VoidCallback onTap;

  const PublisherCircle({
    super.key,
    required this.publisher,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 72,
        height: 72,
        margin: const EdgeInsets.only(top: 8, bottom: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: selected
              ? Border.all(color: const Color(0xFF394374), width: 3)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.16),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipOval(
          child: Image.asset(publisher.image, fit: BoxFit.contain),
        ),
      ),
    );
  }
}

// COMPONENTE DO CARD DO JOGO
class BoardGameCard extends StatelessWidget {
  final BoardGame game;
  final VoidCallback onTap;

  const BoardGameCard({super.key, required this.game, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
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
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              GameCover(image: game.image, width: 72, height: 72),
              const SizedBox(width: 16),
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
                        color: Color(0xFF8B8C98),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      game.price,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3A913F),
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
class BoardGameGridCard extends StatelessWidget {
  final BoardGame game;
  final VoidCallback onTap;

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
          child: Column(
            children: [
              GameCover(image: game.image, width: 100, height: 80),

              const SizedBox(height: 10),

              Text(
                game.title,
                textAlign: TextAlign.center,
                maxLines: 1,
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
class GameCover extends StatelessWidget {
  final String image;
  final double width;
  final double height;

  const GameCover({
    super.key,
    required this.image,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Image.asset(
        image,
        width: width,
        height: height,
        fit: BoxFit.cover,
      ),
    );
  }
}

// SEGUNDA TELA: DETALHES DO JOGO
class BoardGameDetailsScreen extends StatelessWidget {
  final BoardGame game;

  const BoardGameDetailsScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      appBar: AppBar(
        title: const Text('Detalhes do jogo'),
        backgroundColor: const Color(0xFFF7F7FB),
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: GameCover(
                      image: game.image,
                      width: 180,
                      height: 180,
                    ),
                  ),

                  const SizedBox(height: 24),

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

                  Text(
                    game.subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF8B8C98),
                    ),
                  ),

                  const SizedBox(height: 16),

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
                          height: 1.4,
                          color: Color(0xFF444654),
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  FilledButton.icon(
                    onPressed: () {
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
