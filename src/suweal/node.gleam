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
//                                             Node                                              //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub type Node {
  /// https://surrealdb.com/docs/reference/query-language/statements/define/table
  DefineTable(
    name: String,
    schema: SchemaType,
    type_: TableType,
    permissions: List(Permission),
    as_: Option(Node),
  )

  /// https://surrealdb.com/docs/reference/query-language/statements/define/field
  DefineField(
    name: Node,
    table: String,
    type_: SurrealType,
    flexible: Bool,
    default: Option(Node),
    assert_: Option(Node),
    permissions: List(Permission),
  )

  /// https://surrealdb.com/docs/reference/query-language/statements/define/indexes
  DefineIndex(name: String, table: String, fields: List(String), unique: Bool)

  FunctionCall(lhs: Option(String), rhs: String, arguments: List(Node))

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
  Update(target: String, set: List(Node), where: Option(Node))

  /// https://surrealdb.com/docs/reference/query-language/statements/create
  Create(only: Bool, target: String, set: List(Node))

  /// https://surrealdb.com/docs/reference/query-language/statements/relate
  Relate(table: String, from: Node, to: Node, set: List(Node))

  /// https://surrealdb.com/docs/reference/query-language/language-primitives/data-types/closures
  Lambda(parameters: List(String), body: Node)

  /// https://surrealdb.com/docs/reference/query-language/statements/delete
  Delete(target: Node, where: Option(Node))
}

pub fn to_string(node: Node) -> String {
  case node {
    DefineTable(name:, schema:, type_:, permissions:, as_:) ->
      "DEFINE TABLE "
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
      table:,
      type_:,
      default:,
      assert_:,
      permissions:,
      flexible:,
    ) ->
      "DEFINE FIELD "
      <> to_string(name)
      <> " ON "
      <> table
      <> case flexible {
        True -> " FLEXIBLE"
        False -> ""
      }
      <> " TYPE "
      <> surreal_type.to_string(type_)
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

    FunctionCall(lhs:, rhs:, arguments:) ->
      case lhs {
        option.Some(lhs) -> lhs <> "::"
        _ -> ""
      }
      <> rhs
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
      <> string.join(
        list.map(fields, fn(field) {
          to_string(field.field)
          <> case field.alias {
            option.Some(alias) -> " AS " <> alias
            option.None -> ""
          }
        }),
        ", ",
      )
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

    Update(target:, set:, where:) ->
      "UPDATE "
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

    Delete(target:, where:) ->
      "DELETE "
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
    FunctionCall(lhs:, rhs:, arguments:) ->
      FunctionCall(
        lhs: lhs,
        rhs: rhs,
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
    Update(target:, set:, where:) ->
      Update(
        target: target,
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
    Delete(target:, where:) ->
      Delete(
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
    DefineTable(name:, schema:, type_:, permissions:, as_:) ->
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
    FunctionCall(lhs:, rhs:, arguments:) ->
      module.binop.access(
        module.identifier.create("node"),
        module.identifier.create("FunctionCall"),
      )
      |> module.function_call.create()
      |> module.function_call.add_with_alias(
        "lhs",
        option_of(lhs, module.literal.string),
      )
      |> module.function_call.add_with_alias("rhs", module.literal.string(rhs))
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
        module.literal.list(
          list.map(fields, fn(field) {
            module.binop.access(
              module.identifier.create("node"),
              module.identifier.create("SelectField"),
            )
            |> module.function_call.create()
            |> module.function_call.add_with_alias(
              "field",
              to_module(field.field),
            )
            |> module.function_call.add_with_alias(
              "alias",
              option_of(field.alias, module.literal.string),
            )
            |> module.function_call.add_with_alias(
              "value",
              module.literal.bool(field.value),
            )
          }),
        ),
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
    Update(target:, set:, where:) ->
      module.binop.access(
        module.identifier.create("node"),
        module.identifier.create("Update"),
      )
      |> module.function_call.create()
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
    Delete(target:, where:) ->
      module.binop.access(
        module.identifier.create("node"),
        module.identifier.create("Delete"),
      )
      |> module.function_call.create()
      |> module.function_call.add_with_alias("target", to_module(target))
      |> module.function_call.add_with_alias(
        "where",
        option_of(where, to_module),
      )
      |> module.add_import(["suweal", "node"])
  }
}
