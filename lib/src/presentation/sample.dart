import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Sample1Page extends ConsumerWidget {
  const Sample1Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get ViewModel
    final vm = ref.watch(sample1ViewModelProvider.notifier);
    // Get SampleState
    final state = ref.watch(sample1ViewModelProvider);
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () => vm.addUser("test", 100),
            child: const Text('Random User'),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: state.users.length,
            itemBuilder: (_, i) {
              final user = state.users[i];
              return ListTile(
                title: Text(user.name),
                subtitle: Text('Score: ${user.score}'),
              );
            },
          )
        ],
      ),
    );
  }
}

class Sample2Page extends ConsumerWidget {
  const Sample2Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(sample2ViewModelProvider.notifier);
    return Scaffold(
      body: Center(
          child: Wrap(
        children: [
          Consumer(builder: (_, ref, __) {
            final name =
                ref.watch(sample2ViewModelProvider.select((_) => _.name));
            return Text('Name: $name');
          }),
          Consumer(builder: (_, ref, __) {
            final score =
                ref.watch(sample2ViewModelProvider.select((_) => _.score));
            return Text('Score: $score');
          }),
          TextButton(
            onPressed: () => vm.randomUser(),
            child: const Text('Random User'),
          ),
        ],
      )),
    );
  }
}

class SampleState {
  final List<UserEntity> users;
  const SampleState({this.users = const []});
}

class Sample1ViewModel extends StateNotifier<SampleState> {
  final SampleUser _sampleUser;
  Sample1ViewModel({required SampleUser sampleUser})
      : _sampleUser = sampleUser,
        super(const SampleState()) {
    load();
  }
  Future<void> load() async {
    await _sampleUser.load();
    state = SampleState(users: _sampleUser.users);
  }

  Future<void> addUser(String name, int score) async {
    await _sampleUser.add(name: name, score: score);
    state = SampleState(users: _sampleUser.users);
  }
}

final sample1ViewModelProvider =
    StateNotifierProvider.autoDispose<Sample1ViewModel, SampleState>((ref) {
  final sampleUser = ref.read(sampleUserProvider);
  return Sample1ViewModel(sampleUser: sampleUser);
});

class Sample2ViewModel extends ChangeNotifier {
  Sample2ViewModel() : super();

  String name = '';
  int score = 0;

  void randomUser() {
    name = 'Some Name';
    score = 100;
    notifyListeners();
  }
}

final sample2ViewModelProvider =
    ChangeNotifierProvider.autoDispose<Sample2ViewModel>((ref) {
  return Sample2ViewModel();
});

abstract class SampleUser {
  late List<UserEntity> users;
  Future<void> load();
  Future<void> add({required String name, required int score});
}

class SampleUserImpl implements SampleUser {
  final UserRepository _userRepo;
  SampleUserImpl({required UserRepository userRepo}) : _userRepo = userRepo;

  @override
  List<UserEntity> users = [];

  @override
  Future<void> load() async {
    final resp = await _userRepo.getAll();
    users = resp.map((e) => UserEntity.fromResponse(e)).toList();
  }

  @override
  Future<void> add({required String name, required int score}) async {
    final parameter = UserParameter(name: name, score: score);
    final newUser = await _userRepo.add(parameter);
    users = [
      ...users,
      UserEntity.fromResponse(newUser),
    ];
  }
}

final sampleUserProvider = Provider<SampleUser>((ref) {
  final userRepo = ref.read(userRepositoryProvider);
  return SampleUserImpl(userRepo: userRepo);
});

class UserEntity extends Equatable {
  final String name;
  final int score;

  const UserEntity({required this.name, required this.score});

  factory UserEntity.fromResponse(UserResponse resp) => UserEntity(
        name: resp.name,
        score: resp.score,
      );

  @override
  List<Object?> get props => [name, score];
}

abstract class UserRepository {
  Future<List<UserResponse>> getAll();
  Future<UserResponse> add(UserParameter parameter);
}

class UserRepositoryImpl implements UserRepository {
  final Api _getUsersApi;
  final Api _addUserApi;
  UserRepositoryImpl({
    required Api getUsersApi,
    required Api addUserApi,
  })  : _getUsersApi = getUsersApi,
        _addUserApi = addUserApi;

  @override
  Future<List<UserResponse>> getAll() async {
    return await _getUsersApi.exe();
  }

  @override
  Future<UserResponse> add(UserParameter parameter) async {
    return await _addUserApi.build(parameter).exe();
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(
    getUsersApi: GetUsersApi(),
    addUserApi: AddUserApi(),
  );
});

abstract class Api<T> {
  late String path;
  late String baseUrl;

  Api build(BaseParameter parameter);
  Future<T> exe();
}

class BaseApiImpl<T> implements Api {
  @override
  String baseUrl = 'https://base.com';

  @override
  late String path;

  @override
  Api build(BaseParameter parameter) {
    throw UnimplementedError();
  }

  @override
  Future exe() {
    throw UnimplementedError();
  }
}

class GetUsersApi with BaseApiImpl<List<UserResponse>> {
  @override
  String get path => '/users';

  @override
  Future<List<UserResponse>> exe() {
    throw UnimplementedError();
  }
}

class AddUserApi with BaseApiImpl<UserResponse> {
  UserParameter? parameter;

  @override
  Api build(BaseParameter parameter) {
    this.parameter = parameter as UserParameter;
    return this;
  }

  @override
  String get path => '/user';

  @override
  Future<UserResponse> exe() {
    throw UnimplementedError();
  }
}

class UserResponse {
  final String name;
  final int score;

  const UserResponse({required this.name, required this.score});
}

abstract class BaseParameter {}

class UserParameter implements BaseParameter {
  final String name;
  final int score;

  const UserParameter({required this.name, required this.score});
}
