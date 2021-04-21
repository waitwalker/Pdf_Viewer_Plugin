// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pdf_viewer_plugin/src/pdf_viewer_method_channel.dart';

import '../pdf_viewer_plugin.dart';

/// Builds an Android pdfview.
///
/// This is used as the default implementation for [PdfView.platform] on Android. It uses
/// an [AndroidView] to embed the pdfview in the widget hierarchy, and uses a method channel to
/// communicate with the platform code.
class AndroidPdfViewer implements PdfViewerPlatform {
  @override
  Widget build({
    BuildContext? context,
    CreationParams? creationParams,
    Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers,
  }) {
    return GestureDetector(
      // We prevent text selection by intercepting the long press event.
      // This is a temporary stop gap due to issues with text selection on Android:
      // https://github.com/flutter/flutter/issues/24585 - the text selection
      // dialog is not responding to touch events.
      // https://github.com/flutter/flutter/issues/24584 - the text selection
      // handles are not showing.
      // TODO(amirh): remove this when the issues above are fixed.
      onLongPress: () {},
      excludeFromSemantics: true,
      child: AndroidView(
        viewType: 'pdf_viewer_plugin',
        onPlatformViewCreated: (int id) {},
        gestureRecognizers: gestureRecognizers,
        layoutDirection: TextDirection.rtl,
        creationParams:
            MethodChannelPdfViewerPlatform.creationParamsToMap(creationParams!),
        creationParamsCodec: const StandardMessageCodec(),
      ),
    );
  }
}
