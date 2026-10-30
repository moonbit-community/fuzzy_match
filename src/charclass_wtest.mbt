///|
test "CharClass::from_char/uppercase ASCII" {
  let is_upper = fn(ch) {
    match CharClass::from_char(ch) {
      Upper => true
      _ => false
    }
  }
  inspect(is_upper('A'), content="true")
  inspect(is_upper('B'), content="true")
  inspect(is_upper('Z'), content="true")
}
