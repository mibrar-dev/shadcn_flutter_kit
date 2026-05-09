// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart' as m;

import '../../control/button/button.dart';
import '../carousel/carousel.dart' as shadcn;

part '_carousel_preview_state.dart';

/// Core class used by the carousel component.
class CarouselPreview extends m.StatefulWidget {
  const CarouselPreview({super.key});

  @override
  m.State<CarouselPreview> createState() => _CarouselPreviewState();
}
