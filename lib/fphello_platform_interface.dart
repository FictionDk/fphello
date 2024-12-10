import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'fphello_method_channel.dart';

abstract class FphelloPlatform extends PlatformInterface {
  /// Constructs a FphelloPlatform.
  FphelloPlatform() : super(token: _token);

  static final Object _token = Object();

  static FphelloPlatform _instance = MethodChannelFphello();

  /// The default instance of [FphelloPlatform] to use.
  ///
  /// Defaults to [MethodChannelFphello].
  static FphelloPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FphelloPlatform] when
  /// they register themselves.
  static set instance(FphelloPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
  Future<String?> getLocation(){
    throw UnimplementedError('getLocation() has not been implemented.');
  }
  Future<void> soundPlay(){
    throw UnimplementedError('soundPlay() has not been implemented.');
  }
}
