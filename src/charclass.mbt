///|
priv enum CharClass {
  Upper
  Lower
  Digit
  NonWord
}

///|
fn CharClass::from_char(ch : Char) -> CharClass {
  match ch {
    'A'..='Z' => Upper
    'a'..='z' => Lower
    '0'..='9' => Digit
    _ => NonWord
  }
}
