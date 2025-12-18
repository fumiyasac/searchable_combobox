import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'models/master_type.dart';
import 'viewmodels/combobox_viewmodel.dart';
import 'views/master_search_view.dart';
import 'theme/app_theme.dart';

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
      title: 'フリーランス会計マスタ',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const ComboBoxScreen(),
    );
  }
}

class ComboBoxScreen extends ConsumerWidget {
  const ComboBoxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      initialIndex: 0,
      length: MasterTypes.values.length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.1),
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppTheme.spacing2),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryColor,
                      AppTheme.primaryLightColor,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                ),
                child: const Icon(
                  Icons.account_balance_wallet,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              SizedBox(width: AppTheme.spacing3),
              const Text('マスタ選択'),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: Container(
              color: AppTheme.surfaceColor,
              padding: EdgeInsets.symmetric(
                horizontal: AppTheme.spacing2,
                vertical: AppTheme.spacing2,
              ),
              child: ButtonsTabBar(
                backgroundColor: Colors.grey.shade300,
                unselectedBackgroundColor: Colors.transparent,
                unselectedLabelStyle: TextStyle(
                  color: AppTheme.textSecondaryColor,
                  fontWeight: FontWeight.w500,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing4,
                ),
                height: 40,
                labelStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                labelSpacing: AppTheme.spacing2,
                borderWidth: 1,
                borderColor: Colors.grey.shade300,
                unselectedBorderColor: Colors.grey.shade300,
                onTap: (index) {
                  ref.read(selectedMasterTypeProvider.notifier)
                      .update(MasterTypes.values[index]);
                },
                tabs: MasterTypes.values.map((type) {
                  return Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _getIconForMasterType(type.id),
                        SizedBox(width: AppTheme.spacing2),
                        Text(type.displayName),
                      ],
                    ),
                  );
                }).toList(),
              ),
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

  // マスタタイプごとのアイコン
  Widget _getIconForMasterType(String masterType) {
    IconData iconData;

    switch (masterType) {
      case 'all':
        iconData = Icons.apps;
        break;
      case 'account':
        iconData = Icons.account_balance;
        break;
      case 'sub_account':
        iconData = Icons.account_tree;
        break;
      case 'client':
        iconData = Icons.business;
        break;
      case 'project':
        iconData = Icons.folder_special;
        break;
      case 'department':
        iconData = Icons.corporate_fare;
        break;
      case 'item':
        iconData = Icons.inventory_2;
        break;
      case 'payment_method':
        iconData = Icons.payment;
        break;
      case 'tax_type':
        iconData = Icons.receipt_long;
        break;
      case 'segment':
        iconData = Icons.category;
        break;
      default:
        iconData = Icons.label;
    }

    return Icon(iconData, size: 18);
  }
}