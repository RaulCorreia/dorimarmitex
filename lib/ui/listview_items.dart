import 'package:Dorimarmitex/database/repository_service_item.dart';
import 'package:Dorimarmitex/models/item.dart';
import 'package:flutter/material.dart';
import 'package:Dorimarmitex/editItem.dart';
import 'package:Dorimarmitex/main.dart';

class ListViewItems extends StatefulWidget {
  List<Item> items;
  List<Item> _selected;
  VoidCallback _refresh;
  ListViewItems(this.items, this._selected, this._refresh);

  @override
  _ListViewItemsState createState() => _ListViewItemsState();
}

class _ListViewItemsState extends State<ListViewItems> {
  void removeItem(index) {
    Item removed = widget.items.removeAt(index);
    RepositoryServiceItem.deleteItem(removed);
    widget._selected.remove(removed);
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.green.withOpacity(0.6),
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.edit,
              color: Colors.black,
            )
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.redAccent.withOpacity(0.6),
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.black,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  // @override
  // initState() {
  //   super.initState();
  //   RepositoryServiceItem.getActivedItems().then((result) {
  //     setState(() {
  //       result.forEach((item) {
  //         widget.items.add(item);
  //       });
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (BuildContext ctxt, int index) {
          final item = widget.items[index];
          var tipo = "";

          if (widget.items[index].tipo == 0)
            tipo = "Carbo";
          else if (widget.items[index].tipo == 1)
            tipo = "Proteina";
          else
            tipo = "Especial";

          return Dismissible(
            child: CheckboxListTile(
              title: Row(children: <Widget>[
                Text(item.nome, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(" - " + tipo, style: TextStyle(color: item.tipo == 0? Colors.blue : item.tipo == 1? Colors.red : Colors.yellow.shade700))
              ]),
              value: item.selec,
              onChanged: (value) {
                setState(() {
                  item.selec = value;
                });
                if (value) {
                  widget._selected.add(item);
                } else {
                  widget._selected.remove(item);
                }
              },
            ),
            key: Key(item.nome),
            background: slideRightBackground(),
            secondaryBackground: slideLeftBackground(),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.endToStart) {
                final bool res = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text(
                            "Tem certeza que deseja excluir o item ${item.nome}?"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text(
                              "Cancelar",
                              style: TextStyle(color: Colors.black),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                            child: Text(
                              "Deletar",
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () {
                              // TODO: deletar item do bd
                              setState(() {
                                removeItem(index);
                              });

                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
                return res;
              } else {
                // TODO: abrir a pagina de editar
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditItem(item, widget.items)))
                    .then((nada) {
                  widget._refresh();
                });
                return false;
              }
            },
          );
        },
      ),
    );
  }
}
