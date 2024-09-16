import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sqlite3_entity/sqlite3_entity.dart';
import 'package:sqlite3_entity_gen/sqlite3_entity_gen.dart';

import '../tools/helper.dart';
import 'view.list.dart';

part 'model.g.dart';
part 'model.g.view.dart';

// STEP 1: define your tables as shown in the example Classes below.

// Define the 'tableCategory' constant as Sqlite3EntityTable for the category table
const tableCategory = Sqlite3EntityTable(
    tableName: 'category',
    primaryKeyName: 'id',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    useSoftDeleting: false,
    // when useSoftDeleting is true, creates a field named 'isDeleted' on the table, and set to '1' this field when item deleted (does not hard delete)
    modelName:
        null, // Sqlite3Entity will set it to TableName automatically when the modelName (class name) is null
    // declare fields
    fields: [
      Sqlite3EntityField('name', DbType.text, isNotNull: true),
      Sqlite3EntityField('isActive', DbType.bool, defaultValue: true),
    ],
    formListSubTitleField: '');

// Define the 'tableProduct' constant as Sqlite3EntityTable for the product table
const tableProduct = Sqlite3EntityTable(
    tableName: 'product',
    primaryKeyName: 'id',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    useSoftDeleting: true,
    fields: [
      Sqlite3EntityField(
        'name',
        DbType.text,
        isNotNull: true,
      ),
      Sqlite3EntityField('description', DbType.text),
      Sqlite3EntityField('price', DbType.real, defaultValue: 0),
      Sqlite3EntityField('isActive', DbType.bool, defaultValue: true),

      /// Relationship column for CategoryId of Product
      Sqlite3EntityFieldRelationship(
          parentTable: tableCategory,
          deleteRule: DeleteRule.CASCADE,
          defaultValue: 1,
          formDropDownTextField:
              'name' // displayText of dropdownList for category. 'name' => a text field from the category table
          ),
      Sqlite3EntityField('rownum', DbType.integer,
          sequencedBy:
              seqIdentity /*Example of linking a column to a sequence */),
      Sqlite3EntityField('imageUrl', DbType.text),
      Sqlite3EntityField('datetime', DbType.datetime,
          isNotNull: true,
          defaultValue: 'DateTime.now()',
          minValue: '2019-01-01',
          maxValue: 'DateTime.now().add(Duration(days: 30))'),
      Sqlite3EntityField('date', DbType.date,
          minValue: '2015-01-01',
          maxValue: 'DateTime.now().add(Duration(days: 365))')
    ]);

// Define the 'Todo' constant as Sqlite3EntityTable.
const tableTodo = Sqlite3EntityTable(
    tableName: 'todos',
    primaryKeyName: 'id',
    useSoftDeleting:
        false, // when useSoftDeleting is true, creates a field named 'isDeleted' on the table, and set to '1' this field when item deleted (does not hard delete)
    primaryKeyType: PrimaryKeyType.integer_unique,
    defaultJsonUrl:
        'https://jsonplaceholder.typicode.com/todos', // optional: to synchronize your table with json data from webUrl

    // declare fields
    fields: [
      Sqlite3EntityField('userId', DbType.integer, isIndex: true),
      Sqlite3EntityField('title', DbType.text),
      Sqlite3EntityField('completed', DbType.bool, defaultValue: false),
    ]);

// Define the 'identity' constant as Sqlite3EntitySequence.
const seqIdentity = Sqlite3EntitySequence(
  sequenceName: 'identity',
  //maxValue:  10000, /* optional. default is max int (9.223.372.036.854.775.807) */
  //modelName: 'SQEidentity',
  /* optional. Sqlite3Entity will set it to sequenceName automatically when the modelName is null*/
  //cycle : false,    /* optional. default is false; */
  //minValue = 0;     /* optional. default is 0 */
  //incrementBy = 1;  /* optional. default is 1 */
  // startWith = 0;   /* optional. default is 0 */
);

// STEP 2: Create your Database Model constant instanced from Sqlite3EntityModel
// Note: Sqlite3Entity provides support for the use of multiple databases.
// So you can create many Database Models and use them in the application.
@Sqlite3EntityBuilder(myDbModel)
const myDbModel = Sqlite3EntityModel(
    modelName: 'MyDbModel',
    databaseName: 'sampleORM_v2.1.2+38.db',
    password:
        null, // You can set a password if you want to use crypted database (For more information: https://github.com/sqlcipher/sqlcipher)
    // put defined tables into the tables list.
    databaseTables: [tableProduct, tableCategory, tableTodo],
    // You can define tables to generate add/edit view forms if you want to use Form Generator property
    formTables: [tableProduct, tableCategory, tableTodo],
    // put defined sequences into the sequences list.
    sequences: [seqIdentity],
    dbVersion: 2,
    // This value is optional. When bundledDatabasePath is empty then
    // EntityBase creats a new database when initializing the database
    bundledDatabasePath: null, //         'assets/sample.db'
    // This value is optional. When databasePath is null then
    // EntityBase uses the default path from sqflite.getDatabasesPath()
    // If you want to set a physically path just set a directory like: '/Volumes/Repo/MyProject/db',
    databasePath: null,
    defaultColumns: [
      Sqlite3EntityField('dateCreated', DbType.datetime,
          defaultValue: 'DateTime.now()'),
    ]);

/* STEP 3: That's All.. 
--> Go Terminal Window and run command below
    flutter pub run build_runner build --delete-conflicting-outputs
  Note: After running the command Please check lib/model/model.g.dart and lib/model/model.g.view.dart (If formTables parameter is defined in the model)
  Enjoy.. Huseyin TOKPINAR
*/
