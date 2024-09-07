class Country {
  String? code;
  String? name;
  List<States>? states;

  Country({
    this.code,
    this.name,
    this.states,
  });

  @override
  String toString() {
    return 'Country{code: $code, name: $name}';
  }

  Country.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    if (json['states'] != null) {
      states = <States>[];
      json['states'].forEach((v) {
        states!.add(States.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['name'] = name;
    if (states != null) {
      data['states'] = states!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class States {
  String? code;
  String? name;

  States({this.code, this.name});

  States.fromJson(Map<String, dynamic> json) {
    code = json['code']?.toString();
    name = json['name']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['name'] = name;
    return data;
  }
}
