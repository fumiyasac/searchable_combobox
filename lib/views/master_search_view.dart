import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../models/master_item.dart';
import '../viewmodels/combobox_viewmodel.dart';
import '../theme/app_theme.dart';

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
      color: AppTheme.backgroundColor,
      child: Column(
        children: [
          // 検索ボックスエリア
          Container(
            padding: EdgeInsets.all(AppTheme.spacing4),
            child: masterItemsAsync.when(
              data: (items) => _buildDropdownSearch(context, ref, items, selectedItems),
              loading: () => _buildLoadingState(),
              error: (error, stack) => _buildErrorState(error),
            ),
          ),

          // 選択済みアイテムの表示エリア
          if (selectedItems.isNotEmpty)
            Expanded(
              child: _buildSelectedItemsSection(context, ref, selectedItems),
            ),

          // 選択がない場合のメッセージ
          if (selectedItems.isEmpty)
            Expanded(
              child: _buildEmptyState(),
            ),
        ],
      ),
    );
  }

  // ドロップダウン検索
  Widget _buildDropdownSearch(
      BuildContext context,
      WidgetRef ref,
      List<MasterItem> items,
      List<MasterItem> selectedItems,
      ) {
    final filteredItems = masterType == 'all'
        ? items
        : items.where((item) => item.masterType == masterType).toList();

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: AppTheme.shadowSmall,
      ),
      child: DropdownSearch<MasterItem>.multiSelection(
        items: (filter, loadProps) => filteredItems,
        selectedItems: selectedItems
            .where((item) => masterType == 'all' || item.masterType == masterType)
            .toList(),
        compareFn: (item1, item2) =>
        item1.id == item2.id && item1.masterType == item2.masterType,
        popupProps: PopupPropsMultiSelection.menu(
          showSearchBox: true,
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              hintText: "キーワードで検索",
              hintStyle: TextStyle(color: AppTheme.textSecondaryColor),
              prefixIcon: Icon(Icons.search, color: AppTheme.primaryColor),
              filled: true,
              fillColor: AppTheme.backgroundColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppTheme.spacing4,
                vertical: AppTheme.spacing3,
              ),
            ),
          ),
          itemBuilder: (context, item, isDisabled, isSelected) {
            return _buildDropdownItem(item, isSelected);
          },
          fit: FlexFit.loose,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
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
        dropdownBuilder: (context, selectedItems) {
          return _buildDropdownDisplay(selectedItems);
        },
        itemAsString: (item) => item.name,
        onChanged: (items) {
          ref.read(selectedItemsProvider.notifier).setItems(items);
        },
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

  // 選択済みアイテムセクション（改善版）
  Widget _buildSelectedItemsSection(BuildContext context, WidgetRef ref, List<MasterItem> selectedItems) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        AppTheme.spacing4,
        0,
        AppTheme.spacing4,
        AppTheme.spacing4,
      ),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: AppTheme.shadowSmall,
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // ヘッダー
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppTheme.spacing4,
              vertical: AppTheme.spacing3,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor.withOpacity(0.08),
                  AppTheme.primaryLightColor.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppTheme.radiusMedium),
                topRight: Radius.circular(AppTheme.radiusMedium),
              ),
            ),
            child: Row(
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
                    '${selectedItems.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Spacer(),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    onTap: () {
                      ref.read(selectedItemsProvider.notifier).clearAll();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing3,
                        vertical: AppTheme.spacing2,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
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
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey.shade200,
          ),

          // スクロール可能なチップリスト
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppTheme.spacing4),
              physics: const BouncingScrollPhysics(),
              child: Align(
                alignment: Alignment.topLeft,
                child: Wrap(
                  spacing: AppTheme.spacing2,
                  runSpacing: AppTheme.spacing2,
                  crossAxisAlignment: WrapCrossAlignment.start,
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

  // 選択済みチップ（テキスト長に応じた幅調整版）
  Widget _buildSelectedChip(BuildContext context, WidgetRef ref, MasterItem item) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryLightColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
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
            // タップ時の処理（必要に応じて）
          },
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - AppTheme.spacing8 * 2,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: AppTheme.spacing3,
              vertical: AppTheme.spacing2,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.label,
                  size: 14,
                  color: Colors.white.withOpacity(0.9),
                ),
                SizedBox(width: AppTheme.spacing2),
                Flexible(
                  child: Text(
                    item.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      letterSpacing: 0.2,
                      height: 1.2,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                SizedBox(width: AppTheme.spacing2),
                InkWell(
                  onTap: () {
                    ref.read(selectedItemsProvider.notifier).removeItem(item);
                  },
                  child: Container(
                    padding: EdgeInsets.all(AppTheme.spacing1),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      shape: BoxShape.circle,
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

  // ドロップダウンアイテム
  Widget _buildDropdownItem(MasterItem item, bool isSelected) {
    final isRecent = item.lastSelected != null;

    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? AppTheme.primaryColor.withOpacity(0.08)
            : Colors.transparent,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 0.5),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppTheme.spacing4,
          vertical: AppTheme.spacing2,
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                item.name,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: AppTheme.textPrimaryColor,
                  fontSize: 15,
                ),
              ),
            ),
            // 最近使用した項目にはバッジを表示
            if (isRecent) ...[
              SizedBox(width: AppTheme.spacing2),
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
            : null,
      ),
    );
  }

  // ドロップダウン表示内容
  Widget _buildDropdownDisplay(List<MasterItem> selectedItems) {
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

  // 空状態
  Widget _buildEmptyState() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(AppTheme.spacing6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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

  // ローディング状態
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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

  // エラー状態
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