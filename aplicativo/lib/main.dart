import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';
import 'package:aplicativo/pages/home_page.dart';
import 'package:aplicativo/pages/estatisticas_page.dart';
import 'package:aplicativo/pages/preferencias_page.dart';

void main() async {
  // Garante que o framework esteja completamente inicializado
  WidgetsFlutterBinding.ensureInitialized();

  // Carrega as preferências do usuário antes de iniciar o app
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;
  final languageCode = prefs.getString('languageCode') ?? 'en';

  // Inicia o app com as preferências carregadas
  runApp(MyApp(
    themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
    locale: Locale(languageCode),
  ));
}

class MyApp extends StatefulWidget {
  final ThemeMode themeMode;
  final Locale locale;

  const MyApp({Key? key, required this.themeMode, required this.locale})
      : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeMode _themeMode;
  late Locale _locale;
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  List<Map<String, dynamic>> pulseiras = [];

  @override
  void initState() {
    super.initState();
    _themeMode = widget.themeMode;
    _locale = widget.locale;
  }

  Future<void> _saveThemePreference(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  Future<void> _saveLanguagePreference(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);
  }

  void toggleTheme() {
    final isDark = _themeMode == ThemeMode.dark;
    setState(() {
      _themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    });
    _saveThemePreference(!isDark);
  }

  void _changeLanguage(String languageCode) {
    setState(() {
      _locale = Locale(languageCode);
    });
    _saveLanguagePreference(languageCode);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Função para adicionar pulseira
  void _adicionarPulseira(Map<String, dynamic> pulseira) {
    setState(() {
      pulseiras.add(pulseira);
    });
  }

  // Função para deletar pulseira
  void _deletarPulseira(int id) {
    setState(() {
      pulseiras.removeWhere((pulseira) => pulseira['id'] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PulseSync',
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: _themeMode,
      locale: _locale,
      supportedLocales: S.delegate.supportedLocales,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(
        appBar: null, // Remove o AppBar
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: <Widget>[
            HomePage(
              onAddPulseira: _adicionarPulseira,
              onDeletarPulseira: _deletarPulseira,
              pulseiras: pulseiras,  // Passa as pulseiras para HomePage
            ),
            EstatisticasPage(
              pulseiras: pulseiras,  // Passa as pulseiras para EstatisticasPage
            ),
            PreferenciasPage(
              toggleTheme: toggleTheme,
              changeLanguage: _changeLanguage,
            ),
          ],
        ),
        bottomNavigationBar: Builder(
          builder: (context) => BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            backgroundColor: _themeMode == ThemeMode.dark
                ? Colors.black
                : Colors.lightBlueAccent,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/home.png',
                  width: 24,
                  height: 24,
                ),
                label: S.of(context).home,
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/estatisticas.png',
                  width: 24,
                  height: 24,
                ),
                label: S.of(context).statistics,
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/preferencias.png',
                  width: 24,
                  height: 24,
                ),
                label: S.of(context).preferences,
              ),
            ],
            selectedItemColor:
                _themeMode == ThemeMode.dark ? Colors.white : Colors.black,
            unselectedItemColor:
                _themeMode == ThemeMode.dark ? Colors.white70 : Colors.black54,
          ),
        ),
      ),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: Colors.white,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: Colors.black,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
      ),
    );
  }
}
