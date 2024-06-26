class Entreprise {
  int? code;
  String? titre;
  String? video;
  String? detail;
  String? source;
  String? dateN;

  Entreprise({
    this.code,
    this.titre,
    this.video,
    this.detail,
    this.source,
    this.dateN,
  });

  factory Entreprise.fromJson(Map<String, dynamic> json) =>
      _$EntrepriseFromJson(json);
  Map<String, dynamic> toJson() => _$EntrepriseToJson(this);
}

Entreprise _$EntrepriseFromJson(Map<String, dynamic> json) {
  return Entreprise(
      code: json['id'] as int,
      titre: json['titre'] as String,
      video: json['video'] as String,
      source: json['source'] as String,
      dateN: json['dateN'] as String,
      detail: json['detail'] as String);
}

Map<String, dynamic> _$EntrepriseToJson(Entreprise instance) =>
    <String, dynamic>{
      'titre': instance.titre,
      'video': instance.video,
      'detail': instance.detail,
      'source': instance.source,
      'dateN': instance.dateN,
    };
