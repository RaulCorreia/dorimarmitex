import 'package:Dorimarmitex/database/database_creator.dart';
import 'package:Dorimarmitex/database/repository_service_item.dart';
import 'package:Dorimarmitex/models/item.dart';
import 'package:Dorimarmitex/ui/listview_items.dart';
import 'package:flutter/material.dart';
import 'package:Dorimarmitex/addItem.dart';
import 'package:flutter/services.dart';
import './util/images.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseCreator().initDatabase();
  runApp(MyApp());
}

// ADD launch screen

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marmitaria da Dori',
      theme: ThemeData(
          primarySwatch: Colors.red,
          brightness: Brightness.light,
          accentColor: Colors.redAccent),
      home: HomePage(), //MyHomePage(title: 'Cardapio da Dori'),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Item> items = new List();
  List<Item> _selected = new List();
  static const platform = const MethodChannel('flutter.dev/dorimarmitex');

  @override
  initState() {
    super.initState();
    refresh();
  }

  refresh() {
    _selected.clear();
    items.clear();
    RepositoryServiceItem.getActivedItems().then((result) {
      setState(() {
        result.forEach((item) {
          items.add(item);
        });
      });
    });
  }

  void _generateImage(BuildContext context) async {
    // AssetImage assetImage = AssetImage('assets/cardapio-img.jpg');
    // var image = new Image(image: assetImage);
    if (_selected.length > 0) {
      createImage(context, _selected, platform);
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Atenção"),
              content: Text("Ao menos 1 item deve ser selecionado"),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Ok'),
                )
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cardapio da Dori'),
        actions: <Widget>[
          new IconButton(
              color: Colors.white,
              icon: new Icon(Icons.add_photo_alternate),
              tooltip: 'Gerar Imagem',
              onPressed: () {
                _generateImage(context);
              }),
        ],
      ),
      body: ListViewItems(items, _selected, refresh),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // RepositoryServiceItem.itemsCount().then((value) {
          //   print(value);
          // });
          Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddItem()))
              .then((nada) {
            refresh();
          });
        },
        tooltip: 'Adicionar Item',
        child: Icon(Icons.add),
      ),
    );
  }
}
