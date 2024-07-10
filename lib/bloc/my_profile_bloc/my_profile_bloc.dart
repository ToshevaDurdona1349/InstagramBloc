

import 'package:bloc/bloc.dart';
import '../../services/db_service.dart';
import 'my_profile_event.dart';
import 'my_profile_state.dart';

class MyProfileBloc extends Bloc<MyProfileEvent, MyProfileState> {
  MyProfileBloc() : super(MyProfileInitialState()) {
    on<LoadProfileMemberEvent>(_onLoadProfileMemberEvent);
  }

  Future<void> _onLoadProfileMemberEvent(LoadProfileMemberEvent event, Emitter<MyProfileState> emit) async {
    emit(MyProfileLoadingState());
    var member = await DBService.loadMember();
    emit(MyProfileLoadMemberState(member: member));
  }
}
