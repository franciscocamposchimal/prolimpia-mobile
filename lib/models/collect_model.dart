class Collect {
  List<TodayCollects> todayCollects;
  int total;

  Collect({this.todayCollects, this.total});

  Collect.fromJson(Map<String, dynamic> json) {
    if (json['today_collects'] != null) {
      todayCollects = new List<TodayCollects>();
      json['today_collects'].forEach((v) {
        todayCollects.add(new TodayCollects.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.todayCollects != null) {
      data['today_collects'] =
          this.todayCollects.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class TodayCollects {
  int id;
  int userId;
  String contract;
  Location location;
  Data data;
  String createdAt;
  String updatedAt;

  TodayCollects(
      {this.id,
      this.userId,
      this.contract,
      this.location,
      this.data,
      this.createdAt,
      this.updatedAt});

  TodayCollects.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    contract = json['contract'];
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['contract'] = this.contract;
    if (this.location != null) {
      data['location'] = this.location.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}


class Location {
  double lat;
  double lon;

  Location({this.lat, this.lon});

  Location.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lon = json['lon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    return data;
  }
}

class Data {
  int pago;
  int efectivo;
  int cambio;
  String tipoPago;
  String mac;

  Data({this.pago, this.efectivo, this.cambio, this.tipoPago, this.mac});

  Data.fromJson(Map<String, dynamic> json) {
    pago = json['pago'];
    efectivo = json['efectivo'];
    cambio = json['cambio'];
    tipoPago = json['tipo_pago'];
    mac = json['mac'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pago'] = this.pago;
    data['efectivo'] = this.efectivo;
    data['cambio'] = this.cambio;
    data['tipo_pago'] = this.tipoPago;
    data['mac'] = this.mac;
    return data;
  }
}
