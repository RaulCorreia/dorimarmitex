import 'package:Dorimarmitex/database/repository_service_item.dart';
import 'package:Dorimarmitex/models/item.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditItem extends StatefulWidget {
  final Item item;
  List<Item> items;
  EditItem(this.item, this.items);

  @override
  _EditItemState createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  var _formKey = GlobalKey<FormState>();

  final double _minimumPadding = 5.0;
  String results = "";
  var _tipos = ['Carboidrato', 'Proteina', 'Especial'];
  var _tipoSelecionado = '';

  var ctrlNome = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tipoSelecionado = _tipos[widget.item.tipo];
    ctrlNome.text = widget.item.nome;
  }

  Widget getImageAsset() {
    AssetImage assetImage = AssetImage('assets/img/top-image.png');
    Image image = Image(image: assetImage, fit: BoxFit.cover);

    return Container(
      child: image,
      margin: EdgeInsets.only(
        bottom: 20.0,
      ),
    );
  }

  void _onDropDownItemSelected(String newValueSelected) {
    setState(() {
      this._tipoSelecionado = newValueSelected;
    });
  }

  void _editItem() {
    if (ctrlNome.text.isEmpty) return;

    String nome = ctrlNome.text;
    int tipo = -1;
    if (this._tipoSelecionado == "Carboidrato") {
      tipo = 0;
    } else if (this._tipoSelecionado == "Proteina") {
      tipo = 1;
    } else {
      tipo = 2;
    }

    RepositoryServiceItem.updateItem(Item(
        id: widget.item.id,
        nome: nome,
        tipo: tipo,
        selec: false,
        oculto: false));

    ctrlNome.clear();
    setState(() {
      this._tipoSelecionado = _tipos[0];
    });

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    return Scaffold(
      appBar: AppBar(
        title: Text('Salvar'),
        backgroundColor: Colors.redAccent,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
            padding: EdgeInsets.all(_minimumPadding * 2),
            child: ListView(
              children: <Widget>[
                getImageAsset(),
                Padding(
                    padding: EdgeInsets.only(
                        top: _minimumPadding, bottom: _minimumPadding),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      style: textStyle,
                      controller: ctrlNome,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Insira algum texto';
                        }
                      },
                      decoration: InputDecoration(
                          labelText: 'Nome',
                          hintText: 'Digite o nome do novo item',
                          labelStyle: textStyle,
                          errorStyle: TextStyle(
                              color: Colors.yellowAccent, fontSize: 15.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        top: _minimumPadding * 3, bottom: _minimumPadding),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: DropdownButton<String>(
                          isExpanded: true,
                          items: _tipos.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(fontSize: 20.0),
                              ),
                            );
                          }).toList(),
                          value: _tipoSelecionado,
                          onChanged: (String newValueSelected) {
                            _onDropDownItemSelected(newValueSelected);
                          },
                        ))
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        bottom: _minimumPadding, top: _minimumPadding * 3),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            color: Theme.of(context).accentColor,
                            textColor: Colors.white,
                            child: Text(
                              'Salvar',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              // TODO salvar
                              _editItem();
                              Fluttertoast.showToast(
                                  msg: "Item Editado",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIos: 1,
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            },
                          ),
                        )
                      ],
                    )),
              ],
            )),
      ),
    );
  }
}
