import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    @JsonKey(name: '\$id', includeToJson: false) required String uid,
    required String name,
    required String email,
    @Default('') String bio,
    @Default("https://picsum.photos/300/300") String profilePic,
    @Default("https://picsum.photos/500/300") String coverPic,
    @Default(false) bool isTwitterBlue,
    @Default(<String>[]) List<String> followers,
    @Default(<String>[]) List<String> following,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}
