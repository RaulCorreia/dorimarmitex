import 'package:Dorimarmitex/models/item.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void createImage(
    BuildContext context, List<Item> _pratos, MethodChannel platform) async {
  bool result = await handle_permissions(context);
  if (result) {
    _addItemsNative(_pratos, platform);

    print('TERMINOU');

    _showMaterialDialog(context, 'Imagem', 'Imagem Gerada...', true);
  }
}

Future<bool> handle_permissions(BuildContext context) async {
  PermissionStatus permission =
      await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);

  if (permission == PermissionStatus.denied) {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);

    if (permissions[PermissionGroup.storage] == PermissionStatus.denied) {
      _showMaterialDialog(
          context,
          'Permissão',
          'Para o aplicativo funcionar corretamente, é necessario conceder a permissão para salvar a imagem.',
          true);
      return false;
    }
  }

  return true;
}

void _showMaterialDialog(
    BuildContext context, String title, String text, bool btn) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: btn
              ? <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Ok'),
                  )
                ]
              : null,
        );
      });
}

Future<void> _addItemsNative(List<Item> items, MethodChannel platform) async {
  for (var item in items) {
    try {
      final String result = await platform
          .invokeMethod('addItems', {"nome": item.nome, "tipo": item.tipo});
      print(result);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  _writeImage(platform);
}

Future<void> _writeImage(MethodChannel platform) async {
  try {
    final String result = await platform.invokeMethod('writeImage');
    print(result);
  } on PlatformException catch (e) {
    print(e);
  }
}
