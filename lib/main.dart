import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/bloc/item_bloc.dart';
import 'package:tasks/item_repo_impl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ItemBloc(repo: ItemRepoImpl())
            ..add(StartWatcherEvent())
            ..add(LoadItemsEvent()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Favourite App",
        home: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemBloc, ItemState>(
      builder: (context, state) {
        if (state is LoadingItemState) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is LoadedItemState) {
          return _buildListScreen(context, state);
        }

        return const Scaffold(
          body: Center(child: Text("Something went wrong")),
        );
      },
    );
  }
}

Widget _buildListScreen(BuildContext context, LoadedItemState state) {
  final selectionMode = state.selectionMode;
  final items = state.items;

  return PopScope(
    canPop: !selectionMode,
    onPopInvokedWithResult: (didPop, result) {
      if (!didPop && selectionMode) {
        context.read<ItemBloc>().add(ClearSelectionEvent());
      }
    },
    child: Scaffold(
      appBar: AppBar(
        title: Text(
          selectionMode
              ? "${state.selectedIds.length} selected"
              : "Favourite App",
        ),
        actions: [
          if (selectionMode)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                context.read<ItemBloc>().add(DeleteSelectedEvent());
              },
            ),
          if (selectionMode)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                context.read<ItemBloc>().add(ClearSelectionEvent());
              },
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _showAddDialog(context);
        },
      ),
      body: items.isEmpty
          ? const Center(child: Text("No items added."))
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final selected = state.selectedIds.contains(item.id);

                return ListTile(
                  onLongPress: () {
                    context.read<ItemBloc>().add(
                      ToggleSelectItemEvent(item.id),
                    );
                  },
                  onTap: () {
                    if (selectionMode) {
                      context.read<ItemBloc>().add(
                        ToggleSelectItemEvent(item.id),
                      );
                    }
                  },
                  leading: IconButton(
                    icon: Icon(
                      item.isFavorite ? Icons.star : Icons.star_border,
                    ),
                    onPressed: () {
                      context.read<ItemBloc>().add(
                        ToggleFavoriteEvent(item.id),
                      );
                    },
                  ),
                  trailing: selectionMode
                      ? Checkbox(
                          value: selected,
                          onChanged: (_) {
                            context.read<ItemBloc>().add(
                              ToggleSelectItemEvent(item.id),
                            );
                          },
                        )
                      : SizedBox.shrink(),
                  title: Text(item.title),
                );
              },
            ),
    ),
  );
}

void _showAddDialog(BuildContext context) {
  final controller = TextEditingController();

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Add Item"),
        content: BlocBuilder<ItemBloc, ItemState>(
          builder: (context, state) {
            String? error;
            if (state is LoadedItemState) {
              error = state.formError;
            }
            return TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(labelText: "Title", errorText: error),
              onChanged: (value) {
                context.read<ItemBloc>().add(ValidateTitleEvent(value));
              },
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.clear();
              Navigator.pop(context);
            },
            child: const Text("Dismiss"),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ItemBloc>().add(AddItemEvent(controller.text));
              controller.clear();
            },
            child: const Text("Save"),
          ),
        ],
      );
    },
  );
}
