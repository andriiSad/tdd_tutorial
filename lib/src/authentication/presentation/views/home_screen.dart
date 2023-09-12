import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/auth_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Home Screen'),
          ),
          body: state is GettingUsers
              ? const Center(child: CircularProgressIndicator())
              : Center(
                  child: ListView.builder(
                    itemBuilder: (context, index) => const ListTile(
                      title: Text(''),
                    ),
                  ),
                ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              print('Click');
              print(context.read<AuthCubit>().state);
              context.read<AuthCubit>().createUser(
                    createdAt: DateTime.now().toString(),
                    name: 'name',
                    avatar: 'avatar',
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
