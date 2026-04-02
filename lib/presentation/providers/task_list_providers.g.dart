// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_list_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$taskListRepositoryHash() =>
    r'66a67a20755543c77355a7765692daf8359f6772';

/// Provides the concrete [TaskListRepository] backed by drift.
///
/// Copied from [taskListRepository].
@ProviderFor(taskListRepository)
final taskListRepositoryProvider =
    AutoDisposeProvider<TaskListRepository>.internal(
  taskListRepository,
  name: r'taskListRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$taskListRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TaskListRepositoryRef = AutoDisposeProviderRef<TaskListRepository>;
String _$addTaskListUseCaseHash() =>
    r'3e5734f38a28c90ddad3f8bba0420c9c562d28c9';

/// Provides [AddTaskListUseCase].
///
/// Copied from [addTaskListUseCase].
@ProviderFor(addTaskListUseCase)
final addTaskListUseCaseProvider =
    AutoDisposeProvider<AddTaskListUseCase>.internal(
  addTaskListUseCase,
  name: r'addTaskListUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$addTaskListUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AddTaskListUseCaseRef = AutoDisposeProviderRef<AddTaskListUseCase>;
String _$getTaskListsUseCaseHash() =>
    r'3547bcbc31801eecb561214e655cb079c7f74a83';

/// Provides [GetTaskListsUseCase].
///
/// Copied from [getTaskListsUseCase].
@ProviderFor(getTaskListsUseCase)
final getTaskListsUseCaseProvider =
    AutoDisposeProvider<GetTaskListsUseCase>.internal(
  getTaskListsUseCase,
  name: r'getTaskListsUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getTaskListsUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetTaskListsUseCaseRef = AutoDisposeProviderRef<GetTaskListsUseCase>;
String _$taskListsNotifierHash() => r'2774de9193a63f0138f9929bf88a73bd85074588';

/// AsyncNotifier that holds the list of named task lists.
///
/// Copied from [TaskListsNotifier].
@ProviderFor(TaskListsNotifier)
final taskListsNotifierProvider = AutoDisposeAsyncNotifierProvider<
    TaskListsNotifier, List<TaskList>>.internal(
  TaskListsNotifier.new,
  name: r'taskListsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$taskListsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TaskListsNotifier = AutoDisposeAsyncNotifier<List<TaskList>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
