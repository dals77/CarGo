import 'package:get/get.dart';


class GeneralBindings extends Bindings{
  @override
  void dependencies() {
    // Get.lazyPut<NetworkManager>(() => NetworkManager());
    //Get.put(NetworkManager());
  }

}