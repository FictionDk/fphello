import 'package:flutter_test/flutter_test.dart';
import 'package:fphello/fphello.dart';
import 'package:fphello/fphello_platform_interface.dart';
import 'package:fphello/fphello_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFphelloPlatform
    with MockPlatformInterfaceMixin
    implements FphelloPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FphelloPlatform initialPlatform = FphelloPlatform.instance;

  test('$MethodChannelFphello is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFphello>());
  });

  test('getPlatformVersion', () async {
    Fphello fphelloPlugin = Fphello();
    MockFphelloPlatform fakePlatform = MockFphelloPlatform();
    FphelloPlatform.instance = fakePlatform;

    expect(await fphelloPlugin.getPlatformVersion(), '42');
  });
}
