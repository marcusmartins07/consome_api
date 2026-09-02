import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Curiosidades de Gatos',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        useMaterial3: true,
      ),
      home: const CatFactsPage(),
    );
  }
}

class CatFactsPage extends StatefulWidget {
  const CatFactsPage({super.key});

  @override
  State<CatFactsPage> createState() => _CatFactsPageState();
}

class _CatFactsPageState extends State<CatFactsPage> {
  String _curiosidade = 'Clique no botão para ver uma curiosidade sobre gatos!';
  bool _carregando = false;

  Future<void> _buscarCuriosidade() async {
    setState(() {
      _carregando = true;
    });

    try {
      final response =
          await http.get(Uri.parse('https://meowfacts.herokuapp.com/'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final fato = data['data'][0];
        setState(() {
          _curiosidade = fato;
        });
      } else {
        setState(() {
          _curiosidade = 'Erro ao buscar curiosidade. Tente novamente.';
        });
      }
    } catch (e) {
      setState(() {
        _curiosidade = 'Erro de conexão. Verifique sua internet.';
      });
    } finally {
      setState(() {
        _carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Curiosidades de Gatos'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.pets, size: 80, color: Colors.deepOrange),
              const SizedBox(height: 24),
              Text(
                _curiosidade,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 32),
              _carregando
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _buscarCuriosidade,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      child: const Text('Nova Curiosidade'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}