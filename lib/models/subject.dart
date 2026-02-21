class Subject {
  final String id;
  final String name;
  final String iconName;
  final Map<String, double> pricePerBacType;

  Subject({
    required this.id,
    required this.name,
    required this.iconName,
    required this.pricePerBacType,
  });

  factory Subject.fromMap(Map<String, dynamic> map) => Subject(
    id: map['id'],
    name: map['name'],
    iconName: map['icon_name'],
    pricePerBacType: {
      'math': (map['price_math'] as num).toDouble(),
      'science': (map['price_science'] as num).toDouble(),
      'informatique': (map['price_informatique'] as num).toDouble(),
      'lettres': (map['price_lettres'] as num).toDouble(),
      'technique': (map['price_technique'] as num).toDouble(),
    },
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'icon_name': iconName,
    'price_math': pricePerBacType['math'],
    'price_science': pricePerBacType['science'],
    'price_informatique': pricePerBacType['informatique'],
    'price_lettres': pricePerBacType['lettres'],
    'price_technique': pricePerBacType['technique'],
  };

  Subject copyWith({
    String? name,
    String? iconName,
    Map<String, double>? pricePerBacType,
  }) {
    return Subject(
      id: id,
      name: name ?? this.name,
      iconName: iconName ?? this.iconName,
      pricePerBacType: pricePerBacType ?? this.pricePerBacType,
    );
  }
}
