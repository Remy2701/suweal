import common
import gleam/option
import gleeunit/should
import suweal/node

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                           To String                                           //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub fn select_field_to_string_test() {
  node.SelectField(
    field: node.identifier.create("field"),
    alias: option.None,
    value: False,
  )
  |> node.select_field_to_string()
  |> should.equal("field")
}

pub fn select_value_field_to_string_test() {
  node.SelectField(
    field: node.identifier.create("field"),
    alias: option.None,
    value: True,
  )
  |> node.select_field_to_string()
  |> should.equal("VALUE field")
}

pub fn select_field_with_alias_to_string_test() {
  node.SelectField(
    field: node.identifier.create("field"),
    alias: option.Some("alias"),
    value: False,
  )
  |> node.select_field_to_string()
  |> should.equal("field AS alias")
}

pub fn select_value_field_with_alias_to_string_test() {
  node.SelectField(
    field: node.identifier.create("field"),
    alias: option.Some("alias"),
    value: True,
  )
  |> node.select_field_to_string()
  |> should.equal("VALUE field AS alias")
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //
//                                           To Module                                           //
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– //

pub fn select_field_to_module_test() {
  node.SelectField(
    field: node.identifier.create("field"),
    alias: option.None,
    value: False,
  )
  |> node.select_field_to_module()
  |> common.assert_imports([
    "import gleam/option",
    "import suweal/node",
  ])
  |> common.assert_node(
    "node.SelectField(\n"
    <> "  field: node.Identifier(\"field\"),\n"
    <> "  alias: option.None,\n"
    <> "  value: False,\n"
    <> ")",
  )
}

pub fn select_value_field_to_module_test() {
  node.SelectField(
    field: node.identifier.create("field"),
    alias: option.None,
    value: True,
  )
  |> node.select_field_to_module()
  |> common.assert_imports([
    "import gleam/option",
    "import suweal/node",
  ])
  |> common.assert_node(
    "node.SelectField("
    <> "field: node.Identifier(\"field\"), "
    <> "alias: option.None, "
    <> "value: True"
    <> ")",
  )
}

pub fn select_field_with_alias_to_module_test() {
  node.SelectField(
    field: node.identifier.create("field"),
    alias: option.Some("alias"),
    value: False,
  )
  |> node.select_field_to_module()
  |> common.assert_imports([
    "import gleam/option",
    "import suweal/node",
  ])
  |> common.assert_node(
    "node.SelectField(\n"
    <> "  field: node.Identifier(\"field\"),\n"
    <> "  alias: option.Some(\"alias\"),\n"
    <> "  value: False,\n"
    <> ")",
  )
}

pub fn select_value_field_with_alias_to_module_test() {
  node.SelectField(
    field: node.identifier.create("field"),
    alias: option.Some("alias"),
    value: True,
  )
  |> node.select_field_to_module()
  |> common.assert_imports([
    "import gleam/option",
    "import suweal/node",
  ])
  |> common.assert_node(
    "node.SelectField(\n"
    <> "  field: node.Identifier(\"field\"),\n"
    <> "  alias: option.Some(\"alias\"),\n"
    <> "  value: True,\n"
    <> ")",
  )
}
