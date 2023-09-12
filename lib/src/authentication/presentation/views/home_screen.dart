import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/add_user_dialog.dart';
import '../widgets/loading_column.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController nameController = TextEditingController();

  void getUsers() => context.read<AuthCubit>().getUsers();

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    //Use BlocBuilder when we are listening for a state, and we want to update the UI, based on a state of the BLOC
    //Use BlocListener when we dont want to update the UI, but we want to run a func, based on a state of the bloc
    //Use BlocConsumer when we need both functionality
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        //here we can show a snackbar
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        } else if (state is UserCreated) {
          getUsers();
        }
      },
      builder: (context, state) {
        Widget bodyWidget;

        if (state is GettingUsers) {
          bodyWidget = const LoadingColumn(message: 'Fetching Users');
        } else if (state is CreatingUser) {
          bodyWidget = const LoadingColumn(message: 'Creating User');
        } else if (state is UsersLoaded) {
          bodyWidget = _UserListWidget(users: state.users);
        } else {
          // Default to an empty SizedBox if none of the above conditions are met
          bodyWidget = const SizedBox.shrink();
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Home Screen'),
          ),
          body: bodyWidget,
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) => AddUserDialog(
                  nameController: nameController,
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add User'),
          ),
        );
      },
    );
  }
}

class _UserListWidget extends StatelessWidget {
  const _UserListWidget({required this.users});
  final List<User> users;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            leading: Image.network(user.avatar),
            title: Text(user.name),
            subtitle: Text(user.createdAt.substring(10)),
          );
        },
      ),
    );
  }
}
