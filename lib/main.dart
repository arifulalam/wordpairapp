import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(const WordPairApp());

class WordPairApp extends StatelessWidget {
  const WordPairApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Word Pair App',
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  //final wordPair = WordPair.random();
  final wordPair = <WordPair>[];
  final savedWordPairs = <WordPair>{};
  
  Widget _buildList(){
    wordPair.addAll(generateWordPairs().take(30));
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: wordPair.length,
      itemBuilder: (context, item){
        if(item.isOdd) return const Divider();

        final index = item ~/ 2;

        if(index >= wordPair.length){
          wordPair.addAll((generateWordPairs().take(10)));
        }
        return _buildRow(wordPair[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair){
    final savedWords = savedWordPairs.contains(pair);

    return ListTile(
      title: Text(pair.asPascalCase,
          style: const TextStyle(
            fontSize: 18,
          ),
      ),
      trailing: Icon(
        savedWords ? Icons.favorite : Icons.favorite_border,
        color: savedWords ? Colors.red : null,
      ),
      onTap: (){
        setState((){
          savedWords ? savedWordPairs.remove(pair) : savedWordPairs.add(pair);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Pair Generator'),
        centerTitle: true,
        backgroundColor: Colors.green,
        titleSpacing: 3,
        titleTextStyle: const TextStyle(color: Colors.yellowAccent, fontSize: 20),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) {
                    final  Iterable<ListTile> tiles =
                    savedWordPairs.map((WordPair pair){
                      return ListTile(
                        title: Text(pair.asPascalCase,
                            style: const TextStyle(
                              fontSize: 16,
                            )
                        ),
                      );
                    });

                    final List<Widget> divided = ListTile.divideTiles(
                      context: context,
                      tiles: tiles,
                    ).toList();

                    return Scaffold(
                      appBar: AppBar(
                        title: const Text('Saved WordPairs',)
                      ),
                      body: ListView(children: divided,)
                    );
              }));
            },
          )
        ],
      ),
      body: _buildList(),
    );
  }
}
