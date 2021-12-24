import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_app/screens/profile/profile_screen.dart';
import 'package:instagram_app/screens/search/cubit/search_cubit.dart';
import 'package:instagram_app/widgets/widgets.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = '/search';
  const SearchScreen({Key key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(
            title: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                fillColor: Colors.grey[200],
                filled: true,
                border: InputBorder.none,
                hintText: 'Search User',
                suffixIcon: IconButton(
                  onPressed: () {
                    context.read<SearchCubit>().clearSearch();
                    _textEditingController.clear();
                  },
                  icon: const Icon(Icons.clear),
                ),
              ),
              textInputAction: TextInputAction.search,
              textAlignVertical: TextAlignVertical.center,
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  context.read<SearchCubit>().SearchUser(query: value.trim());
                }
              },
            ),
          ),
          body: BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              switch (state.status) {
                case SearchStatus.error:
                  return CenteredText(text: state.failure.message);
                case SearchStatus.loading:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case SearchStatus.loaded:
                  return state.users.isNotEmpty
                      ? ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            final user = state.users[index];
                            return ListTile(
                              leading: UserProfileImage(
                                  radius: 22.0,
                                  profileImageUrl: user.profileImageUrl),
                              title: Text(
                                user.username,
                                style: const TextStyle(fontSize: 16.0),
                              ),
                              onTap: () => Navigator.of(context).pushNamed(
                                ProfileScreen.routeName,
                                arguments: ProfileScreenArgs(userId: user.id),
                              ),
                            );
                          },
                          itemCount: state.users.length)
                      : CenteredText(text: 'No users found');
                default:
                  return const SizedBox.shrink();
              }
            },
          )),
    );
  }
}
