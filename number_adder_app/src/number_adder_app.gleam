import gleam/erlang
import gleam/float
import gleam/io
import gleam/result
import gleam/string

pub fn main() {
  io.println(
    "Hey this application will add two floating point numbers together",
  )
  io.println("It will also demonstrate the Result type!")
  case execute() {
    Error(msg) -> io.println(msg)
    _ -> io.println("We did it!")
  }
}

fn execute() -> Result(Nil, String) {
  use left: Float <- result.try(get_number_from_console())
  use right: Float <- result.try(get_number_from_console())
  let result: Float = float.add(left, right)
  io.println("The result is: " <> float.to_string(result))
  Ok(Nil)
}

fn get_number_from_console() -> Result(Float, String) {
  case erlang.get_line("Please input a number: ") {
    Ok(num_val) -> map_float_result(num_val)
    Error(_) -> Error("Failed to get number from command line")
  }
}

fn map_float_result(input: String) -> Result(Float, String) {
  let cleaned = input |> string.trim
  case float.parse(cleaned) {
    Ok(number) -> Ok(number)
    Error(_) -> Error(cleaned <> " is not a floating point number")
  }
}
