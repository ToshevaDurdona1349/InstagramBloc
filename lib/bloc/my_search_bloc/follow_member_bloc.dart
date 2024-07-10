import 'package:bloc/bloc.dart';
import 'package:ngdemo17/services/log_service.dart';
import '../../model/member_model.dart';
import '../../services/db_service.dart';
import '../../services/http_service.dart';
import 'follow_member_event.dart';
import 'follow_member_state.dart';

class FollowMemberBloc extends Bloc<FollowEvent, FollowState> {
  FollowMemberBloc() : super(FollowMemberInitialState()) {
    on<FollowMemberEvent>(_onFollowMemberEvent);
    on<UnFollowMemberEvent>(_onUnFollowMemberEvent);
  }

  Future<void> _onFollowMemberEvent(FollowMemberEvent event, Emitter<FollowState> emit) async {
    await DBService.followMember(event.someone);
    event.someone.followed = true;
    emit(FollowMemberSuccessState(member: event.someone));

    DBService.storePostsToMyFeed(event.someone);
    sendNotificationToFollowedMember(event.someone);
  }

  Future<void> _onUnFollowMemberEvent(UnFollowMemberEvent event, Emitter<FollowState> emit) async {
    await DBService.unfollowMember(event.someone);
    event.someone.followed = false;
    emit(UnFollowMemberSuccessState(member: event.someone));

    DBService.removePostsFromMyFeed(event.someone);
  }

  void sendNotificationToFollowedMember(Member someone) async {
    Member me = await DBService.loadMember();
    await Network.POST(Network.API_SEND_NOTIF, Network.paramsNotify(me, someone));
  }
}
