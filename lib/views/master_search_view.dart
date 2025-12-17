import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../models/master_item.dart';
import '../viewmodels/combobox_viewmodel.dart';

class MasterSearchView extends ConsumerWidget {
  final String masterType;

  const MasterSearchView({
    super.key,
    required this.masterType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final masterItemsAsync = ref.watch(masterItemsProvider(masterType));
    final selectedItems = ref.watch(selectedItemsProvider);

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // 選択済みアイテムの表示
          if (selectedItems.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '選択済み',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          ref.read(selectedItemsProvider.notifier).clearAll();
                        },
                        child: const Text('全てクリア'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: selectedItems.map((item) {
                      return Chip(
                        label: Text(item.name),
                        deleteIcon: const Icon(Icons.close, size: 18),
                        onDeleted: () {
                          ref.read(selectedItemsProvider.notifier).removeItem(item);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // ドロップダウン検索
          Expanded(
            child: masterItemsAsync.when(
              data: (items) {
                // 現在のマスタタイプでフィルタリング（'all'の場合はフィルタリングしない）
                final filteredItems = masterType == 'all'
                    ? items
                    : items.where((item) => item.masterType == masterType).toList();

                return DropdownSearch<MasterItem>.multiSelection(
                  items: (filter, loadProps) => filteredItems,
                  selectedItems: selectedItems
                      .where((item) => masterType == 'all' || item.masterType == masterType)
                      .toList(),
                  compareFn: (item1, item2) =>
                  item1.id == item2.id && item1.masterType == item2.masterType,
                  popupProps: PopupPropsMultiSelection.menu(
                    showSearchBox: true,
                    searchFieldProps: const TextFieldProps(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "入力を続けると検索されます",
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                    itemBuilder: (context, item, isDisabled, isSelected) {
                      final isRecent = item.lastSelected != null;
                      return ListTile(
                        title: Text(item.name),
                        leading: isRecent
                            ? const Icon(Icons.history, color: Colors.orange, size: 20)
                            : null,
                        trailing: isSelected
                            ? const Icon(Icons.check_circle, color: Colors.blue)
                            : null,
                        selected: isSelected,
                      );
                    },
                    fit: FlexFit.loose,
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.6,
                    ),
                  ),
                  dropdownBuilder: (context, selectedItems) {
                    if (selectedItems.isEmpty) {
                      return const Text(
                        '項目を選択してください',
                        style: TextStyle(color: Colors.grey),
                      );
                    }
                    return Text(
                      '${selectedItems.length}件選択中',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    );
                  },
                  itemAsString: (item) => item.name,
                  onChanged: (items) {
                    ref.read(selectedItemsProvider.notifier).setItems(items);
                  },
                  decoratorProps: const DropDownDecoratorProps(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.list_alt),
                    ),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('エラーが発生しました: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}