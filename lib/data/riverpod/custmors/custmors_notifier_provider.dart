import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iba/data/repository/custmors_repository.dart';
import 'package:iba/data/riverpod/custmors/custmors_notifier.dart';
import 'package:iba/data/riverpod/custmors/custmors_state.dart';

final _custmorsRepositoryProvider = Provider((ref) => CustomrsRepository());

final custmorsNotifierProvider =
    StateNotifierProvider<CustmorsNotifier, CustmorsState>((ref) {
  return CustmorsNotifier(ref.watch(_custmorsRepositoryProvider));
});
