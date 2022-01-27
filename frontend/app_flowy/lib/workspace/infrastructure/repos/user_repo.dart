import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flowy_sdk/dispatch/dispatch.dart';
import 'package:flowy_sdk/protobuf/flowy-folder-data-model/workspace.pb.dart';
import 'package:app_flowy/workspace/domain/i_user.dart';
import 'package:flowy_sdk/protobuf/flowy-error/errors.pb.dart';

class UserRepo {
  final UserProfile user;
  UserRepo({
    required this.user,
  });

  Future<Either<UserProfile, FlowyError>> fetchUserProfile({required String userId}) {
    return UserEventGetUserProfile().send();
  }

  Future<Either<Unit, FlowyError>> deleteWorkspace({required String workspaceId}) {
    throw UnimplementedError();
  }

  Future<Either<Unit, FlowyError>> signOut() {
    return UserEventSignOut().send();
  }

  Future<Either<Unit, FlowyError>> initUser() async {
    return UserEventInitUser().send();
  }

  Future<Either<List<Workspace>, FlowyError>> getWorkspaces() {
    final request = QueryWorkspaceRequest.create();

    return FolderEventReadWorkspaces(request).send().then((result) {
      return result.fold(
        (workspaces) => left(workspaces.items),
        (error) => right(error),
      );
    });
  }

  Future<Either<Workspace, FlowyError>> openWorkspace(String workspaceId) {
    final request = QueryWorkspaceRequest.create()..workspaceId = workspaceId;
    return FolderEventOpenWorkspace(request).send().then((result) {
      return result.fold(
        (workspace) => left(workspace),
        (error) => right(error),
      );
    });
  }

  Future<Either<Workspace, FlowyError>> createWorkspace(String name, String desc) {
    final request = CreateWorkspaceRequest.create()
      ..name = name
      ..desc = desc;
    return FolderEventCreateWorkspace(request).send().then((result) {
      return result.fold(
        (workspace) => left(workspace),
        (error) => right(error),
      );
    });
  }
}
