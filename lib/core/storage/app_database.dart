// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// NEXUS AI — App Database (Drift)
// SQLite ORM: conversations + messages tables
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

// ── Table Definitions ─────────────────────────────────────────

/// Conversations table — stores chat sessions.
class Conversations extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withDefault(const Constant('New Chat'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Messages table — stores individual chat messages.
class Messages extends Table {
  TextColumn get id => text()();
  TextColumn get conversationId => text().references(Conversations, #id)();
  TextColumn get role => text()(); // 'user', 'assistant', 'system'
  TextColumn get type => text().withDefault(const Constant('text'))(); // 'text', 'image', 'voice'
  TextColumn get content => text().withDefault(const Constant(''))();
  TextColumn get status => text().withDefault(const Constant('sent'))(); // 'sending', 'sent', 'streaming', 'error'
  TextColumn get imagePaths => text().nullable()(); // JSON array of paths
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// ── Database ──────────────────────────────────────────────────

@DriftDatabase(tables: [Conversations, Messages])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'nexus_ai');
  }

  // ── Conversation Queries ──────────────────────────────────

  /// Get all conversations, newest first.
  Future<List<Conversation>> getAllConversations() {
    return (select(conversations)
          ..orderBy([(c) => OrderingTerm.desc(c.updatedAt)]))
        .get();
  }

  /// Get a single conversation by ID.
  Future<Conversation?> getConversation(String id) {
    return (select(conversations)..where((c) => c.id.equals(id)))
        .getSingleOrNull();
  }

  /// Create or update a conversation.
  Future<void> upsertConversation(ConversationsCompanion entry) {
    return into(conversations).insertOnConflictUpdate(entry);
  }

  /// Delete a conversation and its messages.
  Future<void> deleteConversation(String id) async {
    await (delete(messages)..where((m) => m.conversationId.equals(id))).go();
    await (delete(conversations)..where((c) => c.id.equals(id))).go();
  }

  // ── Message Queries ───────────────────────────────────────

  /// Get all messages for a conversation, oldest first.
  Future<List<Message>> getMessagesForConversation(String conversationId) {
    return (select(messages)
          ..where((m) => m.conversationId.equals(conversationId))
          ..orderBy([(m) => OrderingTerm.asc(m.createdAt)]))
        .get();
  }

  /// Watch messages for real-time updates.
  Stream<List<Message>> watchMessagesForConversation(String conversationId) {
    return (select(messages)
          ..where((m) => m.conversationId.equals(conversationId))
          ..orderBy([(m) => OrderingTerm.asc(m.createdAt)]))
        .watch();
  }

  /// Insert a new message.
  Future<void> insertMessage(MessagesCompanion entry) {
    return into(messages).insert(entry);
  }

  /// Update an existing message (e.g., streaming content update).
  Future<void> updateMessage(MessagesCompanion entry) {
    return (update(messages)..where((m) => m.id.equals(entry.id.value)))
        .write(entry);
  }

  /// Delete a message by ID.
  Future<void> deleteMessage(String id) {
    return (delete(messages)..where((m) => m.id.equals(id))).go();
  }

  /// Get the most recent conversation.
  Future<Conversation?> getMostRecentConversation() {
    return (select(conversations)
          ..orderBy([(c) => OrderingTerm.desc(c.updatedAt)])
          ..limit(1))
        .getSingleOrNull();
  }
}
