
import 'package:bloc/bloc.dart';

import '../../services/db_service.dart';
import 'my_posts_event.dart';
import 'my_posts_state.dart';

class MyPostsBloc extends Bloc<MyPostsEvent, MyPostsState> {
  MyPostsBloc() : super(MyPostsInitialState()) {
    on<LoadMyPostsEvent>(_onLoadMyPostsEvent);
    on<RemoveMyPostEvent>(_onRemoveMyPostEvent);
  }

  Future<void> _onLoadMyPostsEvent(LoadMyPostsEvent event, Emitter<MyPostsState> emit) async {
    emit(MyPostsLoadingState());
    var items = await DBService.loadPosts();
    if (items.isNotEmpty) {
      emit(MyPostsSuccessState(items: items));
    } else {
      emit(MyPostsFailureState("No data"));
    }
  }

  Future<void> _onRemoveMyPostEvent(RemoveMyPostEvent event, Emitter<MyPostsState> emit) async {
    emit(MyPostsLoadingState());
    await DBService.removePost(event.post);
    emit(RemoveMyPostState());
  }
}