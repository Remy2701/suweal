import gleam/float
import gleam/list
import gleam/option.{type Option}
import gleam/pair
import gleam/string
import omcg/module
import suweal/surreal_ql
import suweal/surreal_type.{type SurrealType}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                        Order Direction                                        //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub type OrderDirection {
  Ascending
  Descending
}

/// Converts an [OrderDirection] into its [String] representation in SurrealQL.
pub fn order_direction_to_string(direction: OrderDirection) -> String {
  case direction {
    Ascending -> "ASC"
    Descending -> "DESC"
  }
}

/// Converts an [OrderDirection] into a module for code generation.
pub fn order_direction_to_module(direction: OrderDirection) -> module.Module {
  module.identifier.create("node")
  |> module.binop.access(
    module.identifier.create(case direction {
      Ascending -> "Ascending"
      Descending -> "Descending"
    }),
  )
  |> module.add_import(["suweal", "node"])
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                           Operator                                            //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub type Operator {
  Equal
  NotEqual
  GreaterThan
  LessThan
  GreaterThanOrEqual
  LessThanOrEqual
  Access
  NamespaceAccess
  Inside
  RelationTo
  RelationFrom
  RelationToFrom
  Indexing
  And
  Or
}

/// Converts an [Operator] into its [String] representation in SurrealQL.
pub fn operator_to_string(operator: Operator) -> String {
  case operator {
    Equal -> " = "
    NotEqual -> " != "
    GreaterThan -> " > "
    LessThan -> " < "
    GreaterThanOrEqual -> " >= "
    LessThanOrEqual -> " <= "
    Access -> "."
    NamespaceAccess -> "::"
    Inside -> " INSIDE "
    RelationTo -> "->"
    RelationFrom -> "<-"
    RelationToFrom -> "<->"
    Indexing -> "["
    And -> " AND "
    Or -> " OR "
  }
}

/// Converts an [Operator] into a module for code generation.
pub fn operator_to_module(operator: Operator) -> module.Module {
  module.identifier.create("node")
  |> module.binop.access(
    module.identifier.create(case operator {
      Equal -> "Equal"
      NotEqual -> "NotEqual"
      GreaterThan -> "GreaterThan"
      LessThan -> "LessThan"
      GreaterThanOrEqual -> "GreaterThanOrEqual"
      LessThanOrEqual -> "LessThanOrEqual"
      Access -> "Access"
      NamespaceAccess -> "NamespaceAccess"
      Inside -> "Inside"
      RelationTo -> "RelationTo"
      RelationFrom -> "RelationFrom"
      RelationToFrom -> "RelationToFrom"
      Indexing -> "Indexing"
      And -> "And"
      Or -> "Or"
    }),
  )
  |> module.add_import(["suweal", "node"])
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                         Select Field                                          //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

/// Represents a field in a SELECT statement in SurrealQL.
pub type SelectField {
  SelectField(field: Node, alias: Option(String), value: Bool)
}

pub fn select_field_to_string(field: SelectField) -> String {
  case field.value {
    True -> "VALUE "
    False -> ""
  }
  <> to_string(field.field)
  <> case field.alias {
    option.Some(alias) -> " AS " <> alias
    option.None -> ""
  }
}

pub fn select_field_to_module(field: SelectField) -> module.Module {
  module.binop.access(
    module.identifier.create("node"),
    module.identifier.create("SelectField"),
  )
  |> module.function_call.create()
  |> module.function_call.add_with_alias("field", to_module(field.field))
  |> module.function_call.add_with_alias(
    "alias",
    option_of(field.alias, module.literal.string),
  )
  |> module.function_call.add_with_alias(
    "value",
    module.literal.bool(field.value),
  )
  |> module.add_import(["suweal", "node"])
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                          Schema Type                                          //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

/// The type of schema of a table in SurrealDB.
pub type SchemaType {
  Schemafull
  Schemaless
}

/// Converts a [SchemaType] into its [String] representation in SurrealQL.
pub fn schema_type_to_string(schema_type: SchemaType) -> String {
  case schema_type {
    Schemafull -> "SCHEMAFULL"
    Schemaless -> "SCHEMALESS"
  }
}

/// Converts a [SchemaType] into a module for code generation.
pub fn schema_type_to_module(schema_type: SchemaType) -> module.Module {
  module.identifier.create("node")
  |> module.binop.access(
    module.identifier.create(case schema_type {
      Schemafull -> "Schemafull"
      Schemaless -> "Schemaless"
    }),
  )
  |> module.add_import(["suweal", "node"])
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                          Table Type                                           //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub type TableType {
  NormalTable
  RelationTable(in: String, out: String)
}

pub fn table_type_to_string(table_type: TableType) -> String {
  case table_type {
    NormalTable -> "NORMAL"
    RelationTable(in:, out:) -> "RELATION IN " <> in <> " OUT " <> out
  }
}

pub fn table_type_to_module(table_type: TableType) -> module.Module {
  case table_type {
    NormalTable ->
      module.identifier.create("node")
      |> module.binop.access(module.identifier.create("NormalTable"))
    RelationTable(in:, out:) ->
      module.identifier.create("node")
      |> module.binop.access(module.identifier.create("RelationTable"))
      |> module.function_call.create()
      |> module.function_call.add_with_alias("in", module.literal.string(in))
      |> module.function_call.add_with_alias("out", module.literal.string(out))
  }
  |> module.add_import(["suweal", "node"])
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                        Operation Type                                         //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub type OperationType {
  OperationCreate
  OperationSelect
  OperationUpdate
  OperationDelete
}

pub fn operation_type_to_string(operation_type: OperationType) -> String {
  case operation_type {
    OperationCreate -> "create"
    OperationSelect -> "select"
    OperationUpdate -> "update"
    OperationDelete -> "delete"
  }
}

pub fn operation_type_to_module(
  operation_type: OperationType,
) -> module.Module {
  case operation_type {
    OperationCreate ->
      module.identifier.create("node")
      |> module.binop.access(module.identifier.create("OperationCreate"))
    OperationSelect ->
      module.identifier.create("node")
      |> module.binop.access(module.identifier.create("OperationSelect"))
    OperationUpdate ->
      module.identifier.create("node")
      |> module.binop.access(module.identifier.create("OperationUpdate"))
    OperationDelete ->
      module.identifier.create("node")
      |> module.binop.access(module.identifier.create("OperationDelete"))
  }
  |> module.add_import(["suweal", "node"])
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                          Permission                                           //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub type Permission {
  PermissionFull
  PermissionNone
  PermissionForFull(targets: List(OperationType))
  PermissionForNone(targets: List(OperationType))
  PermissionForWhere(targets: List(OperationType), expression: Node)
}

pub fn permission_to_string(permission: Permission) -> String {
  case permission {
    PermissionFull -> "FULL"
    PermissionNone -> "NONE"
    PermissionForNone(targets:) ->
      "FOR "
      <> string.join(list.map(targets, operation_type_to_string), ", ")
      <> " NONE"
    PermissionForFull(targets:) ->
      "FOR "
      <> string.join(list.map(targets, operation_type_to_string), ", ")
      <> " FULL"
    PermissionForWhere(targets:, expression:) ->
      "FOR "
      <> string.join(list.map(targets, operation_type_to_string), ", ")
      <> " WHERE "
      <> to_string(expression)
  }
}

pub fn permission_to_module(permission: Permission) -> module.Module {
  case permission {
    PermissionFull ->
      module.identifier.create("node")
      |> module.binop.access(module.identifier.create("PermissionFull"))
    PermissionNone ->
      module.identifier.create("node")
      |> module.binop.access(module.identifier.create("PermissionNone"))
    PermissionForNone(targets:) ->
      module.identifier.create("node")
      |> module.binop.access(module.identifier.create("PermissionForNone"))
      |> module.function_call.create()
      |> module.function_call.add_with_alias(
        "targets",
        module.literal.list(list.map(targets, operation_type_to_module)),
      )
    PermissionForFull(targets:) ->
      module.identifier.create("node")
      |> module.binop.access(module.identifier.create("PermissionForFull"))
      |> module.function_call.create()
      |> module.function_call.add_with_alias(
        "targets",
        module.literal.list(list.map(targets, operation_type_to_module)),
      )
    PermissionForWhere(targets:, expression:) ->
      module.identifier.create("node")
      |> module.binop.access(module.identifier.create("PermissionForWhere"))
      |> module.function_call.create()
      |> module.function_call.add_with_alias(
        "targets",
        module.literal.list(list.map(targets, operation_type_to_module)),
      )
      |> module.function_call.add_with_alias(
        "expression",
        to_module(expression),
      )
  }
  |> module.add_import(["suweal", "node"])
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                     Define Field Strategy                                     //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub type DefineFieldStrategy {
  DefineFieldIfNotExists
  DefineFieldOverwrite
  DefineFieldRegular
}

pub fn define_field_strategy_to_string(strategy: DefineFieldStrategy) {
  case strategy {
    DefineFieldIfNotExists -> "IF NOT EXISTS "
    DefineFieldOverwrite -> "OVERWRITE "
    DefineFieldRegular -> ""
  }
}

pub fn define_field_strategy_to_module(strategy: DefineFieldStrategy) {
  module.identifier.create("node")
  |> module.binop.access(case strategy {
    DefineFieldIfNotExists -> module.identifier.create("DefineFieldIfNotExists")
    DefineFieldOverwrite -> module.identifier.create("DefineFieldOverwrite")
    DefineFieldRegular -> module.identifier.create("DefineFieldRegular")
  })
  |> module.add_import(["suweal", "node"])
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                     Define Table Strategy                                     //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub type DefineTableStrategy {
  DefineTableIfNotExists
  DefineTableOverwrite
  DefineTableRegular
}

pub fn define_table_strategy_to_string(strategy: DefineTableStrategy) {
  case strategy {
    DefineTableIfNotExists -> "IF NOT EXISTS "
    DefineTableOverwrite -> "OVERWRITE "
    DefineTableRegular -> ""
  }
}

pub fn define_table_strategy_to_module(strategy: DefineTableStrategy) {
  module.identifier.create("node")
  |> module.binop.access(case strategy {
    DefineTableIfNotExists -> module.identifier.create("DefineTableIfNotExists")
    DefineTableOverwrite -> module.identifier.create("DefineTableOverwrite")
    DefineTableRegular -> module.identifier.create("DefineTableRegular")
  })
  |> module.add_import(["suweal", "node"])
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                    Define Access Strategy                                     //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub type DefineAccessStrategy {
  DefineAccessIfNotExists
  DefineAccessOverwrite
  DefineAccessRegular
}

pub fn define_access_strategy_to_string(strategy: DefineAccessStrategy) {
  case strategy {
    DefineAccessIfNotExists -> "IF NOT EXISTS "
    DefineAccessOverwrite -> "OVERWRITE "
    DefineAccessRegular -> ""
  }
}

pub fn define_access_strategy_to_module(strategy: DefineAccessStrategy) {
  module.identifier.create("node")
  |> module.binop.access(case strategy {
    DefineAccessIfNotExists ->
      module.identifier.create("DefineAccessIfNotExists")
    DefineAccessOverwrite -> module.identifier.create("DefineAccessOverwrite")
    DefineAccessRegular -> module.identifier.create("DefineAccessRegular")
  })
  |> module.add_import(["suweal", "node"])
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                     Define Access Target                                      //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub type DefineAccessTarget {
  DefineAccessDatabase
  DefineAccessNamespace
  DefineAccessRoot
}

pub fn define_access_target_to_string(target: DefineAccessTarget) {
  case target {
    DefineAccessDatabase -> "DATABASE"
    DefineAccessNamespace -> "NAMESPACE"
    DefineAccessRoot -> "ROOT"
  }
}

pub fn define_access_target_to_module(target: DefineAccessTarget) {
  module.identifier.create("node")
  |> module.binop.access(case target {
    DefineAccessDatabase -> module.identifier.create("DefineAccessDatabase")
    DefineAccessNamespace -> module.identifier.create("DefineAccessNamespace")
    DefineAccessRoot -> module.identifier.create("DefineAccessRoot")
  })
  |> module.add_import(["suweal", "node"])
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                      Define Access Type                                       //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub type JWTConfiguration {
  JWTConfiguration(algorithm: Node, key: Node)
}

pub fn jwt_configuration_to_module(config: JWTConfiguration) {
  module.identifier.create("node")
  |> module.binop.access(case config {
    JWTConfiguration(algorithm, key) ->
      module.identifier.create("JWTConfiguration")
      |> module.function_call.create()
      |> module.function_call.add_with_alias("algorithm", to_module(algorithm))
      |> module.function_call.add_with_alias("key", to_module(key))
  })
  |> module.add_import(["suweal", "node"])
}

pub type DefineAccessType {
  DefineAccessRecord(
    signup: option.Option(Node),
    signin: option.Option(Node),
    jwt_config: option.Option(JWTConfiguration),
  )
}

pub fn define_access_type_to_module(type_: DefineAccessType) {
  module.identifier.create("node")
  |> module.binop.access(case type_ {
    DefineAccessRecord(signup, signin, jwt_config) ->
      module.identifier.create("DefineAccessRecord")
      |> module.function_call.create()
      |> module.function_call.add_with_alias("signup", case signup {
        option.Some(value) ->
          module.identifier.create("option")
          |> module.binop.access(
            module.identifier.create("Some")
            |> module.function_call.create()
            |> module.function_call.add(to_module(value)),
          )
          |> module.add_import(["gleam", "option"])
        option.None ->
          module.identifier.create("option")
          |> module.binop.access(module.identifier.create("None"))
          |> module.add_import(["gleam", "option"])
      })
      |> module.function_call.add_with_alias("signin", case signin {
        option.Some(value) ->
          module.identifier.create("option")
          |> module.binop.access(
            module.identifier.create("Some")
            |> module.function_call.create()
            |> module.function_call.add(to_module(value)),
          )
          |> module.add_import(["gleam", "option"])
        option.None ->
          module.identifier.create("option")
          |> module.binop.access(module.identifier.create("None"))
          |> module.add_import(["gleam", "option"])
      })
      |> module.function_call.add_with_alias("jwt_config", case jwt_config {
        option.Some(value) ->
          module.identifier.create("option")
          |> module.binop.access(
            module.identifier.create("Some")
            |> module.function_call.create()
            |> module.function_call.add(jwt_configuration_to_module(value)),
          )
          |> module.add_import(["gleam", "option"])
        option.None ->
          module.identifier.create("option")
          |> module.binop.access(module.identifier.create("None"))
          |> module.add_import(["gleam", "option"])
      })
  })
  |> module.add_import(["suweal", "node"])
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                             Node                                              //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub type Node {
  /// https://surrealdb.com/docs/reference/query-language/statements/define/table
  DefineTable(
    name: String,
    strategy: DefineTableStrategy,
    schema: SchemaType,
    type_: TableType,
    permissions: List(Permission),
    as_: Option(Node),
  )

  /// https://surrealdb.com/docs/reference/query-language/statements/define/field
  DefineField(
    name: Node,
    strategy: DefineFieldStrategy,
    table: String,
    type_: SurrealType,
    flexible: Bool,
    default: Option(Node),
    assert_: Option(Node),
    permissions: List(Permission),
  )

  /// https://surrealdb.com/docs/reference/query-language/statements/define/indexes
  DefineIndex(name: String, table: String, fields: List(String), unique: Bool)

  /// https://surrealdb.com/docs/reference/query-language/statements/define/access
  DefineAccess(
    name: String,
    strategy: DefineAccessStrategy,
    target: DefineAccessTarget,
    type_: DefineAccessType,
  )

  FunctionCall(node: Node, arguments: List(Node))

  /// https://surrealdb.com/docs/learn/data-models/graph/recursive-traversals
  Self

  /// https://surrealdb.com/docs/reference/query-language/language-primitives/data-types/none-and-null
  None

  /// https://surrealdb.com/docs/learn/data-models/graph/graph-traversal
  All

  /// https://surrealdb.com/docs/reference/query-language/language-primitives/data-types/numbers
  /// Different from Value(surreal_ql.Float | surreal_ql.Int) as it can be coerced to both types.
  Number(Float)

  /// https://surrealdb.com/docs/reference/query-language/language-primitives/parameters
  Parameter(String)

  /// Raw Identifier
  Identifier(String)

  /// https://surrealdb.com/docs/reference/query-language/language-primitives/data-types/values
  Value(surreal_ql.SurrealQL)

  /// https://surrealdb.com/docs/reference/query-language/language-primitives/data-types/objects
  Object(List(#(String, Node)))

  /// https://surrealdb.com/docs/reference/query-language/language-primitives/data-types/arrays
  Array(List(Node))

  /// https://surrealdb.com/docs/reference/query-language/statements/select
  Select(
    fields: List(SelectField),
    only: Bool,
    table: String,
    where: Option(Node),
    order: Option(List(#(Node, OrderDirection))),
    limit: Option(Node),
    group_all: Bool,
  )

  /// https://surrealdb.com/docs/reference/query-language/statements/if-else
  If(condition: Node, then_: Node, else_ifs: List(#(Node, Node)), else_: Node)

  /// https://surrealdb.com/docs/reference/query-language/language-primitives/operators
  BinaryOperator(lhs: Node, operator: Operator, rhs: Node)

  /// Node wrapped in ()
  WrappedNode(node: Node)

  /// https://surrealdb.com/docs/reference/query-language/statements/update
  Update(only: Bool, target: String, set: List(Node), where: Option(Node))

  /// https://surrealdb.com/docs/reference/query-language/statements/create
  Create(only: Bool, target: String, set: List(Node))

  /// https://surrealdb.com/docs/reference/query-language/statements/relate
  Relate(table: String, from: Node, to: Node, set: List(Node))

  /// https://surrealdb.com/docs/reference/query-language/language-primitives/data-types/closures
  Lambda(parameters: List(String), body: Node)

  /// https://surrealdb.com/docs/reference/query-language/statements/delete
  Delete(only: Bool, target: Node, where: Option(Node))
}

pub fn to_string(node: Node) -> String {
  case node {
    DefineTable(name:, strategy:, schema:, type_:, permissions:, as_:) ->
      "DEFINE TABLE "
      <> define_table_strategy_to_string(strategy)
      <> name
      <> " TYPE "
      <> table_type_to_string(type_)
      <> " "
      <> schema_type_to_string(schema)
      <> case as_ {
        option.Some(node) -> " AS " <> to_string(node)
        option.None -> ""
      }
      <> " PERMISSIONS "
      <> string.join(list.map(permissions, permission_to_string), " ")

    DefineField(
      name:,
      strategy:,
      table:,
      type_:,
      default:,
      assert_:,
      permissions:,
      flexible:,
    ) ->
      "DEFINE FIELD "
      <> define_field_strategy_to_string(strategy)
      <> to_string(name)
      <> " ON "
      <> table
      <> " TYPE "
      <> surreal_type.to_string(type_)
      <> case flexible {
        True -> " FLEXIBLE"
        False -> ""
      }
      <> case default {
        option.Some(node) -> " DEFAULT " <> to_string(node)
        option.None -> ""
      }
      <> case assert_ {
        option.Some(node) -> " ASSERT " <> to_string(node)
        option.None -> ""
      }
      <> case permissions {
        [] -> ""
        permissions ->
          " PERMISSIONS "
          <> string.join(list.map(permissions, permission_to_string), " ")
      }

    DefineIndex(name:, table:, fields:, unique:) ->
      "DEFINE INDEX "
      <> name
      <> " ON "
      <> table
      <> " FIELDS "
      <> string.join(fields, ", ")
      <> case unique {
        True -> " UNIQUE"
        False -> ""
      }

    DefineAccess(name:, strategy:, target:, type_:) ->
      "DEFINE ACCESS "
      <> define_access_strategy_to_string(strategy)
      <> name
      <> " ON "
      <> define_access_target_to_string(target)
      <> " TYPE RECORD"
      <> case type_.signup {
        option.Some(node) ->
          " SIGNUP ("
          <> to_string(case node {
            WrappedNode(node) -> node
            _ -> node
          })
          <> ")"
        option.None -> ""
      }
      <> case type_.signin {
        option.Some(node) ->
          " SIGNIN ("
          <> to_string(case node {
            WrappedNode(node) -> node
            _ -> node
          })
          <> ")"
        option.None -> ""
      }
      <> case type_.jwt_config {
        option.Some(config) ->
          " WITH JWT ALGORITHM "
          <> to_string(config.algorithm)
          <> " KEY "
          <> to_string(config.key)
        option.None -> ""
      }

    FunctionCall(node:, arguments:) ->
      to_string(node)
      <> "("
      <> string.join(list.map(arguments, to_string), ", ")
      <> ")"

    Self -> "@"

    None -> "NONE"

    All -> "*"

    Number(value) -> float.to_string(value)

    Parameter(name) -> "$" <> name

    Identifier(name) -> name

    Value(value) -> surreal_ql.to_string(value)

    Object(fields) -> {
      let field_strings =
        fields
        |> list.map(fn(entry) {
          let #(key, value) = entry
          key <> ": " <> to_string(value)
        })
        |> string.join(", ")
      "{" <> field_strings <> "}"
    }

    Array(fields) -> {
      let field_strings =
        fields
        |> list.map(to_string)
        |> string.join(", ")
      "[" <> field_strings <> "]"
    }

    Select(fields:, only:, table:, where:, order:, limit:, group_all:) ->
      "SELECT "
      <> string.join(list.map(fields, select_field_to_string), ", ")
      <> " FROM "
      <> case only {
        True -> "ONLY "
        False -> ""
      }
      <> table
      <> case where {
        option.Some(node) -> " WHERE " <> to_string(node)
        option.None -> ""
      }
      <> case order {
        option.Some(order) ->
          " ORDER BY "
          <> string.join(
            list.map(order, fn(entry) {
              let #(field, direction) = entry
              to_string(field) <> " " <> order_direction_to_string(direction)
            }),
            ", ",
          )
        option.None -> ""
      }
      <> case group_all {
        True -> " GROUP ALL"
        False -> ""
      }
      <> case limit {
        option.Some(node) -> " LIMIT " <> to_string(node)
        option.None -> ""
      }

    BinaryOperator(lhs:, operator:, rhs:) ->
      to_string(lhs)
      <> operator_to_string(operator)
      <> to_string(rhs)
      <> case operator {
        Indexing -> "]"
        _ -> ""
      }

    If(condition:, then_:, else_ifs:, else_:) ->
      "IF "
      <> to_string(condition)
      <> " THEN "
      <> to_string(then_)
      <> list.fold(else_ifs, "", fn(acc, entry) {
        let #(cond, body) = entry
        acc <> " ELSE IF " <> to_string(cond) <> " THEN " <> to_string(body)
      })
      <> " ELSE "
      <> to_string(else_)
      <> " END"

    WrappedNode(node) -> "(" <> to_string(node) <> ")"

    Update(only:, target:, set:, where:) ->
      "UPDATE "
      <> case only {
        True -> "ONLY "
        False -> ""
      }
      <> target
      <> " SET "
      <> string.join(list.map(set, to_string), ", ")
      <> case where {
        option.Some(node) -> " WHERE " <> to_string(node)
        option.None -> ""
      }

    Create(only:, target:, set:) ->
      "CREATE "
      <> case only {
        True -> "ONLY "
        False -> ""
      }
      <> target
      <> " SET "
      <> string.join(list.map(set, to_string), ", ")

    Relate(table:, from:, to:, set:) ->
      "RELATE "
      <> to_string(from)
      <> "->"
      <> table
      <> "->"
      <> to_string(to)
      <> case set {
        [] -> ""
        values -> " SET " <> string.join(list.map(values, to_string), ", ")
      }

    Lambda(parameters:, body:) ->
      "|"
      <> list.map(parameters, fn(p) { "$" <> p }) |> string.join(", ")
      <> "| "
      <> to_string(body)

    Delete(only:, target:, where:) ->
      "DELETE "
      <> case only {
        True -> "ONLY "
        False -> ""
      }
      <> to_string(target)
      <> case where {
        option.Some(node) -> " WHERE " <> to_string(node)
        option.None -> ""
      }
  }
}

fn surreal_type_to_module(type_: surreal_type.SurrealType) -> module.Module {
  case type_ {
    surreal_type.Int ->
      module.binop.access(
        module.identifier.create("surreal_type"),
        module.identifier.create("Int"),
      )
      |> module.add_import(["suweal", "surreal_type"])
    surreal_type.String ->
      module.binop.access(
        module.identifier.create("surreal_type"),
        module.identifier.create("String"),
      )
      |> module.add_import(["suweal", "surreal_type"])
    surreal_type.Float ->
      module.binop.access(
        module.identifier.create("surreal_type"),
        module.identifier.create("Float"),
      )
      |> module.add_import(["suweal", "surreal_type"])
    surreal_type.Identifier(name) ->
      module.binop.access(
        module.identifier.create("surreal_type"),
        module.identifier.create("Identifier"),
      )
      |> module.function_call.create()
      |> module.function_call.add(module.literal.string(name))
      |> module.add_import(["suweal", "surreal_type"])
    surreal_type.Record(name) ->
      module.binop.access(
        module.identifier.create("surreal_type"),
        module.identifier.create("Record"),
      )
      |> module.function_call.create()
      |> module.function_call.add(module.literal.string(name))
      |> module.add_import(["suweal", "surreal_type"])
    surreal_type.Datetime ->
      module.binop.access(
        module.identifier.create("surreal_type"),
        module.identifier.create("Datetime"),
      )
      |> module.add_import(["suweal", "surreal_type"])
    surreal_type.Bool ->
      module.binop.access(
        module.identifier.create("surreal_type"),
        module.identifier.create("Bool"),
      )
      |> module.add_import(["suweal", "surreal_type"])
    surreal_type.Option(inner) ->
      module.binop.access(
        module.identifier.create("surreal_type"),
        module.identifier.create("Option"),
      )
      |> module.function_call.create()
      |> module.function_call.add(surreal_type_to_module(inner))
      |> module.add_import(["suweal", "surreal_type"])
    surreal_type.Array(inner) ->
      module.binop.access(
        module.identifier.create("surreal_type"),
        module.identifier.create("Array"),
      )
      |> module.function_call.create()
      |> module.function_call.add(surreal_type_to_module(inner))
      |> module.add_import(["suweal", "surreal_type"])
    surreal_type.Point ->
      module.binop.access(
        module.identifier.create("surreal_type"),
        module.identifier.create("Point"),
      )
      |> module.add_import(["suweal", "surreal_type"])
    surreal_type.Object ->
      module.binop.access(
        module.identifier.create("surreal_type"),
        module.identifier.create("Object"),
      )
      |> module.add_import(["suweal", "surreal_type"])
    surreal_type.None ->
      module.binop.access(
        module.identifier.create("surreal_type"),
        module.identifier.create("None"),
      )
      |> module.add_import(["suweal", "surreal_type"])
  }
}

pub fn replace_variables(
  node: Node,
  values: List(#(String, surreal_ql.SurrealQL)),
) -> Node {
  case node {
    DefineTable(..) -> node
    DefineField(..) -> node
    DefineIndex(..) -> node
    DefineAccess(type_:, ..) ->
      DefineAccess(..node, type_: case type_ {
        DefineAccessRecord(signup:, signin:, jwt_config:) ->
          DefineAccessRecord(
            signup: option.map(signup, replace_variables(_, values)),
            signin: option.map(signin, replace_variables(_, values)),
            jwt_config: option.map(jwt_config, fn(config) {
              JWTConfiguration(
                algorithm: replace_variables(config.algorithm, values),
                key: replace_variables(config.key, values),
              )
            }),
          )
      })
    FunctionCall(node:, arguments:) ->
      FunctionCall(
        node: replace_variables(node, values),
        arguments: list.map(arguments, replace_variables(_, values)),
      )
    Self -> node
    None -> node
    All -> node
    Number(_) -> node
    Parameter(parameter) ->
      case list.key_find(values, parameter) {
        Ok(value) -> Value(value)
        Error(_) -> node
      }
    Value(_) -> node
    Object(fields) ->
      Object(
        list.map(fields, fn(entry) {
          let #(key, value) = entry
          #(key, replace_variables(value, values))
        }),
      )
    Array(fields) -> Array(list.map(fields, replace_variables(_, values)))
    Identifier(_) -> node
    Select(fields:, where:, limit:, ..) ->
      Select(
        ..node,
        fields: list.map(fields, fn(field) {
          SelectField(..field, field: replace_variables(field.field, values))
        }),
        where: option.map(where, replace_variables(_, values)),
        limit: option.map(limit, replace_variables(_, values)),
      )
    BinaryOperator(lhs:, operator:, rhs:) ->
      BinaryOperator(
        lhs: replace_variables(lhs, values),
        operator: operator,
        rhs: replace_variables(rhs, values),
      )
    If(condition:, then_:, else_ifs:, else_:) ->
      If(
        condition: replace_variables(condition, values),
        then_: replace_variables(then_, values),
        else_ifs: list.map(else_ifs, fn(entry) {
          entry
          |> pair.map_first(replace_variables(_, values))
          |> pair.map_second(replace_variables(_, values))
        }),
        else_: replace_variables(else_, values),
      )
    WrappedNode(node) -> WrappedNode(replace_variables(node, values))
    Update(set:, where:, ..) ->
      Update(
        ..node,
        set: list.map(set, replace_variables(_, values)),
        where: option.map(where, replace_variables(_, values)),
      )
    Create(only:, target:, set:) ->
      Create(only:, target:, set: list.map(set, replace_variables(_, values)))
    Relate(from:, to:, set:, ..) ->
      Relate(
        ..node,
        from: replace_variables(from, values),
        to: replace_variables(to, values),
        set: list.map(set, replace_variables(_, values)),
      )
    Lambda(parameters:, body:) ->
      Lambda(
        parameters: parameters,
        body: replace_variables(
          body,
          values
            |> list.filter(fn(entry) { !list.contains(parameters, entry.0) }),
        ),
      )
    Delete(target:, where:, ..) ->
      Delete(
        ..node,
        target: replace_variables(target, values),
        where: option.map(where, replace_variables(_, values)),
      )
  }
}

fn surreal_value_to_module(value: surreal_ql.SurrealQL) -> module.Module {
  case value {
    surreal_ql.String(value) ->
      module.binop.access(
        module.identifier.create("surreal_ql"),
        module.identifier.create("String"),
      )
      |> module.function_call.create()
      |> module.function_call.add(module.literal.string(value))
      |> module.add_import(["suweal", "surreal_ql"])
    surreal_ql.Int(value) ->
      module.binop.access(
        module.identifier.create("surreal_ql"),
        module.identifier.create("Int"),
      )
      |> module.function_call.create()
      |> module.function_call.add(module.literal.int(value))
      |> module.add_import(["suweal", "surreal_ql"])
    surreal_ql.Float(value) ->
      module.binop.access(
        module.identifier.create("surreal_ql"),
        module.identifier.create("Float"),
      )
      |> module.function_call.create()
      |> module.function_call.add(module.literal.float(value))
      |> module.add_import(["suweal", "surreal_ql"])
    surreal_ql.Bool(value) ->
      module.binop.access(
        module.identifier.create("surreal_ql"),
        module.identifier.create("Bool"),
      )
      |> module.function_call.create()
      |> module.function_call.add(module.literal.bool(value))
      |> module.add_import(["suweal", "surreal_ql"])
    surreal_ql.Datetime(value) ->
      module.binop.access(
        module.identifier.create("surreal_ql"),
        module.identifier.create("Datetime"),
      )
      |> module.function_call.create()
      |> module.function_call.add(module.literal.string(value))
      |> module.add_import(["suweal", "surreal_ql"])
    surreal_ql.Null ->
      module.binop.access(
        module.identifier.create("surreal_ql"),
        module.identifier.create("Null"),
      )
      |> module.add_import(["suweal", "surreal_ql"])
    surreal_ql.Object(value) ->
      module.binop.access(
        module.identifier.create("surreal_ql"),
        module.identifier.create("Object"),
      )
      |> module.function_call.create()
      |> module.function_call.add(
        module.literal.list(
          list.map(value, fn(value) {
            module.literal.tuple([
              module.literal.string(value.0),
              surreal_value_to_module(value.1),
            ])
          }),
        ),
      )
      |> module.add_import(["suweal", "surreal_ql"])
    surreal_ql.Raw(value) ->
      module.binop.access(
        module.identifier.create("surreal_ql"),
        module.identifier.create("Raw"),
      )
      |> module.function_call.create()
      |> module.function_call.add(module.literal.string(value))
      |> module.add_import(["suweal", "surreal_ql"])
    surreal_ql.Array(values) ->
      module.binop.access(
        module.identifier.create("surreal_ql"),
        module.identifier.create("Array"),
      )
      |> module.function_call.create()
      |> module.function_call.add(
        module.literal.list(list.map(values, surreal_value_to_module)),
      )
      |> module.add_import(["suweal", "surreal_ql"])
  }
}

fn option_of(
  value: option.Option(t),
  to_module: fn(t) -> module.Module,
) -> module.Module {
  case value {
    option.Some(value) ->
      module.binop.access(
        module.identifier.create("option"),
        module.identifier.create("Some"),
      )
      |> module.function_call.create()
      |> module.function_call.add(to_module(value))
      |> module.add_import(["gleam", "option"])
    option.None ->
      module.binop.access(
        module.identifier.create("option"),
        module.identifier.create("None"),
      )
      |> module.add_import(["gleam", "option"])
  }
}

pub fn to_module(node: Node) -> module.Module {
  case node {
    DefineTable(name:, strategy:, schema:, type_:, permissions:, as_:) ->
      module.binop.access(
        module.identifier.create("node"),
        module.identifier.create("DefineTable"),
      )
      |> module.function_call.create()
      |> module.function_call.add_with_alias(
        "name",
        module.literal.string(name),
      )
      |> module.function_call.add_with_alias(
        "strategy",
        define_table_strategy_to_module(strategy),
      )
      |> module.function_call.add_with_alias(
        "schema",
        schema_type_to_module(schema),
      )
      |> module.function_call.add_with_alias(
        "type_",
        table_type_to_module(type_),
      )
      |> module.function_call.add_with_alias(
        "permissions",
        module.literal.list(list.map(permissions, permission_to_module)),
      )
      |> module.function_call.add_with_alias("as_", option_of(as_, to_module))
      |> module.add_import(["suweal", "node"])
    DefineField(
      name:,
      strategy:,
      table:,
      type_:,
      default:,
      assert_:,
      permissions:,
      flexible:,
    ) ->
      module.binop.access(
        module.identifier.create("node"),
        module.identifier.create("DefineField"),
      )
      |> module.function_call.create()
      |> module.function_call.add_with_alias("name", to_module(name))
      |> module.function_call.add_with_alias(
        "strategy",
        define_field_strategy_to_module(strategy),
      )
      |> module.function_call.add_with_alias(
        "table",
        module.literal.string(table),
      )
      |> module.function_call.add_with_alias(
        "type_",
        surreal_type_to_module(type_),
      )
      |> module.function_call.add_with_alias(
        "default",
        option_of(default, to_module),
      )
      |> module.function_call.add_with_alias(
        "assert_",
        option_of(assert_, to_module),
      )
      |> module.function_call.add_with_alias(
        "permissions",
        module.literal.list(list.map(permissions, permission_to_module)),
      )
      |> module.function_call.add_with_alias(
        "flexible",
        module.literal.bool(flexible),
      )
      |> module.add_import(["suweal", "node"])
    DefineIndex(name:, table:, fields:, unique:) ->
      module.binop.access(
        module.identifier.create("node"),
        module.identifier.create("DefineIndex"),
      )
      |> module.function_call.create()
      |> module.function_call.add_with_alias(
        "name",
        module.literal.string(name),
      )
      |> module.function_call.add_with_alias(
        "table",
        module.literal.string(table),
      )
      |> module.function_call.add_with_alias(
        "fields",
        module.literal.list(list.map(fields, module.literal.string)),
      )
      |> module.function_call.add_with_alias(
        "unique",
        module.literal.bool(unique),
      )
      |> module.add_import(["suweal", "node"])
    DefineAccess(name:, strategy:, target:, type_:) ->
      module.binop.access(
        module.identifier.create("node"),
        module.identifier.create("DefineAccess"),
      )
      |> module.function_call.create()
      |> module.function_call.add_with_alias(
        "name",
        module.literal.string(name),
      )
      |> module.function_call.add_with_alias(
        "strategy",
        define_access_strategy_to_module(strategy),
      )
      |> module.function_call.add_with_alias(
        "target",
        define_access_target_to_module(target),
      )
      |> module.function_call.add_with_alias(
        "type_",
        define_access_type_to_module(type_),
      )
      |> module.add_import(["suweal", "node"])
    FunctionCall(node:, arguments:) ->
      module.binop.access(
        module.identifier.create("node"),
        module.identifier.create("FunctionCall"),
      )
      |> module.function_call.create()
      |> module.function_call.add_with_alias("node", to_module(node))
      |> module.function_call.add_with_alias(
        "arguments",
        module.literal.list(list.map(arguments, to_module)),
      )
      |> module.add_import(["suweal", "node"])
    Self ->
      module.binop.access(
        module.identifier.create("node"),
        module.identifier.create("Self"),
      )
      |> module.add_import(["suweal", "node"])
    None ->
      module.binop.access(
        module.identifier.create("node"),
        module.identifier.create("None"),
      )
      |> module.add_import(["suweal", "node"])
    All ->
      module.binop.access(
        module.identifier.create("node"),
        module.identifier.create("All"),
      )
      |> module.add_import(["suweal", "node"])
    Number(value) ->
      module.binop.access(
        module.identifier.create("node"),
        module.identifier.create("Number"),
      )
      |> module.function_call.create()
      |> module.function_call.add(module.literal.float(value))
      |> module.add_import(["suweal", "node"])
    Parameter(value) ->
      module.binop.access(
        module.identifier.create("node"),
        module.identifier.create("Parameter"),
      )
      |> module.function_call.create()
      |> module.function_call.add(module.literal.string(value))
      |> module.add_import(["suweal", "node"])
    Identifier(value) ->
      module.binop.access(
        module.identifier.create("node"),
        module.identifier.create("Identifier"),
      )
      |> module.function_call.create()
      |> module.function_call.add(module.literal.string(value))
      |> module.add_import(["suweal", "node"])
    Value(value) ->
      module.binop.access(
        module.identifier.create("node"),
        module.identifier.create("Value"),
      )
      |> module.function_call.create()
      |> module.function_call.add(surreal_value_to_module(value))
      |> module.add_import(["suweal", "node"])
    Object(fields) ->
      module.binop.access(
        module.identifier.create("node"),
        module.identifier.create("Object"),
      )
      |> module.function_call.create()
      |> module.function_call.add(
        module.literal.list(
          list.map(fields, fn(field) {
            let #(key, value) = field
            module.literal.tuple([module.literal.string(key), to_module(value)])
          }),
        ),
      )
      |> module.add_import(["suweal", "node"])
    Array(fields) ->
      module.binop.access(
        module.identifier.create("node"),
        module.identifier.create("Array"),
      )
      |> module.function_call.create()
      |> module.function_call.add(
        module.literal.list(list.map(fields, to_module)),
      )
      |> module.add_import(["suweal", "node"])
    Select(fields:, only:, table:, where:, order:, limit:, group_all:) ->
      module.binop.access(
        module.identifier.create("node"),
        module.identifier.create("Select"),
      )
      |> module.function_call.create()
      |> module.function_call.add_with_alias(
        "fields",
        module.literal.list(list.map(fields, select_field_to_module)),
      )
      |> module.function_call.add_with_alias("only", module.literal.bool(only))
      |> module.function_call.add_with_alias(
        "table",
        module.literal.string(table),
      )
      |> module.function_call.add_with_alias(
        "where",
        option_of(where, to_module),
      )
      |> module.function_call.add_with_alias(
        "order",
        option_of(order, fn(order) {
          module.literal.list(
            list.map(order, fn(entry) {
              let #(field, direction) = entry
              module.literal.tuple([
                to_module(field),
                order_direction_to_module(direction),
              ])
            }),
          )
        }),
      )
      |> module.function_call.add_with_alias(
        "limit",
        option_of(limit, to_module),
      )
      |> module.function_call.add_with_alias(
        "group_all",
        module.literal.bool(group_all),
      )
      |> module.add_import(["suweal", "node"])
    BinaryOperator(lhs:, operator:, rhs:) ->
      module.binop.access(
        module.identifier.create("node"),
        module.identifier.create("BinaryOperator"),
      )
      |> module.function_call.create()
      |> module.function_call.add_with_alias("lhs", to_module(lhs))
      |> module.function_call.add_with_alias(
        "operator",
        operator_to_module(operator),
      )
      |> module.function_call.add_with_alias("rhs", to_module(rhs))
      |> module.add_import(["suweal", "node"])
    If(condition:, then_:, else_ifs:, else_:) ->
      module.binop.access(
        module.identifier.create("node"),
        module.identifier.create("If"),
      )
      |> module.function_call.create()
      |> module.function_call.add_with_alias("condition", to_module(condition))
      |> module.function_call.add_with_alias("then_", to_module(then_))
      |> module.function_call.add_with_alias(
        "else_ifs",
        module.literal.list(
          list.map(else_ifs, fn(entry) {
            let #(cond, body) = entry
            module.literal.tuple([
              to_module(cond),
              to_module(body),
            ])
          }),
        ),
      )
      |> module.function_call.add_with_alias("else_", to_module(else_))
      |> module.add_import(["suweal", "node"])
    WrappedNode(node) ->
      module.binop.access(
        module.identifier.create("node"),
        module.identifier.create("WrappedNode"),
      )
      |> module.function_call.create()
      |> module.function_call.add_with_alias("node", to_module(node))
      |> module.add_import(["suweal", "node"])
    Update(only:, target:, set:, where:) ->
      module.binop.access(
        module.identifier.create("node"),
        module.identifier.create("Update"),
      )
      |> module.function_call.create()
      |> module.function_call.add_with_alias("only", module.literal.bool(only))
      |> module.function_call.add_with_alias(
        "target",
        module.literal.string(target),
      )
      |> module.function_call.add_with_alias(
        "set",
        module.literal.list(list.map(set, to_module)),
      )
      |> module.function_call.add_with_alias(
        "where",
        option_of(where, to_module),
      )
      |> module.add_import(["suweal", "node"])
    Create(only:, target:, set:) ->
      module.binop.access(
        module.identifier.create("node"),
        module.identifier.create("Create"),
      )
      |> module.function_call.create()
      |> module.function_call.add_with_alias("only", module.literal.bool(only))
      |> module.function_call.add_with_alias(
        "target",
        module.literal.string(target),
      )
      |> module.function_call.add_with_alias(
        "set",
        module.literal.list(list.map(set, to_module)),
      )
      |> module.add_import(["suweal", "node"])
    Relate(table:, from:, to:, set:) ->
      module.binop.access(
        module.identifier.create("node"),
        module.identifier.create("Relate"),
      )
      |> module.function_call.create()
      |> module.function_call.add_with_alias(
        "table",
        module.literal.string(table),
      )
      |> module.function_call.add_with_alias("from", to_module(from))
      |> module.function_call.add_with_alias("to", to_module(to))
      |> module.function_call.add_with_alias(
        "set",
        module.literal.list(list.map(set, to_module)),
      )
      |> module.add_import(["suweal", "node"])
    Lambda(parameters:, body:) ->
      module.binop.access(
        module.identifier.create("node"),
        module.identifier.create("Lambda"),
      )
      |> module.function_call.create()
      |> module.function_call.add_with_alias(
        "parameters",
        module.literal.list(list.map(parameters, module.literal.string)),
      )
      |> module.function_call.add_with_alias("body", to_module(body))
      |> module.add_import(["suweal", "node"])
    Delete(only:, target:, where:) ->
      module.binop.access(
        module.identifier.create("node"),
        module.identifier.create("Delete"),
      )
      |> module.function_call.create()
      |> module.function_call.add_with_alias("only", module.literal.bool(only))
      |> module.function_call.add_with_alias("target", to_module(target))
      |> module.function_call.add_with_alias(
        "where",
        option_of(where, to_module),
      )
      |> module.add_import(["suweal", "node"])
  }
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                         Define Table                                          //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub type DefineTableNS {
  DefineTableNS(
    create: fn(String) -> Node,
    with_strategy: fn(Node, DefineTableStrategy) -> Node,
    with_schema: fn(Node, SchemaType) -> Node,
    with_type: fn(Node, TableType) -> Node,
    add_permission: fn(Node, Permission) -> Node,
    set_as: fn(Node, Node) -> Node,
  )
}

pub const define_table = DefineTableNS(
  create: define_table_create,
  with_strategy: define_table_with_strategy,
  with_schema: define_table_with_schema,
  with_type: define_table_with_type,
  add_permission: define_table_add_permission,
  set_as: define_table_set_as,
)

pub fn define_table_create(name: String) -> Node {
  DefineTable(
    name:,
    strategy: DefineTableRegular,
    schema: Schemafull,
    type_: NormalTable,
    permissions: [],
    as_: option.None,
  )
}

pub fn define_table_with_strategy(
  node: Node,
  strategy: DefineTableStrategy,
) -> Node {
  case node {
    DefineTable(..) -> DefineTable(..node, strategy: strategy)
    _ -> node
  }
}

pub fn define_table_with_schema(node: Node, schema: SchemaType) -> Node {
  case node {
    DefineTable(..) -> DefineTable(..node, schema: schema)
    _ -> node
  }
}

pub fn define_table_with_type(node: Node, type_: TableType) -> Node {
  case node {
    DefineTable(..) -> DefineTable(..node, type_: type_)
    _ -> node
  }
}

pub fn define_table_add_permission(node: Node, permission: Permission) -> Node {
  case node {
    DefineTable(..) ->
      DefineTable(
        ..node,
        permissions: list.append(node.permissions, [permission]),
      )
    _ -> node
  }
}

pub fn define_table_set_as(node: Node, as_: Node) -> Node {
  case node {
    DefineTable(..) -> DefineTable(..node, as_: option.Some(as_))
    _ -> node
  }
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                         Define Field                                          //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub type DefineFieldNS {
  DefineFieldNS(
    create: fn(Node, String, surreal_type.SurrealType) -> Node,
    with_strategy: fn(Node, DefineFieldStrategy) -> Node,
    with_default: fn(Node, Node) -> Node,
    with_assert: fn(Node, Node) -> Node,
    add_permission: fn(Node, Permission) -> Node,
    set_flexible: fn(Node, Bool) -> Node,
  )
}

pub const define_field: DefineFieldNS = DefineFieldNS(
  create: define_field_create,
  with_strategy: define_field_with_strategy,
  with_default: define_field_with_default,
  with_assert: define_field_with_assert,
  add_permission: define_field_add_permission,
  set_flexible: define_field_set_flexible,
)

pub fn define_field_create(
  name: Node,
  table: String,
  type_: surreal_type.SurrealType,
) -> Node {
  DefineField(
    name: name,
    strategy: DefineFieldRegular,
    table: table,
    type_: type_,
    default: option.None,
    assert_: option.None,
    permissions: [],
    flexible: False,
  )
}

pub fn define_field_with_strategy(
  node: Node,
  strategy: DefineFieldStrategy,
) -> Node {
  case node {
    DefineField(..) -> DefineField(..node, strategy: strategy)
    _ -> node
  }
}

pub fn define_field_with_default(node: Node, default: Node) -> Node {
  case node {
    DefineField(..) -> DefineField(..node, default: option.Some(default))
    _ -> node
  }
}

pub fn define_field_with_assert(node: Node, assert_: Node) -> Node {
  case node {
    DefineField(..) -> DefineField(..node, assert_: option.Some(assert_))
    _ -> node
  }
}

pub fn define_field_add_permission(node: Node, permission: Permission) -> Node {
  case node {
    DefineField(..) ->
      DefineField(
        ..node,
        permissions: list.append(node.permissions, [permission]),
      )
    _ -> node
  }
}

pub fn define_field_set_flexible(node: Node, flexible: Bool) -> Node {
  case node {
    DefineField(..) -> DefineField(..node, flexible: flexible)
    _ -> node
  }
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                         Define Index                                          //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub type DefineIndexNS {
  DefineIndexNS(
    create: fn(String, String) -> Node,
    add_field: fn(Node, String) -> Node,
    set_unique: fn(Node, Bool) -> Node,
  )
}

pub const define_index = DefineIndexNS(
  create: define_index_create,
  add_field: define_index_add_field,
  set_unique: define_index_set_unique,
)

pub fn define_index_create(name: String, table: String) -> Node {
  DefineIndex(name: name, table: table, fields: [], unique: False)
}

pub fn define_index_add_field(node: Node, field: String) -> Node {
  case node {
    DefineIndex(..) ->
      DefineIndex(..node, fields: list.append(node.fields, [field]))
    _ -> node
  }
}

pub fn define_index_set_unique(node: Node, unique: Bool) -> Node {
  case node {
    DefineIndex(..) -> DefineIndex(..node, unique: unique)
    _ -> node
  }
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                         Define Access                                         //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub type DefineAccessNS {
  DefineAccessNS(
    create: fn(String) -> Node,
    with_strategy: fn(Node, DefineAccessStrategy) -> Node,
    with_target: fn(Node, DefineAccessTarget) -> Node,
    with_signin: fn(Node, Node) -> Node,
    with_signup: fn(Node, Node) -> Node,
    with_jwt_config: fn(Node, JWTConfiguration) -> Node,
  )
}

pub const define_access = DefineAccessNS(
  create: define_access_create,
  with_strategy: define_access_with_strategy,
  with_target: define_access_with_target,
  with_signin: define_access_with_signin,
  with_signup: define_access_with_signup,
  with_jwt_config: define_access_with_jwt_config,
)

pub fn define_access_create(name: String) -> Node {
  DefineAccess(
    name:,
    strategy: DefineAccessRegular,
    target: DefineAccessDatabase,
    type_: DefineAccessRecord(
      signup: option.None,
      signin: option.None,
      jwt_config: option.None,
    ),
  )
}

pub fn define_access_with_strategy(
  node: Node,
  strategy: DefineAccessStrategy,
) -> Node {
  case node {
    DefineAccess(..) -> DefineAccess(..node, strategy:)
    _ -> node
  }
}

pub fn define_access_with_target(
  node: Node,
  target: DefineAccessTarget,
) -> Node {
  case node {
    DefineAccess(..) -> DefineAccess(..node, target:)
    _ -> node
  }
}

pub fn define_access_with_signin(node: Node, signin: Node) -> Node {
  case node {
    DefineAccess(..) ->
      DefineAccess(
        ..node,
        type_: DefineAccessRecord(..node.type_, signin: option.Some(signin)),
      )
    _ -> node
  }
}

pub fn define_access_with_signup(node: Node, signup: Node) -> Node {
  case node {
    DefineAccess(..) ->
      DefineAccess(
        ..node,
        type_: DefineAccessRecord(..node.type_, signup: option.Some(signup)),
      )
    _ -> node
  }
}

pub fn define_access_with_jwt_config(
  node: Node,
  config: JWTConfiguration,
) -> Node {
  case node {
    DefineAccess(..) ->
      DefineAccess(
        ..node,
        type_: DefineAccessRecord(..node.type_, jwt_config: option.Some(config)),
      )
    _ -> node
  }
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                         Function Call                                         //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub type FunctionCallNS {
  FunctionCallNS(create: fn(Node) -> Node, add: fn(Node, Node) -> Node)
}

pub const function_call = FunctionCallNS(
  create: function_call_create,
  add: function_call_add_argument,
)

pub fn function_call_create(lhs: Node) -> Node {
  FunctionCall(node: lhs, arguments: [])
}

pub fn function_call_add_argument(call: Node, arg: Node) -> Node {
  case call {
    FunctionCall(..) ->
      FunctionCall(..call, arguments: list.append(call.arguments, [arg]))
    _ -> call
  }
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                             Self                                              //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub type SelfNS {
  SelfNS(create: fn() -> Node)
}

pub const self = SelfNS(create: self_create)

pub fn self_create() -> Node {
  Self
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                             None                                              //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub type NoneNS {
  NoneNS(create: fn() -> Node)
}

pub const none = NoneNS(create: none_create)

pub fn none_create() -> Node {
  None
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                              All                                              //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub type AllNS {
  AllNS(create: fn() -> Node)
}

pub const all = AllNS(create: all_create)

pub fn all_create() -> Node {
  All
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                            Number                                             //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub type NumberNS {
  NumberNS(create: fn(Float) -> Node)
}

pub const number = NumberNS(create: number_create)

pub fn number_create(value: Float) -> Node {
  Number(value)
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                           Parameter                                           //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub type ParameterNS {
  ParameterNS(create: fn(String) -> Node)
}

pub const parameter = ParameterNS(create: parameter_create)

pub fn parameter_create(name: String) -> Node {
  Parameter(name)
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                          Identifier                                           //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub type IdentifierNS {
  IdentifierNS(create: fn(String) -> Node)
}

pub const identifier = IdentifierNS(create: identifier_create)

pub fn identifier_create(name: String) -> Node {
  Identifier(name)
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                             Value                                             //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub type ValueNS {
  ValueNS(
    create: fn(surreal_ql.SurrealQL) -> Node,
    string: fn(String) -> Node,
    int: fn(Int) -> Node,
    float: fn(Float) -> Node,
    bool: fn(Bool) -> Node,
  )
}

pub const value = ValueNS(
  create: value_create,
  string: value_create_string,
  int: value_create_int,
  float: value_create_float,
  bool: value_create_bool,
)

pub fn value_create(value: surreal_ql.SurrealQL) -> Node {
  Value(value)
}

pub fn value_create_string(value: String) -> Node {
  Value(surreal_ql.String(value))
}

pub fn value_create_int(value: Int) -> Node {
  Value(surreal_ql.Int(value))
}

pub fn value_create_float(value: Float) -> Node {
  Value(surreal_ql.Float(value))
}

pub fn value_create_bool(value: Bool) -> Node {
  Value(surreal_ql.Bool(value))
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                            Object                                             //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub type ObjectNS {
  ObjectNS(create: fn() -> Node, add: fn(Node, String, Node) -> Node)
}

pub const object = ObjectNS(create: object_create, add: object_add)

pub fn object_create() -> Node {
  Object([])
}

pub fn object_add(object: Node, key: String, value: Node) -> Node {
  case object {
    Object(fields) -> Object(list.append(fields, [#(key, value)]))
    _ -> object
  }
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                             Array                                             //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub type ArrayNS {
  ArrayNS(create: fn() -> Node, add: fn(Node, Node) -> Node)
}

pub const array = ArrayNS(create: array_create, add: array_add)

pub fn array_create() -> Node {
  Array([])
}

pub fn array_add(array: Node, value: Node) -> Node {
  case array {
    Array(values) -> Array(list.append(values, [value]))
    _ -> array
  }
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                            Select                                             //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub type SelectNS {
  SelectNS(
    create: fn(String) -> Node,
    add_field: fn(Node, Node) -> Node,
    add_value_field: fn(Node, Node) -> Node,
    add_field_as: fn(Node, Node, String) -> Node,
    add_value_field_as: fn(Node, Node, String) -> Node,
    with_where: fn(Node, Node) -> Node,
    add_order: fn(Node, Node, OrderDirection) -> Node,
    with_limit: fn(Node, Node) -> Node,
    set_group_all: fn(Node, Bool) -> Node,
    set_only: fn(Node, Bool) -> Node,
  )
}

pub const select = SelectNS(
  create: select_create,
  add_field: select_add_field,
  add_value_field: select_add_value_field,
  add_field_as: select_add_field_as,
  add_value_field_as: select_add_value_field_as,
  with_where: select_with_where,
  add_order: select_add_order,
  with_limit: select_with_limit,
  set_group_all: select_set_group_all,
  set_only: select_set_only,
)

pub fn select_create(table: String) -> Node {
  Select(
    fields: [],
    only: False,
    table:,
    where: option.None,
    order: option.None,
    limit: option.None,
    group_all: False,
  )
}

pub fn select_add_field(select: Node, field: Node) -> Node {
  case select {
    Select(..) ->
      Select(
        ..select,
        fields: list.append(select.fields, [
          SelectField(field:, alias: option.None, value: False),
        ]),
      )
    _ -> select
  }
}

pub fn select_add_value_field(select: Node, field: Node) -> Node {
  case select {
    Select(..) ->
      Select(
        ..select,
        fields: list.append(select.fields, [
          SelectField(field:, alias: option.None, value: True),
        ]),
      )
    _ -> select
  }
}

pub fn select_add_field_as(select: Node, field: Node, alias: String) -> Node {
  case select {
    Select(..) ->
      Select(
        ..select,
        fields: list.append(select.fields, [
          SelectField(field:, alias: option.Some(alias), value: False),
        ]),
      )
    _ -> select
  }
}

pub fn select_add_value_field_as(
  select: Node,
  field: Node,
  alias: String,
) -> Node {
  case select {
    Select(..) ->
      Select(
        ..select,
        fields: list.append(select.fields, [
          SelectField(field:, alias: option.Some(alias), value: True),
        ]),
      )
    _ -> select
  }
}

pub fn select_with_where(select: Node, condition: Node) -> Node {
  case select {
    Select(..) -> Select(..select, where: option.Some(condition))
    _ -> select
  }
}

pub fn select_add_order(
  select: Node,
  node: Node,
  order: OrderDirection,
) -> Node {
  case select {
    Select(..) ->
      Select(
        ..select,
        order: option.unwrap(select.order, [])
          |> list.append([#(node, order)])
          |> option.Some,
      )
    _ -> select
  }
}

pub fn select_with_limit(select: Node, limit: Node) -> Node {
  case select {
    Select(..) -> Select(..select, limit: option.Some(limit))
    _ -> select
  }
}

pub fn select_set_group_all(select: Node, group_all: Bool) -> Node {
  case select {
    Select(..) -> Select(..select, group_all: group_all)
    _ -> select
  }
}

pub fn select_set_only(select: Node, only: Bool) -> Node {
  case select {
    Select(..) -> Select(..select, only: only)
    _ -> select
  }
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                              If                                               //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub type IfNS {
  IfNS(
    create: fn(Node, Node, Node) -> Node,
    add_else_if: fn(Node, Node, Node) -> Node,
  )
}

pub const if_ = IfNS(create: if_create, add_else_if: if_add_else_if)

pub fn if_create(condition: Node, then: Node, else_: Node) -> Node {
  If(condition: condition, then_: then, else_ifs: [], else_: else_)
}

pub fn if_add_else_if(if_node: Node, condition: Node, then: Node) -> Node {
  case if_node {
    If(..) ->
      If(
        ..if_node,
        else_ifs: list.append(if_node.else_ifs, [#(condition, then)]),
      )
    _ -> if_node
  }
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                       Binary Operation                                        //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub type BinopNS {
  BinopNS(
    create: fn(Node, Operator, Node) -> Node,
    equal: fn(Node, Node) -> Node,
    not_equal: fn(Node, Node) -> Node,
    greater_than: fn(Node, Node) -> Node,
    less_than: fn(Node, Node) -> Node,
    greater_than_or_equal: fn(Node, Node) -> Node,
    less_than_or_equal: fn(Node, Node) -> Node,
    access: fn(Node, Node) -> Node,
    namespace_access: fn(Node, Node) -> Node,
    inside: fn(Node, Node) -> Node,
    relation_to: fn(Node, Node) -> Node,
    relation_from: fn(Node, Node) -> Node,
    relation_to_from: fn(Node, Node) -> Node,
    indexing: fn(Node, Node) -> Node,
    and: fn(Node, Node) -> Node,
    or: fn(Node, Node) -> Node,
  )
}

pub const binop = BinopNS(
  create: binop_create,
  equal: binop_equal,
  not_equal: binop_not_equal,
  greater_than: binop_greater_than,
  less_than: binop_less_than,
  greater_than_or_equal: binop_greater_than_or_equal,
  less_than_or_equal: binop_less_than_or_equal,
  access: binop_access,
  namespace_access: binop_namespace_access,
  inside: binop_inside,
  relation_to: binop_relation_to,
  relation_from: binop_relation_from,
  relation_to_from: binop_relation_to_from,
  indexing: binop_index,
  and: binop_and,
  or: binop_or,
)

pub fn binop_create(lhs: Node, operator: Operator, rhs: Node) -> Node {
  BinaryOperator(lhs: lhs, operator: operator, rhs: rhs)
}

pub fn binop_equal(lhs: Node, rhs: Node) -> Node {
  binop_create(lhs, Equal, rhs)
}

pub fn binop_not_equal(lhs: Node, rhs: Node) -> Node {
  binop_create(lhs, NotEqual, rhs)
}

pub fn binop_greater_than(lhs: Node, rhs: Node) -> Node {
  binop_create(lhs, GreaterThan, rhs)
}

pub fn binop_less_than(lhs: Node, rhs: Node) -> Node {
  binop_create(lhs, LessThan, rhs)
}

pub fn binop_greater_than_or_equal(lhs: Node, rhs: Node) -> Node {
  binop_create(lhs, GreaterThanOrEqual, rhs)
}

pub fn binop_less_than_or_equal(lhs: Node, rhs: Node) -> Node {
  binop_create(lhs, LessThanOrEqual, rhs)
}

pub fn binop_access(lhs: Node, rhs: Node) -> Node {
  binop_create(lhs, Access, rhs)
}

pub fn binop_namespace_access(lhs: Node, rhs: Node) -> Node {
  binop_create(lhs, NamespaceAccess, rhs)
}

pub fn binop_inside(lhs: Node, rhs: Node) -> Node {
  binop_create(lhs, Inside, rhs)
}

pub fn binop_relation_to(lhs: Node, rhs: Node) -> Node {
  binop_create(lhs, RelationTo, rhs)
}

pub fn binop_relation_from(lhs: Node, rhs: Node) -> Node {
  binop_create(lhs, RelationFrom, rhs)
}

pub fn binop_relation_to_from(lhs: Node, rhs: Node) -> Node {
  binop_create(lhs, RelationToFrom, rhs)
}

pub fn binop_index(lhs: Node, rhs: Node) -> Node {
  binop_create(lhs, Indexing, rhs)
}

pub fn binop_and(lhs: Node, rhs: Node) -> Node {
  binop_create(lhs, And, rhs)
}

pub fn binop_or(lhs: Node, rhs: Node) -> Node {
  binop_create(lhs, Or, rhs)
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                            Wrapped                                            //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub type WrappedNS {
  WrappedNS(create: fn(Node) -> Node)
}

pub const wrapped = WrappedNS(create: wrapped_create)

pub fn wrapped_create(node: Node) -> Node {
  WrappedNode(node: node)
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                            Update                                             //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub type UpdateNS {
  UpdateNS(
    create: fn(String) -> Node,
    set_only: fn(Node, Bool) -> Node,
    add_set: fn(Node, Node) -> Node,
    with_where: fn(Node, Node) -> Node,
  )
}

pub const update = UpdateNS(
  create: update_create,
  set_only: update_set_only,
  add_set: update_add_set,
  with_where: update_with_where,
)

pub fn update_create(target: String) -> Node {
  Update(only: False, target: target, set: [], where: option.None)
}

pub fn update_set_only(node: Node, only: Bool) -> Node {
  case node {
    Update(..) -> Update(..node, only: only)
    _ -> node
  }
}

pub fn update_add_set(node: Node, item: Node) -> Node {
  case node {
    Update(..) -> Update(..node, set: list.append(node.set, [item]))
    _ -> node
  }
}

pub fn update_with_where(node: Node, where: Node) -> Node {
  case node {
    Update(..) -> Update(..node, where: option.Some(where))
    _ -> node
  }
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                            Create                                             //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub type CreateNS {
  CreateNS(
    create: fn(String) -> Node,
    set_only: fn(Node, Bool) -> Node,
    add_set: fn(Node, Node) -> Node,
  )
}

pub const create = CreateNS(
  create: create_create,
  set_only: create_set_only,
  add_set: create_add_set,
)

pub fn create_create(target: String) -> Node {
  Create(only: False, target: target, set: [])
}

pub fn create_set_only(node: Node, only: Bool) -> Node {
  case node {
    Create(..) -> Create(..node, only:)
    _ -> node
  }
}

pub fn create_add_set(node: Node, item: Node) -> Node {
  case node {
    Create(..) -> Create(..node, set: list.append(node.set, [item]))
    _ -> node
  }
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                            Relate                                             //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub type RelateNS {
  RelateNS(
    create: fn(String, Node, Node) -> Node,
    add_set: fn(Node, Node) -> Node,
  )
}

pub const relate = RelateNS(create: relate_create, add_set: relate_add_set)

pub fn relate_create(table: String, from: Node, to: Node) -> Node {
  Relate(table: table, from: from, to: to, set: [])
}

pub fn relate_add_set(node: Node, item: Node) -> Node {
  case node {
    Relate(..) -> Relate(..node, set: list.append(node.set, [item]))
    _ -> node
  }
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                            Lambda                                             //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub type LambdaNS {
  LambdaNS(create: fn(Node) -> Node, add_parameter: fn(Node, String) -> Node)
}

pub const lambda = LambdaNS(
  create: lambda_create,
  add_parameter: lambda_add_parameter,
)

pub fn lambda_create(body: Node) -> Node {
  Lambda(body: body, parameters: [])
}

pub fn lambda_add_parameter(node: Node, parameter: String) -> Node {
  case node {
    Lambda(..) ->
      Lambda(..node, parameters: list.append(node.parameters, [parameter]))
    _ -> node
  }
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                            Delete                                             //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub type DeleteNS {
  DeleteNS(
    create: fn(Node) -> Node,
    set_only: fn(Node, Bool) -> Node,
    with_where: fn(Node, Node) -> Node,
  )
}

pub const delete = DeleteNS(
  create: delete_create,
  set_only: delete_set_only,
  with_where: delete_with_where,
)

pub fn delete_create(target: Node) {
  Delete(only: False, target:, where: option.None)
}

pub fn delete_set_only(node: Node, only: Bool) -> Node {
  case node {
    Delete(..) -> Delete(..node, only: only)
    _ -> node
  }
}

pub fn delete_with_where(node: Node, where: Node) -> Node {
  case node {
    Delete(..) -> Delete(..node, where: option.Some(where))
    _ -> node
  }
}
