// マスタアイテムのデータモデル
//
// このクラスは、勘定科目や取引先などのマスタデータを表現します。
// Flutterでは、データをクラスとして定義し、型安全性を確保します。
class MasterItem {
  // 一意の識別子（例: 'ac101', 'cl001'）
  final String id;

  // 表示名（例: '現金', '株式会社テクノロジー'）
  final String name;

  // マスタの種類（例: 'account', 'client'）
  // この値でデータをフィルタリングします
  final String masterType;

  // 最後に選択された日時
  // null の場合は、まだ選択されたことがない項目です
  // この情報を使って「最近使用した項目」を優先表示します
  final DateTime? lastSelected;

  // コンストラクタ
  //
  // required キーワードは、この引数が必須であることを示します
  // Dartでは名前付き引数を使うことで、可読性を高めます
  MasterItem({
    required this.id,
    required this.name,
    required this.masterType,
    this.lastSelected, // オプショナル（nullを許可）
  });

  // copyWith メソッド
  //
  // 既存のオブジェクトの一部のプロパティだけを変更した
  // 新しいオブジェクトを作成するためのメソッドです。
  //
  // Flutterでは、イミュータブル（不変）なデータを扱うことが推奨されており、
  // 既存のオブジェクトを直接変更するのではなく、新しいオブジェクトを
  // 作成することで、状態管理を安全に行います。
  //
  // 使用例:
  // final newItem = item.copyWith(lastSelected: DateTime.now());
  MasterItem copyWith({
    String? id,
    String? name,
    String? masterType,
    DateTime? lastSelected,
  }) {
    return MasterItem(
      id: id ?? this.id, // 新しい値がnullなら既存の値を使用
      name: name ?? this.name,
      masterType: masterType ?? this.masterType,
      lastSelected: lastSelected ?? this.lastSelected,
    );
  }

  // JSON形式への変換メソッド
  //
  // SharedPreferencesなどのローカルストレージに保存する際、
  // オブジェクトをJSON形式に変換する必要があります。
  //
  // Map<String, dynamic> は、キーが文字列で値が任意の型のマップです
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'masterType': masterType,
      // DateTimeはそのままでは保存できないため、ISO8601形式の文字列に変換
      'lastSelected': lastSelected?.toIso8601String(),
    };
  }

  // JSONからオブジェクトへの変換（ファクトリコンストラクタ）
  //
  // ローカルストレージから読み込んだJSON文字列を
  // MasterItemオブジェクトに変換します。
  //
  // factory キーワードは、通常のコンストラクタとは異なり、
  // 必ずしも新しいインスタンスを返す必要がないコンストラクタです
  factory MasterItem.fromJson(Map<String, dynamic> json) {
    return MasterItem(
      id: json['id'] as String,           // as String で型キャスト
      name: json['name'] as String,
      masterType: json['masterType'] as String,
      // lastSelectedがnullでない場合のみ、文字列をDateTimeに変換
      lastSelected: json['lastSelected'] != null
          ? DateTime.parse(json['lastSelected'] as String)
          : null,
    );
  }

  // 等価性の比較演算子をオーバーライド
  //
  // Dartでは、デフォルトでは == 演算子はオブジェクトの参照を比較します。
  // しかし、ここでは「同じidとmasterTypeを持つアイテム」を
  // 等しいと判定したいため、演算子をオーバーライドします。
  //
  // これにより、selectedItems.contains(item) などで
  // 正しく比較できるようになります
  @override
  bool operator ==(Object other) {
    // 型チェック: otherがMasterItemでない場合はfalse
    if (identical(this, other)) return true;
    return other is MasterItem &&
        other.id == id &&
        other.masterType == masterType;
  }

  // ハッシュコードのオーバーライド
  //
  // == をオーバーライドする場合、hashCodeも必ずオーバーライドする必要があります。
  // これにより、HashMapやHashSetなどで正しく動作します。
  //
  // ^ はXOR（排他的論理和）演算子で、2つの値を組み合わせて
  // ユニークなハッシュ値を生成します
  @override
  int get hashCode => id.hashCode ^ masterType.hashCode;
}