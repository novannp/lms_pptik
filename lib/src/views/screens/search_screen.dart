import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_pptik/src/views/components/loading_widget.dart';

import '../../features/course/provider/search_course_provider.dart';
import '../components/course_card.dart';

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
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        previousPageTitle: 'Kembali',
        middle: Text('Pencarian Kelas'),
      ),
      // appBar: AppBar(
      //   iconTheme: const IconThemeData(color: Colors.black),
      //   titleTextStyle: Theme.of(context).textTheme.titleMedium,
      //   title: const Text('Pencarian'),
      // ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              CupertinoSearchTextField(
                controller: _searchController,
                onChanged: handleSearchTextChange,
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
                  loading: () => const Loading())
            ],
          ),
        ),
      ),
    );
  }
}
