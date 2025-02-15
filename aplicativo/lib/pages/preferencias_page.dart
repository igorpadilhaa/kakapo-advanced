import 'package:flutter/material.dart';
import 'package:aplicativo/generated/l10n.dart';

class PreferenciasPage extends StatelessWidget {
  final VoidCallback toggleTheme;
  final Function(String) changeLanguage;

  const PreferenciasPage({
    required this.toggleTheme,
    required this.changeLanguage,
  });

  @override
  Widget build(BuildContext context) {
    String currentLanguageCode = Localizations.localeOf(context).languageCode;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Usando o S.of(context) para traduções
          Text(
            S.of(context).preferences, // Usando a chave traduzida
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontSize: 24,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: toggleTheme,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
            ),
            child: Text(
              S.of(context).toggleTheme, // Usando a chave traduzida
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            S.of(context).language, // Usando a chave traduzida
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          SizedBox(height: 10),
          DropdownButton<String>(
            value: currentLanguageCode,
            icon: Image.asset(
              'assets/images/mundo.png', // Caminho para a imagem do ícone
              width: 24,
              height: 24,
            ),
            items: [
              DropdownMenuItem(
                value: 'en',
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/ingles.png', // Caminho para a imagem do idioma
                      width: 24,
                      height: 24,
                    ),
                    SizedBox(width: 8), // Espaço entre a imagem e o texto
                    Text(S.of(context).english), // Traduzido
                  ],
                ),
              ),
              DropdownMenuItem(
                value: 'pt',
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/portugues.png', // Caminho para a imagem do idioma
                      width: 24,
                      height: 24,
                    ),
                    SizedBox(width: 8), // Espaço entre a imagem e o texto
                    Text(S.of(context).portuguese), // Traduzido
                  ],
                ),
              ),
              DropdownMenuItem(
                value: 'es',
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/espanhol.png', // Caminho para a imagem do idioma
                      width: 24,
                      height: 24,
                    ),
                    SizedBox(width: 8), // Espaço entre a imagem e o texto
                    Text(S.of(context).spanish), // Traduzido
                  ],
                ),
              ),
            ],
            onChanged: (String? newLanguage) {
              if (newLanguage != null) {
                changeLanguage(newLanguage);
              }
            },
          ),
        ],
      ),
    );
  }
}
