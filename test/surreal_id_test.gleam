import gleam/list
import gleam/option
import gleam/string
import suweal/identifier

pub fn surreal_rand_id_test() {
  let id = identifier.generate(option.None)
  assert id.type_ == option.None as "Expected untyped identifier"
  assert string.length(id.id) == 20 as "Expected identifier to be 20 characters"

  let allowed_characters = "abcdefghijklmnopqrstuvwxyz0123456789"
  string.to_graphemes(id.id)
  |> list.each(fn(grapheme) {
    assert string.contains(allowed_characters, grapheme)
      as "Expected identifier to only contain allowed characters"
  })
}

pub fn surreal_identifier_from_string_test() {
  let assert Ok(id) = identifier.from_string("user:123")
  assert id.id == "123"
  assert id.type_ == option.Some("user")

  assert identifier.to_string(id) == "user:123"
}

pub fn surreal_identifier_from_string_without_type_test() {
  let assert Ok(id) = identifier.from_string("123")
  assert id.id == "123"
  assert id.type_ == option.None

  assert identifier.to_string(id) == "123"
}

pub fn surreal_invalid_identifier_from_string_test() {
  let assert Error(Nil) = identifier.from_string(":::123")
  let assert Error(Nil) = identifier.from_string(string.repeat("a", 30))
  let assert Error(Nil) =
    identifier.from_string(string.repeat("a", 30) <> ":123")
  let assert Error(Nil) =
    identifier.from_string("type:" <> string.repeat("a", 30))
  let assert Error(Nil) = identifier.from_string("")
}

pub fn surreal_identifier_typed_test() {
  let identifier = identifier.Identifier(option.Some("user"), "123")
  assert identifier.id == "123"
  assert identifier.type_ == option.Some("user")
  let identifier = identifier.typed(identifier, "new")
  assert identifier.type_ == option.Some("new")
  assert identifier.id == "123"
}

pub fn surreal_identifier_untyped_test() {
  let identifier = identifier.Identifier(option.Some("user"), "123")
  assert identifier.id == "123"
  assert identifier.type_ == option.Some("user")
  let identifier = identifier.untyped(identifier)
  assert identifier.type_ == option.None
  assert identifier.id == "123"
}
