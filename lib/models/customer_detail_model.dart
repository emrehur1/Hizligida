class CustomerDetailsModel {
  int? id;
  String? firstName;
  String? lastName;
  String? password;
  Billing? billing;
  Shipping? shipping;
  String? email;

  CustomerDetailsModel({
    this.id,
    this.firstName,
    this.lastName,
    this.password,
    this.billing,
    this.shipping,
    this.email
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map.addAll(
      {
        'first_name': firstName,
        'last_name': lastName,
        'billing': billing?.toJson(),
        'shipping': shipping?.toJson(),
        'email': email,

      },
    );

    return map;
  }

  CustomerDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    billing =
    json['billing'] != null ? Billing.fromJson(json['billing']) : null;
    shipping =
    json['shipping'] != null ? Shipping.fromJson(json['shipping']) : null;
    email = json['email'];
  }
}

class Billing {
  String? firstName;
  String? lastName;
  String? company;
  String? address1;
  String? address2;
  String? city;
  String? postcode;
  String? country;
  String? state;
  String? email;
  String? phone;

  Billing({
    this.firstName,
    this.lastName,
    this.company,
    this.address1,
    this.address2,
    this.city,
    this.postcode,
    this.country,
    this.state,
    this.email,
    this.phone,
  });

  Billing.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    company = json['company'];
    address1 = json['address_1'];
    address2 = json['address_2'];
    city = json['city'];
    postcode = json['postcode'];
    country = json['country'];
    state = json['state'];
    email = json['email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['company'] = company;
    data['address_1'] = address1;
    data['address_2'] = address2;
    data['city'] = city;
    data['postcode'] = postcode;
    data['country'] = country;
    data['state'] = state;
    data['email'] = email;
    data['phone'] = phone;
    return data;
  }
}

class Shipping {
  String? firstName;
  String? lastName;
  String? company;
  String? address1;
  String? address2;
  String? city;
  String? postcode;
  String? country;
  String? state;
  String? phone;

  Shipping({
    this.firstName,
    this.lastName,
    this.company,
    this.address1,
    this.address2,
    this.city,
    this.postcode,
    this.country,
    this.state,
    this.phone,
  });

  Shipping.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    company = json['company'];
    address1 = json['address_1'];
    address2 = json['address_2'];
    city = json['city'];
    postcode = json['postcode'];
    country = json['country'];
    state = json['state'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['company'] = company;
    data['address_1'] = address1;
    data['address_2'] = address2;
    data['city'] = city;
    data['postcode'] = postcode;
    data['country'] = country;
    data['state'] = state;
    data['phone'] = phone;
    return data;
  }
}
