// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_fingerprint_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTrackFingerprintEntityCollection on Isar {
  IsarCollection<TrackFingerprintEntity> get trackFingerprintEntitys =>
      this.collection();
}

const TrackFingerprintEntitySchema = CollectionSchema(
  name: r'TrackFingerprintEntity',
  id: -7950839470453932417,
  properties: {
    r'hash': PropertySchema(id: 0, name: r'hash', type: IsarType.string),
    r'modifiedMs': PropertySchema(
      id: 1,
      name: r'modifiedMs',
      type: IsarType.long,
    ),
    r'path': PropertySchema(id: 2, name: r'path', type: IsarType.string),
    r'sizeBytes': PropertySchema(
      id: 3,
      name: r'sizeBytes',
      type: IsarType.long,
    ),
  },

  estimateSize: _trackFingerprintEntityEstimateSize,
  serialize: _trackFingerprintEntitySerialize,
  deserialize: _trackFingerprintEntityDeserialize,
  deserializeProp: _trackFingerprintEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'path': IndexSchema(
      id: 8756705481922369689,
      name: r'path',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'path',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _trackFingerprintEntityGetId,
  getLinks: _trackFingerprintEntityGetLinks,
  attach: _trackFingerprintEntityAttach,
  version: '3.3.2',
);

int _trackFingerprintEntityEstimateSize(
  TrackFingerprintEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.hash.length * 3;
  bytesCount += 3 + object.path.length * 3;
  return bytesCount;
}

void _trackFingerprintEntitySerialize(
  TrackFingerprintEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.hash);
  writer.writeLong(offsets[1], object.modifiedMs);
  writer.writeString(offsets[2], object.path);
  writer.writeLong(offsets[3], object.sizeBytes);
}

TrackFingerprintEntity _trackFingerprintEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TrackFingerprintEntity();
  object.hash = reader.readString(offsets[0]);
  object.id = id;
  object.modifiedMs = reader.readLong(offsets[1]);
  object.path = reader.readString(offsets[2]);
  object.sizeBytes = reader.readLong(offsets[3]);
  return object;
}

P _trackFingerprintEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
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

Id _trackFingerprintEntityGetId(TrackFingerprintEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _trackFingerprintEntityGetLinks(
  TrackFingerprintEntity object,
) {
  return [];
}

void _trackFingerprintEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  TrackFingerprintEntity object,
) {
  object.id = id;
}

extension TrackFingerprintEntityByIndex
    on IsarCollection<TrackFingerprintEntity> {
  Future<TrackFingerprintEntity?> getByPath(String path) {
    return getByIndex(r'path', [path]);
  }

  TrackFingerprintEntity? getByPathSync(String path) {
    return getByIndexSync(r'path', [path]);
  }

  Future<bool> deleteByPath(String path) {
    return deleteByIndex(r'path', [path]);
  }

  bool deleteByPathSync(String path) {
    return deleteByIndexSync(r'path', [path]);
  }

  Future<List<TrackFingerprintEntity?>> getAllByPath(List<String> pathValues) {
    final values = pathValues.map((e) => [e]).toList();
    return getAllByIndex(r'path', values);
  }

  List<TrackFingerprintEntity?> getAllByPathSync(List<String> pathValues) {
    final values = pathValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'path', values);
  }

  Future<int> deleteAllByPath(List<String> pathValues) {
    final values = pathValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'path', values);
  }

  int deleteAllByPathSync(List<String> pathValues) {
    final values = pathValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'path', values);
  }

  Future<Id> putByPath(TrackFingerprintEntity object) {
    return putByIndex(r'path', object);
  }

  Id putByPathSync(TrackFingerprintEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'path', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByPath(List<TrackFingerprintEntity> objects) {
    return putAllByIndex(r'path', objects);
  }

  List<Id> putAllByPathSync(
    List<TrackFingerprintEntity> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'path', objects, saveLinks: saveLinks);
  }
}

extension TrackFingerprintEntityQueryWhereSort
    on QueryBuilder<TrackFingerprintEntity, TrackFingerprintEntity, QWhere> {
  QueryBuilder<TrackFingerprintEntity, TrackFingerprintEntity, QAfterWhere>
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TrackFingerprintEntityQueryWhere
    on
        QueryBuilder<
          TrackFingerprintEntity,
          TrackFingerprintEntity,
          QWhereClause
        > {
  QueryBuilder<
    TrackFingerprintEntity,
    TrackFingerprintEntity,
    QAfterWhereClause
  >
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<
    TrackFingerprintEntity,
    TrackFingerprintEntity,
    QAfterWhereClause
  >
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

  QueryBuilder<
    TrackFingerprintEntity,
    TrackFingerprintEntity,
    QAfterWhereClause
  >
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<
    TrackFingerprintEntity,
    TrackFingerprintEntity,
    QAfterWhereClause
  >
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<
    TrackFingerprintEntity,
    TrackFingerprintEntity,
    QAfterWhereClause
  >
  idBetween(
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

  QueryBuilder<
    TrackFingerprintEntity,
    TrackFingerprintEntity,
    QAfterWhereClause
  >
  pathEqualTo(String path) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'path', value: [path]),
      );
    });
  }

  QueryBuilder<
    TrackFingerprintEntity,
    TrackFingerprintEntity,
    QAfterWhereClause
  >
  pathNotEqualTo(String path) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'path',
                lower: [],
                upper: [path],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'path',
                lower: [path],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'path',
                lower: [path],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'path',
                lower: [],
                upper: [path],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension TrackFingerprintEntityQueryFilter
    on
        QueryBuilder<
          TrackFingerprintEntity,
          TrackFingerprintEntity,
          QFilterCondition
        > {
  QueryBuilder<
    TrackFingerprintEntity,
    TrackFingerprintEntity,
    QAfterFilterCondition
  >
  hashEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'hash',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TrackFingerprintEntity,
    TrackFingerprintEntity,
    QAfterFilterCondition
  >
  hashGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'hash',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TrackFingerprintEntity,
    TrackFingerprintEntity,
    QAfterFilterCondition
  >
  hashLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'hash',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TrackFingerprintEntity,
    TrackFingerprintEntity,
    QAfterFilterCondition
  >
  hashBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'hash',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TrackFingerprintEntity,
    TrackFingerprintEntity,
    QAfterFilterCondition
  >
  hashStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'hash',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TrackFingerprintEntity,
    TrackFingerprintEntity,
    QAfterFilterCondition
  >
  hashEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'hash',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TrackFingerprintEntity,
    TrackFingerprintEntity,
    QAfterFilterCondition
  >
  hashContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'hash',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TrackFingerprintEntity,
    TrackFingerprintEntity,
    QAfterFilterCondition
  >
  hashMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'hash',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TrackFingerprintEntity,
    TrackFingerprintEntity,
    QAfterFilterCondition
  >
  hashIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'hash', value: ''),
      );
    });
  }

  QueryBuilder<
    TrackFingerprintEntity,
    TrackFingerprintEntity,
    QAfterFilterCondition
  >
  hashIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'hash', value: ''),
      );
    });
  }

  QueryBuilder<
    TrackFingerprintEntity,
    TrackFingerprintEntity,
    QAfterFilterCondition
  >
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<
    TrackFingerprintEntity,
    TrackFingerprintEntity,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    TrackFingerprintEntity,
    TrackFingerprintEntity,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    TrackFingerprintEntity,
    TrackFingerprintEntity,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    TrackFingerprintEntity,
    TrackFingerprintEntity,
    QAfterFilterCondition
  >
  modifiedMsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'modifiedMs', value: value),
      );
    });
  }

  QueryBuilder<
    TrackFingerprintEntity,
    TrackFingerprintEntity,
    QAfterFilterCondition
  >
  modifiedMsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'modifiedMs',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    TrackFingerprintEntity,
    TrackFingerprintEntity,
    QAfterFilterCondition
  >
  modifiedMsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'modifiedMs',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    TrackFingerprintEntity,
    TrackFingerprintEntity,
    QAfterFilterCondition
  >
  modifiedMsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'modifiedMs',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    TrackFingerprintEntity,
    TrackFingerprintEntity,
    QAfterFilterCondition
  >
  pathEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'path',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TrackFingerprintEntity,
    TrackFingerprintEntity,
    QAfterFilterCondition
  >
  pathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'path',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TrackFingerprintEntity,
    TrackFingerprintEntity,
    QAfterFilterCondition
  >
  pathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'path',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TrackFingerprintEntity,
    TrackFingerprintEntity,
    QAfterFilterCondition
  >
  pathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'path',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TrackFingerprintEntity,
    TrackFingerprintEntity,
    QAfterFilterCondition
  >
  pathStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'path',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TrackFingerprintEntity,
    TrackFingerprintEntity,
    QAfterFilterCondition
  >
  pathEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'path',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TrackFingerprintEntity,
    TrackFingerprintEntity,
    QAfterFilterCondition
  >
  pathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'path',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TrackFingerprintEntity,
    TrackFingerprintEntity,
    QAfterFilterCondition
  >
  pathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'path',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    TrackFingerprintEntity,
    TrackFingerprintEntity,
    QAfterFilterCondition
  >
  pathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'path', value: ''),
      );
    });
  }

  QueryBuilder<
    TrackFingerprintEntity,
    TrackFingerprintEntity,
    QAfterFilterCondition
  >
  pathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'path', value: ''),
      );
    });
  }

  QueryBuilder<
    TrackFingerprintEntity,
    TrackFingerprintEntity,
    QAfterFilterCondition
  >
  sizeBytesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sizeBytes', value: value),
      );
    });
  }

  QueryBuilder<
    TrackFingerprintEntity,
    TrackFingerprintEntity,
    QAfterFilterCondition
  >
  sizeBytesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sizeBytes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    TrackFingerprintEntity,
    TrackFingerprintEntity,
    QAfterFilterCondition
  >
  sizeBytesLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sizeBytes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    TrackFingerprintEntity,
    TrackFingerprintEntity,
    QAfterFilterCondition
  >
  sizeBytesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sizeBytes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension TrackFingerprintEntityQueryObject
    on
        QueryBuilder<
          TrackFingerprintEntity,
          TrackFingerprintEntity,
          QFilterCondition
        > {}

extension TrackFingerprintEntityQueryLinks
    on
        QueryBuilder<
          TrackFingerprintEntity,
          TrackFingerprintEntity,
          QFilterCondition
        > {}

extension TrackFingerprintEntityQuerySortBy
    on QueryBuilder<TrackFingerprintEntity, TrackFingerprintEntity, QSortBy> {
  QueryBuilder<TrackFingerprintEntity, TrackFingerprintEntity, QAfterSortBy>
  sortByHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hash', Sort.asc);
    });
  }

  QueryBuilder<TrackFingerprintEntity, TrackFingerprintEntity, QAfterSortBy>
  sortByHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hash', Sort.desc);
    });
  }

  QueryBuilder<TrackFingerprintEntity, TrackFingerprintEntity, QAfterSortBy>
  sortByModifiedMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modifiedMs', Sort.asc);
    });
  }

  QueryBuilder<TrackFingerprintEntity, TrackFingerprintEntity, QAfterSortBy>
  sortByModifiedMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modifiedMs', Sort.desc);
    });
  }

  QueryBuilder<TrackFingerprintEntity, TrackFingerprintEntity, QAfterSortBy>
  sortByPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.asc);
    });
  }

  QueryBuilder<TrackFingerprintEntity, TrackFingerprintEntity, QAfterSortBy>
  sortByPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.desc);
    });
  }

  QueryBuilder<TrackFingerprintEntity, TrackFingerprintEntity, QAfterSortBy>
  sortBySizeBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sizeBytes', Sort.asc);
    });
  }

  QueryBuilder<TrackFingerprintEntity, TrackFingerprintEntity, QAfterSortBy>
  sortBySizeBytesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sizeBytes', Sort.desc);
    });
  }
}

extension TrackFingerprintEntityQuerySortThenBy
    on
        QueryBuilder<
          TrackFingerprintEntity,
          TrackFingerprintEntity,
          QSortThenBy
        > {
  QueryBuilder<TrackFingerprintEntity, TrackFingerprintEntity, QAfterSortBy>
  thenByHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hash', Sort.asc);
    });
  }

  QueryBuilder<TrackFingerprintEntity, TrackFingerprintEntity, QAfterSortBy>
  thenByHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hash', Sort.desc);
    });
  }

  QueryBuilder<TrackFingerprintEntity, TrackFingerprintEntity, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TrackFingerprintEntity, TrackFingerprintEntity, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TrackFingerprintEntity, TrackFingerprintEntity, QAfterSortBy>
  thenByModifiedMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modifiedMs', Sort.asc);
    });
  }

  QueryBuilder<TrackFingerprintEntity, TrackFingerprintEntity, QAfterSortBy>
  thenByModifiedMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modifiedMs', Sort.desc);
    });
  }

  QueryBuilder<TrackFingerprintEntity, TrackFingerprintEntity, QAfterSortBy>
  thenByPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.asc);
    });
  }

  QueryBuilder<TrackFingerprintEntity, TrackFingerprintEntity, QAfterSortBy>
  thenByPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.desc);
    });
  }

  QueryBuilder<TrackFingerprintEntity, TrackFingerprintEntity, QAfterSortBy>
  thenBySizeBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sizeBytes', Sort.asc);
    });
  }

  QueryBuilder<TrackFingerprintEntity, TrackFingerprintEntity, QAfterSortBy>
  thenBySizeBytesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sizeBytes', Sort.desc);
    });
  }
}

extension TrackFingerprintEntityQueryWhereDistinct
    on QueryBuilder<TrackFingerprintEntity, TrackFingerprintEntity, QDistinct> {
  QueryBuilder<TrackFingerprintEntity, TrackFingerprintEntity, QDistinct>
  distinctByHash({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hash', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TrackFingerprintEntity, TrackFingerprintEntity, QDistinct>
  distinctByModifiedMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'modifiedMs');
    });
  }

  QueryBuilder<TrackFingerprintEntity, TrackFingerprintEntity, QDistinct>
  distinctByPath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'path', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TrackFingerprintEntity, TrackFingerprintEntity, QDistinct>
  distinctBySizeBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sizeBytes');
    });
  }
}

extension TrackFingerprintEntityQueryProperty
    on
        QueryBuilder<
          TrackFingerprintEntity,
          TrackFingerprintEntity,
          QQueryProperty
        > {
  QueryBuilder<TrackFingerprintEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TrackFingerprintEntity, String, QQueryOperations>
  hashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hash');
    });
  }

  QueryBuilder<TrackFingerprintEntity, int, QQueryOperations>
  modifiedMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'modifiedMs');
    });
  }

  QueryBuilder<TrackFingerprintEntity, String, QQueryOperations>
  pathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'path');
    });
  }

  QueryBuilder<TrackFingerprintEntity, int, QQueryOperations>
  sizeBytesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sizeBytes');
    });
  }
}
