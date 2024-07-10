
import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class MyPhotoEvent extends Equatable {
  const MyPhotoEvent();
}

class UploadMyPhotoEvent extends MyPhotoEvent {
  File image;

  UploadMyPhotoEvent({required this.image});

  @override
  List<Object> get props => [];
}