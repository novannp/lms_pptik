// To parse this JSON data, do
//
//     final notificationSettingsModel = notificationSettingsModelFromJson(jsonString);

import 'dart:convert';

NotificationSettingsModel notificationSettingsModelFromJson(String str) =>
    NotificationSettingsModel.fromJson(json.decode(str));

String notificationSettingsModelToJson(NotificationSettingsModel data) =>
    json.encode(data.toJson());

class NotificationSettingsModel {
  final Preferences preferences;
  final List<dynamic> warnings;

  NotificationSettingsModel({
    required this.preferences,
    required this.warnings,
  });

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) =>
      NotificationSettingsModel(
        preferences: Preferences.fromJson(json["preferences"]),
        warnings: List<dynamic>.from(json["warnings"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "preferences": preferences.toJson(),
        "warnings": List<dynamic>.from(warnings.map((x) => x)),
      };
}

class Preferences {
  final int userid;
  final int disableall;
  final List<PreferencesProcessor> processors;
  final List<Component> components;

  Preferences({
    required this.userid,
    required this.disableall,
    required this.processors,
    required this.components,
  });

  factory Preferences.fromJson(Map<String, dynamic> json) => Preferences(
        userid: json["userid"],
        disableall: json["disableall"],
        processors: List<PreferencesProcessor>.from(
            json["processors"].map((x) => PreferencesProcessor.fromJson(x))),
        components: List<Component>.from(
            json["components"].map((x) => Component.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "userid": userid,
        "disableall": disableall,
        "processors": List<dynamic>.from(processors.map((x) => x.toJson())),
        "components": List<dynamic>.from(components.map((x) => x.toJson())),
      };
}

class Component {
  final String displayname;
  final List<Notification> notifications;

  Component({
    required this.displayname,
    required this.notifications,
  });

  factory Component.fromJson(Map<String, dynamic> json) => Component(
        displayname: json["displayname"],
        notifications: List<Notification>.from(
            json["notifications"].map((x) => Notification.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "displayname": displayname,
        "notifications":
            List<dynamic>.from(notifications.map((x) => x.toJson())),
      };
}

class Notification {
  final String displayname;
  final String preferencekey;
  final List<NotificationProcessor> processors;

  Notification({
    required this.displayname,
    required this.preferencekey,
    required this.processors,
  });

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
        displayname: json["displayname"],
        preferencekey: json["preferencekey"],
        processors: List<NotificationProcessor>.from(
            json["processors"].map((x) => NotificationProcessor.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "displayname": displayname,
        "preferencekey": preferencekey,
        "processors": List<dynamic>.from(processors.map((x) => x.toJson())),
      };
}

class NotificationProcessor {
  final ProcessorDisplayname displayname;
  final ProcessorName name;
  final bool locked;
  final int userconfigured;
  final Logged loggedin;
  final Logged loggedoff;

  NotificationProcessor({
    required this.displayname,
    required this.name,
    required this.locked,
    required this.userconfigured,
    required this.loggedin,
    required this.loggedoff,
  });

  factory NotificationProcessor.fromJson(Map<String, dynamic> json) =>
      NotificationProcessor(
        displayname: processorDisplaynameValues.map[json["displayname"]]!,
        name: processorNameValues.map[json["name"]]!,
        locked: json["locked"],
        userconfigured: json["userconfigured"],
        loggedin: Logged.fromJson(json["loggedin"]),
        loggedoff: Logged.fromJson(json["loggedoff"]),
      );

  Map<String, dynamic> toJson() => {
        "displayname": processorDisplaynameValues.reverse[displayname],
        "name": processorNameValues.reverse[name],
        "locked": locked,
        "userconfigured": userconfigured,
        "loggedin": loggedin.toJson(),
        "loggedoff": loggedoff.toJson(),
      };
}

enum ProcessorDisplayname { WEB, EMAIL }

final processorDisplaynameValues = EnumValues(
    {"Email": ProcessorDisplayname.EMAIL, "Web": ProcessorDisplayname.WEB});

class Logged {
  final LoggedinName name;
  final LoggedinDisplayname displayname;
  final bool checked;

  Logged({
    required this.name,
    required this.displayname,
    required this.checked,
  });

  factory Logged.fromJson(Map<String, dynamic> json) => Logged(
        name: loggedinNameValues.map[json["name"]]!,
        displayname: loggedinDisplaynameValues.map[json["displayname"]]!,
        checked: json["checked"],
      );

  Map<String, dynamic> toJson() => {
        "name": loggedinNameValues.reverse[name],
        "displayname": loggedinDisplaynameValues.reverse[displayname],
        "checked": checked,
      };
}

enum LoggedinDisplayname {
  WHEN_YOU_ARE_LOGGED_INTO_MOODLE,
  WHEN_YOU_ARE_NOT_LOGGED_INTO_MOODLE
}

final loggedinDisplaynameValues = EnumValues({
  "When you are logged into Moodle":
      LoggedinDisplayname.WHEN_YOU_ARE_LOGGED_INTO_MOODLE,
  "When you are not logged into Moodle":
      LoggedinDisplayname.WHEN_YOU_ARE_NOT_LOGGED_INTO_MOODLE
});

enum LoggedinName { LOGGEDIN, LOGGEDOFF }

final loggedinNameValues = EnumValues(
    {"loggedin": LoggedinName.LOGGEDIN, "loggedoff": LoggedinName.LOGGEDOFF});

enum ProcessorName { POPUP, EMAIL }

final processorNameValues =
    EnumValues({"email": ProcessorName.EMAIL, "popup": ProcessorName.POPUP});

class PreferencesProcessor {
  final ProcessorDisplayname displayname;
  final ProcessorName name;
  final bool hassettings;
  final int contextid;
  final int userconfigured;

  PreferencesProcessor({
    required this.displayname,
    required this.name,
    required this.hassettings,
    required this.contextid,
    required this.userconfigured,
  });

  factory PreferencesProcessor.fromJson(Map<String, dynamic> json) =>
      PreferencesProcessor(
        displayname: processorDisplaynameValues.map[json["displayname"]]!,
        name: processorNameValues.map[json["name"]]!,
        hassettings: json["hassettings"],
        contextid: json["contextid"],
        userconfigured: json["userconfigured"],
      );

  Map<String, dynamic> toJson() => {
        "displayname": processorDisplaynameValues.reverse[displayname],
        "name": processorNameValues.reverse[name],
        "hassettings": hassettings,
        "contextid": contextid,
        "userconfigured": userconfigured,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
