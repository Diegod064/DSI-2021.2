import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:startup_namer/editar.dart';
import 'package:startup_namer/palavras.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class Argumentos {
  final Repositorio rep;
  final int index;
  final bool isAdd;
  Argumentos(this.rep, this.index, this.isAdd);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const RandomWords(),
        PaginaEditar.routeName: (context) => PaginaEditar(),
      },
    );
  }
}

class RandomWords extends StatefulWidget {
  static const routeName = '/';
  const RandomWords({Key? key}) : super(key: key);

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final Repositorio _suggestions = Repositorio();
  final _saved = <Word>{};
  final _biggerFont = const TextStyle(fontSize: 18);
  var _view = 0;

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _saved.map(
            (pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
                  context: context,
                  tiles: tiles,
                ).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Favoritados'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  listBuilder() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _suggestions.length,
      itemBuilder: (context, i) {
        final index = i ~/ 1;
        final alreadySaved = _saved.contains(_suggestions.index(index));
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              "/editar",
              arguments: Argumentos(_suggestions, index, false),
            ).then(
              (value) {
                setState(() {});
              },
            );
          },
          child: Card(
            child: ListTile(
              title: Text(
                _suggestions.index(index).asPascalCase,
                style: _biggerFont,
              ),
              trailing: Wrap(
                children: [
                  IconButton(
                    icon: Icon(
                      alreadySaved ? Icons.favorite : Icons.favorite_border,
                      color: alreadySaved ? Colors.red : null,
                      semanticLabel:
                          alreadySaved ? 'Remove from saved' : 'Save',
                    ),
                    onPressed: () {
                      setState(() {
                        if (alreadySaved) {
                          _saved.remove(_suggestions.index(index));
                        } else {
                          _saved.add(_suggestions.index(index));
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      semanticLabel: 'Deletado',
                    ),
                    onPressed: () {
                      setState(() {
                        if (alreadySaved) {
                          _saved.remove(_suggestions.index(index));
                        }
                        _suggestions.remove(index);
                      });
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  gridBuilder() {
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _suggestions.length,
      itemBuilder: (context, i) {
        final index = i;
        final alreadySaved = _saved.contains(_suggestions.index(index));
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              "/editar",
              arguments: Argumentos(_suggestions, index, false),
            ).then(
              (value) {
                setState(() {});
              },
            );
          },
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _suggestions.index(index).asPascalCase,
                  style: _biggerFont,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (alreadySaved) {
                            _saved.remove(_suggestions.index(index));
                          } else {
                            _saved.add(_suggestions.index(index));
                          }
                        });
                      },
                      icon: Icon(
                        alreadySaved ? Icons.favorite : Icons.favorite_border,
                        color: alreadySaved ? Colors.red : null,
                        semanticLabel:
                            alreadySaved ? 'Remove from saved' : 'Save',
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        semanticLabel: 'Deletado',
                      ),
                      onPressed: () {
                        setState(() {
                          if (alreadySaved) {
                            _saved.remove(_suggestions.index(index));
                          }
                          _suggestions.remove(index);
                        });
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Startup Name Generator'),
          actions: [
            IconButton(
              icon: const Icon(Icons.list),
              onPressed: _pushSaved,
              tooltip: 'Saved Suggestions',
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  "/editar",
                  arguments: Argumentos(_suggestions, 1, true),
                ).then(
                  (value) {
                    setState(() {});
                  },
                );
              },
              tooltip: 'Add Suggestions',
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(_view == 0 ? Icons.grid_view : Icons.list),
            onPressed: () {
              if (_view == 0) {
                _view = 1;
              } else {
                _view = 0;
              }
              setState(() {});
            }),
        body: _view == 0 ? listBuilder() : gridBuilder());
  }
}
