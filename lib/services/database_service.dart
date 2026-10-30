import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class DatabaseService {
  static Database? _database;

  // ============================================================
  // DATABASE
  // ============================================================

  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    late final String path;

    if (kIsWeb) {
      // Use the browser-compatible SQLite implementation.
      databaseFactory = databaseFactoryFfiWeb;
      path = 'fitness_up_web.db';
    } else {
      // Keep the existing native database location.
      final databasePath = await getDatabasesPath();
      path = join(databasePath, 'fitness_up.db');
    }

    return await openDatabase(
      path,

      // Version 7 = Pop message for Profile Setup and Exercise scheduler
      version: 7,

      // ========================================================
      // CREATE DATABASE
      // ========================================================

      onCreate: (db, version) async {
        // ------------------------------------------------------
        // USERS
        // ------------------------------------------------------

        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            age INTEGER,
            height REAL,
            weight REAL,
            activityLevel TEXT,
            goal TEXT,
            focus TEXT
          )
        ''');

        // ------------------------------------------------------
        // WEEKLY PLAN
        // ------------------------------------------------------

        await db.execute('''
          CREATE TABLE weekly_plan (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            day TEXT,
            workout TEXT,
            isRest INTEGER,
            hour INTEGER,
            minute INTEGER,
            sets INTEGER DEFAULT 3,
            reps INTEGER DEFAULT 10
          )
        ''');

        // ------------------------------------------------------
        // WORKOUT HISTORY
        // ------------------------------------------------------

        await db.execute('''
          CREATE TABLE workout_history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT,
            workout TEXT,
            bodyPart TEXT,
            completed INTEGER
          )
        ''');

        // ------------------------------------------------------
        // AI CONVERSATIONS
        //
        // One row = one chat conversation
        // ------------------------------------------------------

        await db.execute('''
          CREATE TABLE ai_conversations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            createdAt TEXT,
            updatedAt TEXT
          )
        ''');

        // ------------------------------------------------------
        // AI MESSAGES
        //
        // One row = one message
        //
        // sender:
        // "user" = user's message
        // "ai"   = Gemini's response
        // ------------------------------------------------------

        await db.execute('''
          CREATE TABLE ai_messages (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            conversationId INTEGER,
            sender TEXT,
            message TEXT,
            createdAt TEXT,
            FOREIGN KEY (conversationId)
              REFERENCES ai_conversations(id)
              ON DELETE CASCADE
          )
        ''');

        // ------------------------------------------------------
        // SETUP STATUS
        // ------------------------------------------------------

        await db.execute('''
          CREATE TABLE setup_status (
            id INTEGER PRIMARY KEY,
            profileCompleted INTEGER NOT NULL DEFAULT 0,
            scheduleCompleted INTEGER NOT NULL DEFAULT 0,
            congratulationsShown INTEGER NOT NULL DEFAULT 0
          )
        ''');

        await db.insert(
          'setup_status',
          {
            'id': 1,
            'profileCompleted': 0,
            'scheduleCompleted': 0,
            'congratulationsShown': 0,
          },
        );


      },

      // ========================================================
      // DATABASE UPGRADES
      // ========================================================

      onUpgrade: (db, oldVersion, newVersion) async {
        // ------------------------------------------------------
        // VERSION 2
        // Add weekly plan
        // ------------------------------------------------------

        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE weekly_plan (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              day TEXT,
              workout TEXT,
              isRest INTEGER,
              hour INTEGER,
              minute INTEGER,
              sets INTEGER DEFAULT 3,
              reps INTEGER DEFAULT 10
            )
          ''');
        }

        // ------------------------------------------------------
        // VERSION 3
        // Add workout history
        // ------------------------------------------------------

        if (oldVersion < 3) {
          await db.execute('''
            CREATE TABLE workout_history (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              date TEXT,
              workout TEXT,
              bodyPart TEXT,
              completed INTEGER
            )
          ''');
        }

        // ------------------------------------------------------
        // VERSION 4
        // Add sets and reps to existing weekly plans
        // ------------------------------------------------------

        if (oldVersion < 4) {
          await db.execute(
            'ALTER TABLE weekly_plan '
            'ADD COLUMN sets INTEGER DEFAULT 3',
          );

          await db.execute(
            'ALTER TABLE weekly_plan '
            'ADD COLUMN reps INTEGER DEFAULT 10',
          );
        }

        // ------------------------------------------------------
        // VERSION 6
        // Add AI conversation memory
        // ------------------------------------------------------

        if (oldVersion < 6) {
          await db.execute('''
            CREATE TABLE ai_conversations (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT,
              createdAt TEXT,
              updatedAt TEXT
            )
          ''');

          await db.execute('''
            CREATE TABLE ai_messages (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              conversationId INTEGER,
              sender TEXT,
              message TEXT,
              createdAt TEXT,
              FOREIGN KEY (conversationId)
                REFERENCES ai_conversations(id)
                ON DELETE CASCADE
            )
          ''');
        }

        // ------------------------------------------------------
        // VERSION 7
        // Add setup status
        // ------------------------------------------------------

        if (oldVersion < 7) {
          await db.execute('''
            CREATE TABLE setup_status (
              id INTEGER PRIMARY KEY,
              profileCompleted INTEGER NOT NULL DEFAULT 0,
              scheduleCompleted INTEGER NOT NULL DEFAULT 0,
              congratulationsShown INTEGER NOT NULL DEFAULT 0
            )
          ''');

          await db.insert(
            'setup_status',
            {
              'id': 1,
              'profileCompleted': 0,
              'scheduleCompleted': 0,
              'congratulationsShown': 0,
            },
          );
        }
      },
    );
  }

  // ============================================================
  // USER PROFILE
  // ============================================================

  static Future<void> saveUser({
    required int age,
    required double height,
    required double weight,
    required String activityLevel,
    required String goal,
    required String focus,
  }) async {
    final db = await database;

    final existingUser = await db.query(
      'users',
      orderBy: 'id DESC',
      limit: 1,
    );

    final userData = {
      'age': age,
      'height': height,
      'weight': weight,
      'activityLevel': activityLevel,
      'goal': goal,
      'focus': focus,
    };

    if (existingUser.isEmpty) {
      await db.insert(
        'users',
        userData,
      );
    } else {
      final userId = existingUser.first['id'];

      await db.update(
        'users',
        userData,
        where: 'id = ?',
        whereArgs: [userId],
      );
    }
    
  await setProfileCompleted(true);
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final db = await database;

    final result = await db.query(
      'users',
      orderBy: 'id DESC',
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return result.first;
  }

  // ============================================================
  // WEEKLY PLAN
  // ============================================================

  static Future<void> saveWeeklyPlan({
    required String day,
    required String workout,
    required bool isRest,
    required int hour,
    required int minute,
  }) async {
    final db = await database;

    final planData = {
      'day': day,
      'workout': workout,
      'isRest': isRest ? 1 : 0,
      'hour': hour,
      'minute': minute,
    };

    await db.insert(
      'weekly_plan',
      planData,
    );
  }

  static Future<List<Map<String, dynamic>>> getWeeklyPlan() async {
    final db = await database;

    return await db.query(
      'weekly_plan',
      orderBy: 'id ASC',
    );
  }

  static Future<void> clearWeeklyPlan() async {
    final db = await database;

    await db.delete('weekly_plan');
  }

    // ============================================================
    // SETUP STATUS
    // ============================================================

    // Get the current setup status.
    static Future<Map<String, dynamic>> getSetupStatus() async {
      final db = await database;

      // Get the current setup status.
      final result = await db.query(
        'setup_status',
        where: 'id = ?',
        whereArgs: [1],
        limit: 1,
      );

      // If setup_status does not exist yet, create it.
      if (result.isEmpty) {
        await db.insert(
          'setup_status',
          {
            'id': 1,
            'profileCompleted': 0,
            'scheduleCompleted': 0,
            'congratulationsShown': 0,
          },
        );
      }

      // Check whether profile data already exists.
      final users = await db.query(
        'users',
        limit: 1,
      );

      // Check whether a weekly schedule already exists.
      final weeklyPlan = await db.query(
        'weekly_plan',
        limit: 1,
      );

      final profileCompleted = users.isNotEmpty ? 1 : 0;
      final scheduleCompleted = weeklyPlan.isNotEmpty ? 1 : 0;

      // Update setup status based on the actual database data.
      await db.update(
        'setup_status',
        {
          'profileCompleted': profileCompleted,
          'scheduleCompleted': scheduleCompleted,
        },
        where: 'id = ?',
        whereArgs: [1],
      );

      final updatedStatus = await db.query(
        'setup_status',
        where: 'id = ?',
        whereArgs: [1],
        limit: 1,
      );

      return updatedStatus.first;
    }

    // Mark profile setup as completed or incomplete.
    static Future<void> setProfileCompleted(
      bool completed,
    ) async {
      final db = await database;

      await db.update(
        'setup_status',
        {
          'profileCompleted': completed ? 1 : 0,
        },
        where: 'id = ?',
        whereArgs: [1],
      );
    }

    // Mark schedule setup as completed or incomplete.
    static Future<void> setScheduleCompleted(
      bool completed,
    ) async {
      final db = await database;

      await db.update(
        'setup_status',
        {
          'scheduleCompleted': completed ? 1 : 0,
        },
        where: 'id = ?',
        whereArgs: [1],
      );
    }

    // Mark the congratulations message as shown or not shown.
    static Future<void> setCongratulationsShown(
      bool shown,
    ) async {
      final db = await database;

      await db.update(
        'setup_status',
        {
          'congratulationsShown': shown ? 1 : 0,
        },
        where: 'id = ?',
        whereArgs: [1],
      );
    }

  // ============================================================
  // WORKOUT HISTORY
  // ============================================================

  static Future<void> saveWorkoutHistory({
    required String date,
    required String workout,
    required String bodyPart,
    required bool completed,
  }) async {
    final db = await database;

    await db.insert(
      'workout_history',
      {
        'date': date,
        'workout': workout,
        'bodyPart': bodyPart,
        'completed': completed ? 1 : 0,
      },
    );
  }

  static Future<List<Map<String, dynamic>>> getWorkoutHistory() async {
    final db = await database;

    return await db.query(
      'workout_history',
      orderBy: 'date DESC',
    );
  }

  static Future<void> clearWorkoutHistory() async {
    final db = await database;

    await db.delete('workout_history');
  }

  // ============================================================
  // AI CONVERSATIONS
  // ============================================================

  // Create a new AI conversation.
  //
  // Returns the ID of the new conversation.
  static Future<int> createAIConversation({
    String title = 'New Conversation',
  }) async {
    final db = await database;

    final now = DateTime.now().toIso8601String();

    return await db.insert(
      'ai_conversations',
      {
        'title': title,
        'createdAt': now,
        'updatedAt': now,
      },
    );
  }

  // Get all AI conversations.
  //
  // Newest conversations appear first.
  static Future<List<Map<String, dynamic>>>
      getAIConversations() async {
    final db = await database;

    return await db.query(
      'ai_conversations',
      orderBy: 'updatedAt DESC',
    );
  }

  // Get one specific conversation.
  static Future<Map<String, dynamic>?> getAIConversation(
    int conversationId,
  ) async {
    final db = await database;

    final result = await db.query(
      'ai_conversations',
      where: 'id = ?',
      whereArgs: [conversationId],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return result.first;
  }

  // Update conversation title.
  static Future<void> updateAIConversationTitle({
    required int conversationId,
    required String title,
  }) async {
    final db = await database;

    await db.update(
      'ai_conversations',
      {
        'title': title,
        'updatedAt': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [conversationId],
    );
  }

  // Update the last-used time of a conversation.
  static Future<void> updateAIConversationTime(
    int conversationId,
  ) async {
    final db = await database;

    await db.update(
      'ai_conversations',
      {
        'updatedAt': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [conversationId],
    );
  }

  // ============================================================
  // AI MESSAGES
  // ============================================================

  // Save a user or AI message.
  static Future<int> saveAIMessage({
    required int conversationId,
    required String sender,
    required String message,
  }) async {
    final db = await database;

    final messageId = await db.insert(
      'ai_messages',
      {
        'conversationId': conversationId,
        'sender': sender,
        'message': message,
        'createdAt': DateTime.now().toIso8601String(),
      },
    );

    // Update the conversation's last-used time.
    await updateAIConversationTime(
      conversationId,
    );

    return messageId;
  }

  // Get all messages from one conversation.
  static Future<List<Map<String, dynamic>>>
      getAIMessages(
    int conversationId,
  ) async {
    final db = await database;

    return await db.query(
      'ai_messages',
      where: 'conversationId = ?',
      whereArgs: [conversationId],
      orderBy: 'id ASC',
    );
  }

  // Delete one conversation and its messages.
  static Future<void> deleteAIConversation(
    int conversationId,
  ) async {
    final db = await database;

    await db.delete(
      'ai_messages',
      where: 'conversationId = ?',
      whereArgs: [conversationId],
    );

    await db.delete(
      'ai_conversations',
      where: 'id = ?',
      whereArgs: [conversationId],
    );
  }

  // Delete all AI conversations.
  static Future<void> clearAIConversations() async {
    final db = await database;

    await db.delete('ai_messages');
    await db.delete('ai_conversations');
  }
}