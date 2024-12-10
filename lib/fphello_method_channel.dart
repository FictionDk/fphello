import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'fphello_platform_interface.dart';

class MethodChannelFphello extends FphelloPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('fp/method');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
  @override
  Future<String?> getLocation() async {
    return await methodChannel.invokeMethod<String>('getLocation');
  }
  @override
  Future<void> soundPlay() async {
    return await methodChannel.invokeMethod('soundPlay');
  }
}
