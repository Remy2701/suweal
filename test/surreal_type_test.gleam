import gleam/option
import gleam/string
import gleeunit/should
import omcg/module
import suweal/surreal_type

//-----------------------------------------------------------------------------------------------//
//                                          From String                                          //
//-----------------------------------------------------------------------------------------------//

pub fn surreal_type_string_from_string_test() {
  "string"
  |> surreal_type.from_string
  |> should.be_ok()
  |> should.equal(surreal_type.String)
}

pub fn surreal_type_int_from_string_test() {
  "int"
  |> surreal_type.from_string
  |> should.be_ok()
  |> should.equal(surreal_type.Int)
}

pub fn surreal_type_float_from_string_test() {
  "float"
  |> surreal_type.from_string
  |> should.be_ok()
  |> should.equal(surreal_type.Float)
}

pub fn surreal_type_bool_from_string_test() {
  "bool"
  |> surreal_type.from_string
  |> should.be_ok()
  |> should.equal(surreal_type.Bool)
}

pub fn surreal_type_datetime_from_string_test() {
  "datetime"
  |> surreal_type.from_string
  |> should.be_ok()
  |> should.equal(surreal_type.Datetime)
}

pub fn surreal_type_option_from_string_test() {
  "none | string"
  |> surreal_type.from_string
  |> should.be_ok()
  |> should.equal(surreal_type.Option(surreal_type.String))
}

pub fn surreal_type_none_from_string_test() {
  "none"
  |> surreal_type.from_string
  |> should.be_ok()
  |> should.equal(surreal_type.None)
}

pub fn surreal_type_object_from_string_test() {
  "object"
  |> surreal_type.from_string
  |> should.be_ok()
  |> should.equal(surreal_type.Object)
}

pub fn invalid_surreal_type_from_string_test() {
  "invalid"
  |> surreal_type.from_string
  |> should.be_error()
}

//-----------------------------------------------------------------------------------------------//
//                                          To String                                          //
//-----------------------------------------------------------------------------------------------//

pub fn surreal_type_string_to_string_test() {
  surreal_type.String
  |> surreal_type.to_string
  |> should.equal("string")
}

pub fn surreal_type_int_to_string_test() {
  surreal_type.Int
  |> surreal_type.to_string
  |> should.equal("int")
}

pub fn surreal_type_float_to_string_test() {
  surreal_type.Float
  |> surreal_type.to_string
  |> should.equal("float")
}

pub fn surreal_type_bool_to_string_test() {
  surreal_type.Bool
  |> surreal_type.to_string
  |> should.equal("bool")
}

pub fn surreal_type_datetime_to_string_test() {
  surreal_type.Datetime
  |> surreal_type.to_string
  |> should.equal("datetime")
}

pub fn surreal_type_identifier_to_string_test() {
  surreal_type.Identifier("TYPE")
  |> surreal_type.to_string
  |> should.equal("string")
}

pub fn surreal_type_record_to_string_test() {
  surreal_type.Record("TYPE")
  |> surreal_type.to_string
  |> should.equal("record<TYPE>")
}

pub fn surreal_type_option_to_string_test() {
  surreal_type.Option(surreal_type.String)
  |> surreal_type.to_string
  |> should.equal("option<string>")
}

pub fn surreal_type_none_to_string_test() {
  surreal_type.None
  |> surreal_type.to_string
  |> should.equal("none")
}

pub fn surreal_type_array_to_string_test() {
  surreal_type.Array(surreal_type.String)
  |> surreal_type.to_string
  |> should.equal("array<string>")
}

pub fn surreal_type_point_to_string_test() {
  surreal_type.Point
  |> surreal_type.to_string
  |> should.equal("geometry<Point>")
}

pub fn surreal_type_object_to_string_test() {
  surreal_type.Object
  |> surreal_type.to_string
  |> should.equal("object")
}

//-----------------------------------------------------------------------------------------------//
//                                         To Gleam type                                         //
//-----------------------------------------------------------------------------------------------//

pub fn datetime_to_gleam_type_test() {
  let module =
    surreal_type.Datetime
    |> surreal_type.to_gleam_type

  module
  |> module.module_imports_to_string()
  |> should.equal("import gleam/time/timestamp")

  module
  |> module.module_node_to_string()
  |> should.equal("timestamp.Timestamp")
}

pub fn int_to_gleam_type_test() {
  let module =
    surreal_type.Int
    |> surreal_type.to_gleam_type

  module.imports
  |> should.equal([])

  module
  |> module.module_node_to_string()
  |> should.equal("Int")
}

pub fn float_to_gleam_type_test() {
  let module =
    surreal_type.Float
    |> surreal_type.to_gleam_type

  module.imports
  |> should.equal([])

  module
  |> module.module_node_to_string()
  |> should.equal("Float")
}

pub fn identifier_to_gleam_type_test() {
  let module =
    surreal_type.Identifier("inner")
    |> surreal_type.to_gleam_type

  module
  |> module.module_imports_to_string()
  |> should.equal("import suweal/identifier")

  module
  |> module.module_node_to_string()
  |> should.equal("identifier.Identifier(inner)")
}

pub fn record_to_gleam_type_test() {
  let module =
    surreal_type.Record("inner")
    |> surreal_type.to_gleam_type

  module
  |> module.module_imports_to_string()
  |> should.equal("import suweal/record")

  module
  |> module.module_node_to_string()
  |> should.equal("record.Record(inner)")
}

pub fn string_to_gleam_type_test() {
  let module =
    surreal_type.String
    |> surreal_type.to_gleam_type

  module.imports
  |> should.equal([])

  module
  |> module.module_node_to_string()
  |> should.equal("String")
}

pub fn bool_to_gleam_type_test() {
  let module =
    surreal_type.Bool
    |> surreal_type.to_gleam_type

  module.imports
  |> should.equal([])

  module
  |> module.module_node_to_string()
  |> should.equal("Bool")
}

pub fn string_option_to_gleam_type_test() {
  let module =
    surreal_type.Option(surreal_type.String)
    |> surreal_type.to_gleam_type

  module
  |> module.module_imports_to_string()
  |> should.equal("import gleam/option")

  module
  |> module.module_node_to_string()
  |> should.equal("option.Option(String)")
}

pub fn identifier_option_to_gleam_type_test() {
  let module =
    surreal_type.Option(surreal_type.Identifier("inner"))
    |> surreal_type.to_gleam_type

  module
  |> module.module_imports_to_string()
  |> should.equal(
    ["import gleam/option", "import suweal/identifier"] |> string.join("\n"),
  )

  module
  |> module.module_node_to_string()
  |> should.equal("option.Option(identifier.Identifier(inner))")
}

pub fn string_array_to_gleam_type_test() {
  let module =
    surreal_type.Array(surreal_type.String)
    |> surreal_type.to_gleam_type

  module.imports
  |> should.equal([])

  module
  |> module.module_node_to_string()
  |> should.equal("List(String)")
}

pub fn option_string_array_to_gleam_type_test() {
  let module =
    surreal_type.Array(surreal_type.Option(surreal_type.String))
    |> surreal_type.to_gleam_type

  module
  |> module.module_imports_to_string()
  |> should.equal("import gleam/option")

  module
  |> module.module_node_to_string()
  |> should.equal("List(option.Option(String))")
}

pub fn point_to_gleam_type_test() {
  let module =
    surreal_type.Point
    |> surreal_type.to_gleam_type

  module
  |> module.module_imports_to_string()
  |> should.equal("import suweal/point")

  module
  |> module.module_node_to_string()
  |> should.equal("point.Point")
}

pub fn object_to_gleam_type_test() {
  let module =
    surreal_type.Object
    |> surreal_type.to_gleam_type

  module
  |> module.module_imports_to_string()
  |> should.equal("import pont/value")

  module
  |> module.module_node_to_string()
  |> should.equal("value.Value")
}

pub fn none_to_gleam_type_test() {
  let module =
    surreal_type.None
    |> surreal_type.to_gleam_type

  module.imports
  |> should.equal([])

  module
  |> module.module_node_to_string()
  |> should.equal("Nil")
}

//-----------------------------------------------------------------------------------------------//
//                                         To Gleam module                                         //
//-----------------------------------------------------------------------------------------------//

pub fn datetime_to_gleam_module_test() {
  let module =
    surreal_type.Datetime
    |> surreal_type.to_gleam_module(option.None)

  module
  |> module.module_imports_to_string()
  |> should.equal("import gleam/time/timestamp")

  module
  |> module.module_node_to_string()
  |> should.equal("timestamp.Timestamp")
}

pub fn int_to_gleam_module_test() {
  let module =
    surreal_type.Int
    |> surreal_type.to_gleam_module(option.None)

  module.imports
  |> should.equal([])

  module
  |> module.module_node_to_string()
  |> should.equal("Int")
}

pub fn float_to_gleam_module_test() {
  let module =
    surreal_type.Float
    |> surreal_type.to_gleam_module(option.None)

  module.imports
  |> should.equal([])

  module
  |> module.module_node_to_string()
  |> should.equal("Float")
}

pub fn identifier_to_gleam_module_test() {
  let module =
    surreal_type.Identifier("inner")
    |> surreal_type.to_gleam_module(option.None)

  module
  |> module.module_imports_to_string()
  |> should.equal("import suweal/identifier")

  module
  |> module.module_node_to_string()
  |> should.equal("identifier.Identifier(inner)")
}

pub fn record_to_gleam_module_test() {
  let module =
    surreal_type.Record("inner")
    |> surreal_type.to_gleam_module(option.None)

  module
  |> module.module_imports_to_string()
  |> should.equal("import suweal/record")

  module
  |> module.module_node_to_string()
  |> should.equal("record.Record(inner)")
}

pub fn string_to_gleam_module_test() {
  let module =
    surreal_type.String
    |> surreal_type.to_gleam_module(option.None)

  module.imports
  |> should.equal([])

  module
  |> module.module_node_to_string()
  |> should.equal("String")
}

pub fn string_to_gleam_module_with_linked_enum_test() {
  let module =
    surreal_type.String
    |> surreal_type.to_gleam_module(option.Some("LinkedEnum"))

  module.imports
  |> should.equal([])

  module
  |> module.module_node_to_string()
  |> should.equal("LinkedEnum")
}

pub fn bool_to_gleam_module_test() {
  let module =
    surreal_type.Bool
    |> surreal_type.to_gleam_module(option.None)

  module.imports
  |> should.equal([])

  module
  |> module.module_node_to_string()
  |> should.equal("Bool")
}

pub fn string_option_to_gleam_module_test() {
  let module =
    surreal_type.Option(surreal_type.String)
    |> surreal_type.to_gleam_module(option.None)

  module
  |> module.module_imports_to_string()
  |> should.equal("import gleam/option")

  module
  |> module.module_node_to_string()
  |> should.equal("option.Option(String)")
}

pub fn string_option_to_gleam_module_with_linked_enum_test() {
  let module =
    surreal_type.Option(surreal_type.String)
    |> surreal_type.to_gleam_module(option.Some("LinkedEnum"))

  module
  |> module.module_imports_to_string()
  |> should.equal("import gleam/option")

  module
  |> module.module_node_to_string()
  |> should.equal("option.Option(LinkedEnum)")
}

pub fn identifier_option_to_gleam_module_test() {
  let module =
    surreal_type.Option(surreal_type.Identifier("inner"))
    |> surreal_type.to_gleam_module(option.None)

  module
  |> module.module_imports_to_string()
  |> should.equal(
    ["import gleam/option", "import suweal/identifier"] |> string.join("\n"),
  )

  module
  |> module.module_node_to_string()
  |> should.equal("option.Option(identifier.Identifier(inner))")
}

pub fn string_array_to_gleam_module_test() {
  let module =
    surreal_type.Array(surreal_type.String)
    |> surreal_type.to_gleam_module(option.None)

  module.imports
  |> should.equal([])

  module
  |> module.module_node_to_string()
  |> should.equal("List(String)")
}

pub fn string_array_to_gleam_module_with_linked_enum_test() {
  let module =
    surreal_type.Array(surreal_type.String)
    |> surreal_type.to_gleam_module(option.Some("LinkedEnum"))

  module.imports
  |> should.equal([])

  module
  |> module.module_node_to_string()
  |> should.equal("List(LinkedEnum)")
}

pub fn option_string_array_to_gleam_module_test() {
  let module =
    surreal_type.Array(surreal_type.Option(surreal_type.String))
    |> surreal_type.to_gleam_module(option.None)

  module
  |> module.module_imports_to_string()
  |> should.equal("import gleam/option")

  module
  |> module.module_node_to_string()
  |> should.equal("List(option.Option(String))")
}

pub fn option_string_array_with_linked_enum_to_gleam_module_test() {
  let module =
    surreal_type.Array(surreal_type.Option(surreal_type.String))
    |> surreal_type.to_gleam_module(option.Some("LinkedEnum"))

  module
  |> module.module_imports_to_string()
  |> should.equal("import gleam/option")

  module
  |> module.module_node_to_string()
  |> should.equal("List(option.Option(LinkedEnum))")
}

pub fn point_to_gleam_module_test() {
  let module =
    surreal_type.Point
    |> surreal_type.to_gleam_module(option.None)

  module
  |> module.module_imports_to_string()
  |> should.equal("import suweal/point")

  module
  |> module.module_node_to_string()
  |> should.equal("point.Point")
}

pub fn object_to_gleam_module_test() {
  let module =
    surreal_type.Object
    |> surreal_type.to_gleam_module(option.None)

  module
  |> module.module_imports_to_string()
  |> should.equal("import suweal/surreal_ql")

  module
  |> module.module_node_to_string()
  |> should.equal("surreal_ql.SurrealQL")
}

pub fn none_to_gleam_module_test() {
  let module =
    surreal_type.None
    |> surreal_type.to_gleam_module(option.None)

  module.imports
  |> should.equal([])

  module
  |> module.module_node_to_string()
  |> should.equal("Nil")
}

//-----------------------------------------------------------------------------------------------//
//                                         Value to Gleam module                                         //
//-----------------------------------------------------------------------------------------------//

pub fn datetime_value_to_gleam_module_test() {
  let module =
    surreal_type.Datetime
    |> surreal_type.value_to_gleam_module(option.None, "value")

  module
  |> module.module_imports_to_string()
  |> should.equal(
    [
      "import gleam/time/calendar",
      "import gleam/time/timestamp",
      "import suweal/surreal_ql",
    ]
    |> string.join("\n"),
  )

  module
  |> module.module_node_to_string()
  |> should.equal(
    "surreal_ql.Datetime(timestamp.to_rfc3339(value, calendar.utc_offset))",
  )
}

pub fn int_value_to_gleam_module_test() {
  let module =
    surreal_type.Int
    |> surreal_type.value_to_gleam_module(option.None, "value")

  module
  |> module.module_imports_to_string()
  |> should.equal("import suweal/surreal_ql")

  module
  |> module.module_node_to_string()
  |> should.equal("surreal_ql.Int(value)")
}

pub fn float_value_to_gleam_module_test() {
  let module =
    surreal_type.Float
    |> surreal_type.value_to_gleam_module(option.None, "value")

  module
  |> module.module_imports_to_string()
  |> should.equal("import suweal/surreal_ql")

  module
  |> module.module_node_to_string()
  |> should.equal("surreal_ql.Float(value)")
}

pub fn identifier_value_to_gleam_module_test() {
  let module =
    surreal_type.Identifier("inner")
    |> surreal_type.value_to_gleam_module(option.None, "value")

  module
  |> module.module_imports_to_string()
  |> should.equal(
    [
      "import suweal/identifier",
      "import suweal/surreal_ql",
    ]
    |> string.join("\n"),
  )

  module
  |> module.module_node_to_string()
  |> should.equal("surreal_ql.Raw(identifier.to_string(value))")
}

pub fn record_value_to_gleam_module_test() {
  let module =
    surreal_type.Record("inner")
    |> surreal_type.value_to_gleam_module(option.None, "value")

  module
  |> module.module_imports_to_string()
  |> should.equal(
    [
      "import suweal/identifier",
      "import suweal/surreal_ql",
    ]
    |> string.join("\n"),
  )

  module
  |> module.module_node_to_string()
  |> should.equal("surreal_ql.Raw(identifier.to_string(value.id))")
}

pub fn string_value_to_gleam_module_test() {
  let module =
    surreal_type.String
    |> surreal_type.value_to_gleam_module(option.None, "value")

  module
  |> module.module_imports_to_string()
  |> should.equal("import suweal/surreal_ql")

  module
  |> module.module_node_to_string()
  |> should.equal("surreal_ql.String(value)")
}

pub fn string_with_linked_enum_value_to_gleam_module_test() {
  let module =
    surreal_type.String
    |> surreal_type.value_to_gleam_module(
      option.Some("module.LinkedEnum"),
      "value",
    )

  module
  |> module.module_imports_to_string()
  |> should.equal("import suweal/surreal_ql")

  module
  |> module.module_node_to_string()
  |> should.equal("surreal_ql.String(module.linked_enum_to_string(value))")
}

pub fn string_with_linked_enum_without_module_value_to_gleam_module_test() {
  let module =
    surreal_type.String
    |> surreal_type.value_to_gleam_module(option.Some("LinkedEnum"), "value")

  module
  |> module.module_imports_to_string()
  |> should.equal("import suweal/surreal_ql")

  module
  |> module.module_node_to_string()
  |> should.equal("surreal_ql.String(linked_enum_to_string(value))")
}

pub fn bool_value_to_gleam_module_test() {
  let module =
    surreal_type.Bool
    |> surreal_type.value_to_gleam_module(option.None, "value")

  module
  |> module.module_imports_to_string()
  |> should.equal("import suweal/surreal_ql")

  module
  |> module.module_node_to_string()
  |> should.equal("surreal_ql.Bool(value)")
}

pub fn string_option_value_to_gleam_module_test() {
  let module =
    surreal_type.Option(surreal_type.String)
    |> surreal_type.value_to_gleam_module(option.None, "value")

  module
  |> module.module_imports_to_string()
  |> should.equal(
    [
      "import suweal/surreal_ql",
    ]
    |> string.join("\n"),
  )

  module
  |> module.module_node_to_string()
  |> should.equal(
    "surreal_ql.nullable(\n"
    <> "  value,\n"
    <> "  fn(value) {\n"
    <> "    surreal_ql.String(value)\n"
    <> "  },\n"
    <> ")",
  )
}

pub fn point_option_value_to_gleam_module_test() {
  let module =
    surreal_type.Option(surreal_type.Point)
    |> surreal_type.value_to_gleam_module(option.None, "value")

  module
  |> module.module_imports_to_string()
  |> should.equal(
    [
      "import suweal/point",
      "import suweal/surreal_ql",
    ]
    |> string.join("\n"),
  )

  module
  |> module.module_node_to_string()
  |> should.equal(
    "surreal_ql.nullable(\n"
    <> "  value,\n"
    <> "  fn(value) {\n"
    <> "    point.to_surql(value)\n"
    <> "  },\n"
    <> ")",
  )
}

pub fn string_option_with_linked_enum_value_to_gleam_module_test() {
  let module =
    surreal_type.Option(surreal_type.String)
    |> surreal_type.value_to_gleam_module(
      option.Some("module.LinkedEnum"),
      "value",
    )

  module
  |> module.module_imports_to_string()
  |> should.equal(
    [
      "import suweal/surreal_ql",
    ]
    |> string.join("\n"),
  )

  module
  |> module.module_node_to_string()
  |> should.equal(
    "surreal_ql.nullable(\n"
    <> "  value,\n"
    <> "  fn(value) {\n"
    <> "    surreal_ql.String(module.linked_enum_to_string(value))\n"
    <> "  },\n"
    <> ")",
  )
}

pub fn string_option_with_linked_enum_without_module_value_to_gleam_module_test() {
  let module =
    surreal_type.Option(surreal_type.String)
    |> surreal_type.value_to_gleam_module(option.Some("LinkedEnum"), "value")

  module
  |> module.module_imports_to_string()
  |> should.equal(
    [
      "import suweal/surreal_ql",
    ]
    |> string.join("\n"),
  )

  module
  |> module.module_node_to_string()
  |> should.equal(
    "surreal_ql.nullable(\n"
    <> "  value,\n"
    <> "  fn(value) {\n"
    <> "    surreal_ql.String(linked_enum_to_string(value))\n"
    <> "  },\n"
    <> ")",
  )
}

pub fn point_value_to_gleam_module_test() {
  let module =
    surreal_type.Point
    |> surreal_type.value_to_gleam_module(option.None, "value")

  module
  |> module.module_imports_to_string()
  |> should.equal("import suweal/point")

  module
  |> module.module_node_to_string()
  |> should.equal("point.to_surql(value)")
}

pub fn point_array_value_to_gleam_module_test() {
  let module =
    surreal_type.Array(surreal_type.Point)
    |> surreal_type.value_to_gleam_module(option.None, "value")

  module
  |> module.module_imports_to_string()
  |> should.equal(
    [
      "import suweal/point",
      "import suweal/surreal_ql",
    ]
    |> string.join("\n"),
  )

  module
  |> module.module_node_to_string()
  |> should.equal(
    "surreal_ql.array(\n"
    <> "  value,\n"
    <> "  fn(value) {\n"
    <> "    point.to_surql(value)\n"
    <> "  },\n"
    <> ")",
  )
}

pub fn string_array_value_to_gleam_module_test() {
  let module =
    surreal_type.Array(surreal_type.String)
    |> surreal_type.value_to_gleam_module(option.None, "value")

  module
  |> module.module_imports_to_string()
  |> should.equal(
    [
      "import suweal/surreal_ql",
    ]
    |> string.join("\n"),
  )

  module
  |> module.module_node_to_string()
  |> should.equal(
    "surreal_ql.array(\n"
    <> "  value,\n"
    <> "  fn(value) {\n"
    <> "    surreal_ql.String(value)\n"
    <> "  },\n"
    <> ")",
  )
}

pub fn string_array_with_linked_enum_value_to_gleam_module_test() {
  let module =
    surreal_type.Array(surreal_type.String)
    |> surreal_type.value_to_gleam_module(
      option.Some("module.LinkedEnum"),
      "value",
    )

  module
  |> module.module_imports_to_string()
  |> should.equal(
    [
      "import suweal/surreal_ql",
    ]
    |> string.join("\n"),
  )

  module
  |> module.module_node_to_string()
  |> should.equal(
    "surreal_ql.array(\n"
    <> "  value,\n"
    <> "  fn(value) {\n"
    <> "    surreal_ql.String(module.linked_enum_to_string(value))\n"
    <> "  },\n"
    <> ")",
  )
}

pub fn string_array_with_linked_enum_without_module_value_to_gleam_module_test() {
  let module =
    surreal_type.Array(surreal_type.String)
    |> surreal_type.value_to_gleam_module(option.Some("LinkedEnum"), "value")

  module
  |> module.module_imports_to_string()
  |> should.equal(
    [
      "import suweal/surreal_ql",
    ]
    |> string.join("\n"),
  )

  module
  |> module.module_node_to_string()
  |> should.equal(
    "surreal_ql.array(\n"
    <> "  value,\n"
    <> "  fn(value) {\n"
    <> "    surreal_ql.String(linked_enum_to_string(value))\n"
    <> "  },\n"
    <> ")",
  )
}

pub fn object_value_to_gleam_module_test() {
  let module =
    surreal_type.Object
    |> surreal_type.value_to_gleam_module(option.None, "value")

  module.imports
  |> should.equal([])

  module
  |> module.module_node_to_string()
  |> should.equal("value")
}

pub fn none_value_to_gleam_module_test() {
  let module =
    surreal_type.None
    |> surreal_type.value_to_gleam_module(option.None, "value")

  module
  |> module.module_imports_to_string()
  |> should.equal("import suweal/surreal_ql")

  module
  |> module.module_node_to_string()
  |> should.equal("surreal_ql.None")
}
