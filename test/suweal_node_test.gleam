import gleam/option
import gleeunit/should
import suweal/node
import suweal/surreal_ql
import suweal/surreal_type

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                         Define Table                                          //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub fn define_simple_table_to_string_test() {
  node.DefineTable(
    name: "user",
    schema: node.Schemafull,
    type_: node.NormalTable,
    permissions: [node.PermissionFull],
    as_: option.None,
  )
  |> node.to_string()
  |> should.equal("DEFINE TABLE user TYPE NORMAL SCHEMAFULL PERMISSIONS FULL")
}

pub fn define_relation_table_to_string_test() {
  node.DefineTable(
    name: "user",
    schema: node.Schemafull,
    type_: node.RelationTable(in: "user", out: "profile"),
    permissions: [node.PermissionNone],
    as_: option.None,
  )
  |> node.to_string()
  |> should.equal(
    "DEFINE TABLE user TYPE RELATION IN user OUT profile SCHEMAFULL PERMISSIONS NONE",
  )
}

pub fn define_table_with_query_to_string_test() {
  node.DefineTable(
    name: "user",
    schema: node.Schemafull,
    type_: node.NormalTable,
    permissions: [
      node.PermissionForWhere(
        targets: [
          node.OperationCreate,
          node.OperationUpdate,
          node.OperationDelete,
        ],
        expression: node.BinaryOperator(
          lhs: node.Identifier("id"),
          operator: node.Equal,
          rhs: node.BinaryOperator(
            lhs: node.Parameter("auth"),
            operator: node.Access,
            rhs: node.Identifier("id"),
          ),
        ),
      ),
      node.PermissionForFull(targets: [node.OperationSelect]),
    ],
    as_: option.Some(node.Select(
      fields: [
        node.SelectField(
          field: node.Identifier("id"),
          alias: option.None,
          value: False,
        ),
      ],
      only: False,
      table: "user",
      where: option.None,
      order: option.None,
      limit: option.None,
      group_all: False,
    )),
  )
  |> node.to_string()
  |> should.equal(
    "DEFINE TABLE user TYPE NORMAL SCHEMAFULL "
    <> "AS SELECT id FROM user PERMISSIONS "
    <> "FOR create, update, delete WHERE id = $auth.id "
    <> "FOR select FULL",
  )
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                         Define Field                                          //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub fn define_simple_field_to_string_test() {
  node.DefineField(
    name: node.Identifier("name"),
    table: "user",
    type_: surreal_type.String,
    default: option.None,
    assert_: option.None,
    permissions: [node.PermissionFull],
    flexible: False,
  )
  |> node.to_string()
  |> should.equal("DEFINE FIELD name ON user TYPE string PERMISSIONS FULL")
}

pub fn define_field_with_default_to_string_test() {
  node.DefineField(
    name: node.Identifier("name"),
    table: "user",
    type_: surreal_type.String,
    default: option.Some(node.Value(surreal_ql.String("unknown"))),
    assert_: option.None,
    permissions: [node.PermissionFull],
    flexible: False,
  )
  |> node.to_string()
  |> should.equal(
    "DEFINE FIELD name ON user TYPE string DEFAULT \"unknown\" PERMISSIONS FULL",
  )
}

pub fn define_field_with_assert_to_string_test() {
  node.DefineField(
    name: node.Identifier("name"),
    table: "user",
    type_: surreal_type.String,
    default: option.None,
    assert_: option.Some(node.BinaryOperator(
      lhs: node.Parameter("value"),
      operator: node.NotEqual,
      rhs: node.None,
    )),
    permissions: [node.PermissionFull],
    flexible: False,
  )
  |> node.to_string()
  |> should.equal(
    "DEFINE FIELD name ON user TYPE string ASSERT $value != NONE PERMISSIONS FULL",
  )
}
