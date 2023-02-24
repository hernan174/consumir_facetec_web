import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';

final data = {
  '63d3dfe87c142d02f4ce2afd': 'Hernan',
  '63206b3536da6c59a8cc9dae': 'Hugo',
  '632af5647b28f8c7e6e57007': 'hugo 1',
  '63d4e0ea7c142d02f4ce2b41': 'hugo 2',
  '632afdb9ffefb367c53ee646': 'Luis',
  '633eb8506863305a79497faf': 'Luis 1',
  '634807f22a3822dc1ea6aeff': 'Luis 2',
};
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Selecciona un usuario',
            ),
            ...data.entries.map((e) => GestureDetector(
                onTap: () async {
                  await Permission.camera.request();
                  if (mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Facetec(
                                valor: e.key,
                              )),
                    );
                  }
                },
                child: _Item(
                  valor: e.value,
                  clave: e.key,
                ))),
          ],
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.valor,
    required this.clave,
  });
  final String valor;
  final String clave;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 1), borderRadius: BorderRadius.circular(7)),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Column(
        children: [
          Text(
            valor,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            clave,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}

class Facetec extends StatefulWidget {
  const Facetec({
    super.key,
    required this.valor,
  });
  final String valor;

  @override
  State<Facetec> createState() => _FacetecState();
}

class _FacetecState extends State<Facetec> {
  String _url = '';
  late InAppWebViewController _webViewController;
  @override
  void initState() {
    _url = 'https://documentos.cdmisiones.net.ar/pruebaFace/${widget.valor}';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Page'),
      ),
      body: Center(
        child: InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri(_url)),
          initialSettings: InAppWebViewSettings(
            mediaPlaybackRequiresUserGesture: false,
          ),
          // initialOptions: InAppWebViewGroupOptions(
          //   crossPlatform: InAppWebViewOptions(
          //     mediaPlaybackRequiresUserGesture: false,
          //     // debuggingEnabled: true,
          //   ),
          // ),
          onWebViewCreated: (InAppWebViewController controller) {
            _webViewController = controller;
          },

          onPermissionRequest: (controller, permissionRequest) async {
            return PermissionResponse(
                resources: [PermissionResourceType.CAMERA],
                action: PermissionResponseAction.GRANT);
          },
        ),
      ),
    );
  }
}
