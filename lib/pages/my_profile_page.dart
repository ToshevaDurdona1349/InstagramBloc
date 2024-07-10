import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ngdemo17/pages/signin_page.dart';
import '../bloc/my_profile_bloc/axis_count_bloc.dart';
import '../bloc/my_profile_bloc/my_posts_bloc.dart';
import '../bloc/my_profile_bloc/my_posts_event.dart';
import '../bloc/my_profile_bloc/my_posts_state.dart';
import '../bloc/my_profile_bloc/my_photo_bloc.dart';
import '../bloc/my_profile_bloc/my_photo_event.dart';
import '../bloc/my_profile_bloc/my_photo_state.dart';
import '../bloc/my_profile_bloc/my_profile_bloc.dart';
import '../bloc/my_profile_bloc/my_profile_event.dart';
import '../bloc/my_profile_bloc/my_profile_state.dart';
import '../bloc/signin_bloc/signin_bloc.dart';
import '../model/member_model.dart';
import '../model/post_model.dart';
import '../services/auth_service.dart';
import '../services/utils_service.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  late MyProfileBloc profileBloc;
  late MyPostsBloc postsBloc;
  late MyPhotoBloc photoBloc;

  final ImagePicker _picker = ImagePicker();

  _imgFromGallery() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    photoBloc.add(UploadMyPhotoEvent(image: File(image!.path)));
  }

  _imgFromCamera() async {
    XFile? image = await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    photoBloc.add(UploadMyPhotoEvent(image: File(image!.path)));
  }

  _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Pick Photo'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Take Photo'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  _dialogRemovePost(Post post) async {
    var result = await Utils.dialogCommon(context, "Instagram", "Do you want to detele this post?", false);
    if (result) {
      postsBloc.add(RemoveMyPostEvent(post: post));
    }
  }

  _dialogLogout() async {
    var result = await Utils.dialogCommon(context, "Instagram", "Do you want to logout?", false);
    if (result) {
      _signOutUser();
    }
  }

  _signOutUser() {
    AuthService.signOutUser(context);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => SignInBloc(),
              child: const SignInPage(),
            )));
  }

  @override
  void initState() {
    super.initState();
    profileBloc = context.read<MyProfileBloc>();
    profileBloc.add(LoadProfileMemberEvent());
    postsBloc = context.read<MyPostsBloc>();
    postsBloc.add(LoadMyPostsEvent());
    photoBloc = context.read<MyPhotoBloc>();
    photoBloc.stream.listen((state) {
      if(state is MyPhotoSuccessState){
        profileBloc.add(LoadProfileMemberEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyProfileBloc, MyProfileState>(
      listener: (context, state){

      },
      builder: (context, state){
        if(state is MyProfileLoadingState){
          return viewOfMyProfilePage(true, Member("", ""));
        }
        if(state is MyProfileLoadMemberState){
          return viewOfMyProfilePage(false, state.member);
        }
        return viewOfMyProfilePage(false, Member("", ""));
      },
    );
  }

  Widget viewOfMyProfilePage(bool isLoading, Member member){
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            "Profile",
            style: TextStyle(
                color: Colors.black, fontFamily: "Billabong", fontSize: 25),
          ),
          actions: [
            IconButton(
              onPressed: () {
                _dialogLogout();
              },
              icon: const Icon(Icons.exit_to_app),
              color: const Color.fromRGBO(193, 53, 132, 1),
            )
          ],
        ),
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  //#myphoto
                  GestureDetector(
                      onTap: () {
                        _showPicker(context);
                      },
                      child: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(70),
                              border: Border.all(
                                width: 1.5,
                                color: const Color.fromRGBO(193, 53, 132, 1),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(35),
                              child: member.img_url.isEmpty
                                  ? const Image(
                                image: AssetImage(
                                    "assets/images/ic_person.png"),
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              )
                                  : Image.network(
                                member.img_url,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 80,
                            height: 80,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.add_circle,
                                  color: Colors.purple,
                                )
                              ],
                            ),
                          ),
                        ],
                      )),

                  //#myinfos
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    member.fullname.toUpperCase(),
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    member.email,
                    style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        fontWeight: FontWeight.normal),
                  ),

                  //#mycounts
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    height: 80,
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Column(
                              children: [
                                BlocBuilder<MyPostsBloc, MyPostsState>(
                                  builder: (context, state){
                                    if(state is MyPostsSuccessState){
                                      return Text(
                                        state.items.length.toString(),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      );
                                    }
                                    return const Text(
                                      "0",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                const Text(
                                  "POSTS",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  member.followers_count.toString(),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                const Text(
                                  "FOLLOWERS",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  member.following_count.toString(),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                const Text(
                                  "FOLLOWING",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //list or grid
                  Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              context.read<AxisCountBloc>().add(AxisCountEvent(axisCount: 1));
                            },
                            icon: Icon(Icons.list_alt),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              context.read<AxisCountBloc>().add(AxisCountEvent(axisCount: 2));
                            },
                            icon: const Icon(Icons.grid_view),
                          ),
                        ),
                      ),
                    ],
                  ),

                  //#myposts
                  BlocBuilder<MyPostsBloc, MyPostsState>(
                    builder: (context, state){
                      if(state is MyPostsSuccessState){
                        return viewOfMyPosts(state.items);
                      }
                      return viewOfMyPosts([]);
                    },
                  ),
                ],
              ),
            ),

            isLoading? const Center(
              child: CircularProgressIndicator(),
            ): const SizedBox.shrink(),
          ],
        ));
  }

  Widget viewOfMyPosts(List<Post> items){
    return BlocBuilder<AxisCountBloc, int>(
      builder: (context, state){
        return Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: state),
            itemCount: items.length,
            itemBuilder: (ctx, index) {
              return _itemOfPost(items[index]);
            },
          ),
        );
      },
    );
  }

  Widget _itemOfPost(Post post) {
    return GestureDetector(
        onLongPress: () {
          _dialogRemovePost(post);
        },
        child: Container(
          margin: const EdgeInsets.all(5),
          child: Column(
            children: [
              Expanded(
                child: CachedNetworkImage(
                  width: double.infinity,
                  imageUrl: post.img_post,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              Text(
                post.caption,
                style: TextStyle(color: Colors.black87.withOpacity(0.7)),
                maxLines: 2,
              )
            ],
          ),
        ));
  }
}