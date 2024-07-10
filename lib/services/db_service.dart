import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ngdemo17/services/utils_service.dart';
import '../model/member_model.dart';
import '../model/post_model.dart';
import 'auth_service.dart';
import 'log_service.dart';

class DBService {
  static final _firestore = FirebaseFirestore.instance;

  static String folder_users = "users";
  static String folder_posts = "posts";
  static String folder_feeds = "feeds";
  static String folder_following = "following";
  static String folder_followers = "followers";

  /// Member Related
  static Future storeMember(Member member) async {
    member.uid = AuthService.currentUserId();

    Map<String, String> params = await Utils.deviceParams();
    LogService.i(params.toString());

    member.device_id = params["device_id"]!;
    member.device_type = params["device_type"]!;
    member.device_token = params["device_token"]!;

    return _firestore
        .collection(folder_users)
        .doc(member.uid)
        .set(member.toJson());
  }

  static Future<Member> getOwner(String uid) async {
    var user = await _firestore.collection(folder_users).doc(uid).get();
    var receiver = Member.fromJson(user.data()!);
    LogService.i(receiver.fullname);
    return receiver;
  }

  static Future<Member> loadMember() async {
    String uid = AuthService.currentUserId();
    var value = await _firestore.collection(folder_users).doc(uid).get();
    Member member = Member.fromJson(value.data()!);

    var querySnapshot1 = await _firestore
        .collection(folder_users)
        .doc(uid)
        .collection(folder_followers)
        .get();
    member.followers_count = querySnapshot1.docs.length;

    var querySnapshot2 = await _firestore
        .collection(folder_users)
        .doc(uid)
        .collection(folder_following)
        .get();
    member.following_count = querySnapshot2.docs.length;

    return member;
  }

  static Future updateMember(Member member) async {
    String uid = AuthService.currentUserId();
    return _firestore.collection(folder_users).doc(uid).update(member.toJson());
  }

  static Future<List<Member>> searchMembers(String keyword) async {
    List<Member> allMembers = [];
    List<Member> myMembers = [];
    List<Member> result = [];
    String uid = AuthService.currentUserId();

    var querySnapshot1 = await _firestore
        .collection(folder_users)
        .orderBy("email")
        .startAt([keyword]).get();

    var querySnapshot2 = await _firestore
        .collection(folder_users)
        .doc(uid)
        .collection(folder_following)
        .get();

    for (var result in querySnapshot1.docs) {
      Member newMember = Member.fromJson(result.data());
      if (newMember.uid != uid) {
        allMembers.add(newMember);
      }
    }

    for (var result in querySnapshot2.docs) {
      Member newMember = Member.fromJson(result.data());
      myMembers.add(newMember);
    }

    for (var member in allMembers) {
      if (myMembers.any((obj) => obj.uid == member.uid)) {
        member.followed = true;
        result.add(member);
      } else {
        result.add(member);
      }
    }

    return result;
  }

  static Future<Member> followMember(Member someone) async {
    Member me = await loadMember();

    // I followed to someone
    await _firestore
        .collection(folder_users)
        .doc(me.uid)
        .collection(folder_following)
        .doc(someone.uid)
        .set(someone.toJson());

    // I am in someone`s followers
    await _firestore
        .collection(folder_users)
        .doc(someone.uid)
        .collection(folder_followers)
        .doc(me.uid)
        .set(me.toJson());

    return someone;
  }

  static Future<Member> unfollowMember(Member someone) async {
    Member me = await loadMember();

    // I un followed to someone
    await _firestore
        .collection(folder_users)
        .doc(me.uid)
        .collection(folder_following)
        .doc(someone.uid)
        .delete();

    // I am not in someone`s followers
    await _firestore
        .collection(folder_users)
        .doc(someone.uid)
        .collection(folder_followers)
        .doc(me.uid)
        .delete();

    return someone;
  }

  /// Post Related
  static Future<Post> storePost(Post post) async {
    Member me = await loadMember();
    post.uid = me.uid;
    post.fullname = me.fullname;
    post.img_user = me.img_url;
    post.date = Utils.currentDate();

    String postId = _firestore
        .collection(folder_users)
        .doc(me.uid)
        .collection(folder_posts)
        .doc()
        .id;
    post.id = postId;

    await _firestore
        .collection(folder_users)
        .doc(me.uid)
        .collection(folder_posts)
        .doc(postId)
        .set(post.toJson());
    return post;
  }

  static Future<Post> storeFeed(Post post) async {
    String uid = AuthService.currentUserId();
    await _firestore
        .collection(folder_users)
        .doc(uid)
        .collection(folder_feeds)
        .doc(post.id)
        .set(post.toJson());
    return post;
  }

  static Future<List<Post>> loadPosts() async {
    List<Post> posts = [];
    String uid = AuthService.currentUserId();

    var querySnapshot = await _firestore
        .collection(folder_users)
        .doc(uid)
        .collection(folder_posts)
        .get();

    for (var result in querySnapshot.docs) {
      posts.add(Post.fromJson(result.data()));
    }
    return posts;
  }

  static Future<List<Post>> loadFeeds() async {
    List<Post> posts = [];
    String uid = AuthService.currentUserId();
    var querySnapshot = await _firestore
        .collection(folder_users)
        .doc(uid)
        .collection(folder_feeds)
        .get();

    for (var result in querySnapshot.docs) {
      Post post = Post.fromJson(result.data());
      if (post.uid == uid) post.mine = true;
      posts.add(post);
    }

    return posts;
  }

  static Future storePostsToMyFeed(Member someone) async {
    List<Post> posts = [];

    var querySnapshot = await _firestore
        .collection(folder_users)
        .doc(someone.uid)
        .collection(folder_posts)
        .get();

    for (var result in querySnapshot.docs) {
      var post = Post.fromJson(result.data());
      post.liked = false;
      posts.add(post);
    }

    for (Post post in posts) {
      storeFeed(post);
    }
  }

  static Future removePostsFromMyFeed(Member someone) async {
    List<Post> posts = [];
    var querySnapshot = await _firestore
        .collection(folder_users)
        .doc(someone.uid)
        .collection(folder_posts)
        .get();

    for (var result in querySnapshot.docs) {
      posts.add(Post.fromJson(result.data()));
    }

    for (Post post in posts) {
      removeFeed(post);
    }
  }

  static Future removeFeed(Post post) async {
    String uid = AuthService.currentUserId();

    return await _firestore
        .collection(folder_users)
        .doc(uid)
        .collection(folder_feeds)
        .doc(post.id)
        .delete();
  }

  static Future likePost(Post post, bool liked) async {
    String uid = AuthService.currentUserId();
    post.liked = liked;

    await _firestore
        .collection(folder_users)
        .doc(uid)
        .collection(folder_feeds)
        .doc(post.id)
        .set(post.toJson());

    if (uid == post.uid) {
      await _firestore
          .collection(folder_users)
          .doc(uid)
          .collection(folder_posts)
          .doc(post.id)
          .set(post.toJson());
    }
  }

  static Future<List<Post>> loadLikes() async {
    String uid = AuthService.currentUserId();
    List<Post> posts = [];

    var querySnapshot = await _firestore
        .collection(folder_users)
        .doc(uid)
        .collection(folder_feeds)
        .where("liked", isEqualTo: true)
        .get();

    for (var result in querySnapshot.docs) {
      Post post = Post.fromJson(result.data());
      if (post.uid == uid) post.mine = true;
      posts.add(post);
    }
    return posts;
  }

  static Future removePost(Post post) async {
    String uid = AuthService.currentUserId();
    await removeFeed(post);
    return await _firestore
        .collection(folder_users)
        .doc(uid)
        .collection(folder_posts)
        .doc(post.id)
        .delete();
  }
}