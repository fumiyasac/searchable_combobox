import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/master_item.dart';
import '../models/master_type.dart';
import '../repositories/master_repository.dart';

// ============================================================================
// Riverpod 3.0 について
// ============================================================================
// Riverpodは、Flutterの状態管理ライブラリです。
//
// 主な概念:
// 1. Provider: データや状態を提供するオブジェクト
// 2. Notifier: 状態を変更するロジックを持つクラス（Riverpod 3.0の新機能）
// 3. ref: Providerにアクセスするためのオブジェクト
//
// Riverpod 3.0では、StateNotifierの代わりにNotifierを使用します。
// これにより、よりシンプルで型安全な状態管理が可能になります。
// ============================================================================

// Repository Provider
//
// Providerは、依存性注入（DI）の役割を果たします。
// アプリケーション全体で1つのMasterRepositoryインスタンスを共有し、
// 必要な場所でref.watch()やref.read()でアクセスできます。
//
// Provider<T>は、変更されない（イミュータブルな）オブジェクトを提供します。
// 例: サービスクラス、リポジトリ、設定など
final masterRepositoryProvider = Provider<MasterRepository>((ref) {
  // ここで返されたインスタンスは、アプリケーション全体で共有されます
  return MasterRepository();
});

// ============================================================================
// 選択中のマスタタイプを管理するNotifier
// ============================================================================
//
// Notifier<T>は、状態（State）を持ち、それを変更するロジックを含むクラスです。
// T は管理する状態の型（ここではMasterType）です。
//
// Riverpod 3.0の特徴:
// - build()メソッドで初期状態を定義
// - stateプロパティで現在の状態にアクセス・変更
// - refプロパティで他のProviderにアクセス可能
class SelectedMasterTypeNotifier extends Notifier<MasterType> {
  // build()メソッド: 初期状態を返す
  //
  // このメソッドは、Providerが初めて使用されるときに1度だけ呼ばれます。
  // ここで返した値が、stateの初期値になります。
  @override
  MasterType build() {
    // 初期状態は「全て」タブを選択
    return MasterTypes.all;
  }

  // タブを切り替えるメソッド
  //
  // 状態を変更するには、state = 新しい値 と代入します。
  // stateが変更されると、このProviderをwatchしている
  // 全てのWidgetが自動的に再ビルドされます。
  //
  // @param type 新しく選択されたマスタタイプ
  void update(MasterType type) {
    state = type; // この代入で状態が更新され、UIが再描画される
  }
}

// NotifierProvider: Notifierを提供するProvider
//
// NotifierProvider<NotifierClass, StateType> の形式で定義します。
// - 第1型引数: Notifierクラスの型
// - 第2型引数: 管理する状態の型
//
// .new は、SelectedMasterTypeNotifier.new と同じ意味で、
// コンストラクタへの参照を渡しています（Dart 2.15以降の記法）
final selectedMasterTypeProvider = NotifierProvider<SelectedMasterTypeNotifier, MasterType>(
  SelectedMasterTypeNotifier.new,
);

// ============================================================================
// 各マスタタイプのアイテムリストを取得するProvider
// ============================================================================
//
// FutureProvider: 非同期処理の結果を提供するProvider
//
// FutureProvider.family を使うことで、引数を受け取れるProviderを作成できます。
// これにより、同じロジックで異なるパラメータのデータを取得できます。
//
// 例: masterItemsProvider('account') と masterItemsProvider('client') は
//     異なるデータを返しますが、同じProviderを使用します。
final masterItemsProvider = FutureProvider.family<List<MasterItem>, String>((ref, masterType) async {
  // ref.watch(): 他のProviderの値を監視
  // このProviderが依存しているProviderの値が変わると、自動的に再実行されます
  final repository = ref.watch(masterRepositoryProvider);

  // リポジトリからマスタアイテムを取得（非同期処理）
  final items = await repository.getMasterItems(masterType);

  // 選択履歴も取得
  final history = await repository.getSelectionHistory();

  // 選択履歴をマージする処理
  //
  // 目的: 最近選択した項目を優先的に表示するため、
  //       lastSelected の情報を各アイテムに付与します。
  //
  // 処理の流れ:
  // 1. 各itemに対して、履歴の中から同じID・タイプのitemを探す
  // 2. 見つかった場合、その履歴のlastSelected情報を使用
  // 3. 見つからない場合、元のitemをそのまま使用
  final itemsWithHistory = items.map((item) {
    // firstWhere(): リストの中から条件に一致する最初の要素を返す
    // orElse: 見つからない場合に実行される関数
    final historyItem = history.firstWhere(
          (h) => h.id == item.id && h.masterType == item.masterType,
      orElse: () => item, // 履歴になければ元のitemを返す
    );

    // historyItemがlastSelectedを持っていればそれを使用、なければitemを使用
    return historyItem.lastSelected != null ? historyItem : item;
  }).toList();

  // ソート処理: 最近選択したアイテムを先頭に並べる
  //
  // sort()メソッド: リストを並び替えます
  // 比較関数は、2つの要素a, bを比較し、以下を返します:
  // - 負の数: aがbより前に来る
  // - 0: 順序は変わらない
  // - 正の数: bがaより前に来る
  itemsWithHistory.sort((a, b) {
    // ケース1: aだけがlastSelectedを持っている → aを前に
    if (a.lastSelected != null && b.lastSelected == null) return -1;

    // ケース2: bだけがlastSelectedを持っている → bを前に
    if (a.lastSelected == null && b.lastSelected != null) return 1;

    // ケース3: 両方がlastSelectedを持っている → 新しい方を前に
    if (a.lastSelected != null && b.lastSelected != null) {
      // compareTo()で日時を比較（bとaの順番に注意：新しい方を前に）
      return b.lastSelected!.compareTo(a.lastSelected!);
    }

    // ケース4: 両方ともlastSelectedがない → 名前順
    return a.name.compareTo(b.name);
  });

  // 処理済みのリストを返す
  return itemsWithHistory;
});

// ============================================================================
// 選択されたアイテムを管理するNotifier
// ============================================================================
//
// このクラスは、ユーザーが選択した項目のリストを管理し、
// ローカルストレージへの保存・読み込みも担当します。
class SelectedItemsNotifier extends Notifier<List<MasterItem>> {
  // build()メソッド: 初期状態を返す
  //
  // ここで空のリストを返し、すぐに_loadSelectedItems()を呼んで
  // 保存されているデータを読み込みます。
  //
  // なぜ空リストを返すのか:
  // build()は同期的なメソッドなので、非同期処理（ファイル読み込み）を
  // 完了してから値を返すことができません。そのため、一旦空リストを返し、
  // 非同期で読み込んだデータで状態を更新します。
  @override
  List<MasterItem> build() {
    // 非同期でデータを読み込む（awaitしない）
    _loadSelectedItems();

    // 初期状態として空リストを返す
    return [];
  }

  // リポジトリへのアクセス
  //
  // getterを使って、必要な時にリポジトリを取得します。
  // ref.read(): Providerの現在の値を1回だけ読み取る
  //
  // ref.watch()との違い:
  // - watch: 値の変更を監視し、変更時に再実行される
  // - read: 値を1回読むだけで、変更を監視しない
  //
  // メソッド内で使う場合は、通常ref.read()を使用します。
  MasterRepository get repository => ref.read(masterRepositoryProvider);

  // 保存された選択項目を読み込む（プライベートメソッド）
  //
  // アンダースコア(_)で始まるメソッドは、Dartの慣習でプライベートです。
  // このファイル内でのみ使用できます。
  Future<void> _loadSelectedItems() async {
    // リポジトリから選択済みアイテムを取得
    state = await repository.getSelectedItems();
    // state = ... で状態を更新すると、UIが自動的に再描画されます
  }

  // アイテムを削除するメソッド
  //
  // @param item 削除する項目
  Future<void> removeItem(MasterItem item) async {
    // where()メソッド: 条件に一致する要素だけを残す（フィルタリング）
    // !(...) で条件を反転させ、削除したいアイテム以外を残します
    state = state.where((i) => !(i.id == item.id && i.masterType == item.masterType)).toList();

    // 更新後の状態を保存
    await repository.saveSelectedItems(state);
  }

  // 選択項目を一括設定するメソッド
  //
  // ドロップダウンで複数選択した際に呼ばれます。
  //
  // @param items 新しく選択された項目のリスト
  Future<void> setItems(List<MasterItem> items) async {
    // 状態を新しいリストで置き換え
    state = items;

    // 保存
    await repository.saveSelectedItems(state);

    // 全ての選択項目の履歴を更新
    // for-in ループで各アイテムの履歴を記録
    for (final item in items) {
      await repository.updateSelectionHistory(item);
    }
  }

  // 全ての選択をクリアするメソッド
  void clearAll() {
    // 空のリストに置き換え
    state = [];

    // ローカルストレージも空にする
    // awaitしていないので、非同期処理が完了するのを待たずに次に進みます
    // （UIの応答性を保つため）
    repository.saveSelectedItems([]);
  }
}

// NotifierProviderの定義
//
// このProviderを通じて、アプリケーション全体で選択状態を共有します。
//
// 使用例:
// - 状態を読む: ref.watch(selectedItemsProvider)
// - 状態を変更: ref.read(selectedItemsProvider.notifier).addItem(item)
final selectedItemsProvider = NotifierProvider<SelectedItemsNotifier, List<MasterItem>>(
  SelectedItemsNotifier.new,
);