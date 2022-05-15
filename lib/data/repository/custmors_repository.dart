import 'package:iba/data/interfaces/icustmors_repository.dart';
import 'package:iba/data/models/custmor_model.dart';
import 'package:iba/data/network/network_utils.dart';

class CustomrsRepository implements IcutmorsRepository {
  int offset = 0;
  int limit = 30;
  List<CustmorModel> custmorsList = [];
  @override
  Future<List<CustmorModel>> fatchCustmor(int placeID, String search,
      {bool loadmore = false}) async {
    if (loadmore) {
      offset += limit;
    } else {
      offset = 0;
      custmorsList = [];
    }
    final response = await NetworkUtil().getRequest(
      api:
          '/customerInfo/${search == '' ? ' ' : search}/$placeID?limit=$limit&offset=$offset',
    );

    final list = List<CustmorModel>.from(
      response['items'].map((x) => CustmorModel.fromJson(x)),
    );

    custmorsList.addAll(list);
    return custmorsList;
  }
}
