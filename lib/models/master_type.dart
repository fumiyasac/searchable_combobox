class MasterType {
  final String id;
  final String displayName;

  const MasterType({
    required this.id,
    required this.displayName,
  });
}

// フリーランス向け会計マスタ（日商簿記3級準拠）
class MasterTypes {
  static const all = MasterType(id: 'all', displayName: '全て');
  static const account = MasterType(id: 'account', displayName: '勘定科目');
  static const subAccount = MasterType(id: 'sub_account', displayName: '補助科目');
  static const client = MasterType(id: 'client', displayName: '取引先');
  static const project = MasterType(id: 'project', displayName: 'プロジェクト');
  static const department = MasterType(id: 'department', displayName: '部門');
  static const item = MasterType(id: 'item', displayName: '品目');
  static const paymentMethod = MasterType(id: 'payment_method', displayName: '決済方法');
  static const taxType = MasterType(id: 'tax_type', displayName: '税区分');
  static const segment = MasterType(id: 'segment', displayName: 'セグメント');

  // 全マスタタイプのリスト
  static const List<MasterType> values = [
    all,
    account,
    subAccount,
    client,
    project,
    department,
    item,
    paymentMethod,
    taxType,
    segment,
  ];
}