import 'package:cook_random/common/Global.dart';
import 'package:cook_random/model/IngredientsProvider.dart';
import 'package:cook_random/pages/inventory/inventory_list.dart';
import 'package:cook_random/pages/menu/menu_list.dart';
import 'package:cook_random/pages/random/random.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Global.init().then((e) => runApp(MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => IngredientsProvider()),
        ],
        child: const MyApp(),
      )));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightColor, ColorScheme? darkColor) {
        return MaterialApp(
          title: 'Cook random',
          theme: ThemeData(
              colorScheme: lightColor ??
                  ColorScheme.fromSwatch(primarySwatch: Colors.blue),
              useMaterial3: true,
              inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder(),
              )),
          darkTheme: ThemeData(
            colorScheme: darkColor ??
                ColorScheme.fromSwatch(
                  primarySwatch: Colors.blue,
                  brightness: Brightness.dark,
                ),
            useMaterial3: true,
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
            ),
          ),
          themeMode: ThemeMode.system,
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
      },
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
        const Random(),
        const InventoryList(),
      ][_current],
    );
  }
}
