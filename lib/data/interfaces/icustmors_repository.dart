import 'package:iba/data/models/custmor_model.dart';

abstract class IcutmorsRepository {
  Future<List<CustmorModel>> fatchCustmor(int placeId, String search, {bool loadmore});
}
