import gleam/dynamic
import gleam/erlang/process
import gleam/otp/actor
import gleam/result
import suweal
import suweal/wss/surreal_wss

pub fn start(
  connection: suweal.Connection,
  process: fn(surreal_wss.SurrealWssMessage) -> Nil,
) -> Result(surreal_wss.SurrealWssConnection, surreal_wss.SurrealWssError) {
  use mocked <- result.try(
    actor.new_with_initialiser(100, fn(self) {
      Nil |> actor.initialised() |> actor.returning(self) |> Ok
    })
    |> actor.on_message(fn(state, message) {
      process(message)
      actor.continue(state)
    })
    |> actor.start()
    |> result.replace_error(surreal_wss.FailedToConnect),
  )

  Ok(surreal_wss.SurrealWssConnection(mocked.data, connection))
}

pub fn reply(
  message: surreal_wss.SurrealWssMessage,
  response: surreal_wss.SurrealWssResponse(dynamic.Dynamic),
) {
  case message {
    surreal_wss.Query(receiver:, ..) -> process.send(receiver, response)
    surreal_wss.Signup(receiver:, ..) -> process.send(receiver, response)
    surreal_wss.Signin(receiver:, ..) -> process.send(receiver, response)
    surreal_wss.Use(receiver:, ..) -> process.send(receiver, response)
  }
}
