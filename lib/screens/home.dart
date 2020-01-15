import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const request = 'https://api.hgbrasil.com/finance?key=36a8c084';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _realController = TextEditingController();
  final _dolarController = TextEditingController();
  final _euroController = TextEditingController();

  double dolar;
  double euro;

  void _clearFields() {
    setState(() {
      _realController.text = "";
      _dolarController.text = "";
      _euroController.text = "";
    });
  }

  void _changeReal(String valor) {
    double real = double.parse(_realController.text);
    _dolarController.text = (this.dolar * real).toStringAsFixed(2);
    _euroController.text = (this.euro * real).toStringAsFixed(2);
  }

  void _changeDolar(String valor) {
    print(valor);
  }

  void _changeEuro(String valor) {
    print(valor);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.amber,
          inputDecorationTheme: InputDecorationTheme(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 0.5)))),
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text('Conversor de Moedas'),
          backgroundColor: Colors.amber,
          centerTitle: true,
        ),
        body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text("Carregando...",
                      style: TextStyle(color: Colors.amber, fontSize: 25),
                      textAlign: TextAlign.center),
                );
              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Erro ao carregar os dados.",
                        style: TextStyle(color: Colors.amber, fontSize: 25),
                        textAlign: TextAlign.center),
                  );
                } else {
                  dolar = snapshot.data["USD"]["buy"];
                  euro = snapshot.data["EUR"]["buy"];
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(Icons.monetization_on,
                            size: 150, color: Colors.amber),
                        getTextField(
                            'Reais', 'R\$ ', _realController, _changeReal),
                        Divider(),
                        getTextField(
                            'Dolares', 'US\$ ', _dolarController, _changeDolar),
                        Divider(),
                        getTextField(
                            'Euros', '€ ', _euroController, _changeEuro),
                        FlatButton(
                          onPressed: _clearFields,
                          child: Text(
                            'Limpar',
                            style: TextStyle(fontSize: 25, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  );
                }
            }
          },
        ),
      ),
    );
  }

  TextField getTextField(String label, String decorator,
      TextEditingController controllerText, Function onChange) {
    return TextField(
      onChanged: onChange,
      controller: controllerText,
      keyboardType: TextInputType.number,
      style: TextStyle(color: Colors.amber, fontSize: 25),
      decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          labelStyle: TextStyle(color: Colors.amber),
          prefixText: decorator,
          prefixStyle: TextStyle(color: Colors.amber, fontSize: 18)),
    );
  }

  Future<Map> getData() async {
    http.Response response = await http.get(request);
    return jsonDecode(response.body)["results"]["currencies"];
  }
}
