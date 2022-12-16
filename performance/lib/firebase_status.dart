class ResponseJson {
  List<FirebaseStatus>? response;

  ResponseJson({this.response});

  ResponseJson.fromJson(Map<String, dynamic> json) {
    if (json['response'] != null) {
      response = <FirebaseStatus>[];
      json['response'].forEach((v) {
        response!.add(new FirebaseStatus.fromJson(v));
      });
    }
  }
}

class FirebaseStatus {
  String? id;
  String? number;
  String? begin;
  String? created;
  String? end;
  String? modified;
  String? externalDesc;
  List<Updates>? updates;
  Updates? mostRecentUpdate;
  String? statusImpact;
  String? severity;
  String? serviceKey;
  String? serviceName;
  List<AffectedProducts>? affectedProducts;
  String? uri;

  FirebaseStatus(
      {this.id,
      this.number,
      this.begin,
      this.created,
      this.end,
      this.modified,
      this.externalDesc,
      this.updates,
      this.mostRecentUpdate,
      this.statusImpact,
      this.severity,
      this.serviceKey,
      this.serviceName,
      this.affectedProducts,
      this.uri});

  FirebaseStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    number = json['number'];
    begin = json['begin'];
    created = json['created'];
    end = json['end'];
    modified = json['modified'];
    externalDesc = json['external_desc'];
    if (json['updates'] != null) {
      updates = <Updates>[];
      json['updates'].forEach((v) {
        updates!.add(new Updates.fromJson(v));
      });
    }
    mostRecentUpdate = json['most_recent_update'] != null
        ? new Updates.fromJson(json['most_recent_update'])
        : null;
    statusImpact = json['status_impact'];
    severity = json['severity'];
    serviceKey = json['service_key'];
    serviceName = json['service_name'];
    if (json['affected_products'] != null) {
      affectedProducts = <AffectedProducts>[];
      json['affected_products'].forEach((v) {
        affectedProducts!.add(new AffectedProducts.fromJson(v));
      });
    }
    uri = json['uri'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['number'] = this.number;
    data['begin'] = this.begin;
    data['created'] = this.created;
    data['end'] = this.end;
    data['modified'] = this.modified;
    data['external_desc'] = this.externalDesc;
    if (this.updates != null) {
      data['updates'] = this.updates!.map((v) => v.toJson()).toList();
    }
    if (this.mostRecentUpdate != null) {
      data['most_recent_update'] = this.mostRecentUpdate!.toJson();
    }
    data['status_impact'] = this.statusImpact;
    data['severity'] = this.severity;
    data['service_key'] = this.serviceKey;
    data['service_name'] = this.serviceName;
    if (this.affectedProducts != null) {
      data['affected_products'] =
          this.affectedProducts!.map((v) => v.toJson()).toList();
    }
    data['uri'] = this.uri;
    return data;
  }
}

class Updates {
  String? created;
  String? modified;
  String? when;
  String? text;
  String? status;

  Updates({this.created, this.modified, this.when, this.text, this.status});

  Updates.fromJson(Map<String, dynamic> json) {
    created = json['created'];
    modified = json['modified'];
    when = json['when'];
    text = json['text'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created'] = this.created;
    data['modified'] = this.modified;
    data['when'] = this.when;
    data['text'] = this.text;
    data['status'] = this.status;
    return data;
  }
}

class AffectedProducts {
  String? title;
  String? id;

  AffectedProducts({this.title, this.id});

  AffectedProducts.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['id'] = this.id;
    return data;
  }
}
