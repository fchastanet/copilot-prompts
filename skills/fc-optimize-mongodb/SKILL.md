---
name: fc-optimize-mongodb
description: Analyze the MongoDB usage in these repositories, identify all the CRUD queries that are made to MongoDB in both projects, and propose optimizations.
---
# MongoDB Usage Analysis & Optimization Proposal

As a Senior specialist of documentDB and MongoDB optimization, you have been tasked to analyze the MongoDB usage in the API and its Kafka Consumer. Your goal is to identify all the CRUD queries that are made to MongoDB in both projects, and propose optimizations.

## 🚀 Phased Execution Strategy

**This skill uses automatic checkpointing with session memory** to handle the heavy analysis workload without timeouts.

### Execution Workflow

The analysis is broken into **4 independent phases** (3-5 minutes each). Each phase:

- ✅ Checks for previous phase data in session memory
- 📊 Processes its specific scope
- 💾 Saves results to `/memories/session/mongodb-analysis-{phase}.json`
- 📝 Shows a summary of findings
- ➡️ Indicates next phase to run

**How to use:**

1. Run: `@workspace /fc-optimize-mongodb` (or with `phase=1`)
2. Review phase summary
3. Continue: `@workspace /fc-optimize-mongodb phase=2`
4. Repeat until Phase 4 generates the final report

**Recovery:** If interrupted, just restart from the last completed phase. All previous work is preserved in session memory.

### Phase Breakdown

1. Discovery & Inventory
   Duration: 2-3 min
   Focus: Repository metadata, collections, query inventory
   Output: `mongodb-analysis-phase1.json`
2. Index Coverage
   Duration: 2-3 min
   Focus: Map queries to indexes, identify gaps
   Output: `mongodb-analysis-phase2.json`
3. Optimization Analysis
   Duration: 2-3 min
   Focus: Partial indexes, compound usage, recommendations
   Output: `mongodb-analysis-phase3.json`
4. Report Generation
   Duration: 1-2 min
   Focus: Final markdown report + PlantUML diagrams
   Output: `mongodbAnalysis.md` + `.puml` files

## Scope and Source of Truth

**CRITICAL** Analyse all the files **ONLY** in the directories `api_python` and `kafka-consumer`.
But ignore files in `api_python/admin/database/migrations/`.

These 2 projects are separated but they use the same MongoDB database but with different beanie models definitions.
`api_python` is the project that is responsible for the database schema and migrations. While `kafka-consumer` is responsible for consuming the Kafka events and updating the MongoDB collections accordingly. So consider api_python as source of truth.

You will analyse current mongodb schema (api_python/admin/database/indexes/definition.py, api_python/odm/models.py).

**CRITICAL** Don't update source code, just analyze and generate intermediate results in `/memories/session/` and final report in `docs/ai/{date:YYYY-mm-dd}-mongodbAnalysis/mongodbAnalysis.md`.
**CRITICAL** Don't invent any query, just list the queries accurately as they are in the codebase.

## Pre-Analysis Checks (Phase 1 only)

- If folder `kafka-consumer` doesn't exist, use askQuestions to propose creating symlink
- Use askQuestions to ask if user has updated branches before starting

## 📋 Phase 1: Discovery & Inventory (2-3 min)

### Objectives

1. Capture repository metadata (branch, commit hash)
2. Load collection inventory from index definitions
3. Build complete query inventory from both projects
4. Identify obsolete collections (collections with indexes but no queries)

### Actions

- Read `api_python/admin/database/indexes/definition.py` for collection list
- Read `api_python/odm/models.py` for schema
- Parallel grep search for all Beanie queries in both projects:
  - `\.(find|find_one|aggregate|update_many|delete|insert_many|save|replace_one)\(`
- Cross-reference: collections WITHOUT any queries = obsolete candidates

### Output Format (save to `/memories/session/mongodb-analysis-phase1.json`)

```json
{
  "metadata": {
    "date": "YYYY-MM-DD",
    "api_python": {"branch": "...", "commit": "..."},
    "kafka_consumer": {"branch": "...", "commit": "..."}
  },
  "collections": {
    "music": {"has_indexes": true, "query_count": 15, "obsolete": false},
    "music_preference": {"has_indexes": true, "query_count": 0, "obsolete": true}
  },
  "queries": [
    {
      "collection": "music",
      "file": "api_python/routers/user_music_preferences.py",
      "line": 27,
      "type": "find",
      "code": "await Music.find(In(Music.id, unique_music_ids)).count()"
    }
  ],
  "summary": {
    "total_collections": 10,
    "collections_with_queries": 7,
    "obsolete_collections": 3,
    "total_queries": 65
  }
}
```

### Phase 1: Summary Output

Display to user:

- ✅ Phase 1 Complete
- 📊 Collections analyzed: X
- 🗑️ Obsolete collections found: Y (list names)
- 🔍 Queries inventoried: Z
- 💾 Data saved to: `/memories/session/mongodb-analysis-phase1.json`
- ➡️ Next: Run `@workspace /fc-optimize-mongodb phase=2` for index coverage analysis

---

## 🎯 Phase 2: Index Coverage Analysis (2-3 min)

### Phase 2: Prerequisites

- Requires `/memories/session/mongodb-analysis-phase1.json`
- If missing, prompt: "Please run Phase 1 first: `@workspace /fc-optimize-mongodb phase=1`"

### Phase 2: Objectives

1. Map each query to its index coverage
2. Identify missing indexes (🔴 CRITICAL)
3. Flag compound index prefix usage (🪛 TO CHECK)
4. Check timestamp field consistency

### Phase 2: Actions

- Load Phase 1 data
- For each query, determine index coverage:
  - ✅ **Full**: Query fields exactly match an index
  - 🪛 **TO CHECK**: Using first field of compound index (may be OK)
  - 🔴 **Missing**: No index covers query fields
- Check all collections for `created_at` and `updated_at` fields

### Output Format (save to `/memories/session/mongodb-analysis-phase2.json`)

```json
{
  "coverage": [
    {
      "query_id": "music_find_by_ids",
      "collection": "music",
      "fields_used": ["id"],
      "index_used": "name_unique_idx",
      "status": "🪛 TO CHECK",
      "reason": "Using _id field, default index should work",
      "recommendation": "Verify with explain() in production"
    },
    {
      "query_id": "pending_reco_by_music_id",
      "collection": "pending_user_recommendation",
      "fields_used": ["music_urn"],
      "index_used": "music_urn_idx",
      "status": "✅ Full",
      "reason": "Exact index match"
    }
  ],
  "missing_indexes": [
    {
      "collection": "pending_user_recommendation",
      "query": "PendingUserRecommendation.find({music_urn: urn}).update_many()",
      "fields": ["music_urn"],
      "severity": "🔴 CRITICAL",
      "reason": "Kafka consumer update_many without index"
    }
  ],
  "schema_issues": [
    {
      "collection": "music",
      "issue": "missing_timestamps",
      "missing_fields": ["created_at", "updated_at"],
      "severity": "🔥 HIGH"
    }
  ],
  "summary": {
    "full_coverage": 45,
    "to_check": 12,
    "missing_index": 8,
    "schema_issues": 2
  }
}
```

### Phase 2: Summary Output

Display to user:

- ✅ Phase 2 Complete
- ✅ Full coverage: X queries
- 🪛 To verify: Y queries
- 🔴 Missing indexes: Z queries (CRITICAL)
- ⚠️ Schema issues: N collections
- 💾 Data saved to: `/memories/session/mongodb-analysis-phase2.json`
- ➡️ Next: Run `@workspace /fc-optimize-mongodb phase=3` for optimization analysis

---

## 🔧 Phase 3: Index Optimization Analysis (2-3 min)

### Phase 3: Prerequisites

- Requires Phase 1 + Phase 2 data
- If missing, prompt to run previous phases

### Phase 3: Objectives

1. Analyze partial index opportunities (instrument fields)
2. Identify covered query optimizations
3. Generate index recommendations with code snippets
4. Compare Kafka consumer vs api_python models

### Phase 3: Actions

- Load Phase 1 + 2 data
- Check for sparse indexes on large array fields (instrument, instrument_structure)
- Analyze query projections for covered query opportunities
- Compare model definitions between projects
- Generate Python + mongosh code for each recommendation

### Output Format (save to `/memories/session/mongodb-analysis-phase3.json`)

```json
{
  "optimizations": [
    {
      "type": "partial_index_for_instrument",
      "collection": "music",
      "current": {
        "code": "{\"keys\": [(\"instrument\", 1)], \"sparse\": True}",
        "issue": "Indexing entire 1536-dimensional instrument for existence check"
      },
      "proposed": {
        "python": "python code here",
        "mongosh": "mongosh code here",
        "benefit": "90% index size reduction, same query performance"
      },
      "priority": "📀 OPTIMIZATION",
      "migration": "Can be done online, no downtime"
    }
  ],
  "kafka_consumer_drift": [
    {
      "collection": "playlist",
      "api_python_fields": ["field1", "field2", "created_at"],
      "kafka_consumer_fields": ["field1", "field2"],
      "missing_in_kafka": ["created_at"],
      "severity": "🔥 HIGH",
      "recommendation": "Create shared models package"
    }
  ],
  "covered_queries": [
    {
      "query": "UserRecommendation.find(...).project(music_urn, score)",
      "current_index": ["user_urn", "is_recommendable", "score"],
      "add_to_index": ["music_urn"],
      "benefit": "Index-only scan, no document fetch"
    }
  ],
  "summary": {
    "partial_index_opportunities": 2,
    "covered_query_opportunities": 3,
    "kafka_drift_issues": 4
  }
}
```

### Phase 3: Summary Output

Display to user:

- ✅ Phase 3 Complete
- 📀 Optimization opportunities: X
- 🔥 Kafka drift issues: Y (HIGH priority)
- 💡 Potential index size reduction: Z%
- 💾 Data saved to: `/memories/session/mongodb-analysis-phase3.json`
- ➡️ Next: Run `@workspace /fc-optimize-mongodb phase=4` to generate final report

---

## 📄 Phase 4: Report Generation (1-2 min)

### Phase 4: Prerequisites

- Requires Phase 1 + 2 + 3 data
- If missing, prompt to run previous phases

### Phase 4: Objectives

1. Consolidate all findings into comprehensive markdown report
2. Generate PlantUML diagrams (current + proposed schema)
3. Create production verification checklist with explain() queries
4. Provide prioritized recommendations

### Phase 4: Actions

- Load all phase data
- Generate `docs/ai/{date:YYYY-mm-dd}-mongodbAnalysis/mongodbAnalysis.md`
- Generate `mongodbCurrentSchema.puml` (exclude obsolete collections)
- Generate `mongodbProposedSchema.puml` (with recommendations)
- Create explain() queries for all 🪛 TO CHECK items

### Report Structure

1. **Executive Summary**
   - Analysis date and scope
   - Key metrics (collections, queries, findings)
   - Top 3 critical recommendations
   - Obsolete collections to remove

2. **Repository Information**
   - Branch and commit hashes
   - Analysis scope and exclusions

3. **Collection Inventory**
   - Active collections (with query count)
   - Obsolete collections (mark for removal)

4. **Query Analysis by Collection**
   - All queries with file/line references
   - Beanie syntax + equivalent mongosh
   - Index coverage status

5. **Critical Findings**
   - 🔴 Missing indexes (with impact analysis)
   - 🔥 Schema inconsistencies
   - ⚠️ Queries to verify

6. **Index Optimization Opportunities**
   - Partial index recommendations (with code)
   - Covered query opportunities
   - Redundant index identification

7. **Kafka Consumer Drift**
   - Model inconsistencies
   - HIGH priority architectural recommendation
   - Migration strategy

8. **Production Verification Checklist**
   - explain() queries for all 🪛 TO CHECK items
   - Expected metrics (execution time, docs examined)
   - Monitoring recommendations

9. **Appendices**
   - Complete index definitions
   - Query patterns reference
   - Priority matrix

### Phase 4: Summary Output

Display to user:

- ✅ Phase 4 Complete - Analysis finished!
- 📄 Report generated: `docs/ai/{date}/mongodbAnalysis.md`
- 🎨 Diagrams generated: `mongodbCurrentSchema.puml`, `mongodbProposedSchema.puml`
- 🔥 Critical issues: X
- 📀 Optimization opportunities: Y
- 🧹 Session memory can be cleared

---

## Analysis Checklist (Reference for All Phases)

When you will have the full view, ensure these analyses are covered:

### 1. Repository Metadata

- Indicate branch name and commit hash of each repository

### 2. Query Inventory

For each query found:

- File location and line number
- Beanie query syntax as written in code
- Equivalent MongoDB shell query (mongosh)
- Index coverage status (✅ Full, ⚠️ Partial, 🔴 Missing, 🪛 TO CHECK)

### 3. Obsolete Collection Detection

**CRITICAL** Cross-reference collections:

- List all collections from `api_python/admin/database/indexes/definition.py`
- List all collections with queries found in codebase
- **IDENTIFY OBSOLETE**: Collections with index definitions but NO queries found
- Mark obsolete collections: `genre_musics`, `trackings`, `import_stack`, `music_listened_logs` (if no queries found)
- Recommend removal or archival of obsolete collections

### 4. Schema Consistency Checks

#### 4.1 Timestamp Consistency

**CRITICAL** Check ALL collections for audit fields:

- `created_at` - MUST be present on all collections
- `updated_at` - MUST be present on all collections
- Flag collections missing these fields (e.g., `music`, `playlist`)
- **Rationale**: Essential for debugging, data lineage, and Kafka event correlation

### 5. Index Analysis

#### 5.1 Index Coverage

- List all indexes currently defined
- Check if all required indexes are present
- Propose missing indexes with code snippets
- Propose indexes that should be removed (unused)
- index that are redundant or could be replaced by a lighter index (e.g., partial indexes for instrument existence checks)

#### 5.2 Index Optimization Patterns

**CRITICAL** Analyze for these specific optimizations but do **not** limit to them:

**Pattern A: Partial Index for Array/instrument Existence Checks**

- **Look for**: Sparse indexes on large array fields (e.g., `instrument`, `instrument_structure`)
- **Issue**: Indexing entire instrument array when only checking existence
- **Solution**: Replace with partial index on `_id` with filter expression

```python
# BEFORE (inefficient):
{"keys": [("instrument_structure", pymongo.ASCENDING)], "sparse": True}

# AFTER (optimized):
{"keys": [("_id", pymongo.ASCENDING)],
 "partialFilterExpression": {"instrument_structure": {"$exists": True}},
 "name": "instrument_structure_exists_partial_idx"}
```

**Pattern B: Single-Field Queries on Compound Index**

- **Look for**: Queries using only first field of compound index
- **Flag as**: 🪛 TO CHECK - may be suboptimal, needs production explain()
- **Example**: `music_urn` query using `music_urn_instance_urn_unique_idx`
- **Action**: Recommend production testing with explain() to verify efficiency

**Pattern C: Covered Query Opportunities**

- **Analyze**: Query projections vs index fields
- **Look for**: Queries projecting only indexed fields
- **Optimization**: 📀 Add projected fields to index for index-only scans
- **Example**:

```python
# Query projects: music_urn, score
# Index: user_urn, playlist_is_recommendable, score
# Optimization: Add music_urn to index for covered query
```

#### 5.3 Index Type Optimization

Indicate when an index could be replaced by a lighter index:

- Compound Indexes (field order matters - ESR rule: Equality, Sort, Range)
- Partial Indexes (instead of sparse for complex filters)
- Sparse Indexes (for optional fields)
- Partial indexes with filter expressions (instead of indexing large arrays)
- TTL Indexes (for automatic expiration)

#### 5.4 Index Report format

For each index change suggestion, provide:

- Current index definition
- Proposed index definition
- Rationale for change
- Migration approach (if needed)
- beanies code snippet
- mongosh code snippet
- Production verification query (explain())

### 6. Query Optimization

- Propose optimizations to the queries themselves
- Check for N+1 query patterns
- Suggest batch operations where applicable
- Recommend aggregation pipeline improvements

### 7. Production Verification Strategy

**CRITICAL** For each optimization recommendation, categorize:

**🔴 CRITICAL** - Full collection scan, missing index, immediate fix
**⚠️ PARTIAL** - Using compound index prefix, may be acceptable
**🪛 TO CHECK** - Needs production explain() verification before deciding

For each 🪛 TO CHECK item, provide exact explain() query:

```javascript
// Example for music_urn single-field query
db.musics_instances.find({
  music_urn: "urn:music:xyz123"
}).explain("executionStats")

// Check for:
// - totalDocsExamined vs nReturned ratio
// - executionTimeMillis < 100ms threshold
// - indexName used by query planner
```

### 8. Schema Improvements

Check for:

- Data type consistency across collections
- Denormalization opportunities (or over-denormalization issues)
- Field naming consistency
- **Missing timestamps** (created_at, updated_at)
- **Missing tracing fields** (correlation_id)
- Proper use of DBRef vs embedded documents

### 9. Kafka Consumer Inconsistencies

**CRITICAL** Compare models:

- List all fields in api_python models
- List all fields in kafka-consumer models
- **Identify inconsistent fields** in kafka-consumer
- **Recommendation strength**: HIGH (not medium) - suggest architectural solution:
  - **Option 1**: Merge kafka-consumer into api_python monorepo
  - **Option 2**: Create shared `models` package
  - **Option 3**: Generate kafka-consumer models from api_python
- **Rationale**: Schema drift is a critical risk for data integrity

### 11. Report Structure

Generate report with:

- **Executive Summary** at the start with:
  - Date of analysis
  - Key metrics (collections, indexes, queries analyzed)
  - Critical findings count by severity
  - Top 3 recommendations
  - Obsolete collections identified
- **Table of Contents**
- **Repository Information** (branch, commit)
- **Collections and Models** (from api_python)
- **Current Index Definitions** (complete list)
- **Query Analysis by Collection**
- **Obsolete Collections Section**
- **Schema Consistency Issues** (timestamps, correlation_id)
- **Index Coverage Summary**
- **Index Optimization Opportunities** (partial indexes, covered queries)
- **Kafka Consumer Inconsistencies** (with HIGH priority architectural recommendation)
- **Production Verification Checklist** (🪛 TO CHECK items with explain() queries)
- **Recommendations** prioritized (CRITICAL, HIGH, MEDIUM, LOW)
- **Production Query Analysis** (explain() examples for critical queries)
- **Appendices** (index definitions, query patterns)

### 12. PlantUML Diagrams

Generate two diagrams:

- `docs/ai/{date:YYYY-mm-dd}-mongodbAnalysis/mongodbCurrentSchema.puml` - **Exclude obsolete collections**
- `docs/ai/{date:YYYY-mm-dd}-mongodbAnalysis/mongodbProposedSchema.puml` - With recommended changes

### 13. Code Snippets

For each suggestion, provide:

- Current code/index definition
- Proposed code/index definition
- Migration approach (if needed)
- Production verification query (explain())

### 14. Consider These Specific Patterns

**instrument/Array Field Indexing:**

- Check `music.instrument` and `music.instrument_structure` indexing
- Recommend partial indexes over sparse indexes for existence checks

**Compound Index Effectiveness:**

- Verify queries using only first field of compound index
- Flag as 🪛 TO CHECK for production verification

**Delete Operations:**

- Check if delete queries on compound index prefix need dedicated index
- Example: `user_musics_id` deletes using compound unique index

**Update Many Operations:**

- Ensure indexed fields for Kafka Consumer update_many operations
- Example: `music_urn` updates in recommendation collections

**Projection Analysis:**

- Cross-reference query `.project()` calls with index fields
- Identify covered query opportunities

## Priority Matrix

Use this matrix to prioritize findings:

| Severity | Criteria | Action | Example |
|----------|----------|--------|---------|

- 🔴 **CRITICAL**
  Criteria: Full collection scan on frequent operation, missing index on high-volume update/delete
  Action: Immediate fix required
  Example: Missing `music_urn` index on Kafka update_many
- 🔥 **HIGH**
  Criteria: Schema inconsistency, race conditions, data integrity risk
  Action: Fix within sprint
  Example: Kafka consumer model drift missing `created_at`
- ⚠️ **MEDIUM**
  Criteria: Using compound index prefix, suboptimal but functional
  Action: Optimize if bottleneck
  Example: Single-field query on compound index
- 📀 **OPTIMIZATION**
  Criteria: Recommended optimization
  Action: Optimize if bottleneck
  Example: Index projection improvement
- 🪛 **TO CHECK**
  Criteria: Assumption needs production verification
  Action: Test with explain()
  Example: Compound index effectiveness
- ℹ️ **LOW**
  Criteria: Collection scan on infrequent admin task
  Action: Monitor, fix if becomes issue
  Example: Translation count query
- 🗑️ **OBSOLETE**
  Criteria: Unused collection or index
  Action: Safe to remove
  Example: Collection with no queries

## Anti-Patterns to Avoid

**DO NOT:**

- ❌ Assume compound index prefix is always suboptimal (flag as 🪛 TO CHECK instead)
- ❌ Recommend indexes for one-time migration queries
- ❌ Suggest indexes for infrequent admin tasks (collection scan acceptable)
- ❌ Mark as "missing index" without checking if query is actually used
- ❌ Accept sparse index on large arrays without considering partial index alternative
- ❌ Ignore collections just because they seem unused (verify with query count)
- ❌ Provide generic recommendations (always include specific code snippets)
- ❌ Skip production verification for assumptions (always provide explain() queries)

**DO:**

- ✅ Cross-reference every collection against actual query usage
- ✅ Verify timestamp and correlation_id consistency
- ✅ Flag single-field queries on compound indexes as 🪛 TO CHECK
- ✅ Analyze instrument/array indexing for partial index opportunities
- ✅ Provide exact explain() queries for production verification

## Success Criteria

A complete analysis MUST include:

**Coverage Metrics:**

- [ ] Total collections analyzed
- [ ] Collections with queries found
- [ ] Collections with NO queries (obsolete candidates)
- [ ] Total queries inventoried
- [ ] Queries with full index coverage
- [ ] Queries with partial coverage (🪛 TO CHECK)
- [ ] Queries missing indexes (🔴 CRITICAL)

**Schema Validation:**

- [ ] All collections checked for `created_at` and `updated_at`
- [ ] Kafka-updated collections checked for `correlation_id` recommendation
- [ ] Model consistency verified between api_python and kafka-consumer
- [ ] Field existence or nested field indexing analyzed for partial index opportunities

**Optimization Opportunities:**

- [ ] At least 3 specific 🪛 TO CHECK items with explain() queries
- [ ] All 🔴 CRITICAL missing indexes identified with code snippets
- [ ] Obsolete collections identified with removal recommendation
- [ ] Covered query opportunities analyzed for top queries

**Production Readiness:**

- [ ] Exact explain() queries for all 🪛 TO CHECK items
- [ ] Migration approach for schema changes (timestamps, correlation_id)
- [ ] Rollback plan considerations mentioned
- [ ] Monitoring recommendations (CloudWatch, slow query logs)

## 🎮 Execution Logic

### Phase Detection

1. Check user request for explicit phase: `phase=1`, `phase=2`, etc.
2. If no phase specified, default to phase=1
3. Before each phase, check for prerequisite session files
4. If prerequisites missing, show helpful error with command to run

### Session Memory Management

Location: /memories/session/mongodb-analysis-phase{N}.json

Files created:

- mongodb-analysis-phase1.json (Discovery & Inventory)
- mongodb-analysis-phase2.json (Index Coverage)
- mongodb-analysis-phase3.json (Optimization Analysis)

Cleanup: After Phase 4 completes, suggest user can delete session files

### Error Handling

If interrupted during a phase:

1. Session file for that phase will be incomplete/missing
2. User can restart same phase - it will rebuild
3. Previous phases' data remains intact
4. No data loss, just time cost of re-running that phase

## Processing Workflow

**Follow this systematic approach :**

**CRITICAL** Group phase 1 and phase 2 and then phase 3 and phase 4 together.

### For Each Phase Execution

1. **Phase Validation**
   - Determine which phase to run (from user input or default to 1)
   - Check for prerequisite phase data in /memories/session/
   - If missing prerequisites, show error + command to run

2. **Data Loading**
   - Load all prerequisite phase data from session memory
   - Validate JSON structure and completeness
   - Show brief recap of loaded data

3. **Phase Execution**
   - Execute phase-specific analysis (see phase details above)
   - Show progress indicators for long operations
   - Build phase output data structure

4. **Data Persistence**
   - Save phase results to `/memories/session/mongodb-analysis-phase{N}.json`
   - Validate saved data is complete
   - Show data save confirmation

5. **Summary Display**
   - Show phase completion message
   - Display key metrics and findings
   - If phase 1 or phase 3
     - continue yourself with phase 2 without asking the user to run the command
   - Else
     - Indicate next phase command if any

### Quick Validation Checklist (Before Phase 4 Report)

- [ ] Phase 1: Did I identify obsolete collections?
- [ ] Phase 2: Did I check timestamp consistency?
- [ ] Phase 2: Did I flag compound index assumptions as 🪛 TO CHECK?
- [ ] Phase 3: Did I analyze instrument field indexing for partial indexes?
- [ ] Phase 3: Did I compare Kafka vs api_python models?
- [ ] Phase 4: Did I provide explain() queries for all 🪛 TO CHECK items?

### Performance Guidelines

- Use parallel file reads when possible
- Batch grep searches (don't search file-by-file)
- Keep session JSON files < 500KB each
- Limit query inventory to actual code (skip test/migration files)
- Focus on critical indexes (skip one-time admin queries)
