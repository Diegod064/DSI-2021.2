// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:startup_namer/editar.dart';

void main() {
  runApp(const MyApp());
}

class Argumentos {
  final WordPair nome;
  Argumentos(this.nome);
}

class Repositorio {
  Iterable<WordPair> palavra;
  Repositorio(this.palavra);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      // home: RandomWords(),
      routes: {
        '/': (context) => const RandomWords(),
        PaginaEditar.routeName: (context) =>  PaginaEditar(),
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
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>[];
  final repo = Repositorio(generateWordPairs().take(20)).palavra.toList();
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
      itemCount: 20,
      itemBuilder: (context, i) {
        // if (i.isOdd) return const Divider();

        final index = i ~/ 1;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(20));
        }

        final alreadySaved = _saved.contains(repo.elementAt(index));
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context,"/editar", 
            arguments: Argumentos(repo[index]),
            );
          },
          child: Card(
            child: ListTile(
              title: Text(
                repo.elementAt(index).asPascalCase,
                style: _biggerFont,
              ),
              trailing: IconButton(
                onPressed: () {
                  setState(() {
                    if (alreadySaved) {
                      _saved.remove(repo.elementAt(index));
                    } else {
                      _saved.add(repo.elementAt(index));
                    }
                  });
                },
                icon: Icon(
                  alreadySaved ? Icons.favorite : Icons.favorite_border,
                  color: alreadySaved ? Colors.red : null,
                  semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
                ),
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
      itemCount: 20,
      itemBuilder: (context, i) {
        final index = i;
        final alreadySaved = _saved.contains(repo.elementAt(index));
        return Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                repo.elementAt(index).asPascalCase,
                style: _biggerFont,
              ),
              const SizedBox(height: 10),
              IconButton(
                onPressed: () {
                  setState(() {
                    if (alreadySaved) {
                      _saved.remove(repo.elementAt(index));
                    } else {
                      _saved.add(repo.elementAt(index));
                    }
                  });
                },
                icon: Icon(
                  alreadySaved ? Icons.favorite : Icons.favorite_border,
                  color: alreadySaved ? Colors.red : null,
                  semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
                ),
              )
            ],
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
