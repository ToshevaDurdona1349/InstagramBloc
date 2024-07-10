
import 'package:bloc/bloc.dart';

import '../../model/member_model.dart';
import '../../services/db_service.dart';
import '../../services/file_service.dart';
import 'my_photo_event.dart';
import 'my_photo_state.dart';

class MyPhotoBloc extends Bloc<MyPhotoEvent, MyPhotoState> {
  MyPhotoBloc() : super(MyPhotoInitialState()) {
    on<UploadMyPhotoEvent>(_onUploadMyPhotoEvent);
  }

  Future<void> _onUploadMyPhotoEvent(UploadMyPhotoEvent event, Emitter<MyPhotoState> emit) async {
    emit(MyPhotoLoadingState());
    var downloadUrl = await FileService.uploadUserImage(event.image);
    Member member = await DBService.loadMember();
    member.img_url = downloadUrl;
    await DBService.updateMember(member);
    emit(MyPhotoSuccessState());
  }
}