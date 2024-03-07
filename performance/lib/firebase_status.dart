class ResponseJson {
  List<FirebaseStatus>? response;

  ResponseJson({this.response});

  ResponseJson.fromJson(Map<String, dynamic> json) {
    if (json['response'] != null) {
      response = <FirebaseStatus>[];
      json['response'].forEach((v) {
        response!.add(FirebaseStatus.fromJson(v));
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
        updates!.add(Updates.fromJson(v));
      });
    }
    mostRecentUpdate = json['most_recent_update'] != null
        ? Updates.fromJson(json['most_recent_update'])
        : null;
    statusImpact = json['status_impact'];
    severity = json['severity'];
    serviceKey = json['service_key'];
    serviceName = json['service_name'];
    if (json['affected_products'] != null) {
      affectedProducts = <AffectedProducts>[];
      json['affected_products'].forEach((v) {
        affectedProducts!.add(AffectedProducts.fromJson(v));
      });
    }
    uri = json['uri'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['number'] = number;
    data['begin'] = begin;
    data['created'] = created;
    data['end'] = end;
    data['modified'] = modified;
    data['external_desc'] = externalDesc;
    if (updates != null) {
      data['updates'] = updates!.map((v) => v.toJson()).toList();
    }
    if (mostRecentUpdate != null) {
      data['most_recent_update'] = mostRecentUpdate!.toJson();
    }
    data['status_impact'] = statusImpact;
    data['severity'] = severity;
    data['service_key'] = serviceKey;
    data['service_name'] = serviceName;
    if (affectedProducts != null) {
      data['affected_products'] =
          affectedProducts!.map((v) => v.toJson()).toList();
    }
    data['uri'] = uri;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['created'] = created;
    data['modified'] = modified;
    data['when'] = when;
    data['text'] = text;
    data['status'] = status;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['id'] = id;
    return data;
  }
}
