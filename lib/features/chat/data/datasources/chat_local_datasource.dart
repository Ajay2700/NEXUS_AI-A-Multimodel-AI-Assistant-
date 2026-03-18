// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// NEXUS AI — Chat Local DataSource
// Drift-backed local storage for chat data
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'dart:convert';

import 'package:drift/drift.dart';

import 'package:nexus_ai/core/storage/app_database.dart';
import 'package:nexus_ai/core/utils/logger.dart';
import 'package:nexus_ai/features/chat/domain/entities/conversation_entity.dart';
import 'package:nexus_ai/features/chat/domain/entities/message_entity.dart';

/// Local data source for chat operations using Drift.
class ChatLocalDataSource {
  ChatLocalDataSource({required this.database});

  final AppDatabase database;

  // ── Conversations ─────────────────────────────────────────

  Future<List<ConversationEntity>> getAllConversations() async {
    final rows = await database.getAllConversations();
    return rows.map(_conversationFromRow).toList();
  }

  Future<ConversationEntity?> getConversation(String id) async {
    final row = await database.getConversation(id);
    return row != null ? _conversationFromRow(row) : null;
  }

  Future<ConversationEntity> getOrCreateConversation(String id) async {
    var row = await database.getConversation(id);
    if (row == null) {
      final now = DateTime.now();
      await database.upsertConversation(
        ConversationsCompanion.insert(
          id: id,
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );
      row = await database.getConversation(id);
    }
    return _conversationFromRow(row!);
  }

  Future<void> deleteConversation(String id) async {
    await database.deleteConversation(id);
  }

  Future<ConversationEntity?> getMostRecentConversation() async {
    final row = await database.getMostRecentConversation();
    return row != null ? _conversationFromRow(row) : null;
  }

  // ── Messages ──────────────────────────────────────────────

  Future<List<MessageEntity>> getMessages(String conversationId) async {
    final rows = await database.getMessagesForConversation(conversationId);
    return rows.map(_messageFromRow).toList();
  }

  Future<void> insertMessage(MessageEntity entity) async {
    await database.insertMessage(
      MessagesCompanion.insert(
        id: entity.id,
        conversationId: entity.conversationId,
        role: entity.role.name,
        type: Value(entity.type.name),
        content: Value(entity.content),
        status: Value(entity.status.name),
        imagePaths: Value(
          entity.imagePaths.isNotEmpty
              ? jsonEncode(entity.imagePaths)
              : null,
        ),
        createdAt: Value(entity.createdAt),
      ),
    );
  }

  Future<void> updateMessage(MessageEntity entity) async {
    await database.updateMessage(
      MessagesCompanion(
        id: Value(entity.id),
        content: Value(entity.content),
        status: Value(entity.status.name),
        imagePaths: Value(
          entity.imagePaths.isNotEmpty
              ? jsonEncode(entity.imagePaths)
              : null,
        ),
      ),
    );
  }

  Future<void> updateConversationTimestamp(String conversationId) async {
    await database.upsertConversation(
      ConversationsCompanion(
        id: Value(conversationId),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // ── Mappers ───────────────────────────────────────────────

  ConversationEntity _conversationFromRow(Conversation row) {
    return ConversationEntity(
      id: row.id,
      title: row.title,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  MessageEntity _messageFromRow(Message row) {
    List<String> imagePaths = [];
    if (row.imagePaths != null && row.imagePaths!.isNotEmpty) {
      try {
        imagePaths = (jsonDecode(row.imagePaths!) as List)
            .cast<String>();
      } catch (e) {
        logger.error('Failed to decode imagePaths', e);
      }
    }

    return MessageEntity(
      id: row.id,
      conversationId: row.conversationId,
      role: MessageRole.values.byName(row.role),
      type: MessageType.values.byName(row.type),
      content: row.content,
      status: MessageStatus.values.byName(row.status),
      imagePaths: imagePaths,
      createdAt: row.createdAt,
    );
  }
}
