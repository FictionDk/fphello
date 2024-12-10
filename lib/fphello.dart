
import 'package:flutter/services.dart';

import 'fphello_platform_interface.dart';

class Fphello {
  Future<String?> getPlatformVersion() {
    return FphelloPlatform.instance.getPlatformVersion();
  }

  Future<String?> getLocation(){
    return FphelloPlatform.instance.getLocation();
  }

  Future<void> soundPlay(){
    return FphelloPlatform.instance.soundPlay();
  }

  EventChannel getEventStream(){
    return const EventChannel('fp/event');
  }
}
