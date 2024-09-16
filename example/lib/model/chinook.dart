import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sqlite3_entity/sqlite3_entity.dart';
import 'package:sqlite3_entity_gen/sqlite3_entity_gen.dart';

import '../tools/helper.dart';
import 'view.list.dart';

part 'chinook.g.dart';
part 'chinook.g.view.dart';

//  BEGIN chinook.db MODEL

// BEGIN TABLES

const tableAlbum = Sqlite3EntityTable(
    tableName: 'Album',
    primaryKeyName: 'AlbumId',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      Sqlite3EntityField('Title', DbType.text),
      Sqlite3EntityFieldRelationship(
          parentTable: tableArtist,
          deleteRule: DeleteRule.NO_ACTION,
          fieldName: 'ArtistId',
          isPrimaryKeyField: false),
    ]);

const tableArtist = Sqlite3EntityTable(
    tableName: 'Artist',
    primaryKeyName: 'ArtistId',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      Sqlite3EntityField('Name', DbType.text),
    ]);

const tableCustomer = Sqlite3EntityTable(
    tableName: 'Customer',
    primaryKeyName: 'CustomerId',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      Sqlite3EntityField('FirstName', DbType.text),
      Sqlite3EntityField('LastName', DbType.text),
      Sqlite3EntityField('Company', DbType.text),
      Sqlite3EntityField('Address', DbType.text),
      Sqlite3EntityField('City', DbType.text),
      Sqlite3EntityField('State', DbType.text),
      Sqlite3EntityField('Country', DbType.text),
      Sqlite3EntityField('PostalCode', DbType.text),
      Sqlite3EntityField('Phone', DbType.text),
      Sqlite3EntityField('Fax', DbType.text),
      Sqlite3EntityField('Email', DbType.text),
      Sqlite3EntityFieldRelationship(
          parentTable: tableEmployee,
          deleteRule: DeleteRule.NO_ACTION,
          fieldName: 'SupportRepId',
          isPrimaryKeyField: false),
    ]);

const tableEmployee = Sqlite3EntityTable(
    tableName: 'Employee',
    primaryKeyName: 'EmployeeId',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      Sqlite3EntityField('LastName', DbType.text),
      Sqlite3EntityField('FirstName', DbType.text),
      Sqlite3EntityField('Title', DbType.text),
      Sqlite3EntityField('BirthDate', DbType.datetime),
      Sqlite3EntityField('HireDate', DbType.datetime),
      Sqlite3EntityField('Address', DbType.text),
      Sqlite3EntityField('City', DbType.text),
      Sqlite3EntityField('State', DbType.text),
      Sqlite3EntityField('Country', DbType.text),
      Sqlite3EntityField('PostalCode', DbType.text),
      Sqlite3EntityField('Phone', DbType.text),
      Sqlite3EntityField('Fax', DbType.text),
      Sqlite3EntityField('Email', DbType.text),
      Sqlite3EntityFieldRelationship(
          parentTable: null,
          deleteRule: DeleteRule.NO_ACTION,
          fieldName: 'ReportsTo',
          isPrimaryKeyField: false),
    ]);

const tableGenre = Sqlite3EntityTable(
    tableName: 'Genre',
    primaryKeyName: 'GenreId',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      Sqlite3EntityField('Name', DbType.text),
    ]);

const tableInvoice = Sqlite3EntityTable(
    tableName: 'Invoice',
    primaryKeyName: 'InvoiceId',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      Sqlite3EntityField('InvoiceDate', DbType.datetime),
      Sqlite3EntityField('BillingAddress', DbType.text),
      Sqlite3EntityField('BillingCity', DbType.text),
      Sqlite3EntityField('BillingState', DbType.text),
      Sqlite3EntityField('BillingCountry', DbType.text),
      Sqlite3EntityField('BillingPostalCode', DbType.text),
      Sqlite3EntityField('Total', DbType.real),
      Sqlite3EntityFieldRelationship(
          parentTable: tableCustomer,
          deleteRule: DeleteRule.NO_ACTION,
          fieldName: 'CustomerId',
          isPrimaryKeyField: false),
    ]);

const tableInvoiceLine = Sqlite3EntityTable(
    tableName: 'InvoiceLine',
    primaryKeyName: 'InvoiceLineId',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      Sqlite3EntityField('UnitPrice', DbType.real),
      Sqlite3EntityField('Quantity', DbType.integer),
      Sqlite3EntityFieldRelationship(
          parentTable: tableTrack,
          deleteRule: DeleteRule.NO_ACTION,
          fieldName: 'TrackId',
          isPrimaryKeyField: false),
      Sqlite3EntityFieldRelationship(
          parentTable: tableInvoice,
          deleteRule: DeleteRule.NO_ACTION,
          fieldName: 'InvoiceId',
          isPrimaryKeyField: false),
    ]);

const tableMediaType = Sqlite3EntityTable(
    tableName: 'MediaType',
    primaryKeyName: 'MediaTypeId',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      Sqlite3EntityField('Name', DbType.text),
    ]);

const tablePlaylist = Sqlite3EntityTable(
    tableName: 'Playlist',
    primaryKeyName: 'PlaylistId',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      Sqlite3EntityField('Name', DbType.text),
    ]);

const tableTrack = Sqlite3EntityTable(
    tableName: 'Track',
    primaryKeyName: 'TrackId',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      Sqlite3EntityField('Name', DbType.text),
      Sqlite3EntityField('Composer', DbType.text),
      Sqlite3EntityField('Milliseconds', DbType.integer),
      Sqlite3EntityField('Bytes', DbType.integer),
      Sqlite3EntityField('UnitPrice', DbType.real),
      Sqlite3EntityFieldRelationship(
          parentTable: tableMediaType,
          deleteRule: DeleteRule.NO_ACTION,
          fieldName: 'MediaTypeId',
          isPrimaryKeyField: false),
      Sqlite3EntityFieldRelationship(
          parentTable: tableGenre,
          deleteRule: DeleteRule.NO_ACTION,
          fieldName: 'GenreId',
          isPrimaryKeyField: false),
      Sqlite3EntityFieldRelationship(
          parentTable: tableAlbum,
          deleteRule: DeleteRule.NO_ACTION,
          fieldName: 'AlbumId',
          isPrimaryKeyField: false),
      Sqlite3EntityFieldRelationship(
          parentTable: tablePlaylist,
          deleteRule: DeleteRule.NO_ACTION,
          fieldName: 'mPlaylistTrack',
          relationType: RelationType.MANY_TO_MANY,
          manyToManyTableName: 'PlaylistTrack'),
    ]);

const VIEW_tracks = Sqlite3EntityTable(
  tableName: 'VTracks',
  objectType: ObjectType.view,
  fields: [
    Sqlite3EntityField('Name', DbType.text),
    Sqlite3EntityField('album', DbType.text),
    Sqlite3EntityField('media', DbType.text),
    Sqlite3EntityField('genres', DbType.text),
    Sqlite3EntityFieldRelationship(
        parentTable: tableTrack,
        deleteRule: DeleteRule.NO_ACTION,
        fieldName: 'TrackId',
        isPrimaryKeyField: false),
  ],
  sqlStatement: '''SELECT
	trackid,
	track.name,
	album.Title AS album,
	mediatype.Name AS media,
	genre.Name AS genres
FROM
	track
INNER JOIN album ON Album.AlbumId = track.AlbumId
INNER JOIN mediatype ON mediatype.MediaTypeId = track.MediaTypeId
INNER JOIN genre ON genre.GenreId = track.GenreId''',
);
// END TABLES

// BEGIN DATABASE MODEL
@Sqlite3EntityBuilder(chinookdb)
const chinookdb = Sqlite3EntityModel(
    modelName: 'Chinookdb',
    databaseName: 'chinook_v1.4.0+1.db',
    bundledDatabasePath: 'assets/chinook.sqlite',
    databaseTables: [
      tableAlbum,
      tableArtist,
      tableCustomer,
      tableEmployee,
      tableGenre,
      tableInvoice,
      tableInvoiceLine,
      tableMediaType,
      tablePlaylist,
      tableTrack,
      VIEW_tracks
    ],
    formTables: [
      tableAlbum,
      tableArtist,
      tableCustomer,
      tableEmployee,
      tableGenre,
      tableInvoice,
      tableInvoiceLine,
      tableMediaType,
      tablePlaylist,
      tableTrack,
    ]);
// END chinook.db MODEL
