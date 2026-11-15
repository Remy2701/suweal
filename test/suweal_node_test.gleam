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
    strategy: node.DefineTableRegular,
    schema: node.Schemafull,
    type_: node.NormalTable,
    permissions: [node.PermissionFull],
    as_: option.None,
  )
  |> node.to_string()
  |> should.equal("DEFINE TABLE user TYPE NORMAL SCHEMAFULL PERMISSIONS FULL")
}

pub fn define_simple_table_overwrite_to_string_test() {
  node.DefineTable(
    name: "user",
    strategy: node.DefineTableOverwrite,
    schema: node.Schemafull,
    type_: node.NormalTable,
    permissions: [node.PermissionFull],
    as_: option.None,
  )
  |> node.to_string()
  |> should.equal(
    "DEFINE TABLE OVERWRITE user TYPE NORMAL SCHEMAFULL PERMISSIONS FULL",
  )
}

pub fn define_simple_table_if_not_exists_to_string_test() {
  node.DefineTable(
    name: "user",
    strategy: node.DefineTableIfNotExists,
    schema: node.Schemafull,
    type_: node.NormalTable,
    permissions: [node.PermissionFull],
    as_: option.None,
  )
  |> node.to_string()
  |> should.equal(
    "DEFINE TABLE IF NOT EXISTS user TYPE NORMAL SCHEMAFULL PERMISSIONS FULL",
  )
}

pub fn define_relation_table_to_string_test() {
  node.DefineTable(
    name: "user",
    strategy: node.DefineTableRegular,
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
    strategy: node.DefineTableRegular,
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
    strategy: node.DefineFieldRegular,
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

pub fn define_simple_overwrite_field_to_string_test() {
  node.DefineField(
    name: node.Identifier("name"),
    strategy: node.DefineFieldOverwrite,
    table: "user",
    type_: surreal_type.String,
    default: option.None,
    assert_: option.None,
    permissions: [node.PermissionFull],
    flexible: False,
  )
  |> node.to_string()
  |> should.equal(
    "DEFINE FIELD OVERWRITE name ON user TYPE string PERMISSIONS FULL",
  )
}

pub fn define_simple_if_not_exists_field_to_string_test() {
  node.DefineField(
    name: node.Identifier("name"),
    strategy: node.DefineFieldIfNotExists,
    table: "user",
    type_: surreal_type.String,
    default: option.None,
    assert_: option.None,
    permissions: [node.PermissionFull],
    flexible: False,
  )
  |> node.to_string()
  |> should.equal(
    "DEFINE FIELD IF NOT EXISTS name ON user TYPE string PERMISSIONS FULL",
  )
}

pub fn define_field_with_default_to_string_test() {
  node.DefineField(
    name: node.Identifier("name"),
    strategy: node.DefineFieldRegular,
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
    strategy: node.DefineFieldRegular,
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

pub fn define_flexible_object_field_to_string_test() {
  node.DefineField(
    name: node.Identifier("name"),
    strategy: node.DefineFieldRegular,
    table: "user",
    type_: surreal_type.Object,
    default: option.None,
    assert_: option.None,
    permissions: [node.PermissionFull],
    flexible: True,
  )
  |> node.to_string()
  |> should.equal(
    "DEFINE FIELD name ON user TYPE object FLEXIBLE PERMISSIONS FULL",
  )
}

pub fn define_nested_object_field_to_string_test() {
  node.DefineField(
    name: node.BinaryOperator(
      node.Identifier("settings"),
      node.Access,
      node.Identifier("notification"),
    ),
    strategy: node.DefineFieldRegular,
    table: "user",
    type_: surreal_type.Bool,
    default: option.None,
    assert_: option.None,
    permissions: [node.PermissionFull],
    flexible: False,
  )
  |> node.to_string()
  |> should.equal(
    "DEFINE FIELD settings.notification ON user TYPE bool PERMISSIONS FULL",
  )
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                         Define Access                                         //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub fn define_access_to_string_test() {
  node.DefineAccess(
    name: "user",
    strategy: node.DefineAccessRegular,
    target: node.DefineAccessDatabase,
    type_: node.DefineAccessRecord(signin: option.None, signup: option.None),
  )
  |> node.to_string()
  |> should.equal("DEFINE ACCESS user ON DATABASE TYPE RECORD")
}

pub fn define_access_overwrite_to_string_test() {
  node.DefineAccess(
    name: "user",
    strategy: node.DefineAccessOverwrite,
    target: node.DefineAccessDatabase,
    type_: node.DefineAccessRecord(signin: option.None, signup: option.None),
  )
  |> node.to_string()
  |> should.equal("DEFINE ACCESS OVERWRITE user ON DATABASE TYPE RECORD")
}

pub fn define_access_if_not_exists_to_string_test() {
  node.DefineAccess(
    name: "user",
    strategy: node.DefineAccessIfNotExists,
    target: node.DefineAccessDatabase,
    type_: node.DefineAccessRecord(signin: option.None, signup: option.None),
  )
  |> node.to_string()
  |> should.equal("DEFINE ACCESS IF NOT EXISTS user ON DATABASE TYPE RECORD")
}

pub fn define_access_namespace_to_string_test() {
  node.DefineAccess(
    name: "user",
    strategy: node.DefineAccessRegular,
    target: node.DefineAccessNamespace,
    type_: node.DefineAccessRecord(signin: option.None, signup: option.None),
  )
  |> node.to_string()
  |> should.equal("DEFINE ACCESS user ON NAMESPACE TYPE RECORD")
}

pub fn define_access_root_to_string_test() {
  node.DefineAccess(
    name: "user",
    strategy: node.DefineAccessRegular,
    target: node.DefineAccessRoot,
    type_: node.DefineAccessRecord(signin: option.None, signup: option.None),
  )
  |> node.to_string()
  |> should.equal("DEFINE ACCESS user ON ROOT TYPE RECORD")
}

pub fn define_access_with_signin_to_string_test() {
  node.DefineAccess(
    name: "user",
    strategy: node.DefineAccessRegular,
    target: node.DefineAccessDatabase,
    type_: node.DefineAccessRecord(
      signin: option.Some(node.Select(
        fields: [
          node.SelectField(field: node.All, alias: option.None, value: False),
        ],
        only: False,
        table: "user",
        where: option.Some(node.BinaryOperator(
          lhs: node.BinaryOperator(
            lhs: node.Identifier("email"),
            operator: node.Equal,
            rhs: node.Parameter("email"),
          ),
          operator: node.And,
          rhs: node.FunctionCall(
            node: node.BinaryOperator(
              lhs: node.Identifier("crypto"),
              operator: node.NamespaceAccess,
              rhs: node.BinaryOperator(
                lhs: node.Identifier("argon2"),
                operator: node.NamespaceAccess,
                rhs: node.Identifier("compare"),
              ),
            ),
            arguments: [
              node.Identifier("password"),
              node.Parameter("password"),
            ],
          ),
        )),
        order: option.None,
        limit: option.None,
        group_all: False,
      )),
      signup: option.None,
    ),
  )
  |> node.to_string()
  |> should.equal(
    "DEFINE ACCESS user ON DATABASE TYPE RECORD "
    <> "SIGNIN (SELECT * FROM user WHERE email = $email AND crypto::argon2::compare(password, $password))",
  )
}

pub fn define_access_with_signup_to_string_test() {
  node.DefineAccess(
    name: "user",
    strategy: node.DefineAccessRegular,
    target: node.DefineAccessDatabase,
    type_: node.DefineAccessRecord(
      signin: option.None,
      signup: option.Some(
        node.Create(only: False, target: "user", set: [
          node.BinaryOperator(
            lhs: node.Identifier("email"),
            operator: node.Equal,
            rhs: node.Parameter("email"),
          ),
          node.BinaryOperator(
            lhs: node.Identifier("password"),
            operator: node.Equal,
            rhs: node.FunctionCall(
              node: node.BinaryOperator(
                lhs: node.Identifier("crypto"),
                operator: node.NamespaceAccess,
                rhs: node.BinaryOperator(
                  lhs: node.Identifier("argon2"),
                  operator: node.NamespaceAccess,
                  rhs: node.Identifier("generate"),
                ),
              ),
              arguments: [
                node.Parameter("password"),
              ],
            ),
          ),
        ]),
      ),
    ),
  )
  |> node.to_string()
  |> should.equal(
    "DEFINE ACCESS user ON DATABASE TYPE RECORD "
    <> "SIGNUP (CREATE user SET email = $email, password = crypto::argon2::generate($password))",
  )
}

pub fn define_access_with_signin_and_signup_to_string_test() {
  node.DefineAccess(
    name: "user",
    strategy: node.DefineAccessRegular,
    target: node.DefineAccessDatabase,
    type_: node.DefineAccessRecord(
      signin: option.Some(node.Select(
        fields: [
          node.SelectField(field: node.All, alias: option.None, value: False),
        ],
        only: False,
        table: "user",
        where: option.Some(node.BinaryOperator(
          lhs: node.BinaryOperator(
            lhs: node.Identifier("email"),
            operator: node.Equal,
            rhs: node.Parameter("email"),
          ),
          operator: node.And,
          rhs: node.FunctionCall(
            node: node.BinaryOperator(
              lhs: node.Identifier("crypto"),
              operator: node.NamespaceAccess,
              rhs: node.BinaryOperator(
                lhs: node.Identifier("argon2"),
                operator: node.NamespaceAccess,
                rhs: node.Identifier("compare"),
              ),
            ),
            arguments: [
              node.Identifier("password"),
              node.Parameter("password"),
            ],
          ),
        )),
        order: option.None,
        limit: option.None,
        group_all: False,
      )),
      signup: option.Some(
        node.Create(only: False, target: "user", set: [
          node.BinaryOperator(
            lhs: node.Identifier("email"),
            operator: node.Equal,
            rhs: node.Parameter("email"),
          ),
          node.BinaryOperator(
            lhs: node.Identifier("password"),
            operator: node.Equal,
            rhs: node.FunctionCall(
              node: node.BinaryOperator(
                lhs: node.Identifier("crypto"),
                operator: node.NamespaceAccess,
                rhs: node.BinaryOperator(
                  lhs: node.Identifier("argon2"),
                  operator: node.NamespaceAccess,
                  rhs: node.Identifier("generate"),
                ),
              ),
              arguments: [
                node.Parameter("password"),
              ],
            ),
          ),
        ]),
      ),
    ),
  )
  |> node.to_string()
  |> should.equal(
    "DEFINE ACCESS user ON DATABASE TYPE RECORD "
    <> "SIGNUP (CREATE user SET email = $email, password = crypto::argon2::generate($password)) "
    <> "SIGNIN (SELECT * FROM user WHERE email = $email AND crypto::argon2::compare(password, $password))",
  )
}
