import 'dart:io';
import 'package:bloc/bloc.dart';
import 'image_picer_event.dart';
import 'image_picer_state.dart';


class ImagePickerBloc extends Bloc<PickerEvent, PickerState> {
  File? image;

  ImagePickerBloc() : super(PickInitialState()) {
    on<SelectedPhotoEvent>(_onSelectedPhotoEvent);
    on<ClearedPhotoEvent>(_onClearedPhotoEvent);
  }

  Future<void> _onSelectedPhotoEvent(SelectedPhotoEvent event, Emitter<PickerState> emit) async {
    image = event.image;
    emit(SelectedPhotoState());
  }

  Future<void> _onClearedPhotoEvent(ClearedPhotoEvent event, Emitter<PickerState> emit) async {
    image = null;
    emit(ClearedPhotoState());
  }
}
