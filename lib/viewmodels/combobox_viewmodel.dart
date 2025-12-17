import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/master_item.dart';
import '../models/master_type.dart';
import '../repositories/master_repository.dart';

// Repository Provider
final masterRepositoryProvider = Provider<MasterRepository>((ref) {
  return MasterRepository();
});

// 選択中のタブ（マスタタイプ）を管理
final selectedMasterTypeProvider = StateProvider<MasterType>((ref) {
  return MasterTypes.all;
});

// 各マスタタイプのアイテムリストを取得
final masterItemsProvider = FutureProvider.family<List<MasterItem>, String>((ref, masterType) async {
  final repository = ref.watch(masterRepositoryProvider);
  final items = await repository.getMasterItems(masterType);
  final history = await repository.getSelectionHistory();

  // 選択履歴をもとに、最近選択したアイテムを優先表示
  final itemsWithHistory = items.map((item) {
    final historyItem = history.firstWhere(
          (h) => h.id == item.id && h.masterType == item.masterType,
      orElse: () => item,
    );
    return historyItem.lastSelected != null ? historyItem : item;
  }).toList();

  // lastSelectedがあるアイテムを先頭に並べる
  itemsWithHistory.sort((a, b) {
    if (a.lastSelected != null && b.lastSelected == null) return -1;
    if (a.lastSelected == null && b.lastSelected != null) return 1;
    if (a.lastSelected != null && b.lastSelected != null) {
      return b.lastSelected!.compareTo(a.lastSelected!);
    }
    return a.name.compareTo(b.name);
  });

  return itemsWithHistory;
});

// 選択されたアイテムを管理
class SelectedItemsNotifier extends StateNotifier<List<MasterItem>> {
  SelectedItemsNotifier(this.repository) : super([]) {
    _loadSelectedItems();
  }

  final MasterRepository repository;

  Future<void> _loadSelectedItems() async {
    state = await repository.getSelectedItems();
  }

  Future<void> addItem(MasterItem item) async {
    if (!state.any((i) => i.id == item.id && i.masterType == item.masterType)) {
      state = [...state, item];
      await repository.saveSelectedItems(state);
      await repository.updateSelectionHistory(item);
    }
  }

  Future<void> removeItem(MasterItem item) async {
    state = state.where((i) => !(i.id == item.id && i.masterType == item.masterType)).toList();
    await repository.saveSelectedItems(state);
  }

  Future<void> setItems(List<MasterItem> items) async {
    state = items;
    await repository.saveSelectedItems(state);

    // 選択履歴を更新
    for (final item in items) {
      await repository.updateSelectionHistory(item);
    }
  }

  void clearAll() {
    state = [];
    repository.saveSelectedItems([]);
  }
}

final selectedItemsProvider = StateNotifierProvider<SelectedItemsNotifier, List<MasterItem>>((ref) {
  final repository = ref.watch(masterRepositoryProvider);
  return SelectedItemsNotifier(repository);
});