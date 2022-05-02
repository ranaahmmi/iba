class CustmorModel {
  final int? cusSupPk;
  final String? csCode;
  final String? csName;
  final String? address;
  final String? cellNo;
  final String? phoneNo;
  final String? activeYn;
  final int? branchFk;
  final int? csClassificationFk;
  final int? cityFk;
  final String? cnicNtn;
  final String? registeredName;
  final double? latitude;
  final double? longitude;

  CustmorModel({
    this.cusSupPk,
    this.csCode,
    this.csName,
    this.address,
    this.cellNo,
    this.phoneNo,
    this.activeYn,
    this.branchFk,
    this.csClassificationFk,
    this.cityFk,
    this.cnicNtn,
    this.registeredName,
    this.latitude,
    this.longitude,
  });

  CustmorModel copyWith({
    int? cusSupPk,
    String? csCode,
    String? csName,
    String? address,
    String? cellNo,
    String? phoneNo,
    String? activeYn,
    int? branchFk,
    int? csClassificationFk,
    int? cityFk,
    String? cnicNtn,
    String? registeredName,
    double? latitude,
    double? longitude,
  }) {
    return CustmorModel(
      cusSupPk: cusSupPk ?? this.cusSupPk,
      csCode: csCode ?? this.csCode,
      csName: csName ?? this.csName,
      address: address ?? this.address,
      cellNo: cellNo ?? this.cellNo,
      phoneNo: phoneNo ?? this.phoneNo,
      activeYn: activeYn ?? this.activeYn,
      branchFk: branchFk ?? this.branchFk,
      csClassificationFk: csClassificationFk ?? this.csClassificationFk,
      cityFk: cityFk ?? this.cityFk,
      cnicNtn: cnicNtn ?? this.cnicNtn,
      registeredName: registeredName ?? this.registeredName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  CustmorModel.fromJson(Map<String, dynamic> json)
      : cusSupPk = json['cus_sup_pk'] as int?,
        csCode = json['cs_code'] as String?,
        csName = json['cs_name'] as String?,
        address = json['address'] as String?,
        cellNo = json['cell_no'] as String?,
        phoneNo = json['phone_no'] as String?,
        activeYn = json['active_yn'] as String?,
        branchFk = json['branch_fk'] as int?,
        csClassificationFk = json['cs_classification_fk'] as int?,
        cityFk = json['city_fk'] as int?,
        cnicNtn = json['cnic_ntn'] as String?,
        registeredName = json['registered_name'] as String?,
        latitude = json['latitude']?.toDouble(),
        longitude = json['longitude']?.toDouble();

  Map<String, dynamic> toJson() => {
        'cus_sup_pk': cusSupPk,
        'cs_code': csCode,
        'cs_name': csName,
        'address': address,
        'cell_no': cellNo,
        'phone_no': phoneNo,
        'active_yn': activeYn,
        'branch_fk': branchFk,
        'cs_classification_fk': csClassificationFk,
        'city_fk': cityFk,
        'cnic_ntn': cnicNtn,
        'registered_name': registeredName,
        'latitude': latitude,
        'longitude': longitude
      };
}
