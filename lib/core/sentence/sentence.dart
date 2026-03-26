import 'package:dio/dio.dart';
import 'package:hyy_drop/core/logging/app_talker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sentence.g.dart';

@riverpod
Future<String?> sentence(Ref ref) async {
  final url = "https://v1.hitokoto.cn/?c=d&encode=text";
  final dio = Dio();
  late final String? text;
  await dio.get<String>(url).then((value) => text = value.data).catchError((
    Object e,
    StackTrace stack,
  ) {
    appTalker.error(e, stack);
    return text = null;
  });
  return text;
}
