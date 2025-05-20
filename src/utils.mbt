///|
fn lowercase(ch : Char) -> Char {
  match ch {
    'A'..='Z' => ch.to_int() + 32 |> Int::unsafe_to_char
    _ => ch
  }
}

///|
test "lowercase/basic" {
  inspect!(lowercase('A'), content="a")
  inspect!(lowercase('B'), content="b")
  inspect!(lowercase('Z'), content="z")
}

///|
test "lowercase/already_lowercase" {
  inspect!(lowercase('a'), content="a")
  inspect!(lowercase('z'), content="z")
}

///|
test "lowercase/non_alpha" {
  inspect!(lowercase('1'), content="1")
  inspect!(lowercase('!'), content="!")
  inspect!(lowercase(' '), content=" ")
}

///|
fn equal_ignore_case(ch1 : Char, ch2 : Char) -> Bool {
  lowercase(ch1) == lowercase(ch2)
}

///|
let not_matching = false

///|
let matching = true

///|
fnalias @math.maximum as max
