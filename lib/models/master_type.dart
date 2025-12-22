// マスタタイプを表すクラス
//
// タブで表示されるマスタの種類を定義します。
// idは内部処理用、displayNameはUI表示用です。
class MasterType {
  // 内部で使用するID（例: 'account', 'client'）
  final String id;

  // UIに表示する名前（例: '勘定科目', '取引先'）
  final String displayName;

  // constコンストラクタ
  //
  // const を使用することで、コンパイル時に定数として扱われ、
  // メモリ効率が向上します。同じ値を持つインスタンスは
  // 同一のオブジェクトとして扱われます。
  const MasterType({
    required this.id,
    required this.displayName,
  });
}

// アプリケーション全体で使用するマスタタイプの定義
//
// このクラスは、全てのマスタタイプを一元管理します。
// 将来的にマスタを追加・変更する際は、ここを編集するだけで
// アプリケーション全体に反映されます。
class MasterTypes {
  // 各マスタタイプの定義
  // static const を使用することで、クラスをインスタンス化せずに
  // MasterTypes.all のようにアクセスできます

  // 全てのマスタを表示するタブ
  static const all = MasterType(id: 'all', displayName: '全て');

  // 勘定科目（日商簿記3級の科目体系に準拠）
  static const account = MasterType(id: 'account', displayName: '勘定科目');

  // 補助科目（勘定科目をさらに細分化）
  static const subAccount = MasterType(id: 'sub_account', displayName: '補助科目');

  // 取引先企業
  static const client = MasterType(id: 'client', displayName: '取引先');

  // プロジェクト・案件
  static const project = MasterType(id: 'project', displayName: 'プロジェクト');

  // 部門・事業区分
  static const department = MasterType(id: 'department', displayName: '部門');

  // 品目・サービス内容
  static const item = MasterType(id: 'item', displayName: '品目');

  // 決済方法
  static const paymentMethod = MasterType(id: 'payment_method', displayName: '決済方法');

  // 税区分（消費税の種類）
  static const taxType = MasterType(id: 'tax_type', displayName: '税区分');

  // セグメント（事業の切り口）
  static const segment = MasterType(id: 'segment', displayName: 'セグメント');

  // 全マスタタイプのリスト
  //
  // このリストの順番がタブの表示順になります。
  // 新しいマスタタイプを追加する場合は、上で定義してから
  // このリストに追加します。
  //
  // const List を使用することで、コンパイル時に固定されます
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