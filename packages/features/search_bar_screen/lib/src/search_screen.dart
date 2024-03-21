import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:io_library/io_library.dart';
import 'package:oxidized/oxidized.dart';
import 'package:database/database.dart';
import 'package:toast/toast.dart';
import 'package:search_bar_screen/src/components/project_list_tile.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late ProjectDatabase database;
  late IFileService fileService;
  late IImageService imageService;

  Future<List<Project>> _getProjects() async =>
      database.projectDAO.getProjects();

  Future<bool> _loadProject(IOHandler ioHandler, Project project) async {
    project.lastModified = DateTime.now();
    await database.projectDAO.insertProject(project);
    return fileService.getFile(project.path).when(
      ok: (file) async {
        return await ioHandler.loadFromFiles(Result.ok(file));
      },
      err: (failure) {
        if (failure != LoadImageFailure.userCancelled) {
          ToastUtils.showShortToast(message: failure.message);
        }
        return false;
      },
    );
  }

  Future<void> _openProject(Project? project, IOHandler ioHandler) async {
    if (project != null) {
      bool loaded = await _loadProject(ioHandler, project);
      if (loaded) _navigateToPocketPaint();
    }
  }

  Future<void> _navigateToPocketPaint() async {
    await Navigator.pushNamed(context, '/PocketPaint');
    setState(() {});
  }

  final TextEditingController _searchController = TextEditingController();
  List<Project> data = [];
  List<Project> searchResults = [];

  void onQueryChanged(String query) {
    setState(() {
      if(data.isEmpty) {
        ToastUtils.showShortToast(message: 'Data is empty');
      }
      searchResults = data
          .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);

    final db = ref.watch(ProjectDatabase.provider);
    db.when(
      data: (value) => database = value,
      error: (err, stacktrace) =>
          ToastUtils.showShortToast(message: 'Error: $err'),
      loading: () {},
    );
    final ioHandler = ref.watch(IOHandler.provider);
    fileService = ref.watch(IFileService.provider);
    imageService = ref.watch(IImageService.provider);

    return Scaffold(
      backgroundColor: lightColorScheme.primary,
      
      appBar: AppBar(
        elevation: 5,
        shadowColor: Colors.black,
        title: TextField(
          controller: _searchController,
          onChanged: (value) {
            onQueryChanged(value);
          },
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.white),
            suffixIcon: Icon(Icons.search, color: Colors.white)
          ),
        ),
      ),
      
      body: FutureBuilder(
        future: _getProjects(),
        builder: (BuildContext context, AsyncSnapshot<List<Project>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            data = snapshot.data!;
            return Column(
              children: [
                Flexible(
                  flex: 3,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      Project project = searchResults[index];
                      return ProjectListTile(
                        project: project,
                        imageService: imageService,
                        index: index,
                        onTap: () async => _openProject(project, ioHandler),
                      );
                    },
                    itemCount: searchResults.length,
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: lightColorScheme.background,
              ),
            );
          }
        },
      ),
    );
  }
}
