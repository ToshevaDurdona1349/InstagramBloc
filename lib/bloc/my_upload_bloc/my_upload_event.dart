import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class MyUploadEvent extends Equatable {
  const MyUploadEvent();
}

class UploadPostEvent extends MyUploadEvent {
  String caption;
  File image;

  UploadPostEvent({required this.caption, required this.image});

  @override
  List<Object> get props => [];
}
