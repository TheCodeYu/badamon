///数据库操作工具
import 'dart:io';
import 'dart:ffi';

import 'package:sqlite3/open.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqlite_api.dart' as db;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'log_utils.dart';

class SqlUtils {
  // 初始化数据库
  static Future<db.Database> initDb() async {
    setupDatabase();
    var databasesPath = await getApplicationSupportDirectory();
    var dbPath = join(databasesPath.path, "simple.db");

    var file = File(dbPath);
    if (!file.existsSync()) {
      await Directory(dirname(dbPath)).create(recursive: true);
      ByteData data = await rootBundle.load("assets/flutter.db");
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(dbPath).writeAsBytes(bytes, flush: true);
      LogUtil.info('SqlUtils', "========= assets ======拷贝完成==${file.path}==");
    } else {
      LogUtil.info('SqlUtils', "========= 数据库 ======已存在==${file.path}==");
    }

    var databaseFactory = databaseFactoryFfi;
    return await databaseFactory.openDatabase(dbPath);
  }

  static setupDatabase() {
    if (Platform.isWindows) {
      var location = Directory.current.path;
      windowsInit(join(location, 'sqlite3.dll'));
    }
  }

  static void windowsInit(String path) {
    open.overrideFor(OperatingSystem.windows, () {
      try {
        return DynamicLibrary.open(path);
      } catch (e) {
        LogUtil.error('SqlUtils', 'Failed to load sqlite3.dll at $path');
        //stderr.writeln();
        rethrow;
      }
    });
    sqlite3.openInMemory().dispose();
  }
}
