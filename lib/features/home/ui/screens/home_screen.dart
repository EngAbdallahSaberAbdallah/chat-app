import 'package:chat_app/core/di/dependency_injection.dart';
import 'package:chat_app/features/auth/logic/auth_cubit.dart';
import 'package:chat_app/features/chat/data/repos/chat_repo.dart';
import 'package:chat_app/features/chat/logic/chat_cubit.dart';
import 'package:chat_app/features/chat/ui/screens/chat_screen.dart';
import 'package:chat_app/features/home/logic/cubit/user_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch users when the screen is initialized
    context.read<UserCubit>().fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthCubit>().signOut();
            },
          ),
        ],
      ),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserLoaded) {
            final users = state.users;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                final currentUserId = FirebaseAuth.instance.currentUser!.uid; // Get the current user ID
                final chatId = context.read<ChatRepo>().getChatId(currentUserId, user.userId); // Replace 'currentUserId' with the actual user ID

                return ListTile(
                  title: Text(user.name), // Updated to use username
                  subtitle: Text(user.email),
                  onTap: () {
                    // Navigate to chat screen with the selected user
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => getIt<ChatCubit>(),
                          child: ChatScreen(chatId: chatId, otherUserId: user.userId), // Pass chatId and user ID
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is UserError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text("No users found"));
          }
        },
      ),
    );
  }
}
