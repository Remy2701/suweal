import gleam/string
import gleeunit/should
import omcg/module

pub fn assert_import(module: module.Module, expected: String) -> module.Module {
  module
  |> module.module_imports_to_string()
  |> should.equal(expected)
  module
}

pub fn assert_imports(
  module: module.Module,
  expected: List(String),
) -> module.Module {
  module
  |> module.module_imports_to_string()
  |> should.equal(string.join(expected, "\n"))
  module
}

pub fn assert_node(module: module.Module, expected: String) -> module.Module {
  module
  |> module.module_node_to_string()
  |> should.equal(expected)
  module
}
