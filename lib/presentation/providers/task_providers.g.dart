// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$taskRepositoryHash() => r'8a55f4e8ee3800b276c2ad0a7d083fe223d8a4ae';

/// Provides the concrete [TaskRepository] backed by drift DAOs.
///
/// The presentation layer accesses tasks through this provider —
/// never by importing from [data/] directly.
///
/// Copied from [taskRepository].
@ProviderFor(taskRepository)
final taskRepositoryProvider = AutoDisposeProvider<TaskRepository>.internal(
  taskRepository,
  name: r'taskRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$taskRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TaskRepositoryRef = AutoDisposeProviderRef<TaskRepository>;
String _$addTaskUseCaseHash() => r'd38190383dc8bab7def5a1527ddbdc4236d289ff';

/// Provides [AddTaskUseCase].
///
/// Copied from [addTaskUseCase].
@ProviderFor(addTaskUseCase)
final addTaskUseCaseProvider = AutoDisposeProvider<AddTaskUseCase>.internal(
  addTaskUseCase,
  name: r'addTaskUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$addTaskUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AddTaskUseCaseRef = AutoDisposeProviderRef<AddTaskUseCase>;
String _$updateTaskUseCaseHash() => r'0bb597a34acd235fa99e3f4c2664ce0ea238d890';

/// Provides [UpdateTaskUseCase].
///
/// Copied from [updateTaskUseCase].
@ProviderFor(updateTaskUseCase)
final updateTaskUseCaseProvider =
    AutoDisposeProvider<UpdateTaskUseCase>.internal(
  updateTaskUseCase,
  name: r'updateTaskUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$updateTaskUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UpdateTaskUseCaseRef = AutoDisposeProviderRef<UpdateTaskUseCase>;
String _$getTasksUseCaseHash() => r'037c85270e9450e2d214d653005f0610163580b9';

/// Provides [GetTasksUseCase].
///
/// Copied from [getTasksUseCase].
@ProviderFor(getTasksUseCase)
final getTasksUseCaseProvider = AutoDisposeProvider<GetTasksUseCase>.internal(
  getTasksUseCase,
  name: r'getTasksUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getTasksUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetTasksUseCaseRef = AutoDisposeProviderRef<GetTasksUseCase>;
String _$getTasksByListUseCaseHash() =>
    r'253637994bb7a06c039920d1a4505a6a524b2fcf';

/// Provides [GetTasksByListUseCase].
///
/// Copied from [getTasksByListUseCase].
@ProviderFor(getTasksByListUseCase)
final getTasksByListUseCaseProvider =
    AutoDisposeProvider<GetTasksByListUseCase>.internal(
  getTasksByListUseCase,
  name: r'getTasksByListUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getTasksByListUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetTasksByListUseCaseRef
    = AutoDisposeProviderRef<GetTasksByListUseCase>;
String _$deleteTaskUseCaseHash() => r'968cd4ce424089039b31ebcd944246463b78c501';

/// Provides [DeleteTaskUseCase] wired to [NotificationService].
///
/// Copied from [deleteTaskUseCase].
@ProviderFor(deleteTaskUseCase)
final deleteTaskUseCaseProvider =
    AutoDisposeProvider<DeleteTaskUseCase>.internal(
  deleteTaskUseCase,
  name: r'deleteTaskUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$deleteTaskUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DeleteTaskUseCaseRef = AutoDisposeProviderRef<DeleteTaskUseCase>;
String _$completeTaskUseCaseHash() =>
    r'ba5a8f136bf569c6d3edd62856e3864b1c78544e';

/// Provides [CompleteTaskUseCase] wired to [NotificationService].
///
/// Copied from [completeTaskUseCase].
@ProviderFor(completeTaskUseCase)
final completeTaskUseCaseProvider =
    AutoDisposeProvider<CompleteTaskUseCase>.internal(
  completeTaskUseCase,
  name: r'completeTaskUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$completeTaskUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CompleteTaskUseCaseRef = AutoDisposeProviderRef<CompleteTaskUseCase>;
String _$taskListNotifierHash() => r'69411569a36d6849554e79f6f191a6e352a6a832';

/// AsyncNotifier that holds and manages the list of all tasks.
///
/// Exposes methods for adding, updating, completing, and deleting tasks.
/// The notifier invalidates itself after each mutation to refresh the list.
///
/// Copied from [TaskListNotifier].
@ProviderFor(TaskListNotifier)
final taskListNotifierProvider =
    AutoDisposeAsyncNotifierProvider<TaskListNotifier, List<Task>>.internal(
  TaskListNotifier.new,
  name: r'taskListNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$taskListNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TaskListNotifier = AutoDisposeAsyncNotifier<List<Task>>;
String _$tasksByListNotifierHash() =>
    r'9d43b9574b43f88eba16c3c2d9185be0a8745894';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$TasksByListNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<Task>> {
  late final String listId;

  FutureOr<List<Task>> build(
    String listId,
  );
}

/// AsyncNotifier that holds tasks filtered by a specific named list.
///
/// Takes [listId] as a parameter and provides the same mutation methods
/// as [TaskListNotifier].
///
/// Copied from [TasksByListNotifier].
@ProviderFor(TasksByListNotifier)
const tasksByListNotifierProvider = TasksByListNotifierFamily();

/// AsyncNotifier that holds tasks filtered by a specific named list.
///
/// Takes [listId] as a parameter and provides the same mutation methods
/// as [TaskListNotifier].
///
/// Copied from [TasksByListNotifier].
class TasksByListNotifierFamily extends Family<AsyncValue<List<Task>>> {
  /// AsyncNotifier that holds tasks filtered by a specific named list.
  ///
  /// Takes [listId] as a parameter and provides the same mutation methods
  /// as [TaskListNotifier].
  ///
  /// Copied from [TasksByListNotifier].
  const TasksByListNotifierFamily();

  /// AsyncNotifier that holds tasks filtered by a specific named list.
  ///
  /// Takes [listId] as a parameter and provides the same mutation methods
  /// as [TaskListNotifier].
  ///
  /// Copied from [TasksByListNotifier].
  TasksByListNotifierProvider call(
    String listId,
  ) {
    return TasksByListNotifierProvider(
      listId,
    );
  }

  @override
  TasksByListNotifierProvider getProviderOverride(
    covariant TasksByListNotifierProvider provider,
  ) {
    return call(
      provider.listId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'tasksByListNotifierProvider';
}

/// AsyncNotifier that holds tasks filtered by a specific named list.
///
/// Takes [listId] as a parameter and provides the same mutation methods
/// as [TaskListNotifier].
///
/// Copied from [TasksByListNotifier].
class TasksByListNotifierProvider extends AutoDisposeAsyncNotifierProviderImpl<
    TasksByListNotifier, List<Task>> {
  /// AsyncNotifier that holds tasks filtered by a specific named list.
  ///
  /// Takes [listId] as a parameter and provides the same mutation methods
  /// as [TaskListNotifier].
  ///
  /// Copied from [TasksByListNotifier].
  TasksByListNotifierProvider(
    String listId,
  ) : this._internal(
          () => TasksByListNotifier()..listId = listId,
          from: tasksByListNotifierProvider,
          name: r'tasksByListNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$tasksByListNotifierHash,
          dependencies: TasksByListNotifierFamily._dependencies,
          allTransitiveDependencies:
              TasksByListNotifierFamily._allTransitiveDependencies,
          listId: listId,
        );

  TasksByListNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.listId,
  }) : super.internal();

  final String listId;

  @override
  FutureOr<List<Task>> runNotifierBuild(
    covariant TasksByListNotifier notifier,
  ) {
    return notifier.build(
      listId,
    );
  }

  @override
  Override overrideWith(TasksByListNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: TasksByListNotifierProvider._internal(
        () => create()..listId = listId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        listId: listId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<TasksByListNotifier, List<Task>>
      createElement() {
    return _TasksByListNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TasksByListNotifierProvider && other.listId == listId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, listId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TasksByListNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<List<Task>> {
  /// The parameter `listId` of this provider.
  String get listId;
}

class _TasksByListNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<TasksByListNotifier,
        List<Task>> with TasksByListNotifierRef {
  _TasksByListNotifierProviderElement(super.provider);

  @override
  String get listId => (origin as TasksByListNotifierProvider).listId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
