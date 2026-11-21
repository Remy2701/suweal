import gleeunit/should
import suweal/node.{binop, define_field}
import suweal/surreal_type

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                           To String                                           //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub fn define_simple_field_to_string_test() {
  define_field.create(
    node.identifier.create("name"),
    "user",
    surreal_type.String,
  )
  |> define_field.with_strategy(node.DefineFieldRegular)
  |> define_field.add_permission(node.PermissionFull)
  |> node.to_string()
  |> should.equal("DEFINE FIELD name ON user TYPE string PERMISSIONS FULL")
}

pub fn define_simple_overwrite_field_to_string_test() {
  define_field.create(
    node.identifier.create("name"),
    "user",
    surreal_type.String,
  )
  |> define_field.with_strategy(node.DefineFieldOverwrite)
  |> define_field.add_permission(node.PermissionFull)
  |> node.to_string()
  |> should.equal(
    "DEFINE FIELD OVERWRITE name ON user TYPE string PERMISSIONS FULL",
  )
}

pub fn define_simple_if_not_exists_field_to_string_test() {
  define_field.create(
    node.identifier.create("name"),
    "user",
    surreal_type.String,
  )
  |> define_field.with_strategy(node.DefineFieldIfNotExists)
  |> define_field.add_permission(node.PermissionFull)
  |> node.to_string()
  |> should.equal(
    "DEFINE FIELD IF NOT EXISTS name ON user TYPE string PERMISSIONS FULL",
  )
}

pub fn define_field_with_default_to_string_test() {
  define_field.create(
    node.identifier.create("name"),
    "user",
    surreal_type.String,
  )
  |> define_field.with_strategy(node.DefineFieldRegular)
  |> define_field.add_permission(node.PermissionFull)
  |> define_field.with_default(node.value.string("unknown"))
  |> node.to_string()
  |> should.equal(
    "DEFINE FIELD name ON user TYPE string DEFAULT \"unknown\" PERMISSIONS FULL",
  )
}

pub fn define_field_with_assert_to_string_test() {
  define_field.create(
    node.identifier.create("name"),
    "user",
    surreal_type.String,
  )
  |> define_field.with_strategy(node.DefineFieldRegular)
  |> define_field.add_permission(node.PermissionFull)
  |> define_field.with_assert(binop.not_equal(
    node.parameter.create("value"),
    node.none.create(),
  ))
  |> node.to_string()
  |> should.equal(
    "DEFINE FIELD name ON user TYPE string ASSERT $value != NONE PERMISSIONS FULL",
  )
}

pub fn define_flexible_object_field_to_string_test() {
  define_field.create(
    node.identifier.create("name"),
    "user",
    surreal_type.Object,
  )
  |> define_field.with_strategy(node.DefineFieldRegular)
  |> define_field.add_permission(node.PermissionFull)
  |> define_field.set_flexible(True)
  |> node.to_string()
  |> should.equal(
    "DEFINE FIELD name ON user TYPE object FLEXIBLE PERMISSIONS FULL",
  )
}

pub fn define_nested_object_field_to_string_test() {
  define_field.create(
    binop.access(
      node.identifier.create("settings"),
      node.identifier.create("notification"),
    ),
    "user",
    surreal_type.Bool,
  )
  |> define_field.with_strategy(node.DefineFieldRegular)
  |> define_field.add_permission(node.PermissionFull)
  |> node.to_string()
  |> should.equal(
    "DEFINE FIELD settings.notification ON user TYPE bool PERMISSIONS FULL",
  )
}
