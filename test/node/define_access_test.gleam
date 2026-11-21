import gleeunit/should
import suweal/node.{binop, create, define_access, function_call, select}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                           To String                                           //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub fn define_access_to_string_test() {
  define_access.create("user")
  |> define_access.with_strategy(node.DefineAccessRegular)
  |> define_access.with_target(node.DefineAccessDatabase)
  |> node.to_string()
  |> should.equal("DEFINE ACCESS user ON DATABASE TYPE RECORD")
}

pub fn define_access_overwrite_node_to_string_test() {
  define_access.create("user")
  |> define_access.with_strategy(node.DefineAccessOverwrite)
  |> define_access.with_target(node.DefineAccessDatabase)
  |> node.to_string()
  |> should.equal("DEFINE ACCESS OVERWRITE user ON DATABASE TYPE RECORD")
}

pub fn define_access_if_not_node_exists_to_string_test() {
  define_access.create("user")
  |> define_access.with_strategy(node.DefineAccessIfNotExists)
  |> define_access.with_target(node.DefineAccessDatabase)
  |> node.to_string()
  |> should.equal("DEFINE ACCESS IF NOT EXISTS user ON DATABASE TYPE RECORD")
}

pub fn define_access_namespace_node_to_string_test() {
  define_access.create("user")
  |> define_access.with_strategy(node.DefineAccessRegular)
  |> define_access.with_target(node.DefineAccessNamespace)
  |> node.to_string()
  |> should.equal("DEFINE ACCESS user ON NAMESPACE TYPE RECORD")
}

pub fn define_access_root_node_to_string_test() {
  define_access.create("user")
  |> define_access.with_strategy(node.DefineAccessRegular)
  |> define_access.with_target(node.DefineAccessRoot)
  |> node.to_string()
  |> should.equal("DEFINE ACCESS user ON ROOT TYPE RECORD")
}

pub fn define_access_with_signin_to_string_test() {
  define_access.create("user")
  |> define_access.with_strategy(node.DefineAccessRegular)
  |> define_access.with_target(node.DefineAccessDatabase)
  |> define_access.with_signin(
    select.create("user")
    |> select.add_field(node.all.create())
    |> select.with_where(
      binop.equal(
        node.identifier.create("email"),
        node.parameter.create("email"),
      )
      |> binop.and(
        binop.namespace_access(
          node.identifier.create("crypto"),
          binop.namespace_access(
            node.identifier.create("argon2"),
            node.identifier.create("compare"),
          ),
        )
        |> function_call.create()
        |> function_call.add(node.identifier.create("password"))
        |> function_call.add(node.parameter.create("password")),
      ),
    ),
  )
  |> node.to_string()
  |> should.equal(
    "DEFINE ACCESS user ON DATABASE TYPE RECORD "
    <> "SIGNIN (SELECT * FROM user WHERE email = $email AND crypto::argon2::compare(password, $password))",
  )
}

pub fn define_access_with_signup_to_string_test() {
  define_access.create("user")
  |> define_access.with_strategy(node.DefineAccessRegular)
  |> define_access.with_target(node.DefineAccessDatabase)
  |> define_access.with_signup(
    create.create("user")
    |> create.add_set(binop.equal(
      node.identifier.create("email"),
      node.parameter.create("email"),
    ))
    |> create.add_set(binop.equal(
      node.identifier.create("password"),
      binop.namespace_access(
        node.identifier.create("crypto"),
        binop.namespace_access(
          node.identifier.create("argon2"),
          node.identifier.create("generate"),
        ),
      )
        |> function_call.create()
        |> function_call.add(node.parameter.create("password")),
    )),
  )
  |> node.to_string()
  |> should.equal(
    "DEFINE ACCESS user ON DATABASE TYPE RECORD "
    <> "SIGNUP (CREATE user SET email = $email, password = crypto::argon2::generate($password))",
  )
}

pub fn define_access_with_signin_and_signup_to_string_test() {
  define_access.create("user")
  |> define_access.with_strategy(node.DefineAccessRegular)
  |> define_access.with_target(node.DefineAccessDatabase)
  |> define_access.with_signin(
    select.create("user")
    |> select.add_field(node.all.create())
    |> select.with_where(
      binop.equal(
        node.identifier.create("email"),
        node.parameter.create("email"),
      )
      |> binop.and(
        binop.namespace_access(
          node.identifier.create("crypto"),
          binop.namespace_access(
            node.identifier.create("argon2"),
            node.identifier.create("compare"),
          ),
        )
        |> function_call.create()
        |> function_call.add(node.identifier.create("password"))
        |> function_call.add(node.parameter.create("password")),
      ),
    ),
  )
  |> define_access.with_signup(
    create.create("user")
    |> create.add_set(binop.equal(
      node.identifier.create("email"),
      node.parameter.create("email"),
    ))
    |> create.add_set(binop.equal(
      node.identifier.create("password"),
      binop.namespace_access(
        node.identifier.create("crypto"),
        binop.namespace_access(
          node.identifier.create("argon2"),
          node.identifier.create("generate"),
        ),
      )
        |> function_call.create()
        |> function_call.add(node.parameter.create("password")),
    )),
  )
  |> node.to_string()
  |> should.equal(
    "DEFINE ACCESS user ON DATABASE TYPE RECORD "
    <> "SIGNUP (CREATE user SET email = $email, password = crypto::argon2::generate($password)) "
    <> "SIGNIN (SELECT * FROM user WHERE email = $email AND crypto::argon2::compare(password, $password))",
  )
}

pub fn define_access_with_signin_and_signup_with_jwt_to_string_test() {
  define_access.create("user")
  |> define_access.with_strategy(node.DefineAccessRegular)
  |> define_access.with_target(node.DefineAccessDatabase)
  |> define_access.with_signin(
    select.create("user")
    |> select.add_field(node.all.create())
    |> select.with_where(
      binop.equal(
        node.identifier.create("email"),
        node.parameter.create("email"),
      )
      |> binop.and(
        binop.namespace_access(
          node.identifier.create("crypto"),
          binop.namespace_access(
            node.identifier.create("argon2"),
            node.identifier.create("compare"),
          ),
        )
        |> function_call.create()
        |> function_call.add(node.identifier.create("password"))
        |> function_call.add(node.parameter.create("password")),
      ),
    ),
  )
  |> define_access.with_signup(
    create.create("user")
    |> create.add_set(binop.equal(
      node.identifier.create("email"),
      node.parameter.create("email"),
    ))
    |> create.add_set(binop.equal(
      node.identifier.create("password"),
      binop.namespace_access(
        node.identifier.create("crypto"),
        binop.namespace_access(
          node.identifier.create("argon2"),
          node.identifier.create("generate"),
        ),
      )
        |> function_call.create()
        |> function_call.add(node.parameter.create("password")),
    )),
  )
  |> define_access.with_jwt_config(node.JWTConfiguration(
    algorithm: node.value.string("HS256"),
    key: node.value.string("secret"),
  ))
  |> node.to_string()
  |> should.equal(
    "DEFINE ACCESS user ON DATABASE TYPE RECORD "
    <> "SIGNUP (CREATE user SET email = $email, password = crypto::argon2::generate($password)) "
    <> "SIGNIN (SELECT * FROM user WHERE email = $email AND crypto::argon2::compare(password, $password)) "
    <> "WITH JWT ALGORITHM \"HS256\" KEY \"secret\"",
  )
}

pub fn define_access_with_signin_and_signup_no_double_wrap_to_string_test() {
  define_access.create("user")
  |> define_access.with_strategy(node.DefineAccessRegular)
  |> define_access.with_target(node.DefineAccessDatabase)
  |> define_access.with_signin(
    select.create("user")
    |> select.add_field(node.all.create())
    |> select.with_where(
      binop.equal(
        node.identifier.create("email"),
        node.parameter.create("email"),
      )
      |> binop.and(
        binop.namespace_access(
          node.identifier.create("crypto"),
          binop.namespace_access(
            node.identifier.create("argon2"),
            node.identifier.create("compare"),
          ),
        )
        |> function_call.create()
        |> function_call.add(node.identifier.create("password"))
        |> function_call.add(node.parameter.create("password")),
      ),
    )
    |> node.wrapped.create(),
  )
  |> define_access.with_signup(
    create.create("user")
    |> create.add_set(binop.equal(
      node.identifier.create("email"),
      node.parameter.create("email"),
    ))
    |> create.add_set(binop.equal(
      node.identifier.create("password"),
      binop.namespace_access(
        node.identifier.create("crypto"),
        binop.namespace_access(
          node.identifier.create("argon2"),
          node.identifier.create("generate"),
        ),
      )
        |> function_call.create()
        |> function_call.add(node.parameter.create("password")),
    ))
    |> node.wrapped.create(),
  )
  |> node.to_string()
  |> should.equal(
    "DEFINE ACCESS user ON DATABASE TYPE RECORD "
    <> "SIGNUP (CREATE user SET email = $email, password = crypto::argon2::generate($password)) "
    <> "SIGNIN (SELECT * FROM user WHERE email = $email AND crypto::argon2::compare(password, $password))",
  )
}
