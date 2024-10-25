import 'package:cook_random/common/Global.dart';
import 'package:cook_random/pages/inventory/inventory_list.dart';
import 'package:cook_random/pages/menu/menu_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Global.init().then((e) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
          )),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('zh'),
        Locale('en'),
      ],
      home: const BasePage(),
    );
  }
}

class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (v) {
          setState(() {
            _current = v;
          });
        },
        selectedIndex: _current,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.menu_book),
            label: '菜单',
          ),
          NavigationDestination(
            icon: Icon(Icons.generating_tokens),
            label: '随机',
          ),
          NavigationDestination(
            icon: Icon(Icons.fastfood),
            label: '库存',
          ),
        ],
      ),
      body: [
        const MenuList(),
        const Placeholder(),
        const InventoryList(),
      ][_current],
    );
  }
}
