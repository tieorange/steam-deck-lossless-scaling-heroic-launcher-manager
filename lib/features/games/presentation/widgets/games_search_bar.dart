import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroic_lsfg_applier/features/games/presentation/cubit/games_cubit.dart';

/// Search bar for filtering games - StatefulWidget for clear button reactivity
class GamesSearchBar extends StatefulWidget {
  final TextEditingController controller;
  
  const GamesSearchBar({super.key, required this.controller});

  @override
  State<GamesSearchBar> createState() => _GamesSearchBarState();
}

class _GamesSearchBarState extends State<GamesSearchBar> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    // Trigger rebuild to show/hide clear button
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: 'Search games...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: widget.controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  widget.controller.clear();
                  context.read<GamesCubit>().search('');
                },
              )
            : null,
        ),
        onChanged: (value) => context.read<GamesCubit>().search(value),
      ),
    );
  }
}
