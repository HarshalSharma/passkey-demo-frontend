class Preferences {
  /* home latitude */
  double? homeLat;

/* home longitude */
  double? homeLog;

  Preferences({this.homeLat, this.homeLog});

  @override
  String toString() {
    return 'Preferences[homeLat=$homeLat, homeLog=$homeLog, ]';
  }

  Preferences.fromJson(Map<String, dynamic> json) {
    homeLat = json['home_lat'];
    homeLog = json['home_log'];
  }

  Map<String, dynamic> toJson() {
    return {'home_lat': homeLat, 'home_log': homeLog};
  }
}
