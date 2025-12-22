import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../models/master_item.dart';
import '../viewmodels/combobox_viewmodel.dart';
import '../theme/app_theme.dart';

// ============================================================================
// マスタ検索画面のウィジェット
// ============================================================================
//
// このウィジェットは、マスタ項目の検索・選択機能を提供します。
//
// ConsumerWidgetについて:
// - Riverpodを使用するウィジェットの基本クラス
// - StatelessWidgetの代わりに使用します
// - buildメソッドでWidgetRefを受け取り、Providerにアクセスできます
//
// StatelessWidgetとの違い:
// StatelessWidget: build(BuildContext context)
// ConsumerWidget: build(BuildContext context, WidgetRef ref)
//                 ↑ refが追加されている
class MasterSearchView extends ConsumerWidget {
  // 表示するマスタのタイプ
  // 例: 'account', 'client', 'project' など
  final String masterType;

  // コンストラクタ
  //
  // {super.key} は、親クラス（ConsumerWidget）のkeyパラメータに
  // 値を渡すための記法です。
  //
  // keyについて:
  // Flutterでは、各ウィジェットを一意に識別するためにkeyを使用できます。
  // 通常は自動で管理されますが、リストの並び替えなどで明示的に
  // 指定する必要がある場合があります。
  const MasterSearchView({
    super.key,
    required this.masterType,
  });

  // ビルドメソッド
  //
  // このメソッドは、画面を描画する際に呼ばれます。
  //
  // @param context ウィジェットツリー内の位置情報
  // @param ref Providerへのアクセスを提供するオブジェクト
  // @return 描画するウィジェット
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch(): Providerの値を監視
    //
    // watchを使うと、Providerの値が変更されたときに
    // 自動的にこのウィジェットが再ビルドされます。
    //
    // AsyncValue<T>について:
    // FutureProviderは、非同期処理の状態を表すAsyncValueを返します。
    // AsyncValueには3つの状態があります:
    // - data: 処理が成功し、データが取得できた
    // - loading: 処理中（データ取得中）
    // - error: 処理が失敗（エラー発生）
    final masterItemsAsync = ref.watch(masterItemsProvider(masterType));

    // 選択済みアイテムのリストを取得
    final selectedItems = ref.watch(selectedItemsProvider);

    // UIの構築
    //
    // Column: 縦方向に子ウィジェットを並べるウィジェット
    return Container(
      color: AppTheme.backgroundColor,
      child: Column(
        children: [
          // 検索ボックスエリア
          //
          // Container: ボックスモデルを提供する汎用ウィジェット
          // padding, margin, decoration などを設定できます
          Container(
            padding: EdgeInsets.all(AppTheme.spacing4),
            // AsyncValue.when(): 非同期処理の状態に応じて異なるUIを表示
            //
            // 3つのコールバックを受け取ります:
            // - data: 成功時（データを引数として受け取る）
            // - loading: 読み込み中
            // - error: エラー時（エラーとスタックトレースを受け取る）
            child: masterItemsAsync.when(
              data: (items) => _buildDropdownSearch(context, ref, items, selectedItems),
              loading: () => _buildLoadingState(),
              error: (error, stack) => _buildErrorState(error),
            ),
          ),

          // 選択済みアイテムの表示エリア
          //
          // if文をウィジェットリスト内で使用（コレクションif）
          // Dart 2.3以降の機能で、条件に応じてウィジェットを含めるか決定できます
          if (selectedItems.isNotEmpty)
            // Expanded: 残りのスペースを全て使用するウィジェット
            //
            // Columnの中で使うと、他のウィジェットが使った残りの
            // 縦方向スペースを全て使います。
            Expanded(
              child: _buildSelectedItemsSection(context, ref, selectedItems),
            ),

          // 選択がない場合の空状態メッセージ
          if (selectedItems.isEmpty)
            Expanded(
              child: _buildEmptyState(),
            ),
        ],
      ),
    );
  }

  // ドロップダウン検索ウィジェットを構築
  //
  // このメソッドは、dropdown_searchパッケージを使用して
  // 検索可能なドロップダウンリストを作成します。
  //
  // アンダースコア(_)で始まるメソッド = プライベートメソッド
  // このクラス内でのみ使用できます
  Widget _buildDropdownSearch(
      BuildContext context,
      WidgetRef ref,
      List<MasterItem> items,
      List<MasterItem> selectedItems,
      ) {
    // 表示するアイテムをフィルタリング
    //
    // 条件演算子（三項演算子）: 条件 ? 真の場合 : 偽の場合
    //
    // masterTypeが'all'の場合: 全てのアイテムを表示
    // それ以外の場合: 該当するmasterTypeのアイテムのみを表示
    final filteredItems = masterType == 'all'
        ? items
        : items.where((item) => item.masterType == masterType).toList();

    return Container(
      // BoxDecoration: Containerの見た目を装飾
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: AppTheme.shadowSmall,
      ),
      // DropdownSearch.multiSelection: 複数選択可能なドロップダウン
      //
      // dropdown_searchパッケージの機能で、
      // 検索とフィルタリングが可能なドロップダウンを提供します
      child: DropdownSearch<MasterItem>.multiSelection(
        // items: 表示するアイテムのリストを返す関数
        //
        // (filter, loadProps) => ... は関数リテラル（無名関数）
        // この場合、filterとloadPropsは使用していませんが、
        // パッケージの仕様で必要なパラメータです
        items: (filter, loadProps) => filteredItems,

        // selectedItems: 現在選択されているアイテム
        //
        // where()でフィルタリングして、現在のタブに関連する
        // 選択済みアイテムのみを表示
        selectedItems: selectedItems
            .where((item) => masterType == 'all' || item.masterType == masterType)
            .toList(),

        // compareFn: アイテムの比較方法を定義
        //
        // 2つのアイテムが同じかどうかを判定する関数です。
        // idとmasterTypeが両方一致する場合に、同じアイテムとみなします。
        compareFn: (item1, item2) =>
        item1.id == item2.id && item1.masterType == item2.masterType,

        // popupProps: ポップアップ（ドロップダウンリスト）の設定
        popupProps: PopupPropsMultiSelection.menu(
          // 検索ボックスを表示
          showSearchBox: true,

          // 検索ボックスのスタイル設定
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              hintText: "キーワードで検索",
              hintStyle: TextStyle(color: AppTheme.textSecondaryColor),
              prefixIcon: Icon(Icons.search, color: AppTheme.primaryColor),
              filled: true,
              fillColor: AppTheme.backgroundColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                borderSide: BorderSide.none, // ボーダーなし
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppTheme.spacing4,
                vertical: AppTheme.spacing3,
              ),
            ),
          ),

          // itemBuilder: 各アイテムの表示方法をカスタマイズ
          //
          // この関数は、リストの各項目を描画する際に呼ばれます
          // @param context コンテキスト
          // @param item 表示するアイテム
          // @param isDisabled 無効化されているか
          // @param isSelected 選択されているか
          itemBuilder: (context, item, isDisabled, isSelected) {
            return _buildDropdownItem(item, isSelected);
          },

          // fit: ポップアップのサイズ調整方法
          // FlexFit.loose: 内容に合わせてサイズを調整
          fit: FlexFit.loose,

          // constraints: ポップアップの最大サイズ制約
          //
          // MediaQuery.of(context): 画面のサイズ情報を取得
          // size.height * 0.6: 画面の高さの60%を最大高さとして設定
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),

          // containerBuilder: ポップアップ全体のコンテナをカスタマイズ
          containerBuilder: (context, popupWidget) {
            return Container(
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                boxShadow: AppTheme.shadowMedium,
              ),
              child: popupWidget,
            );
          },
        ),

        // dropdownBuilder: ドロップダウンボタンの表示内容をカスタマイズ
        //
        // 選択されている項目の数を表示します
        dropdownBuilder: (context, selectedItems) {
          return _buildDropdownDisplay(selectedItems);
        },

        // itemAsString: アイテムを文字列に変換
        //
        // 検索時に使用されます。ここでは、アイテムの名前で検索します。
        itemAsString: (item) => item.name,

        // onChanged: 選択が変更されたときに呼ばれるコールバック
        //
        // ref.read(): Providerのnotifierにアクセス
        // .notifier: 状態を変更するメソッドを持つオブジェクト
        // .setItems(): 選択項目を更新するメソッド
        onChanged: (items) {
          ref.read(selectedItemsProvider.notifier).setItems(items);
        },

        // decoratorProps: ドロップダウンボタンの装飾
        decoratorProps: DropDownDecoratorProps(
          decoration: InputDecoration(
            labelText: "",
            labelStyle: TextStyle(
              color: AppTheme.textSecondaryColor,
              fontWeight: FontWeight.w500,
            ),
            hintText: "",
            hintStyle: TextStyle(color: AppTheme.textDisabledColor),
            prefixIcon: Icon(Icons.list_alt, color: AppTheme.primaryColor),
            filled: true,
            fillColor: AppTheme.surfaceColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
            ),
          ),
        ),
      ),
    );
  }

  // 選択済みアイテムセクションを構築
  //
  // このメソッドは、ユーザーが選択した項目のリストを表示します。
  Widget _buildSelectedItemsSection(BuildContext context, WidgetRef ref, List<MasterItem> selectedItems) {
    return Container(
      // EdgeInsets.fromLTRB: 上下左右を個別に指定
      // L(Left), T(Top), R(Right), B(Bottom)
      margin: EdgeInsets.fromLTRB(
        AppTheme.spacing4,
        0, // 上のマージンは0（検索ボックスとの間隔は検索ボックス側で設定済み）
        AppTheme.spacing4,
        AppTheme.spacing4,
      ),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: AppTheme.shadowSmall,
        // Border.all: 全辺に同じボーダーを設定
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      // Column: 縦に並べるレイアウト
      child: Column(
        children: [
          // ========== ヘッダー部分 ==========
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppTheme.spacing4,
              vertical: AppTheme.spacing3,
            ),
            // LinearGradient: グラデーション（色の段階的変化）
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor.withOpacity(0.08),
                  AppTheme.primaryLightColor.withOpacity(0.05),
                ],
              ),
              // BorderRadius.only: 特定の角だけ丸くする
              // ここでは上の2つの角だけを丸くしています
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppTheme.radiusMedium),
                topRight: Radius.circular(AppTheme.radiusMedium),
              ),
            ),
            // Row: 横に並べるレイアウト
            child: Row(
              children: [
                // アイコン付きのボックス
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
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
                // SizedBox: 固定サイズの空白を作成
                //
                // ウィジェット間にスペースを入れる際に使用します
                SizedBox(width: AppTheme.spacing3),
                Text(
                  '選択済み項目',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                SizedBox(width: AppTheme.spacing2),
                // 選択数のバッジ
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing3,
                    vertical: AppTheme.spacing1,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryColor,
                        AppTheme.primaryLightColor,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    '${selectedItems.length}', // 文字列補間: $変数名 で変数を埋め込む
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                // Spacer: 残りのスペースを全て使う
                //
                // Rowの中で使うと、このウィジェット以降の要素を右端に配置できます
                const Spacer(),
                // クリアボタン
                //
                // Material: マテリアルデザインのインク効果を提供
                // InkWell: タップ可能な領域を作成（リップル効果付き）
                Material(
                  color: Colors.transparent, // 背景を透明に
                  child: InkWell(
                    // borderRadius: タップ時のリップル効果の形状
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    // onTap: タップされたときに呼ばれるコールバック
                    onTap: () {
                      // 全ての選択をクリア
                      ref.read(selectedItemsProvider.notifier).clearAll();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing3,
                        vertical: AppTheme.spacing2,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // 内容に合わせて幅を調整
                        children: [
                          Icon(
                            Icons.delete_outline,
                            size: 18,
                            color: AppTheme.errorColor,
                          ),
                          SizedBox(width: AppTheme.spacing1),
                          Text(
                            'クリア',
                            style: TextStyle(
                              color: AppTheme.errorColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 区切り線
          //
          // Divider: 水平線を描画するウィジェット
          Divider(
            height: 1, // ウィジェット全体の高さ
            thickness: 1, // 線の太さ
            color: Colors.grey.shade200,
          ),

          // ========== スクロール可能なチップリスト ==========
          //
          // Expanded: 残りのスペースを使用
          Expanded(
            // SingleChildScrollView: スクロール可能な領域を作成
            //
            // 内容が画面に収まらない場合、スクロールできるようになります
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppTheme.spacing4),
              // BouncingScrollPhysics: iOS風のバウンススクロール
              //
              // スクロールの端に達したときに跳ね返る効果を提供
              physics: const BouncingScrollPhysics(),
              // Align: 子ウィジェットの配置を制御
              child: Align(
                alignment: Alignment.topLeft, // 左上揃え
                // Wrap: 子ウィジェットを折り返しながら配置
                //
                // Rowと似ていますが、スペースが足りない場合に
                // 自動的に次の行に折り返します。
                child: Wrap(
                  spacing: AppTheme.spacing2, // 横方向の間隔
                  runSpacing: AppTheme.spacing2, // 縦方向（行間）の間隔
                  crossAxisAlignment: WrapCrossAlignment.start,
                  // map(): リストの各要素を変換
                  // toList(): 変換結果を新しいリストとして取得
                  children: selectedItems.map((item) {
                    return _buildSelectedChip(context, ref, item);
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 選択済みチップを構築
  //
  // このメソッドは、選択された各項目を視覚的に表現するチップを作成します。
  Widget _buildSelectedChip(BuildContext context, WidgetRef ref, MasterItem item) {
    return Container(
      // グラデーション: 2色の間を滑らかに変化
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryLightColor,
          ],
          begin: Alignment.topLeft, // グラデーションの開始位置
          end: Alignment.bottomRight, // グラデーションの終了位置
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.4),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          onTap: () {
            // タップ時の処理（必要に応じて実装）
          },
          child: Container(
            // constraints: サイズの制約を設定
            //
            // BoxConstraints: 最小・最大の幅と高さを指定できます
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - AppTheme.spacing8 * 2,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: AppTheme.spacing3,
              vertical: AppTheme.spacing2,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min, // 内容に合わせて幅を最小化
              children: [
                // ラベルアイコン
                Icon(
                  Icons.label,
                  size: 14,
                  color: Colors.white.withOpacity(0.9),
                ),
                SizedBox(width: AppTheme.spacing2),
                // Flexible: 柔軟にサイズ調整可能な領域
                //
                // Expandedと似ていますが、必ずしも全スペースを使いません。
                // 内容に応じてサイズが変わります。
                Flexible(
                  child: Text(
                    item.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      letterSpacing: 0.2, // 文字間隔
                      height: 1.2, // 行の高さ（フォントサイズに対する倍率）
                    ),
                    // overflow: テキストが領域に収まらない場合の処理
                    //
                    // TextOverflow.ellipsis: 末尾を「...」で省略
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1, // 最大行数
                  ),
                ),
                SizedBox(width: AppTheme.spacing2),
                // 削除ボタン
                InkWell(
                  onTap: () {
                    // このアイテムを選択から削除
                    ref.read(selectedItemsProvider.notifier).removeItem(item);
                  },
                  child: Container(
                    padding: EdgeInsets.all(AppTheme.spacing1),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      shape: BoxShape.circle, // 円形
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ドロップダウンの各アイテムを構築
  //
  // リストに表示される各項目のUIを定義します。
  Widget _buildDropdownItem(MasterItem item, bool isSelected) {
    // 最近使用したアイテムかどうかをチェック
    //
    // null != は、nullでないことを確認する演算子です
    final isRecent = item.lastSelected != null;

    return Container(
      decoration: BoxDecoration(
        // 条件演算子で背景色を切り替え
        color: isSelected
            ? AppTheme.primaryColor.withOpacity(0.08) // 選択時は薄い背景色
            : Colors.transparent, // 未選択時は透明
        // Border: ボーダーを設定
        border: Border(
          // 下部のみにボーダーを設定（区切り線として使用）
          bottom: BorderSide(color: Colors.grey.shade200, width: 0.5),
        ),
      ),
      // ListTile: リストアイテムの標準的なレイアウト
      //
      // Material Designのガイドラインに沿った、
      // 使いやすいリストアイテムを簡単に作成できます
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppTheme.spacing4,
          vertical: AppTheme.spacing2,
        ),
        // title: メインのコンテンツ
        title: Row(
          children: [
            // Expanded: 残りのスペースを使用
            Expanded(
              child: Text(
                item.name,
                style: TextStyle(
                  // 選択状態に応じて太さを変更
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: AppTheme.textPrimaryColor,
                  fontSize: 15,
                ),
              ),
            ),
            // 最近使用した項目にはバッジを表示
            //
            // コレクションif: if文をリスト内で使用
            // 条件がtrueの場合のみ、...内のウィジェットが追加されます
            if (isRecent) ...[
              SizedBox(width: AppTheme.spacing2),
              // 「履歴」バッジ
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing2,
                  vertical: AppTheme.spacing1,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.orange.shade400,
                      Colors.orange.shade600,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.history,
                      color: Colors.white,
                      size: 12,
                    ),
                    SizedBox(width: AppTheme.spacing1),
                    const Text(
                      '履歴',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        // trailing: 末尾のウィジェット
        //
        // 選択されている場合のみチェックマークを表示
        trailing: isSelected
            ? Container(
          padding: EdgeInsets.all(AppTheme.spacing1 + 2),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryColor,
                AppTheme.primaryLightColor,
              ],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.check,
            color: Colors.white,
            size: 16,
          ),
        )
            : null, // 未選択時はnull（何も表示しない）
      ),
    );
  }

  // ドロップダウンボタンの表示内容を構築
  //
  // 選択された項目の数を表示します。
  Widget _buildDropdownDisplay(List<MasterItem> selectedItems) {
    // 何も選択されていない場合
    if (selectedItems.isEmpty) {
      return Row(
        children: [
          Icon(Icons.touch_app, color: AppTheme.textDisabledColor, size: 20),
          SizedBox(width: AppTheme.spacing2),
          Text(
            '項目を選択してください',
            style: TextStyle(
              color: AppTheme.textSecondaryColor,
              fontSize: 15,
            ),
          ),
        ],
      );
    }

    // 選択されている場合
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppTheme.spacing3,
            vertical: AppTheme.spacing1 + 2,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryColor,
                AppTheme.primaryLightColor,
              ],
            ),
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            '${selectedItems.length}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ),
        SizedBox(width: AppTheme.spacing3),
        Expanded(
          child: Text(
            '件選択中',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }

  // 空状態を構築
  //
  // 何も選択されていない時に表示するメッセージです。
  Widget _buildEmptyState() {
    // Center: 子ウィジェットを中央に配置
    return Center(
      child: Container(
        padding: EdgeInsets.all(AppTheme.spacing6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 縦方向の中央揃え
          children: [
            // アイコンを円形の背景に配置
            Container(
              padding: EdgeInsets.all(AppTheme.spacing5),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.inbox_outlined,
                size: 64,
                color: AppTheme.primaryColor.withOpacity(0.6),
              ),
            ),
            SizedBox(height: AppTheme.spacing4),
            Text(
              '選択された項目がありません',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            SizedBox(height: AppTheme.spacing2),
            Text(
              '上部の検索ボックスから項目を選択してください',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ローディング状態を構築
  //
  // データ読み込み中に表示するインジケーターです。
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // CircularProgressIndicator: 円形のローディングインジケーター
          //
          // Material Designの標準的なローディング表示です
          CircularProgressIndicator(
            color: AppTheme.primaryColor,
          ),
          SizedBox(height: AppTheme.spacing4),
          Text(
            '読み込み中...',
            style: TextStyle(
              color: AppTheme.textSecondaryColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // エラー状態を構築
  //
  // データの読み込みに失敗した時に表示します。
  Widget _buildErrorState(Object error) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(AppTheme.spacing5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppTheme.errorColor,
            ),
            SizedBox(height: AppTheme.spacing4),
            Text(
              'エラーが発生しました',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            SizedBox(height: AppTheme.spacing2),
            // エラー内容を表示
            // $error は文字列補間で、errorオブジェクトの内容を文字列に変換します
            Text(
              '$error',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}