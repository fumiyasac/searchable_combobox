import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/master_item.dart';

class MasterRepository {
  static const String _selectedItemsKey = 'selected_items';
  static const String _selectionHistoryKey = 'selection_history';

  // 実際の運用では、APIやローカルDBから取得
  // ここではダミーデータを返す
  Future<List<MasterItem>> getMasterItems(String masterType) async {
    await Future.delayed(const Duration(milliseconds: 300)); // API呼び出しをシミュレート

    switch (masterType) {
      case 'all':
        return _getAllItems();
      case 'department':
        return _getDepartmentItems();
      case 'subject':
        return _getSubjectItems();
      case 'segment1':
        return _getSegment1Items();
      case 'segment2':
        return _getSegment2Items();
      case 'segment3':
        return _getSegment3Items();
      case 'project':
        return _getProjectItems();
      case 'client':
        return _getClientItems();
      case 'account':
        return _getAccountItems();
      case 'expense':
        return _getExpenseItems();
      case 'product':
        return _getProductItems();
      case 'location':
        return _getLocationItems();
      default:
        return [];
    }
  }

  List<MasterItem> _getAllItems() {
    return [
      ..._getDepartmentItems(),
      ..._getSubjectItems(),
      ..._getSegment1Items(),
      ..._getSegment2Items(),
      ..._getSegment3Items(),
      ..._getProjectItems(),
      ..._getClientItems(),
      ..._getAccountItems(),
      ..._getExpenseItems(),
      ..._getProductItems(),
      ..._getLocationItems(),
    ];
  }

  List<MasterItem> _getDepartmentItems() {
    return [
      MasterItem(id: 'd001', name: '営業本部 部門', masterType: 'department'),
      MasterItem(id: 'd002', name: '管理本部 部門', masterType: 'department'),
      MasterItem(id: 'd003', name: '採用 部門', masterType: 'department'),
      MasterItem(id: 'd004', name: '開発 部門', masterType: 'department'),
      MasterItem(id: 'd005', name: '人事 部門', masterType: 'department'),
      MasterItem(id: 'd006', name: '経理 部門', masterType: 'department'),
      MasterItem(id: 'd007', name: '総務 部門', masterType: 'department'),
      MasterItem(id: 'd008', name: 'マーケティング 部門', masterType: 'department'),
    ];
  }

  List<MasterItem> _getSubjectItems() {
    return [
      MasterItem(id: 's001', name: '補助科目 その1', masterType: 'subject'),
      MasterItem(id: 's002', name: '補助科目 その2', masterType: 'subject'),
      MasterItem(id: 's003', name: '給与科目', masterType: 'subject'),
      MasterItem(id: 's004', name: '交通費科目', masterType: 'subject'),
      MasterItem(id: 's005', name: '会議費科目', masterType: 'subject'),
      MasterItem(id: 's006', name: '通信費科目', masterType: 'subject'),
      MasterItem(id: 's007', name: '消耗品費科目', masterType: 'subject'),
    ];
  }

  List<MasterItem> _getSegment1Items() {
    return [
      MasterItem(id: 'sg001', name: 'セグメント 東日本', masterType: 'segment1'),
      MasterItem(id: 'sg002', name: 'セグメント 西日本', masterType: 'segment1'),
      MasterItem(id: 'sg003', name: 'セグメント 海外', masterType: 'segment1'),
      MasterItem(id: 'sg004', name: 'セグメント 北海道', masterType: 'segment1'),
      MasterItem(id: 'sg005', name: 'セグメント 九州', masterType: 'segment1'),
    ];
  }

  List<MasterItem> _getSegment2Items() {
    return [
      MasterItem(id: 'sg2001', name: 'セグメント2 大企業向け', masterType: 'segment2'),
      MasterItem(id: 'sg2002', name: 'セグメント2 中小企業向け', masterType: 'segment2'),
      MasterItem(id: 'sg2003', name: 'セグメント2 個人事業主向け', masterType: 'segment2'),
      MasterItem(id: 'sg2004', name: 'セグメント2 スタートアップ向け', masterType: 'segment2'),
      MasterItem(id: 'sg2005', name: 'セグメント2 官公庁向け', masterType: 'segment2'),
    ];
  }

  List<MasterItem> _getSegment3Items() {
    return [
      MasterItem(id: 'sg3001', name: 'セグメント3 製造業', masterType: 'segment3'),
      MasterItem(id: 'sg3002', name: 'セグメント3 小売業', masterType: 'segment3'),
      MasterItem(id: 'sg3003', name: 'セグメント3 サービス業', masterType: 'segment3'),
      MasterItem(id: 'sg3004', name: 'セグメント3 IT業', masterType: 'segment3'),
      MasterItem(id: 'sg3005', name: 'セグメント3 金融業', masterType: 'segment3'),
      MasterItem(id: 'sg3006', name: 'セグメント3 建設業', masterType: 'segment3'),
    ];
  }

  List<MasterItem> _getProjectItems() {
    return [
      MasterItem(id: 'pj001', name: 'プロジェクト 新規システム開発', masterType: 'project'),
      MasterItem(id: 'pj002', name: 'プロジェクト Webサイトリニューアル', masterType: 'project'),
      MasterItem(id: 'pj003', name: 'プロジェクト 業務改善PJ', masterType: 'project'),
      MasterItem(id: 'pj004', name: 'プロジェクト AIサービス開発', masterType: 'project'),
      MasterItem(id: 'pj005', name: 'プロジェクト DX推進', masterType: 'project'),
      MasterItem(id: 'pj006', name: 'プロジェクト セキュリティ強化', masterType: 'project'),
      MasterItem(id: 'pj007', name: 'プロジェクト クラウド移行', masterType: 'project'),
    ];
  }

  List<MasterItem> _getClientItems() {
    return [
      MasterItem(id: 'cl001', name: '取引先 株式会社ABC商事', masterType: 'client'),
      MasterItem(id: 'cl002', name: '取引先 XYZ株式会社', masterType: 'client'),
      MasterItem(id: 'cl003', name: '取引先 デフォルト工業', masterType: 'client'),
      MasterItem(id: 'cl004', name: '取引先 サンプル商店', masterType: 'client'),
      MasterItem(id: 'cl005', name: '取引先 テスト物産', masterType: 'client'),
      MasterItem(id: 'cl006', name: '取引先 モックアップ株式会社', masterType: 'client'),
      MasterItem(id: 'cl007', name: '取引先 ダミー商会', masterType: 'client'),
      MasterItem(id: 'cl008', name: '取引先 プロトタイプ企業', masterType: 'client'),
    ];
  }

  List<MasterItem> _getAccountItems() {
    return [
      MasterItem(id: 'ac001', name: '勘定科目 現金', masterType: 'account'),
      MasterItem(id: 'ac002', name: '勘定科目 預金', masterType: 'account'),
      MasterItem(id: 'ac003', name: '勘定科目 売掛金', masterType: 'account'),
      MasterItem(id: 'ac004', name: '勘定科目 買掛金', masterType: 'account'),
      MasterItem(id: 'ac005', name: '勘定科目 売上高', masterType: 'account'),
      MasterItem(id: 'ac006', name: '勘定科目 仕入高', masterType: 'account'),
      MasterItem(id: 'ac007', name: '勘定科目 販売費及び一般管理費', masterType: 'account'),
      MasterItem(id: 'ac008', name: '勘定科目 営業外収益', masterType: 'account'),
      MasterItem(id: 'ac009', name: '勘定科目 営業外費用', masterType: 'account'),
    ];
  }

  List<MasterItem> _getExpenseItems() {
    return [
      MasterItem(id: 'ex001', name: '費用項目 人件費', masterType: 'expense'),
      MasterItem(id: 'ex002', name: '費用項目 広告宣伝費', masterType: 'expense'),
      MasterItem(id: 'ex003', name: '費用項目 旅費交通費', masterType: 'expense'),
      MasterItem(id: 'ex004', name: '費用項目 通信費', masterType: 'expense'),
      MasterItem(id: 'ex005', name: '費用項目 水道光熱費', masterType: 'expense'),
      MasterItem(id: 'ex006', name: '費用項目 地代家賃', masterType: 'expense'),
      MasterItem(id: 'ex007', name: '費用項目 減価償却費', masterType: 'expense'),
      MasterItem(id: 'ex008', name: '費用項目 福利厚生費', masterType: 'expense'),
      MasterItem(id: 'ex009', name: '費用項目 研修費', masterType: 'expense'),
      MasterItem(id: 'ex010', name: '費用項目 外注費', masterType: 'expense'),
    ];
  }

  List<MasterItem> _getProductItems() {
    return [
      MasterItem(id: 'pr001', name: '製品 製品A スタンダード', masterType: 'product'),
      MasterItem(id: 'pr002', name: '製品 製品B プレミアム', masterType: 'product'),
      MasterItem(id: 'pr003', name: '製品 製品C エンタープライズ', masterType: 'product'),
      MasterItem(id: 'pr004', name: '製品 サービスX ベーシック', masterType: 'product'),
      MasterItem(id: 'pr005', name: '製品 サービスY プロフェッショナル', masterType: 'product'),
      MasterItem(id: 'pr006', name: '製品 ソリューションZ', masterType: 'product'),
      MasterItem(id: 'pr007', name: '製品 カスタムパッケージ', masterType: 'product'),
    ];
  }

  List<MasterItem> _getLocationItems() {
    return [
      MasterItem(id: 'loc001', name: '拠点 東京本社', masterType: 'location'),
      MasterItem(id: 'loc002', name: '拠点 大阪支社', masterType: 'location'),
      MasterItem(id: 'loc003', name: '拠点 名古屋支社', masterType: 'location'),
      MasterItem(id: 'loc004', name: '拠点 福岡支社', masterType: 'location'),
      MasterItem(id: 'loc005', name: '拠点 札幌支社', masterType: 'location'),
      MasterItem(id: 'loc006', name: '拠点 仙台支社', masterType: 'location'),
      MasterItem(id: 'loc007', name: '拠点 広島支社', masterType: 'location'),
      MasterItem(id: 'loc008', name: '拠点 海外オフィス（シンガポール）', masterType: 'location'),
      MasterItem(id: 'loc009', name: '拠点 海外オフィス（上海）', masterType: 'location'),
    ];
  }

  // 選択した項目を保存
  Future<void> saveSelectedItems(List<MasterItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = items.map((item) => item.toJson()).toList();
    await prefs.setString(_selectedItemsKey, jsonEncode(jsonList));
  }

  // 保存された選択項目を取得
  Future<List<MasterItem>> getSelectedItems() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_selectedItemsKey);
    if (jsonString == null) return [];

    final jsonList = jsonDecode(jsonString) as List;
    return jsonList.map((json) => MasterItem.fromJson(json)).toList();
  }

  // 選択履歴を更新（最近選択した項目を記録）
  Future<void> updateSelectionHistory(MasterItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_selectionHistoryKey);

    List<MasterItem> history = [];
    if (historyJson != null) {
      final jsonList = jsonDecode(historyJson) as List;
      history = jsonList.map((json) => MasterItem.fromJson(json)).toList();
    }

    // 既存の履歴から同じアイテムを削除
    history.removeWhere((h) => h.id == item.id && h.masterType == item.masterType);

    // 新しい選択を先頭に追加
    history.insert(0, item.copyWith(lastSelected: DateTime.now()));

    // 履歴は最大50件まで保持
    if (history.length > 50) {
      history = history.sublist(0, 50);
    }

    final jsonList = history.map((h) => h.toJson()).toList();
    await prefs.setString(_selectionHistoryKey, jsonEncode(jsonList));
  }

  // 選択履歴を取得
  Future<List<MasterItem>> getSelectionHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_selectionHistoryKey);
    if (historyJson == null) return [];

    final jsonList = jsonDecode(historyJson) as List;
    return jsonList.map((json) => MasterItem.fromJson(json)).toList();
  }
}