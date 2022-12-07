import 'dart:convert';

import 'package:currency_converter/widgets/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _request = 'https://api.hgbrasil.com/finance?key=76e66d65';

  Future<Map> getData() async {
    http.Response response = await http.get(Uri.parse(_request));
    return json.decode(response.body);
  }

  late double dolar;
  late double euro;
  final realController = TextEditingController();
  final dollarController = TextEditingController();
  final euroController = TextEditingController();

  void _realChanged(String text) {
    double real;
    real = text != '' ? double.parse(text) : 0;
    dollarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void _dollarChanged(String text) {
    double dollar;
    dollar = text != '' ? double.parse(text) : 0;
    realController.text = (dollar * dolar).toStringAsFixed(2);
    euroController.text = (dollar * dolar / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    double euroText;
    euroText = text != '' ? double.parse(text) : 0;
    realController.text = (euroText * euro).toStringAsFixed(2);
    dollarController.text = (euroText * euro / dolar).toStringAsFixed(2);
  }

  void _onTap(TextEditingController _controller) {
    _controller.text = '';
  }

  void _clearAll() {
    realController.text = '';
    euroController.text = '';
    dollarController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '\$ Conversor \$',
          style: TextStyle(color: Colors.amber),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _clearAll,
            color: Colors.amber,
            icon: const Icon(Icons.clear),
          )
        ],
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            default:
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Deu erro!!'),
                );
              }
              dolar = snapshot.data!['results']['currencies']['USD']['buy'];
              euro = snapshot.data!['results']['currencies']['EUR']['buy'];
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.currency_exchange,
                        size: MediaQuery.of(context).size.height * .2,
                        color: Colors.amber,
                      ),
                      const SizedBox(height: 40),
                      CurrencyTextField(
                        label: 'Reais',
                        prefix: 'R\$ ',
                        controller: realController,
                        onChanged: _realChanged,
                        onTap: () {
                          _onTap(realController);
                        },
                      ),
                      const Divider(),
                      CurrencyTextField(
                        label: 'Dólares',
                        prefix: 'USD ',
                        controller: dollarController,
                        onChanged: _dollarChanged,
                        onTap: () {
                          _onTap(dollarController);
                        },
                      ),
                      const Divider(),
                      CurrencyTextField(
                        label: 'Euros',
                        prefix: '€ ',
                        controller: euroController,
                        onChanged: _euroChanged,
                        onTap: () {
                          _onTap(euroController);
                        },
                      ),
                    ],
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}
