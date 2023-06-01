import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_pptik/src/views/components/loading_widget.dart';
import 'package:lms_pptik/src/views/screens/dashboard_screen.dart';

import '../../features/course/provider/search_course_provider.dart';
import '../themes.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void handleSearchTextChange(String searchText) {
    ref.watch(searchQueryProvider.notifier).state = searchText;
    ref.refresh(searchCourseProvider.future);
  }

  @override
  Widget build(BuildContext context) {
    final search = ref.watch(searchCourseProvider);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: Theme.of(context).textTheme.titleMedium,
        title: const Text('Pencarian'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              keyboardType: TextInputType.text,
              onChanged: (value) => handleSearchTextChange(value),
              autofocus: true,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(5),
                prefixIcon: const Icon(
                  FluentIcons.search_12_regular,
                  size: 20,
                ),
                prefixIconColor: Colors.black,
                hintText: 'Cari kelas',
                hintStyle: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: Colors.grey.shade500),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    width: 1,
                    color: Colors.black,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    width: 1,
                    color: borderColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            search.when(
                data: (data) {
                  if (data.isEmpty) {
                    return const Center(
                      child: Text('Tidak ada hasil'),
                    );
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return CourseCard(course: data[index]);
                      },
                    ),
                  );
                },
                error: (error, stackTrace) {
                  return const Center(
                    child: Text('Gagal melakukan pencarian'),
                  );
                },
                loading: () => Loading())
          ],
        ),
      ),
    );
  }
}
