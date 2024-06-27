import argv
import gleam/bool
import gleam/int
import gleam/io
import gleam/list
import gleam/string
import glint.{type Command}
import simplifile as file
import sqlight

type Person {
  Person(name: String, age: Int, favorite: String)
}

pub fn main() {
  todo
}

fn create_file_flag() -> glint.Flag(String) {
  glint.string_flag("file")
  |> glint.flag_default("")
  |> glint.flag_help("Sets the file path for the csv import process")
}

fn handle_csv() -> glint.Command(Nil) {
  use <- glint.command_help(
    "Imports the data from the given CSV into the SQLITE database",
  )
  use file_flag <- glint.flag(create_file_flag())
  use _, _, flags <- glint.command()
  let assert Ok(file) = file_flag(flags)
  case process_csv(file) {
    Ok(_) -> Nil
    Error(msg) -> io.println(msg)
  }
}

fn process_csv(path: String) -> Result(Nil, String) {
  let assert Ok(exists) = file.is_file(path)
  use <- bool.guard(bool.negate(exists), Error("File does not exist"))
  case file.read(path) {
    Ok(data) -> {
      let content =
        data
        |> string.split("\n")
        |> list.map(fn(line) { convert_line_to_person(line) })
      Ok(Nil)
    }
    Error(_) -> Error("Failed to read data from " <> path)
  }
}

fn convert_line_to_person(input: String) -> Person {
  let data = input |> string.split(",")
  let assert Ok(#(name, next)) = get_name(data)
  let assert Ok(#(age, next_two)) = get_age(next)
  let assert Ok(fav) = get_favorite(next_two)
  Person(name: name, age: age, favorite: fav)
}

fn get_name(input: List(String)) -> Result(#(String, List(String)), Nil) {
  case input {
    [head, ..tail] -> Ok(#(head, tail))
    _ -> Error(Nil)
  }
}

fn get_age(input: List(String)) -> Result(#(Int, List(String)), Nil) {
  case input {
    [head, ..tail] -> {
      let assert Ok(val) = int.parse(head)
      Ok(#(val, tail))
    }
    _ -> Error(Nil)
  }
}

fn get_favorite(input: List(String)) -> Result(String, Nil) {
  case input {
    [head, _] -> Ok(head)
    _ -> Error(Nil)
  }
}

fn write_content_to_db(input: List(Person)) -> Result(Nil, String) {
  todo
}
