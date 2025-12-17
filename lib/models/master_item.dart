class MasterItem {
  final String id;
  final String name;
  final String masterType;
  final DateTime? lastSelected;

  MasterItem({
    required this.id,
    required this.name,
    required this.masterType,
    this.lastSelected,
  });

  MasterItem copyWith({
    String? id,
    String? name,
    String? masterType,
    DateTime? lastSelected,
  }) {
    return MasterItem(
      id: id ?? this.id,
      name: name ?? this.name,
      masterType: masterType ?? this.masterType,
      lastSelected: lastSelected ?? this.lastSelected,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'masterType': masterType,
      'lastSelected': lastSelected?.toIso8601String(),
    };
  }

  factory MasterItem.fromJson(Map<String, dynamic> json) {
    return MasterItem(
      id: json['id'] as String,
      name: json['name'] as String,
      masterType: json['masterType'] as String,
      lastSelected: json['lastSelected'] != null
          ? DateTime.parse(json['lastSelected'] as String)
          : null,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MasterItem && other.id == id && other.masterType == masterType;
  }

  @override
  int get hashCode => id.hashCode ^ masterType.hashCode;
}