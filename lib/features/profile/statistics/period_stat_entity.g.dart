// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'period_stat_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPeriodStatEntityCollection on Isar {
  IsarCollection<PeriodStatEntity> get periodStatEntitys => this.collection();
}

const PeriodStatEntitySchema = CollectionSchema(
  name: r'PeriodStatEntity',
  id: -3198194132626618972,
  properties: {
    r'kind': PropertySchema(
      id: 0,
      name: r'kind',
      type: IsarType.byte,
      enumMap: _PeriodStatEntitykindEnumValueMap,
    ),
    r'listenMs': PropertySchema(
      id: 1,
      name: r'listenMs',
      type: IsarType.long,
    ),
    r'period': PropertySchema(
      id: 2,
      name: r'period',
      type: IsarType.string,
    ),
    r'playCount': PropertySchema(
      id: 3,
      name: r'playCount',
      type: IsarType.long,
    )
  },
  estimateSize: _periodStatEntityEstimateSize,
  serialize: _periodStatEntitySerialize,
  deserialize: _periodStatEntityDeserialize,
  deserializeProp: _periodStatEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'kind_period': IndexSchema(
      id: -4212738055583308348,
      name: r'kind_period',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'kind',
          type: IndexType.value,
          caseSensitive: false,
        ),
        IndexPropertySchema(
          name: r'period',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _periodStatEntityGetId,
  getLinks: _periodStatEntityGetLinks,
  attach: _periodStatEntityAttach,
  version: '3.1.0+1',
);

int _periodStatEntityEstimateSize(
  PeriodStatEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.period.length * 3;
  return bytesCount;
}

void _periodStatEntitySerialize(
  PeriodStatEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeByte(offsets[0], object.kind.index);
  writer.writeLong(offsets[1], object.listenMs);
  writer.writeString(offsets[2], object.period);
  writer.writeLong(offsets[3], object.playCount);
}

PeriodStatEntity _periodStatEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PeriodStatEntity();
  object.id = id;
  object.kind =
      _PeriodStatEntitykindValueEnumMap[reader.readByteOrNull(offsets[0])] ??
          PeriodKind.day;
  object.listenMs = reader.readLong(offsets[1]);
  object.period = reader.readString(offsets[2]);
  object.playCount = reader.readLong(offsets[3]);
  return object;
}

P _periodStatEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (_PeriodStatEntitykindValueEnumMap[
              reader.readByteOrNull(offset)] ??
          PeriodKind.day) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _PeriodStatEntitykindEnumValueMap = {
  'day': 0,
  'month': 1,
};
const _PeriodStatEntitykindValueEnumMap = {
  0: PeriodKind.day,
  1: PeriodKind.month,
};

Id _periodStatEntityGetId(PeriodStatEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _periodStatEntityGetLinks(PeriodStatEntity object) {
  return [];
}

void _periodStatEntityAttach(
    IsarCollection<dynamic> col, Id id, PeriodStatEntity object) {
  object.id = id;
}

extension PeriodStatEntityByIndex on IsarCollection<PeriodStatEntity> {
  Future<PeriodStatEntity?> getByKindPeriod(PeriodKind kind, String period) {
    return getByIndex(r'kind_period', [kind, period]);
  }

  PeriodStatEntity? getByKindPeriodSync(PeriodKind kind, String period) {
    return getByIndexSync(r'kind_period', [kind, period]);
  }

  Future<bool> deleteByKindPeriod(PeriodKind kind, String period) {
    return deleteByIndex(r'kind_period', [kind, period]);
  }

  bool deleteByKindPeriodSync(PeriodKind kind, String period) {
    return deleteByIndexSync(r'kind_period', [kind, period]);
  }

  Future<List<PeriodStatEntity?>> getAllByKindPeriod(
      List<PeriodKind> kindValues, List<String> periodValues) {
    final len = kindValues.length;
    assert(periodValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([kindValues[i], periodValues[i]]);
    }

    return getAllByIndex(r'kind_period', values);
  }

  List<PeriodStatEntity?> getAllByKindPeriodSync(
      List<PeriodKind> kindValues, List<String> periodValues) {
    final len = kindValues.length;
    assert(periodValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([kindValues[i], periodValues[i]]);
    }

    return getAllByIndexSync(r'kind_period', values);
  }

  Future<int> deleteAllByKindPeriod(
      List<PeriodKind> kindValues, List<String> periodValues) {
    final len = kindValues.length;
    assert(periodValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([kindValues[i], periodValues[i]]);
    }

    return deleteAllByIndex(r'kind_period', values);
  }

  int deleteAllByKindPeriodSync(
      List<PeriodKind> kindValues, List<String> periodValues) {
    final len = kindValues.length;
    assert(periodValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([kindValues[i], periodValues[i]]);
    }

    return deleteAllByIndexSync(r'kind_period', values);
  }

  Future<Id> putByKindPeriod(PeriodStatEntity object) {
    return putByIndex(r'kind_period', object);
  }

  Id putByKindPeriodSync(PeriodStatEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'kind_period', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByKindPeriod(List<PeriodStatEntity> objects) {
    return putAllByIndex(r'kind_period', objects);
  }

  List<Id> putAllByKindPeriodSync(List<PeriodStatEntity> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'kind_period', objects, saveLinks: saveLinks);
  }
}

extension PeriodStatEntityQueryWhereSort
    on QueryBuilder<PeriodStatEntity, PeriodStatEntity, QWhere> {
  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PeriodStatEntityQueryWhere
    on QueryBuilder<PeriodStatEntity, PeriodStatEntity, QWhereClause> {
  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterWhereClause>
      kindEqualToAnyPeriod(PeriodKind kind) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'kind_period',
        value: [kind],
      ));
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterWhereClause>
      kindNotEqualToAnyPeriod(PeriodKind kind) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'kind_period',
              lower: [],
              upper: [kind],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'kind_period',
              lower: [kind],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'kind_period',
              lower: [kind],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'kind_period',
              lower: [],
              upper: [kind],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterWhereClause>
      kindGreaterThanAnyPeriod(
    PeriodKind kind, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'kind_period',
        lower: [kind],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterWhereClause>
      kindLessThanAnyPeriod(
    PeriodKind kind, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'kind_period',
        lower: [],
        upper: [kind],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterWhereClause>
      kindBetweenAnyPeriod(
    PeriodKind lowerKind,
    PeriodKind upperKind, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'kind_period',
        lower: [lowerKind],
        includeLower: includeLower,
        upper: [upperKind],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterWhereClause>
      kindPeriodEqualTo(PeriodKind kind, String period) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'kind_period',
        value: [kind, period],
      ));
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterWhereClause>
      kindEqualToPeriodNotEqualTo(PeriodKind kind, String period) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'kind_period',
              lower: [kind],
              upper: [kind, period],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'kind_period',
              lower: [kind, period],
              includeLower: false,
              upper: [kind],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'kind_period',
              lower: [kind, period],
              includeLower: false,
              upper: [kind],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'kind_period',
              lower: [kind],
              upper: [kind, period],
              includeUpper: false,
            ));
      }
    });
  }
}

extension PeriodStatEntityQueryFilter
    on QueryBuilder<PeriodStatEntity, PeriodStatEntity, QFilterCondition> {
  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterFilterCondition>
      kindEqualTo(PeriodKind value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'kind',
        value: value,
      ));
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterFilterCondition>
      kindGreaterThan(
    PeriodKind value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'kind',
        value: value,
      ));
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterFilterCondition>
      kindLessThan(
    PeriodKind value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'kind',
        value: value,
      ));
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterFilterCondition>
      kindBetween(
    PeriodKind lower,
    PeriodKind upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'kind',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterFilterCondition>
      listenMsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'listenMs',
        value: value,
      ));
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterFilterCondition>
      listenMsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'listenMs',
        value: value,
      ));
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterFilterCondition>
      listenMsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'listenMs',
        value: value,
      ));
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterFilterCondition>
      listenMsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'listenMs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterFilterCondition>
      periodEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'period',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterFilterCondition>
      periodGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'period',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterFilterCondition>
      periodLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'period',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterFilterCondition>
      periodBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'period',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterFilterCondition>
      periodStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'period',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterFilterCondition>
      periodEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'period',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterFilterCondition>
      periodContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'period',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterFilterCondition>
      periodMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'period',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterFilterCondition>
      periodIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'period',
        value: '',
      ));
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterFilterCondition>
      periodIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'period',
        value: '',
      ));
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterFilterCondition>
      playCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'playCount',
        value: value,
      ));
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterFilterCondition>
      playCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'playCount',
        value: value,
      ));
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterFilterCondition>
      playCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'playCount',
        value: value,
      ));
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterFilterCondition>
      playCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'playCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PeriodStatEntityQueryObject
    on QueryBuilder<PeriodStatEntity, PeriodStatEntity, QFilterCondition> {}

extension PeriodStatEntityQueryLinks
    on QueryBuilder<PeriodStatEntity, PeriodStatEntity, QFilterCondition> {}

extension PeriodStatEntityQuerySortBy
    on QueryBuilder<PeriodStatEntity, PeriodStatEntity, QSortBy> {
  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterSortBy> sortByKind() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kind', Sort.asc);
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterSortBy>
      sortByKindDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kind', Sort.desc);
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterSortBy>
      sortByListenMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'listenMs', Sort.asc);
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterSortBy>
      sortByListenMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'listenMs', Sort.desc);
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterSortBy>
      sortByPeriod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'period', Sort.asc);
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterSortBy>
      sortByPeriodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'period', Sort.desc);
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterSortBy>
      sortByPlayCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playCount', Sort.asc);
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterSortBy>
      sortByPlayCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playCount', Sort.desc);
    });
  }
}

extension PeriodStatEntityQuerySortThenBy
    on QueryBuilder<PeriodStatEntity, PeriodStatEntity, QSortThenBy> {
  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterSortBy> thenByKind() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kind', Sort.asc);
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterSortBy>
      thenByKindDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kind', Sort.desc);
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterSortBy>
      thenByListenMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'listenMs', Sort.asc);
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterSortBy>
      thenByListenMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'listenMs', Sort.desc);
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterSortBy>
      thenByPeriod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'period', Sort.asc);
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterSortBy>
      thenByPeriodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'period', Sort.desc);
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterSortBy>
      thenByPlayCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playCount', Sort.asc);
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterSortBy>
      thenByPlayCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playCount', Sort.desc);
    });
  }
}

extension PeriodStatEntityQueryWhereDistinct
    on QueryBuilder<PeriodStatEntity, PeriodStatEntity, QDistinct> {
  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QDistinct> distinctByKind() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'kind');
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QDistinct>
      distinctByListenMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'listenMs');
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QDistinct> distinctByPeriod(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'period', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QDistinct>
      distinctByPlayCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'playCount');
    });
  }
}

extension PeriodStatEntityQueryProperty
    on QueryBuilder<PeriodStatEntity, PeriodStatEntity, QQueryProperty> {
  QueryBuilder<PeriodStatEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodKind, QQueryOperations> kindProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'kind');
    });
  }

  QueryBuilder<PeriodStatEntity, int, QQueryOperations> listenMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'listenMs');
    });
  }

  QueryBuilder<PeriodStatEntity, String, QQueryOperations> periodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'period');
    });
  }

  QueryBuilder<PeriodStatEntity, int, QQueryOperations> playCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'playCount');
    });
  }
}
