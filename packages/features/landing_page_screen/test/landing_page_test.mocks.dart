// Mocks generated by Mockito 5.4.2 from annotations
// in landing_page_screen/test/landing_page_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;
import 'dart:io' as _i11;
import 'dart:typed_data' as _i10;
import 'dart:ui' as _i9;

import 'package:database/src/models/project.dart' as _i7;
import 'package:database/src/project_dao.dart' as _i2;
import 'package:database/src/project_database.dart' as _i6;
import 'package:io_library/io_library.dart' as _i8;
import 'package:mockito/mockito.dart' as _i1;
import 'package:oxidized/oxidized.dart' as _i5;
import 'package:sqflite/sqflite.dart' as _i4;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeProjectDAO_0 extends _i1.SmartFake implements _i2.ProjectDAO {
  _FakeProjectDAO_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeStreamController_1<T> extends _i1.SmartFake
    implements _i3.StreamController<T> {
  _FakeStreamController_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDatabaseExecutor_2 extends _i1.SmartFake
    implements _i4.DatabaseExecutor {
  _FakeDatabaseExecutor_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeResult_3<T extends Object, E extends Object> extends _i1.SmartFake
    implements _i5.Result<T, E> {
  _FakeResult_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [ProjectDatabase].
///
/// See the documentation for Mockito's code generation for more information.
class MockProjectDatabase extends _i1.Mock implements _i6.ProjectDatabase {
  MockProjectDatabase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.ProjectDAO get projectDAO => (super.noSuchMethod(
        Invocation.getter(#projectDAO),
        returnValue: _FakeProjectDAO_0(
          this,
          Invocation.getter(#projectDAO),
        ),
      ) as _i2.ProjectDAO);

  @override
  _i3.StreamController<String> get changeListener => (super.noSuchMethod(
        Invocation.getter(#changeListener),
        returnValue: _FakeStreamController_1<String>(
          this,
          Invocation.getter(#changeListener),
        ),
      ) as _i3.StreamController<String>);

  @override
  set changeListener(_i3.StreamController<String>? _changeListener) =>
      super.noSuchMethod(
        Invocation.setter(
          #changeListener,
          _changeListener,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i4.DatabaseExecutor get database => (super.noSuchMethod(
        Invocation.getter(#database),
        returnValue: _FakeDatabaseExecutor_2(
          this,
          Invocation.getter(#database),
        ),
      ) as _i4.DatabaseExecutor);

  @override
  set database(_i4.DatabaseExecutor? _database) => super.noSuchMethod(
        Invocation.setter(
          #database,
          _database,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i3.Future<void> close() => (super.noSuchMethod(
        Invocation.method(
          #close,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
}

/// A class which mocks [ProjectDAO].
///
/// See the documentation for Mockito's code generation for more information.
class MockProjectDAO extends _i1.Mock implements _i2.ProjectDAO {
  MockProjectDAO() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<int> insertProject(_i7.Project? project) => (super.noSuchMethod(
        Invocation.method(
          #insertProject,
          [project],
        ),
        returnValue: _i3.Future<int>.value(0),
      ) as _i3.Future<int>);

  @override
  _i3.Future<List<int>> insertProjects(List<_i7.Project>? projects) =>
      (super.noSuchMethod(
        Invocation.method(
          #insertProjects,
          [projects],
        ),
        returnValue: _i3.Future<List<int>>.value(<int>[]),
      ) as _i3.Future<List<int>>);

  @override
  _i3.Future<void> deleteProject(int? id) => (super.noSuchMethod(
        Invocation.method(
          #deleteProject,
          [id],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> deleteProjects(List<_i7.Project>? projects) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteProjects,
          [projects],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<List<_i7.Project>> getProjects() => (super.noSuchMethod(
        Invocation.method(
          #getProjects,
          [],
        ),
        returnValue: _i3.Future<List<_i7.Project>>.value(<_i7.Project>[]),
      ) as _i3.Future<List<_i7.Project>>);

  @override
  _i3.Future<_i7.Project?> getProjectByName(String? name) =>
      (super.noSuchMethod(
        Invocation.method(
          #getProjectByName,
          [name],
        ),
        returnValue: _i3.Future<_i7.Project?>.value(),
      ) as _i3.Future<_i7.Project?>);
}

/// A class which mocks [IImageService].
///
/// See the documentation for Mockito's code generation for more information.
class MockIImageService extends _i1.Mock implements _i8.IImageService {
  MockIImageService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<_i5.Result<_i9.Image, _i8.Failure>> import(
          _i10.Uint8List? fileData) =>
      (super.noSuchMethod(
        Invocation.method(
          #import,
          [fileData],
        ),
        returnValue: _i3.Future<_i5.Result<_i9.Image, _i8.Failure>>.value(
            _FakeResult_3<_i9.Image, _i8.Failure>(
          this,
          Invocation.method(
            #import,
            [fileData],
          ),
        )),
      ) as _i3.Future<_i5.Result<_i9.Image, _i8.Failure>>);

  @override
  _i3.Future<_i5.Result<_i10.Uint8List, _i8.Failure>> exportAsJpg(
    _i9.Image? image,
    int? quality,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #exportAsJpg,
          [
            image,
            quality,
          ],
        ),
        returnValue: _i3.Future<_i5.Result<_i10.Uint8List, _i8.Failure>>.value(
            _FakeResult_3<_i10.Uint8List, _i8.Failure>(
          this,
          Invocation.method(
            #exportAsJpg,
            [
              image,
              quality,
            ],
          ),
        )),
      ) as _i3.Future<_i5.Result<_i10.Uint8List, _i8.Failure>>);

  @override
  _i3.Future<_i5.Result<_i10.Uint8List, _i8.Failure>> exportAsPng(
          _i9.Image? image) =>
      (super.noSuchMethod(
        Invocation.method(
          #exportAsPng,
          [image],
        ),
        returnValue: _i3.Future<_i5.Result<_i10.Uint8List, _i8.Failure>>.value(
            _FakeResult_3<_i10.Uint8List, _i8.Failure>(
          this,
          Invocation.method(
            #exportAsPng,
            [image],
          ),
        )),
      ) as _i3.Future<_i5.Result<_i10.Uint8List, _i8.Failure>>);

  @override
  _i5.Result<_i10.Uint8List, _i8.Failure> getProjectPreview(String? path) =>
      (super.noSuchMethod(
        Invocation.method(
          #getProjectPreview,
          [path],
        ),
        returnValue: _FakeResult_3<_i10.Uint8List, _i8.Failure>(
          this,
          Invocation.method(
            #getProjectPreview,
            [path],
          ),
        ),
      ) as _i5.Result<_i10.Uint8List, _i8.Failure>);
}

/// A class which mocks [IFileService].
///
/// See the documentation for Mockito's code generation for more information.
class MockIFileService extends _i1.Mock implements _i8.IFileService {
  MockIFileService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<_i5.Result<_i11.File, _i8.Failure>> save(
    String? filename,
    _i10.Uint8List? data,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #save,
          [
            filename,
            data,
          ],
        ),
        returnValue: _i3.Future<_i5.Result<_i11.File, _i8.Failure>>.value(
            _FakeResult_3<_i11.File, _i8.Failure>(
          this,
          Invocation.method(
            #save,
            [
              filename,
              data,
            ],
          ),
        )),
      ) as _i3.Future<_i5.Result<_i11.File, _i8.Failure>>);

  @override
  _i3.Future<_i5.Result<_i11.File, _i8.Failure>> saveToApplicationDirectory(
    String? filename,
    _i10.Uint8List? data,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #saveToApplicationDirectory,
          [
            filename,
            data,
          ],
        ),
        returnValue: _i3.Future<_i5.Result<_i11.File, _i8.Failure>>.value(
            _FakeResult_3<_i11.File, _i8.Failure>(
          this,
          Invocation.method(
            #saveToApplicationDirectory,
            [
              filename,
              data,
            ],
          ),
        )),
      ) as _i3.Future<_i5.Result<_i11.File, _i8.Failure>>);

  @override
  _i3.Future<_i5.Result<_i11.File, _i8.Failure>> pick() => (super.noSuchMethod(
        Invocation.method(
          #pick,
          [],
        ),
        returnValue: _i3.Future<_i5.Result<_i11.File, _i8.Failure>>.value(
            _FakeResult_3<_i11.File, _i8.Failure>(
          this,
          Invocation.method(
            #pick,
            [],
          ),
        )),
      ) as _i3.Future<_i5.Result<_i11.File, _i8.Failure>>);

  @override
  _i5.Result<_i11.File, _i8.Failure> getFile(String? path) =>
      (super.noSuchMethod(
        Invocation.method(
          #getFile,
          [path],
        ),
        returnValue: _FakeResult_3<_i11.File, _i8.Failure>(
          this,
          Invocation.method(
            #getFile,
            [path],
          ),
        ),
      ) as _i5.Result<_i11.File, _i8.Failure>);

  @override
  _i3.Future<bool> checkIfFileExistsInApplicationDirectory(String? fileName) =>
      (super.noSuchMethod(
        Invocation.method(
          #checkIfFileExistsInApplicationDirectory,
          [fileName],
        ),
        returnValue: _i3.Future<bool>.value(false),
      ) as _i3.Future<bool>);

  @override
  _i3.Future<_i5.Result<_i11.FileSystemEntity, _i8.Failure>>
      deleteFileInApplicationDirectory(String? fileName) => (super.noSuchMethod(
            Invocation.method(
              #deleteFileInApplicationDirectory,
              [fileName],
            ),
            returnValue: _i3
                .Future<_i5.Result<_i11.FileSystemEntity, _i8.Failure>>.value(
                _FakeResult_3<_i11.FileSystemEntity, _i8.Failure>(
              this,
              Invocation.method(
                #deleteFileInApplicationDirectory,
                [fileName],
              ),
            )),
          ) as _i3.Future<_i5.Result<_i11.FileSystemEntity, _i8.Failure>>);
}
