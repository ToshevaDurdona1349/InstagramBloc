import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/my_search_bloc/follow_member_bloc.dart';
import '../bloc/my_search_bloc/follow_member_event.dart';
import '../bloc/my_search_bloc/follow_member_state.dart';
import '../bloc/my_search_bloc/my_search_bloc.dart';
import '../bloc/my_search_bloc/my_search_event.dart';
import '../bloc/my_search_bloc/my_search_state.dart';
import '../model/member_model.dart';


class MySearchPage extends StatefulWidget {
  const MySearchPage({Key? key}) : super(key: key);

  @override
  State<MySearchPage> createState() => _MySearchPageState();
}

class _MySearchPageState extends State<MySearchPage> {
  late MySearchBloc searchBloc;
  var searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchBloc = context.read<MySearchBloc>();
    searchBloc.add(LoadSearchMembersEvent(keyword: ""));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MySearchBloc, MySearchState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is MySearchLoadingState) {
          return viewOfSearchPage(true, []);
        }

        if (state is MySearchSuccessState) {
          return viewOfSearchPage(false, state.items);
        }
        return viewOfSearchPage(true, []);
      },
    );
  }

  Widget viewOfSearchPage(bool isLoading, List<Member> items) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            "Search",
            style: TextStyle(
                color: Colors.black, fontFamily: "Billabong", fontSize: 25),
          ),
        ),
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  //#search member
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    height: 45,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(7)),
                    child: TextField(
                      style: const TextStyle(color: Colors.black87),
                      controller: searchController,
                      decoration: const InputDecoration(
                          hintText: "Search",
                          border: InputBorder.none,
                          hintStyle:
                          TextStyle(fontSize: 15, color: Colors.grey),
                          icon: Icon(
                            Icons.search,
                            color: Colors.grey,
                          )),
                    ),
                  ),

                  //#member list
                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (ctx, index) {
                        return _itemOfMember(items[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _itemOfMember(Member member) {
    return SizedBox(
      height: 90,
      child: Row(
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
              borderRadius: BorderRadius.circular(22.5),
              child: member.img_url.isEmpty
                  ? const Image(
                image: AssetImage("assets/images/ic_person.png"),
                width: 45,
                height: 45,
                fit: BoxFit.cover,
              )
                  : Image.network(
                member.img_url,
                width: 45,
                height: 45,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                member.fullname,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 3,
              ),
              Text(
                member.email,
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    if (!member.followed) {
                      context.read<FollowMemberBloc>().add(FollowMemberEvent(someone: member));
                    } else {
                      context.read<FollowMemberBloc>().add(UnFollowMemberEvent(someone: member));
                    }
                  },
                  child: BlocBuilder<FollowMemberBloc, FollowState>(
                    builder: (context, state){
                      return member.followed ? Container(
                        width: 100,
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(width: 1, color: Colors.grey)),
                        child: const Center(
                            child: Text("Following")
                        ),
                      ):Container(
                        width: 100,
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(width: 1, color: Colors.grey)),
                        child: const Center(
                          child: Text("Follow"),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
