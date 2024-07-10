import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class PickerEvent extends Equatable {
  const PickerEvent();
}

class SelectedPhotoEvent extends PickerEvent {
  File? image;

  SelectedPhotoEvent({required this.image});

  @override
  List<Object> get props => [];
}

class ClearedPhotoEvent extends PickerEvent {

  @override
  List<Object> get props => [];
}
