// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AlarmsTable extends Alarms with TableInfo<$AlarmsTable, Alarm> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlarmsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<DateTime> time = GeneratedColumn<DateTime>(
    'time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repeatDaysMeta = const VerificationMeta(
    'repeatDays',
  );
  @override
  late final GeneratedColumn<String> repeatDays = GeneratedColumn<String>(
    'repeat_days',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
    'mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('normal'),
  );
  static const VerificationMeta _soundIdMeta = const VerificationMeta(
    'soundId',
  );
  @override
  late final GeneratedColumn<int> soundId = GeneratedColumn<int>(
    'sound_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mediaIdMeta = const VerificationMeta(
    'mediaId',
  );
  @override
  late final GeneratedColumn<int> mediaId = GeneratedColumn<int>(
    'media_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _snoozeIntervalMinutesMeta =
      const VerificationMeta('snoozeIntervalMinutes');
  @override
  late final GeneratedColumn<int> snoozeIntervalMinutes = GeneratedColumn<int>(
    'snooze_interval_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(5),
  );
  static const VerificationMeta _snoozeMaxCountMeta = const VerificationMeta(
    'snoozeMaxCount',
  );
  @override
  late final GeneratedColumn<int> snoozeMaxCount = GeneratedColumn<int>(
    'snooze_max_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _challengesMeta = const VerificationMeta(
    'challenges',
  );
  @override
  late final GeneratedColumn<String> challenges = GeneratedColumn<String>(
    'challenges',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timezoneMeta = const VerificationMeta(
    'timezone',
  );
  @override
  late final GeneratedColumn<String> timezone = GeneratedColumn<String>(
    'timezone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    time,
    repeatDays,
    label,
    mode,
    soundId,
    mediaId,
    snoozeIntervalMinutes,
    snoozeMaxCount,
    challenges,
    timezone,
    enabled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'alarms';
  @override
  VerificationContext validateIntegrity(
    Insertable<Alarm> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('time')) {
      context.handle(
        _timeMeta,
        time.isAcceptableOrUnknown(data['time']!, _timeMeta),
      );
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    if (data.containsKey('repeat_days')) {
      context.handle(
        _repeatDaysMeta,
        repeatDays.isAcceptableOrUnknown(data['repeat_days']!, _repeatDaysMeta),
      );
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    }
    if (data.containsKey('mode')) {
      context.handle(
        _modeMeta,
        mode.isAcceptableOrUnknown(data['mode']!, _modeMeta),
      );
    }
    if (data.containsKey('sound_id')) {
      context.handle(
        _soundIdMeta,
        soundId.isAcceptableOrUnknown(data['sound_id']!, _soundIdMeta),
      );
    }
    if (data.containsKey('media_id')) {
      context.handle(
        _mediaIdMeta,
        mediaId.isAcceptableOrUnknown(data['media_id']!, _mediaIdMeta),
      );
    }
    if (data.containsKey('snooze_interval_minutes')) {
      context.handle(
        _snoozeIntervalMinutesMeta,
        snoozeIntervalMinutes.isAcceptableOrUnknown(
          data['snooze_interval_minutes']!,
          _snoozeIntervalMinutesMeta,
        ),
      );
    }
    if (data.containsKey('snooze_max_count')) {
      context.handle(
        _snoozeMaxCountMeta,
        snoozeMaxCount.isAcceptableOrUnknown(
          data['snooze_max_count']!,
          _snoozeMaxCountMeta,
        ),
      );
    }
    if (data.containsKey('challenges')) {
      context.handle(
        _challengesMeta,
        challenges.isAcceptableOrUnknown(data['challenges']!, _challengesMeta),
      );
    }
    if (data.containsKey('timezone')) {
      context.handle(
        _timezoneMeta,
        timezone.isAcceptableOrUnknown(data['timezone']!, _timezoneMeta),
      );
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Alarm map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Alarm(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      time: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}time'],
      )!,
      repeatDays: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repeat_days'],
      ),
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      mode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mode'],
      )!,
      soundId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sound_id'],
      ),
      mediaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}media_id'],
      ),
      snoozeIntervalMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}snooze_interval_minutes'],
      )!,
      snoozeMaxCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}snooze_max_count'],
      )!,
      challenges: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}challenges'],
      ),
      timezone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}timezone'],
      ),
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
    );
  }

  @override
  $AlarmsTable createAlias(String alias) {
    return $AlarmsTable(attachedDatabase, alias);
  }
}

class Alarm extends DataClass implements Insertable<Alarm> {
  /// ID tự tăng
  final int id;

  /// Giờ báo thức (UTC timestamp)
  final DateTime time;

  /// Các ngày lặp lại, lưu dạng JSON array, ví dụ: [1,2,3] = Thứ 2, 3, 4
  /// Dùng DateTime.monday (1) đến DateTime.sunday (7)
  /// null = báo thức một lần
  final String? repeatDays;

  /// Nhãn tùy chỉnh
  final String label;

  /// Chế độ đánh thức: 'normal' hoặc 'deep'
  final String mode;

  /// ID âm thanh tùy chỉnh (GĐ 2)
  final int? soundId;

  /// ID media (video) tùy chỉnh (GĐ 2)
  final int? mediaId;

  /// Khoảng thời gian báo lại (phút)
  final int snoozeIntervalMinutes;

  /// Số lần báo lại tối đa
  final int snoozeMaxCount;

  /// Danh sách thử thách dạng JSON (GĐ 3)
  final String? challenges;

  /// Múi giờ IANA, ví dụ 'Asia/Tokyo' (GĐ 6)
  final String? timezone;

  /// Báo thức đang bật hay tắt
  final bool enabled;
  const Alarm({
    required this.id,
    required this.time,
    this.repeatDays,
    required this.label,
    required this.mode,
    this.soundId,
    this.mediaId,
    required this.snoozeIntervalMinutes,
    required this.snoozeMaxCount,
    this.challenges,
    this.timezone,
    required this.enabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['time'] = Variable<DateTime>(time);
    if (!nullToAbsent || repeatDays != null) {
      map['repeat_days'] = Variable<String>(repeatDays);
    }
    map['label'] = Variable<String>(label);
    map['mode'] = Variable<String>(mode);
    if (!nullToAbsent || soundId != null) {
      map['sound_id'] = Variable<int>(soundId);
    }
    if (!nullToAbsent || mediaId != null) {
      map['media_id'] = Variable<int>(mediaId);
    }
    map['snooze_interval_minutes'] = Variable<int>(snoozeIntervalMinutes);
    map['snooze_max_count'] = Variable<int>(snoozeMaxCount);
    if (!nullToAbsent || challenges != null) {
      map['challenges'] = Variable<String>(challenges);
    }
    if (!nullToAbsent || timezone != null) {
      map['timezone'] = Variable<String>(timezone);
    }
    map['enabled'] = Variable<bool>(enabled);
    return map;
  }

  AlarmsCompanion toCompanion(bool nullToAbsent) {
    return AlarmsCompanion(
      id: Value(id),
      time: Value(time),
      repeatDays: repeatDays == null && nullToAbsent
          ? const Value.absent()
          : Value(repeatDays),
      label: Value(label),
      mode: Value(mode),
      soundId: soundId == null && nullToAbsent
          ? const Value.absent()
          : Value(soundId),
      mediaId: mediaId == null && nullToAbsent
          ? const Value.absent()
          : Value(mediaId),
      snoozeIntervalMinutes: Value(snoozeIntervalMinutes),
      snoozeMaxCount: Value(snoozeMaxCount),
      challenges: challenges == null && nullToAbsent
          ? const Value.absent()
          : Value(challenges),
      timezone: timezone == null && nullToAbsent
          ? const Value.absent()
          : Value(timezone),
      enabled: Value(enabled),
    );
  }

  factory Alarm.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Alarm(
      id: serializer.fromJson<int>(json['id']),
      time: serializer.fromJson<DateTime>(json['time']),
      repeatDays: serializer.fromJson<String?>(json['repeatDays']),
      label: serializer.fromJson<String>(json['label']),
      mode: serializer.fromJson<String>(json['mode']),
      soundId: serializer.fromJson<int?>(json['soundId']),
      mediaId: serializer.fromJson<int?>(json['mediaId']),
      snoozeIntervalMinutes: serializer.fromJson<int>(
        json['snoozeIntervalMinutes'],
      ),
      snoozeMaxCount: serializer.fromJson<int>(json['snoozeMaxCount']),
      challenges: serializer.fromJson<String?>(json['challenges']),
      timezone: serializer.fromJson<String?>(json['timezone']),
      enabled: serializer.fromJson<bool>(json['enabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'time': serializer.toJson<DateTime>(time),
      'repeatDays': serializer.toJson<String?>(repeatDays),
      'label': serializer.toJson<String>(label),
      'mode': serializer.toJson<String>(mode),
      'soundId': serializer.toJson<int?>(soundId),
      'mediaId': serializer.toJson<int?>(mediaId),
      'snoozeIntervalMinutes': serializer.toJson<int>(snoozeIntervalMinutes),
      'snoozeMaxCount': serializer.toJson<int>(snoozeMaxCount),
      'challenges': serializer.toJson<String?>(challenges),
      'timezone': serializer.toJson<String?>(timezone),
      'enabled': serializer.toJson<bool>(enabled),
    };
  }

  Alarm copyWith({
    int? id,
    DateTime? time,
    Value<String?> repeatDays = const Value.absent(),
    String? label,
    String? mode,
    Value<int?> soundId = const Value.absent(),
    Value<int?> mediaId = const Value.absent(),
    int? snoozeIntervalMinutes,
    int? snoozeMaxCount,
    Value<String?> challenges = const Value.absent(),
    Value<String?> timezone = const Value.absent(),
    bool? enabled,
  }) => Alarm(
    id: id ?? this.id,
    time: time ?? this.time,
    repeatDays: repeatDays.present ? repeatDays.value : this.repeatDays,
    label: label ?? this.label,
    mode: mode ?? this.mode,
    soundId: soundId.present ? soundId.value : this.soundId,
    mediaId: mediaId.present ? mediaId.value : this.mediaId,
    snoozeIntervalMinutes: snoozeIntervalMinutes ?? this.snoozeIntervalMinutes,
    snoozeMaxCount: snoozeMaxCount ?? this.snoozeMaxCount,
    challenges: challenges.present ? challenges.value : this.challenges,
    timezone: timezone.present ? timezone.value : this.timezone,
    enabled: enabled ?? this.enabled,
  );
  Alarm copyWithCompanion(AlarmsCompanion data) {
    return Alarm(
      id: data.id.present ? data.id.value : this.id,
      time: data.time.present ? data.time.value : this.time,
      repeatDays: data.repeatDays.present
          ? data.repeatDays.value
          : this.repeatDays,
      label: data.label.present ? data.label.value : this.label,
      mode: data.mode.present ? data.mode.value : this.mode,
      soundId: data.soundId.present ? data.soundId.value : this.soundId,
      mediaId: data.mediaId.present ? data.mediaId.value : this.mediaId,
      snoozeIntervalMinutes: data.snoozeIntervalMinutes.present
          ? data.snoozeIntervalMinutes.value
          : this.snoozeIntervalMinutes,
      snoozeMaxCount: data.snoozeMaxCount.present
          ? data.snoozeMaxCount.value
          : this.snoozeMaxCount,
      challenges: data.challenges.present
          ? data.challenges.value
          : this.challenges,
      timezone: data.timezone.present ? data.timezone.value : this.timezone,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Alarm(')
          ..write('id: $id, ')
          ..write('time: $time, ')
          ..write('repeatDays: $repeatDays, ')
          ..write('label: $label, ')
          ..write('mode: $mode, ')
          ..write('soundId: $soundId, ')
          ..write('mediaId: $mediaId, ')
          ..write('snoozeIntervalMinutes: $snoozeIntervalMinutes, ')
          ..write('snoozeMaxCount: $snoozeMaxCount, ')
          ..write('challenges: $challenges, ')
          ..write('timezone: $timezone, ')
          ..write('enabled: $enabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    time,
    repeatDays,
    label,
    mode,
    soundId,
    mediaId,
    snoozeIntervalMinutes,
    snoozeMaxCount,
    challenges,
    timezone,
    enabled,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Alarm &&
          other.id == this.id &&
          other.time == this.time &&
          other.repeatDays == this.repeatDays &&
          other.label == this.label &&
          other.mode == this.mode &&
          other.soundId == this.soundId &&
          other.mediaId == this.mediaId &&
          other.snoozeIntervalMinutes == this.snoozeIntervalMinutes &&
          other.snoozeMaxCount == this.snoozeMaxCount &&
          other.challenges == this.challenges &&
          other.timezone == this.timezone &&
          other.enabled == this.enabled);
}

class AlarmsCompanion extends UpdateCompanion<Alarm> {
  final Value<int> id;
  final Value<DateTime> time;
  final Value<String?> repeatDays;
  final Value<String> label;
  final Value<String> mode;
  final Value<int?> soundId;
  final Value<int?> mediaId;
  final Value<int> snoozeIntervalMinutes;
  final Value<int> snoozeMaxCount;
  final Value<String?> challenges;
  final Value<String?> timezone;
  final Value<bool> enabled;
  const AlarmsCompanion({
    this.id = const Value.absent(),
    this.time = const Value.absent(),
    this.repeatDays = const Value.absent(),
    this.label = const Value.absent(),
    this.mode = const Value.absent(),
    this.soundId = const Value.absent(),
    this.mediaId = const Value.absent(),
    this.snoozeIntervalMinutes = const Value.absent(),
    this.snoozeMaxCount = const Value.absent(),
    this.challenges = const Value.absent(),
    this.timezone = const Value.absent(),
    this.enabled = const Value.absent(),
  });
  AlarmsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime time,
    this.repeatDays = const Value.absent(),
    this.label = const Value.absent(),
    this.mode = const Value.absent(),
    this.soundId = const Value.absent(),
    this.mediaId = const Value.absent(),
    this.snoozeIntervalMinutes = const Value.absent(),
    this.snoozeMaxCount = const Value.absent(),
    this.challenges = const Value.absent(),
    this.timezone = const Value.absent(),
    this.enabled = const Value.absent(),
  }) : time = Value(time);
  static Insertable<Alarm> custom({
    Expression<int>? id,
    Expression<DateTime>? time,
    Expression<String>? repeatDays,
    Expression<String>? label,
    Expression<String>? mode,
    Expression<int>? soundId,
    Expression<int>? mediaId,
    Expression<int>? snoozeIntervalMinutes,
    Expression<int>? snoozeMaxCount,
    Expression<String>? challenges,
    Expression<String>? timezone,
    Expression<bool>? enabled,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (time != null) 'time': time,
      if (repeatDays != null) 'repeat_days': repeatDays,
      if (label != null) 'label': label,
      if (mode != null) 'mode': mode,
      if (soundId != null) 'sound_id': soundId,
      if (mediaId != null) 'media_id': mediaId,
      if (snoozeIntervalMinutes != null)
        'snooze_interval_minutes': snoozeIntervalMinutes,
      if (snoozeMaxCount != null) 'snooze_max_count': snoozeMaxCount,
      if (challenges != null) 'challenges': challenges,
      if (timezone != null) 'timezone': timezone,
      if (enabled != null) 'enabled': enabled,
    });
  }

  AlarmsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? time,
    Value<String?>? repeatDays,
    Value<String>? label,
    Value<String>? mode,
    Value<int?>? soundId,
    Value<int?>? mediaId,
    Value<int>? snoozeIntervalMinutes,
    Value<int>? snoozeMaxCount,
    Value<String?>? challenges,
    Value<String?>? timezone,
    Value<bool>? enabled,
  }) {
    return AlarmsCompanion(
      id: id ?? this.id,
      time: time ?? this.time,
      repeatDays: repeatDays ?? this.repeatDays,
      label: label ?? this.label,
      mode: mode ?? this.mode,
      soundId: soundId ?? this.soundId,
      mediaId: mediaId ?? this.mediaId,
      snoozeIntervalMinutes:
          snoozeIntervalMinutes ?? this.snoozeIntervalMinutes,
      snoozeMaxCount: snoozeMaxCount ?? this.snoozeMaxCount,
      challenges: challenges ?? this.challenges,
      timezone: timezone ?? this.timezone,
      enabled: enabled ?? this.enabled,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (time.present) {
      map['time'] = Variable<DateTime>(time.value);
    }
    if (repeatDays.present) {
      map['repeat_days'] = Variable<String>(repeatDays.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (soundId.present) {
      map['sound_id'] = Variable<int>(soundId.value);
    }
    if (mediaId.present) {
      map['media_id'] = Variable<int>(mediaId.value);
    }
    if (snoozeIntervalMinutes.present) {
      map['snooze_interval_minutes'] = Variable<int>(
        snoozeIntervalMinutes.value,
      );
    }
    if (snoozeMaxCount.present) {
      map['snooze_max_count'] = Variable<int>(snoozeMaxCount.value);
    }
    if (challenges.present) {
      map['challenges'] = Variable<String>(challenges.value);
    }
    if (timezone.present) {
      map['timezone'] = Variable<String>(timezone.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlarmsCompanion(')
          ..write('id: $id, ')
          ..write('time: $time, ')
          ..write('repeatDays: $repeatDays, ')
          ..write('label: $label, ')
          ..write('mode: $mode, ')
          ..write('soundId: $soundId, ')
          ..write('mediaId: $mediaId, ')
          ..write('snoozeIntervalMinutes: $snoozeIntervalMinutes, ')
          ..write('snoozeMaxCount: $snoozeMaxCount, ')
          ..write('challenges: $challenges, ')
          ..write('timezone: $timezone, ')
          ..write('enabled: $enabled')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AlarmsTable alarms = $AlarmsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [alarms];
}

typedef $$AlarmsTableCreateCompanionBuilder = AlarmsCompanion Function({
  Value<int> id,
  required DateTime time,
  Value<String?> repeatDays,
  Value<String> label,
  Value<String> mode,
  Value<int?> soundId,
  Value<int?> mediaId,
  Value<int> snoozeIntervalMinutes,
  Value<int> snoozeMaxCount,
  Value<String?> challenges,
  Value<String?> timezone,
  Value<bool> enabled,
});
typedef $$AlarmsTableUpdateCompanionBuilder = AlarmsCompanion Function({
  Value<int> id,
  Value<DateTime> time,
  Value<String?> repeatDays,
  Value<String> label,
  Value<String> mode,
  Value<int?> soundId,
  Value<int?> mediaId,
  Value<int> snoozeIntervalMinutes,
  Value<int> snoozeMaxCount,
  Value<String?> challenges,
  Value<String?> timezone,
  Value<bool> enabled,
});

class $$AlarmsTableFilterComposer
    extends Composer<_$AppDatabase, $AlarmsTable> {
  $$AlarmsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repeatDays => $composableBuilder(
    column: $table.repeatDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get soundId => $composableBuilder(
    column: $table.soundId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mediaId => $composableBuilder(
    column: $table.mediaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get snoozeIntervalMinutes => $composableBuilder(
    column: $table.snoozeIntervalMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get snoozeMaxCount => $composableBuilder(
    column: $table.snoozeMaxCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get challenges => $composableBuilder(
    column: $table.challenges,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timezone => $composableBuilder(
    column: $table.timezone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AlarmsTableOrderingComposer
    extends Composer<_$AppDatabase, $AlarmsTable> {
  $$AlarmsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repeatDays => $composableBuilder(
    column: $table.repeatDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get soundId => $composableBuilder(
    column: $table.soundId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mediaId => $composableBuilder(
    column: $table.mediaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get snoozeIntervalMinutes => $composableBuilder(
    column: $table.snoozeIntervalMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get snoozeMaxCount => $composableBuilder(
    column: $table.snoozeMaxCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get challenges => $composableBuilder(
    column: $table.challenges,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timezone => $composableBuilder(
    column: $table.timezone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AlarmsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AlarmsTable> {
  $$AlarmsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  GeneratedColumn<String> get repeatDays => $composableBuilder(
    column: $table.repeatDays,
    builder: (column) => column,
  );

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<int> get soundId =>
      $composableBuilder(column: $table.soundId, builder: (column) => column);

  GeneratedColumn<int> get mediaId =>
      $composableBuilder(column: $table.mediaId, builder: (column) => column);

  GeneratedColumn<int> get snoozeIntervalMinutes => $composableBuilder(
    column: $table.snoozeIntervalMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get snoozeMaxCount => $composableBuilder(
    column: $table.snoozeMaxCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get challenges => $composableBuilder(
    column: $table.challenges,
    builder: (column) => column,
  );

  GeneratedColumn<String> get timezone =>
      $composableBuilder(column: $table.timezone, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);
}

class $$AlarmsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AlarmsTable,
          Alarm,
          $$AlarmsTableFilterComposer,
          $$AlarmsTableOrderingComposer,
          $$AlarmsTableAnnotationComposer,
          $$AlarmsTableCreateCompanionBuilder,
          $$AlarmsTableUpdateCompanionBuilder,
          (Alarm, BaseReferences<_$AppDatabase, $AlarmsTable, Alarm>),
          Alarm,
          PrefetchHooks Function()
        > {
  $$AlarmsTableTableManager(_$AppDatabase db, $AlarmsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AlarmsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AlarmsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AlarmsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> time = const Value.absent(),
                Value<String?> repeatDays = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String> mode = const Value.absent(),
                Value<int?> soundId = const Value.absent(),
                Value<int?> mediaId = const Value.absent(),
                Value<int> snoozeIntervalMinutes = const Value.absent(),
                Value<int> snoozeMaxCount = const Value.absent(),
                Value<String?> challenges = const Value.absent(),
                Value<String?> timezone = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
              }) => AlarmsCompanion(
                id: id,
                time: time,
                repeatDays: repeatDays,
                label: label,
                mode: mode,
                soundId: soundId,
                mediaId: mediaId,
                snoozeIntervalMinutes: snoozeIntervalMinutes,
                snoozeMaxCount: snoozeMaxCount,
                challenges: challenges,
                timezone: timezone,
                enabled: enabled,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime time,
                Value<String?> repeatDays = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String> mode = const Value.absent(),
                Value<int?> soundId = const Value.absent(),
                Value<int?> mediaId = const Value.absent(),
                Value<int> snoozeIntervalMinutes = const Value.absent(),
                Value<int> snoozeMaxCount = const Value.absent(),
                Value<String?> challenges = const Value.absent(),
                Value<String?> timezone = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
              }) => AlarmsCompanion.insert(
                id: id,
                time: time,
                repeatDays: repeatDays,
                label: label,
                mode: mode,
                soundId: soundId,
                mediaId: mediaId,
                snoozeIntervalMinutes: snoozeIntervalMinutes,
                snoozeMaxCount: snoozeMaxCount,
                challenges: challenges,
                timezone: timezone,
                enabled: enabled,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AlarmsTable, Alarm>(table),
                  BaseReferences<_$AppDatabase, $AlarmsTable, Alarm>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AlarmsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AlarmsTable,
      Alarm,
      $$AlarmsTableFilterComposer,
      $$AlarmsTableOrderingComposer,
      $$AlarmsTableAnnotationComposer,
      $$AlarmsTableCreateCompanionBuilder,
      $$AlarmsTableUpdateCompanionBuilder,
      (Alarm, BaseReferences<_$AppDatabase, $AlarmsTable, Alarm>),
      Alarm,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AlarmsTableTableManager get alarms =>
      $$AlarmsTableTableManager(_db, _db.alarms);
}
