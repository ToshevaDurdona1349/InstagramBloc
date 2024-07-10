
import 'package:bloc/bloc.dart';
import '../../services/db_service.dart';
import 'my_likes_event.dart';
import 'my_likes_state.dart';


class MyLikedBloc extends Bloc<MyLikedEvent, MyLikedState> {
  MyLikedBloc() : super(MyLikedInitialState()) {
    on<LoadLikedPostsEvent>(_onLoadLikedPostsEvent);
    on<UnLikePostEvent>(_onUnLikedPostEvent);
    on<RemovePostEvent>(_onRemovedPostEvent);
  }

  Future<void> _onLoadLikedPostsEvent(LoadLikedPostsEvent event, Emitter<MyLikedState> emit) async {
    emit(MyLikedLoadingState());
    var items = await DBService.loadLikes();
    if (items.isNotEmpty) {
      emit(MyLikedSuccessState(items: items));
    } else {
      emit(MyLikedFailureState("No data"));
    }
  }

  Future<void> _onUnLikedPostEvent(UnLikePostEvent event, Emitter<MyLikedState> emit) async {
    emit(MyLikedLoadingState());
    await DBService.likePost(event.post, false);
    emit(UnLikePostSuccessState());
  }

  Future<void> _onRemovedPostEvent(RemovePostEvent event, Emitter<MyLikedState> emit) async {
    emit(MyLikedLoadingState());
    await DBService.removePost(event.post);
    emit(RemovePostSuccessState());
  }
}
