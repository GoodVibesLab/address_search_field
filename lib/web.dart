import 'dart:async';
// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html show window;

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

/// A web implementation of the AddressSearchField plugin.
class AddressSearchFieldWeb {
  /// Constructor.
  const AddressSearchFieldWeb();

  /// Register method.
  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
      'address_search_field',
      const StandardMethodCodec(),
      // ignore: deprecated_member_use
      registrar.messenger,
    );

    final pluginInstance = AddressSearchFieldWeb();
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
  }

  /// Handles method calls over the MethodChannel of this plugin.
  /// Note: Check the "federated" architecture for a new way of doing this:
  /// https://flutter.dev/go/federated-plugins
  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'getPlatformVersion':
        return getPlatformVersion();
        // ignore: dead_code
        break;
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details:
              'address_search_field for web doesn\'t implement \'${call.method}\'',
        );
    }
  }

  /// Returns a [String] containing the version of the platform.
  Future<String> getPlatformVersion() {
    final version = html.window.navigator.userAgent;
    return Future.value(version);
  }
}
