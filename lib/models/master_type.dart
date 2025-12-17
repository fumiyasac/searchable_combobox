class MasterType {
  final String id;
  final String displayName;

  const MasterType({
    required this.id,
    required this.displayName,
  });
}

// 将来的にマスタを追加・変更しやすいよう、ここで一元管理
class MasterTypes {
  static const all = MasterType(id: 'all', displayName: '全て');
  static const department = MasterType(id: 'department', displayName: '補助部門');
  static const subject = MasterType(id: 'subject', displayName: '科目');
  static const segment1 = MasterType(id: 'segment1', displayName: 'セグメント1');

  // 追加マスタ（8種類）
  static const segment2 = MasterType(id: 'segment2', displayName: 'セグメント2');
  static const segment3 = MasterType(id: 'segment3', displayName: 'セグメント3');
  static const project = MasterType(id: 'project', displayName: 'プロジェクト');
  static const client = MasterType(id: 'client', displayName: '取引先');
  static const account = MasterType(id: 'account', displayName: '勘定科目');
  static const expense = MasterType(id: 'expense', displayName: '費用項目');
  static const product = MasterType(id: 'product', displayName: '製品');
  static const location = MasterType(id: 'location', displayName: '拠点');

  // 全マスタタイプのリスト（タブの順番もここで制御）
  static const List<MasterType> values = [
    all,
    department,
    subject,
    segment1,
    segment2,
    segment3,
    project,
    client,
    account,
    expense,
    product,
    location,
  ];
}