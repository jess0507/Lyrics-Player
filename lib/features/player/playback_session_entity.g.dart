// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playback_session_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPlaybackSessionEntityCollection on Isar {
  IsarCollection<PlaybackSessionEntity> get playbackSessionEntitys =>
      this.collection();
}

const PlaybackSessionEntitySchema = CollectionSchema(
  name: r'PlaybackSessionEntity',
  id: -6717341798927458997,
  properties: {
    r'positionMs': PropertySchema(
      id: 0,
      name: r'positionMs',
      type: IsarType.long,
    ),
    r'trackArtist': PropertySchema(
      id: 1,
      name: r'trackArtist',
      type: IsarType.string,
    ),
    r'trackDurationMs': PropertySchema(
      id: 2,
      name: r'trackDurationMs',
      type: IsarType.long,
    ),
    r'trackId': PropertySchema(
      id: 3,
      name: r'trackId',
      type: IsarType.string,
    ),
    r'trackTitle': PropertySchema(
      id: 4,
      name: r'trackTitle',
      type: IsarType.string,
    ),
    r'trackUri': PropertySchema(
      id: 5,
      name: r'trackUri',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 6,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _playbackSessionEntityEstimateSize,
  serialize: _playbackSessionEntitySerialize,
  deserialize: _playbackSessionEntityDeserialize,
  deserializeProp: _playbackSessionEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'trackId': IndexSchema(
      id: -8614467705999066844,
      name: r'trackId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'trackId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _playbackSessionEntityGetId,
  getLinks: _playbackSessionEntityGetLinks,
  attach: _playbackSessionEntityAttach,
  version: '3.1.0+1',
);

int _playbackSessionEntityEstimateSize(
  PlaybackSessionEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.trackArtist;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.trackId.length * 3;
  bytesCount += 3 + object.trackTitle.length * 3;
  bytesCount += 3 + object.trackUri.length * 3;
  return bytesCount;
}

void _playbackSessionEntitySerialize(
  PlaybackSessionEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.positionMs);
  writer.writeString(offsets[1], object.trackArtist);
  writer.writeLong(offsets[2], object.trackDurationMs);
  writer.writeString(offsets[3], object.trackId);
  writer.writeString(offsets[4], object.trackTitle);
  writer.writeString(offsets[5], object.trackUri);
  writer.writeDateTime(offsets[6], object.updatedAt);
}

PlaybackSessionEntity _playbackSessionEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PlaybackSessionEntity();
  object.id = id;
  object.positionMs = reader.readLong(offsets[0]);
  object.trackArtist = reader.readStringOrNull(offsets[1]);
  object.trackDurationMs = reader.readLongOrNull(offsets[2]);
  object.trackId = reader.readString(offsets[3]);
  object.trackTitle = reader.readString(offsets[4]);
  object.trackUri = reader.readString(offsets[5]);
  object.updatedAt = reader.readDateTime(offsets[6]);
  return object;
}

P _playbackSessionEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _playbackSessionEntityGetId(PlaybackSessionEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _playbackSessionEntityGetLinks(
    PlaybackSessionEntity object) {
  return [];
}

void _playbackSessionEntityAttach(
    IsarCollection<dynamic> col, Id id, PlaybackSessionEntity object) {
  object.id = id;
}

extension PlaybackSessionEntityByIndex
    on IsarCollection<PlaybackSessionEntity> {
  Future<PlaybackSessionEntity?> getByTrackId(String trackId) {
    return getByIndex(r'trackId', [trackId]);
  }

  PlaybackSessionEntity? getByTrackIdSync(String trackId) {
    return getByIndexSync(r'trackId', [trackId]);
  }

  Future<bool> deleteByTrackId(String trackId) {
    return deleteByIndex(r'trackId', [trackId]);
  }

  bool deleteByTrackIdSync(String trackId) {
    return deleteByIndexSync(r'trackId', [trackId]);
  }

  Future<List<PlaybackSessionEntity?>> getAllByTrackId(
      List<String> trackIdValues) {
    final values = trackIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'trackId', values);
  }

  List<PlaybackSessionEntity?> getAllByTrackIdSync(List<String> trackIdValues) {
    final values = trackIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'trackId', values);
  }

  Future<int> deleteAllByTrackId(List<String> trackIdValues) {
    final values = trackIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'trackId', values);
  }

  int deleteAllByTrackIdSync(List<String> trackIdValues) {
    final values = trackIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'trackId', values);
  }

  Future<Id> putByTrackId(PlaybackSessionEntity object) {
    return putByIndex(r'trackId', object);
  }

  Id putByTrackIdSync(PlaybackSessionEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'trackId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByTrackId(List<PlaybackSessionEntity> objects) {
    return putAllByIndex(r'trackId', objects);
  }

  List<Id> putAllByTrackIdSync(List<PlaybackSessionEntity> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'trackId', objects, saveLinks: saveLinks);
  }
}

extension PlaybackSessionEntityQueryWhereSort
    on QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QWhere> {
  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PlaybackSessionEntityQueryWhere on QueryBuilder<PlaybackSessionEntity,
    PlaybackSessionEntity, QWhereClause> {
  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QAfterWhereClause>
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

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QAfterWhereClause>
      trackIdEqualTo(String trackId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'trackId',
        value: [trackId],
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QAfterWhereClause>
      trackIdNotEqualTo(String trackId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'trackId',
              lower: [],
              upper: [trackId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'trackId',
              lower: [trackId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'trackId',
              lower: [trackId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'trackId',
              lower: [],
              upper: [trackId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension PlaybackSessionEntityQueryFilter on QueryBuilder<
    PlaybackSessionEntity, PlaybackSessionEntity, QFilterCondition> {
  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> positionMsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'positionMs',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> positionMsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'positionMs',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> positionMsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'positionMs',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> positionMsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'positionMs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> trackArtistIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'trackArtist',
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> trackArtistIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'trackArtist',
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> trackArtistEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'trackArtist',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> trackArtistGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'trackArtist',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> trackArtistLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'trackArtist',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> trackArtistBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'trackArtist',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> trackArtistStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'trackArtist',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> trackArtistEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'trackArtist',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
          QAfterFilterCondition>
      trackArtistContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'trackArtist',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
          QAfterFilterCondition>
      trackArtistMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'trackArtist',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> trackArtistIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'trackArtist',
        value: '',
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> trackArtistIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'trackArtist',
        value: '',
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> trackDurationMsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'trackDurationMs',
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> trackDurationMsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'trackDurationMs',
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> trackDurationMsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'trackDurationMs',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> trackDurationMsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'trackDurationMs',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> trackDurationMsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'trackDurationMs',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> trackDurationMsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'trackDurationMs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> trackIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'trackId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> trackIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'trackId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> trackIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'trackId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> trackIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'trackId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> trackIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'trackId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> trackIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'trackId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
          QAfterFilterCondition>
      trackIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'trackId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
          QAfterFilterCondition>
      trackIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'trackId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> trackIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'trackId',
        value: '',
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> trackIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'trackId',
        value: '',
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> trackTitleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'trackTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> trackTitleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'trackTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> trackTitleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'trackTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> trackTitleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'trackTitle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> trackTitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'trackTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> trackTitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'trackTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
          QAfterFilterCondition>
      trackTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'trackTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
          QAfterFilterCondition>
      trackTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'trackTitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> trackTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'trackTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> trackTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'trackTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> trackUriEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'trackUri',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> trackUriGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'trackUri',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> trackUriLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'trackUri',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> trackUriBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'trackUri',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> trackUriStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'trackUri',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> trackUriEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'trackUri',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
          QAfterFilterCondition>
      trackUriContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'trackUri',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
          QAfterFilterCondition>
      trackUriMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'trackUri',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> trackUriIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'trackUri',
        value: '',
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> trackUriIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'trackUri',
        value: '',
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity,
      QAfterFilterCondition> updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PlaybackSessionEntityQueryObject on QueryBuilder<
    PlaybackSessionEntity, PlaybackSessionEntity, QFilterCondition> {}

extension PlaybackSessionEntityQueryLinks on QueryBuilder<PlaybackSessionEntity,
    PlaybackSessionEntity, QFilterCondition> {}

extension PlaybackSessionEntityQuerySortBy
    on QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QSortBy> {
  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QAfterSortBy>
      sortByPositionMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'positionMs', Sort.asc);
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QAfterSortBy>
      sortByPositionMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'positionMs', Sort.desc);
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QAfterSortBy>
      sortByTrackArtist() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackArtist', Sort.asc);
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QAfterSortBy>
      sortByTrackArtistDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackArtist', Sort.desc);
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QAfterSortBy>
      sortByTrackDurationMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackDurationMs', Sort.asc);
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QAfterSortBy>
      sortByTrackDurationMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackDurationMs', Sort.desc);
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QAfterSortBy>
      sortByTrackId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackId', Sort.asc);
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QAfterSortBy>
      sortByTrackIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackId', Sort.desc);
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QAfterSortBy>
      sortByTrackTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackTitle', Sort.asc);
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QAfterSortBy>
      sortByTrackTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackTitle', Sort.desc);
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QAfterSortBy>
      sortByTrackUri() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackUri', Sort.asc);
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QAfterSortBy>
      sortByTrackUriDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackUri', Sort.desc);
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension PlaybackSessionEntityQuerySortThenBy
    on QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QSortThenBy> {
  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QAfterSortBy>
      thenByPositionMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'positionMs', Sort.asc);
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QAfterSortBy>
      thenByPositionMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'positionMs', Sort.desc);
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QAfterSortBy>
      thenByTrackArtist() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackArtist', Sort.asc);
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QAfterSortBy>
      thenByTrackArtistDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackArtist', Sort.desc);
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QAfterSortBy>
      thenByTrackDurationMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackDurationMs', Sort.asc);
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QAfterSortBy>
      thenByTrackDurationMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackDurationMs', Sort.desc);
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QAfterSortBy>
      thenByTrackId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackId', Sort.asc);
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QAfterSortBy>
      thenByTrackIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackId', Sort.desc);
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QAfterSortBy>
      thenByTrackTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackTitle', Sort.asc);
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QAfterSortBy>
      thenByTrackTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackTitle', Sort.desc);
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QAfterSortBy>
      thenByTrackUri() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackUri', Sort.asc);
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QAfterSortBy>
      thenByTrackUriDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackUri', Sort.desc);
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension PlaybackSessionEntityQueryWhereDistinct
    on QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QDistinct> {
  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QDistinct>
      distinctByPositionMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'positionMs');
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QDistinct>
      distinctByTrackArtist({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'trackArtist', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QDistinct>
      distinctByTrackDurationMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'trackDurationMs');
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QDistinct>
      distinctByTrackId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'trackId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QDistinct>
      distinctByTrackTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'trackTitle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QDistinct>
      distinctByTrackUri({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'trackUri', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlaybackSessionEntity, PlaybackSessionEntity, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension PlaybackSessionEntityQueryProperty on QueryBuilder<
    PlaybackSessionEntity, PlaybackSessionEntity, QQueryProperty> {
  QueryBuilder<PlaybackSessionEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PlaybackSessionEntity, int, QQueryOperations>
      positionMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'positionMs');
    });
  }

  QueryBuilder<PlaybackSessionEntity, String?, QQueryOperations>
      trackArtistProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'trackArtist');
    });
  }

  QueryBuilder<PlaybackSessionEntity, int?, QQueryOperations>
      trackDurationMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'trackDurationMs');
    });
  }

  QueryBuilder<PlaybackSessionEntity, String, QQueryOperations>
      trackIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'trackId');
    });
  }

  QueryBuilder<PlaybackSessionEntity, String, QQueryOperations>
      trackTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'trackTitle');
    });
  }

  QueryBuilder<PlaybackSessionEntity, String, QQueryOperations>
      trackUriProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'trackUri');
    });
  }

  QueryBuilder<PlaybackSessionEntity, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
