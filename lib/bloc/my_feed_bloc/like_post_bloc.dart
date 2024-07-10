import 'package:bloc/bloc.dart';
import '../../services/db_service.dart';
import 'like_post_event.dart';
import 'like_post_state.dart';

class LikePostBloc extends Bloc<LikedEvent, LikeState> {
  LikePostBloc() : super(LikePostInitialState()) {
    on<LikePostEvent>(_onLikePostEvent);
    on<UnlikePostEvent>(_onUnlikePostEvent);
  }

  Future<void> _onLikePostEvent(LikePostEvent event, Emitter<LikeState> emit) async {
    await DBService.likePost(event.post, true);
    event.post.liked = true;
    emit(LikePostSuccessState(post: event.post));
  }

  Future<void> _onUnlikePostEvent(UnlikePostEvent event, Emitter<LikeState> emit) async {

    await DBService.likePost(event.post, false);
    event.post.liked = false;
    emit(UnLikePostSuccessState(post: event.post));
  }
}
