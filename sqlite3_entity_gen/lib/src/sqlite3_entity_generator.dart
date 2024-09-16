// Copyright (c) 2018, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import '../sqlite3_entity_gen.dart';

//import 'package:sqfentity_base/sqfentity_base.dart';

class Sqlite3EntityGenerator extends GeneratorForAnnotation<Sqlite3EntityBuilder> {
  @override
  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    //final keepFieldNamesAsOriginal = getBoolValueAnnotation(annotation,'keepFieldNamesAsOriginal');
    //print('keepFieldNamesAsOriginal: $keepFieldNamesAsOriginal');

    final model = annotation.read('model').objectValue;

// When testing, you can uncomment the test line to make sure everything's working properly
    //  return '''/* MODEL -> ${model.toString()} */''';

    final instanceName = element
        .toString()
        .replaceAll('Sqlite3EntityModel', '')
        .replaceAll('*', '')
        .trim();
    print('SQFENTITY GENERATOR STARTED... instance Of:$instanceName');
    final builder = Sqlite3EntityModelBuilder(model, instanceName);
    print(
        'SQFENTITY GENERATOR: builder initialized (${builder.instancename})...');
    final dbModel = builder.toModel();

    print('${dbModel.modelName} Model recognized successfully');
    final modelStr = MyStringBuffer()
          //..writeln('/*') // write output as commented to see what is wrong
          ..writeln(Sqlite3EntityConverter(dbModel).createModelDatabase())
          ..printToDebug(
              '${dbModel.modelName} converted to Sqlite3EntityModelBase successfully')
          ..writeln(Sqlite3EntityConverter(dbModel).createEntites())
          ..printToDebug(
              '${dbModel.modelName} converted to Entities successfully')
          ..writeln(Sqlite3EntityConverter(dbModel).createControllers())
          ..printToDebug(
              '${dbModel.modelName} converted to Controller successfully')
        //..writeln('*/') //  write output as commented to see what is wrong
        ;
    return modelStr.toString();
  }
}
