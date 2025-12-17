import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'models/master_type.dart';
import 'viewmodels/combobox_viewmodel.dart';
import 'views/master_search_view.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ComboBox Sample',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ComboBoxScreen(),
    );
  }
}

class ComboBoxScreen extends ConsumerWidget {
  const ComboBoxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedType = ref.watch(selectedMasterTypeProvider);

    return DefaultTabController(
      initialIndex: 0,
      length: MasterTypes.values.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("検索要素を選択する"),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: ButtonsTabBar(
              backgroundColor: Colors.deepPurple,
              unselectedBackgroundColor: Colors.white70,
              unselectedLabelStyle: const TextStyle(color: Colors.grey),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              labelStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              labelSpacing: 8,
              onTap: (index) {
                ref.read(selectedMasterTypeProvider.notifier).state =
                MasterTypes.values[index];
              },
              tabs: MasterTypes.values
                  .map((type) => Tab(text: type.displayName))
                  .toList(),
            ),
          ),
        ),
        body: TabBarView(
          children: MasterTypes.values
              .map((type) => MasterSearchView(masterType: type.id))
              .toList(),
        ),
      ),
    );
  }
}