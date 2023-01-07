import 'package:get/get.dart';

import '../controllers/auth.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthCtx>(() => AuthCtx());
  }
}
