import 'dart:io';

abstract class PickerState {}

class PickInitialState extends PickerState {}

class SelectedPhotoState extends PickerState {
}

class ClearedPhotoState extends PickerState {
}
