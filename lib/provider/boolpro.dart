
import 'package:flutter/foundation.dart';

class ProviderModel extends ChangeNotifier
{


bool _switch=true;

bool get sswitch =>_switch;


void changebool()
{
 _switch=! _switch;
  
  notifyListeners();
}

}


class ProviderForsinup extends ChangeNotifier
{


bool _switch=false;

bool get sswitch =>_switch;


void changebool()
{
 !sswitch;
  
  notifyListeners();
}

}