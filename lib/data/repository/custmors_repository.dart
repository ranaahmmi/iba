import 'package:iba/data/interfaces/icustmors_repository.dart';
import 'package:iba/data/models/custmor_model.dart';
import 'package:iba/data/network/network_utils.dart';

class CustomrsRepository implements IcutmorsRepository {
  int page = 0;
  List<CustmorModel> custmorsList = [];
  @override
  Future<List<CustmorModel>> fatchCustmor(int placeID,
      {bool loadmore = false}) async {
    if (loadmore) {
      page++;
    } else {
      page = 0;
      custmorsList = [];
    }
    final response = await NetworkUtil().getRequest(
      api: '/allcustomers/$placeID?limit=30&offset=$page',
    );

    final list = List<CustmorModel>.from(
      response['items'].map((x) => CustmorModel.fromJson(x)),
    );
    print(list);
    custmorsList.addAll(list);
    return custmorsList;
  }
}
