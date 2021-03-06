import 'dart:async';
import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'package:knctd/data/Contact.dart';

class DBContact {
  static final DBName = "main.db";

  static final DBContact _instance = new DBContact.internal();
  factory DBContact() => _instance;

  static Database _db;

  DBContact.internal();

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DBName);
    var theDb = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onDowngrade: _onDowngrade,
    );
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    var ret = await db.execute("CREATE TABLE ${Contact.db_tableName} ("
        "${Contact.db_id} STRING PRIMARY KEY,"
        "${Contact.db_acct_id} TEXT,"
        "${Contact.db_name} TEXT,"
        "${Contact.db_email} TEXT,"
        "${Contact.db_phnum} TEXT,"
        "${Contact.db_last_ct} TEXT,"
        "${Contact.db_monitoring} TEXT"
        ")");
    print("*************Created tables (${Contact.db_tableName})********** ");
  }

  void _onUpgrade(Database db, int oldVersion, int version) async {
    await db.execute("DROP TABLE IF EXISTS ${Contact.db_tableName}");

    _onCreate(db, version);
  }

  void _onDowngrade(Database db, int oldVersion, int version) async {
    await db.execute("DROP TABLE IF EXISTS ${Contact.db_tableName}");

    _onCreate(db, version);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }

  /// Get a contact by its id, if there is not entry for that ID, returns null.
  Future<Contact> getContact(String id) async {
    var dbClient = await db;
    //var result = await dbClient.rawQuery('SELECT * FROM Contact.db_tableName WHERE ${Contact.db_id} = "$id"');
    List<Map> result = await dbClient.query("${Contact.db_tableName}",
        columns: Contact.columns,
        where: "${Contact.db_id} = ?",
        whereArgs: [id]);

    if (result.length == 0) return null;
    return new Contact.fromMap(result[0]);
  }

  /// Get all contacts that I'm monitoring
  Future<List<Contact>> getMonitoredContacts() async {
    var dbClient = await db;
    List<Contact> contacts = [];
//    var result = await dbClient.rawQuery('SELECT * FROM Contact.db_tableName WHERE ${Contact.db_monitoring} = "1"');
//    for (Map<String, dynamic> item in result) {
//      contacts.add(new Contact.fromMap(item));
//    }
    List<Map> result = await dbClient.query("${Contact.db_tableName}",
        columns: Contact.columns,
        where: "${Contact.db_monitoring} = ?",
        whereArgs: ["1"]);
    result.forEach((res) {
      contacts.add(new Contact.fromMap(res));
    });
    return contacts;
  }

  /// Get all contacts that I'm being monitored
  Future<List<Contact>> getMonitoringContacts() async {
    var dbClient = await db;
    List<Contact> contacts = [];
//    var result = await dbClient.rawQuery('SELECT * FROM $Contact.db_tableName WHERE ${Contact.db_monitoring} = "0"');
//    for (Map<String, dynamic> item in result) {
//      contacts.add(new Contact.fromMap(item));
//    }
    List<Map> result = await dbClient.query("${Contact.db_tableName}",
        columns: Contact.columns,
        where: "${Contact.db_monitoring} = ?",
        whereArgs: ["0"]);
    result.forEach((res) {
      contacts.add(new Contact.fromMap(res));
    });
    return contacts;
  }

  Future<int> updateContact(Contact contact) async {
    var dbClient = await db;
    int res = 0;
//    res = await dbClient.rawInsert('INSERT OR REPLACE INTO '
//        '$Contact.db_tableName(${Contact.db_id}, ${Contact.db_acct_id},${Contact.db_name}, ${Contact.db_email}, ${Contact.db_phnum},${Contact.db_last_ct}, ${Contact.db_monitoring} )'
//        ' VALUES(?, ?, ?, ?, ?, ?, ?)',
//        [contact.id, contact.acctid, contact.name, contact.email, contact.phnum, contact.lastct, contact.monitoring]
//    );

    var count = Sqflite.firstIntValue(await _db.rawQuery(
        "SELECT COUNT(*) FROM ${Contact.db_tableName} WHERE ${Contact.db_acct_id} = ?",
        [contact.id]));
    if (count == 0) {
      res = await dbClient.insert("${Contact.db_tableName}", contact.toMap());
    } else {
      res = await dbClient.update("${Contact.db_tableName}", contact.toMap(),
          where: "${Contact.db_id} = ?", whereArgs: [contact.id]);
    }

    return res;
  }

  Future<int> deleteContact(Contact contact) async {
    var dbClient = await db;
    int res = await dbClient.delete("${Contact.db_tableName}",
        where: "${Contact.db_id} = ?", whereArgs: [contact.id]);
  }
}
