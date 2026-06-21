import 'package:get/get.dart';

class NavigationController extends GetxController {
  final selectedindex = 0.obs;
  int get selectedIndex => selectedindex.value;
 

 void changeIndex (int index){
  selectedindex.value = index;
 }
}
