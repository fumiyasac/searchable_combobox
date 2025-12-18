import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/master_item.dart';

class MasterRepository {
  static const String _selectedItemsKey = 'selected_items';
  static const String _selectionHistoryKey = 'selection_history';

  // 実際の運用では、APIやローカルDBから取得
  Future<List<MasterItem>> getMasterItems(String masterType) async {
    await Future.delayed(const Duration(milliseconds: 300));

    switch (masterType) {
      case 'all':
        return _getAllItems();
      case 'account':
        return _getAccountItems();
      case 'sub_account':
        return _getSubAccountItems();
      case 'client':
        return _getClientItems();
      case 'project':
        return _getProjectItems();
      case 'department':
        return _getDepartmentItems();
      case 'item':
        return _getItemItems();
      case 'payment_method':
        return _getPaymentMethodItems();
      case 'tax_type':
        return _getTaxTypeItems();
      case 'segment':
        return _getSegmentItems();
      default:
        return [];
    }
  }

  List<MasterItem> _getAllItems() {
    return [
      ..._getAccountItems(),
      ..._getSubAccountItems(),
      ..._getClientItems(),
      ..._getProjectItems(),
      ..._getDepartmentItems(),
      ..._getItemItems(),
      ..._getPaymentMethodItems(),
      ..._getTaxTypeItems(),
      ..._getSegmentItems(),
    ];
  }

  // 勘定科目（日商簿記3級準拠）
  List<MasterItem> _getAccountItems() {
    return [
      // 資産
      MasterItem(id: 'ac101', name: '現金', masterType: 'account'),
      MasterItem(id: 'ac102', name: '普通預金', masterType: 'account'),
      MasterItem(id: 'ac103', name: '当座預金', masterType: 'account'),
      MasterItem(id: 'ac111', name: '売掛金', masterType: 'account'),
      MasterItem(id: 'ac112', name: '受取手形', masterType: 'account'),
      MasterItem(id: 'ac121', name: '貸付金', masterType: 'account'),
      MasterItem(id: 'ac122', name: '前払金', masterType: 'account'),
      MasterItem(id: 'ac131', name: '建物', masterType: 'account'),
      MasterItem(id: 'ac132', name: '備品', masterType: 'account'),
      MasterItem(id: 'ac133', name: '車両運搬具', masterType: 'account'),
      MasterItem(id: 'ac134', name: '土地', masterType: 'account'),

      // 負債
      MasterItem(id: 'ac201', name: '買掛金', masterType: 'account'),
      MasterItem(id: 'ac202', name: '支払手形', masterType: 'account'),
      MasterItem(id: 'ac211', name: '借入金', masterType: 'account'),
      MasterItem(id: 'ac212', name: '未払金', masterType: 'account'),
      MasterItem(id: 'ac213', name: '前受金', masterType: 'account'),
      MasterItem(id: 'ac214', name: '預り金', masterType: 'account'),

      // 純資産
      MasterItem(id: 'ac301', name: '資本金', masterType: 'account'),
      MasterItem(id: 'ac302', name: '事業主借', masterType: 'account'),
      MasterItem(id: 'ac303', name: '事業主貸', masterType: 'account'),

      // 収益
      MasterItem(id: 'ac401', name: '売上高', masterType: 'account'),
      MasterItem(id: 'ac402', name: '受取手数料', masterType: 'account'),
      MasterItem(id: 'ac403', name: '受取利息', masterType: 'account'),
      MasterItem(id: 'ac411', name: '雑収入', masterType: 'account'),

      // 費用
      MasterItem(id: 'ac501', name: '仕入高', masterType: 'account'),
      MasterItem(id: 'ac511', name: '給料', masterType: 'account'),
      MasterItem(id: 'ac512', name: '外注費', masterType: 'account'),
      MasterItem(id: 'ac521', name: '広告宣伝費', masterType: 'account'),
      MasterItem(id: 'ac522', name: '旅費交通費', masterType: 'account'),
      MasterItem(id: 'ac523', name: '通信費', masterType: 'account'),
      MasterItem(id: 'ac524', name: '水道光熱費', masterType: 'account'),
      MasterItem(id: 'ac525', name: '消耗品費', masterType: 'account'),
      MasterItem(id: 'ac526', name: '支払家賃', masterType: 'account'),
      MasterItem(id: 'ac527', name: '保険料', masterType: 'account'),
      MasterItem(id: 'ac528', name: '租税公課', masterType: 'account'),
      MasterItem(id: 'ac529', name: '減価償却費', masterType: 'account'),
      MasterItem(id: 'ac531', name: '支払利息', masterType: 'account'),
      MasterItem(id: 'ac541', name: '雑費', masterType: 'account'),
    ];
  }

  // 補助科目
  List<MasterItem> _getSubAccountItems() {
    return [
      // 普通預金の補助
      MasterItem(id: 'sub101', name: '○○銀行 本店', masterType: 'sub_account'),
      MasterItem(id: 'sub102', name: '○○銀行 支店', masterType: 'sub_account'),
      MasterItem(id: 'sub103', name: '△△信用金庫', masterType: 'sub_account'),
      MasterItem(id: 'sub104', name: 'ネット銀行', masterType: 'sub_account'),

      // 売掛金の補助
      MasterItem(id: 'sub201', name: 'A社 売掛金', masterType: 'sub_account'),
      MasterItem(id: 'sub202', name: 'B社 売掛金', masterType: 'sub_account'),
      MasterItem(id: 'sub203', name: 'C社 売掛金', masterType: 'sub_account'),

      // 買掛金の補助
      MasterItem(id: 'sub301', name: 'X社 買掛金', masterType: 'sub_account'),
      MasterItem(id: 'sub302', name: 'Y社 買掛金', masterType: 'sub_account'),

      // 借入金の補助
      MasterItem(id: 'sub401', name: '○○銀行 借入金', masterType: 'sub_account'),
      MasterItem(id: 'sub402', name: '政策金融公庫', masterType: 'sub_account'),
    ];
  }

  // 取引先（フリーランスが実際に取引する企業）
  List<MasterItem> _getClientItems() {
    return [
      MasterItem(id: 'cl001', name: '株式会社テクノロジー', masterType: 'client'),
      MasterItem(id: 'cl002', name: '株式会社デジタルマーケティング', masterType: 'client'),
      MasterItem(id: 'cl003', name: '株式会社Webソリューションズ', masterType: 'client'),
      MasterItem(id: 'cl004', name: '合同会社クリエイティブワークス', masterType: 'client'),
      MasterItem(id: 'cl005', name: '株式会社ビジネスコンサルティング', masterType: 'client'),
      MasterItem(id: 'cl006', name: '株式会社スタートアップ支援', masterType: 'client'),
      MasterItem(id: 'cl007', name: '株式会社メディアプロダクション', masterType: 'client'),
      MasterItem(id: 'cl008', name: '株式会社ECコマース', masterType: 'client'),
      MasterItem(id: 'cl009', name: '株式会社コンテンツマネジメント', masterType: 'client'),
      MasterItem(id: 'cl010', name: '個人事業主 山田太郎様', masterType: 'client'),
    ];
  }

  // プロジェクト（案件単位）
  List<MasterItem> _getProjectItems() {
    return [
      MasterItem(id: 'pj001', name: 'コーポレートサイト制作', masterType: 'project'),
      MasterItem(id: 'pj002', name: 'ECサイト構築プロジェクト', masterType: 'project'),
      MasterItem(id: 'pj003', name: 'Webアプリ開発', masterType: 'project'),
      MasterItem(id: 'pj004', name: 'SEO対策・コンサルティング', masterType: 'project'),
      MasterItem(id: 'pj005', name: 'SNS運用代行', masterType: 'project'),
      MasterItem(id: 'pj006', name: 'LP制作・運用', masterType: 'project'),
      MasterItem(id: 'pj007', name: 'システム保守運用', masterType: 'project'),
      MasterItem(id: 'pj008', name: 'ブランディング支援', masterType: 'project'),
      MasterItem(id: 'pj009', name: 'デザイン制作業務', masterType: 'project'),
      MasterItem(id: 'pj010', name: '記事執筆・編集', masterType: 'project'),
    ];
  }

  // 部門（フリーランスの事業区分）
  List<MasterItem> _getDepartmentItems() {
    return [
      MasterItem(id: 'dep01', name: 'Web制作事業', masterType: 'department'),
      MasterItem(id: 'dep02', name: 'デザイン事業', masterType: 'department'),
      MasterItem(id: 'dep03', name: 'ライティング事業', masterType: 'department'),
      MasterItem(id: 'dep04', name: 'コンサルティング事業', masterType: 'department'),
      MasterItem(id: 'dep05', name: 'システム開発事業', masterType: 'department'),
      MasterItem(id: 'dep06', name: 'マーケティング事業', masterType: 'department'),
      MasterItem(id: 'dep07', name: '動画編集事業', masterType: 'department'),
      MasterItem(id: 'dep08', name: '翻訳事業', masterType: 'department'),
    ];
  }

  // 品目（サービス・商品の詳細）
  List<MasterItem> _getItemItems() {
    return [
      MasterItem(id: 'itm001', name: 'Webサイト制作', masterType: 'item'),
      MasterItem(id: 'itm002', name: 'ロゴデザイン', masterType: 'item'),
      MasterItem(id: 'itm003', name: 'バナー制作', masterType: 'item'),
      MasterItem(id: 'itm004', name: 'SEO記事執筆', masterType: 'item'),
      MasterItem(id: 'itm005', name: 'プレスリリース作成', masterType: 'item'),
      MasterItem(id: 'itm006', name: 'SNS投稿コンテンツ', masterType: 'item'),
      MasterItem(id: 'itm007', name: 'WordPress構築', masterType: 'item'),
      MasterItem(id: 'itm008', name: 'システム設計', masterType: 'item'),
      MasterItem(id: 'itm009', name: 'コーディング', masterType: 'item'),
      MasterItem(id: 'itm010', name: 'コンサルティング（時間単価）', masterType: 'item'),
      MasterItem(id: 'itm011', name: '保守運用（月額）', masterType: 'item'),
      MasterItem(id: 'itm012', name: '動画編集', masterType: 'item'),
    ];
  }

  // 決済方法
  List<MasterItem> _getPaymentMethodItems() {
    return [
      MasterItem(id: 'pay01', name: '現金払い', masterType: 'payment_method'),
      MasterItem(id: 'pay02', name: '銀行振込', masterType: 'payment_method'),
      MasterItem(id: 'pay03', name: 'クレジットカード', masterType: 'payment_method'),
      MasterItem(id: 'pay04', name: 'PayPay', masterType: 'payment_method'),
      MasterItem(id: 'pay05', name: '請求書払い', masterType: 'payment_method'),
      MasterItem(id: 'pay06', name: '電子マネー', masterType: 'payment_method'),
      MasterItem(id: 'pay07', name: 'デビットカード', masterType: 'payment_method'),
      MasterItem(id: 'pay08', name: '掛売り', masterType: 'payment_method'),
    ];
  }

  // 税区分
  List<MasterItem> _getTaxTypeItems() {
    return [
      MasterItem(id: 'tax01', name: '課税売上 10%', masterType: 'tax_type'),
      MasterItem(id: 'tax02', name: '課税売上 8%（軽減税率）', masterType: 'tax_type'),
      MasterItem(id: 'tax03', name: '課税仕入 10%', masterType: 'tax_type'),
      MasterItem(id: 'tax04', name: '課税仕入 8%（軽減税率）', masterType: 'tax_type'),
      MasterItem(id: 'tax05', name: '非課税', masterType: 'tax_type'),
      MasterItem(id: 'tax06', name: '免税', masterType: 'tax_type'),
      MasterItem(id: 'tax07', name: '不課税', masterType: 'tax_type'),
      MasterItem(id: 'tax08', name: '対象外', masterType: 'tax_type'),
    ];
  }

  // セグメント（事業の切り口）
  List<MasterItem> _getSegmentItems() {
    return [
      MasterItem(id: 'seg01', name: '新規顧客向け', masterType: 'segment'),
      MasterItem(id: 'seg02', name: '既存顧客向け', masterType: 'segment'),
      MasterItem(id: 'seg03', name: '単発案件', masterType: 'segment'),
      MasterItem(id: 'seg04', name: '継続案件', masterType: 'segment'),
      MasterItem(id: 'seg05', name: 'スポット対応', masterType: 'segment'),
      MasterItem(id: 'seg06', name: '大型案件', masterType: 'segment'),
      MasterItem(id: 'seg07', name: '小規模案件', masterType: 'segment'),
      MasterItem(id: 'seg08', name: '自社事業', masterType: 'segment'),
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
