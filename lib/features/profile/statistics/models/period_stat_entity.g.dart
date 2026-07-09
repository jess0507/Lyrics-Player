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
    r'listenMs': PropertySchema(id: 0, name: r'listenMs', type: IsarType.long),
    r'period': PropertySchema(id: 1, name: r'period', type: IsarType.string),
    r'playCount': PropertySchema(
      id: 2,
      name: r'playCount',
      type: IsarType.long,
    ),
  },

  estimateSize: _periodStatEntityEstimateSize,
  serialize: _periodStatEntitySerialize,
  deserialize: _periodStatEntityDeserialize,
  deserializeProp: _periodStatEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'period': IndexSchema(
      id: -1253107732758621689,
      name: r'period',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'period',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _periodStatEntityGetId,
  getLinks: _periodStatEntityGetLinks,
  attach: _periodStatEntityAttach,
  version: '3.3.2',
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
  writer.writeLong(offsets[0], object.listenMs);
  writer.writeString(offsets[1], object.period);
  writer.writeLong(offsets[2], object.playCount);
}

PeriodStatEntity _periodStatEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PeriodStatEntity();
  object.id = id;
  object.listenMs = reader.readLong(offsets[0]);
  object.period = reader.readString(offsets[1]);
  object.playCount = reader.readLong(offsets[2]);
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
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _periodStatEntityGetId(PeriodStatEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _periodStatEntityGetLinks(PeriodStatEntity object) {
  return [];
}

void _periodStatEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  PeriodStatEntity object,
) {
  object.id = id;
}

extension PeriodStatEntityByIndex on IsarCollection<PeriodStatEntity> {
  Future<PeriodStatEntity?> getByPeriod(String period) {
    return getByIndex(r'period', [period]);
  }

  PeriodStatEntity? getByPeriodSync(String period) {
    return getByIndexSync(r'period', [period]);
  }

  Future<bool> deleteByPeriod(String period) {
    return deleteByIndex(r'period', [period]);
  }

  bool deleteByPeriodSync(String period) {
    return deleteByIndexSync(r'period', [period]);
  }

  Future<List<PeriodStatEntity?>> getAllByPeriod(List<String> periodValues) {
    final values = periodValues.map((e) => [e]).toList();
    return getAllByIndex(r'period', values);
  }

  List<PeriodStatEntity?> getAllByPeriodSync(List<String> periodValues) {
    final values = periodValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'period', values);
  }

  Future<int> deleteAllByPeriod(List<String> periodValues) {
    final values = periodValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'period', values);
  }

  int deleteAllByPeriodSync(List<String> periodValues) {
    final values = periodValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'period', values);
  }

  Future<Id> putByPeriod(PeriodStatEntity object) {
    return putByIndex(r'period', object);
  }

  Id putByPeriodSync(PeriodStatEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'period', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByPeriod(List<PeriodStatEntity> objects) {
    return putAllByIndex(r'period', objects);
  }

  List<Id> putAllByPeriodSync(
    List<PeriodStatEntity> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'period', objects, saveLinks: saveLinks);
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
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
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
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterWhereClause>
  periodEqualTo(String period) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'period', value: [period]),
      );
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterWhereClause>
  periodNotEqualTo(String period) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'period',
                lower: [],
                upper: [period],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'period',
                lower: [period],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'period',
                lower: [period],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'period',
                lower: [],
                upper: [period],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension PeriodStatEntityQueryFilter
    on QueryBuilder<PeriodStatEntity, PeriodStatEntity, QFilterCondition> {
  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
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
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterFilterCondition>
  listenMsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'listenMs', value: value),
      );
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterFilterCondition>
  listenMsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'listenMs',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterFilterCondition>
  listenMsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'listenMs',
          value: value,
        ),
      );
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
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'listenMs',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterFilterCondition>
  periodEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'period',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterFilterCondition>
  periodGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'period',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterFilterCondition>
  periodLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'period',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
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
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'period',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterFilterCondition>
  periodStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'period',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterFilterCondition>
  periodEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'period',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterFilterCondition>
  periodContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'period',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterFilterCondition>
  periodMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'period',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterFilterCondition>
  periodIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'period', value: ''),
      );
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterFilterCondition>
  periodIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'period', value: ''),
      );
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterFilterCondition>
  playCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'playCount', value: value),
      );
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterFilterCondition>
  playCountGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'playCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QAfterFilterCondition>
  playCountLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'playCount',
          value: value,
        ),
      );
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
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'playCount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension PeriodStatEntityQueryObject
    on QueryBuilder<PeriodStatEntity, PeriodStatEntity, QFilterCondition> {}

extension PeriodStatEntityQueryLinks
    on QueryBuilder<PeriodStatEntity, PeriodStatEntity, QFilterCondition> {}

extension PeriodStatEntityQuerySortBy
    on QueryBuilder<PeriodStatEntity, PeriodStatEntity, QSortBy> {
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
  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QDistinct>
  distinctByListenMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'listenMs');
    });
  }

  QueryBuilder<PeriodStatEntity, PeriodStatEntity, QDistinct> distinctByPeriod({
    bool caseSensitive = true,
  }) {
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
