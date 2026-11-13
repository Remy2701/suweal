import gleam/erlang/process
import gleam/option
import suweal
import suweal/wss/surreal_wss
import suweal/wss/surreal_wss_mock

pub fn surreal_wss_mock_reply_test() {
  let connection = suweal.Connection("", "main", "main", "")
  let assert Ok(connection) =
    surreal_wss_mock.start(connection, surreal_wss_mock.reply(
      _,
      surreal_wss.QueryResponse(1, []),
    ))

  let receiver = process.new_subject()
  surreal_wss.send_query(connection, "Hello", receiver)

  let assert Ok(received) = process.receive(receiver, 500)
  assert received == surreal_wss.QueryResponse(1, [])
}

pub fn surreal_wss_mock_reply_failure_test() {
  let connection = suweal.Connection("", "main", "main", "")
  let assert Ok(connection) =
    surreal_wss_mock.start(connection, surreal_wss_mock.reply(
      _,
      surreal_wss.ErrorResponse(
        0,
        surreal_wss.SurrealWssResponseError(
          cause: option.Some("Some error cause"),
          code: 1234,
          kind: "kind",
          message: "Some error message",
        ),
      ),
    ))

  let receiver = process.new_subject()
  surreal_wss.send_query(connection, "Hello", receiver)

  let assert Ok(received) = process.receive(receiver, 500)
  assert received
    == surreal_wss.ErrorResponse(
      0,
      surreal_wss.SurrealWssResponseError(
        cause: option.Some("Some error cause"),
        code: 1234,
        kind: "kind",
        message: "Some error message",
      ),
    )
}
