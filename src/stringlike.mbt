///|
pub(open) trait StringLike {
  fn length(Self) -> Int
  fn op_get(Self, Int) -> Char
  fn is_empty(Self) -> Bool = _
  fn to_string(Self) -> String
  fn view(Self, Int, Int) -> StringView
}

///|
pub impl StringLike for String with fn length(self) {
  self.char_length()
}

///|
pub impl StringLike for String with fn op_get(self, index) {
  self.get_char(index).unwrap()
}

///|
pub impl StringLike for String with fn to_string(self) {
  self
}

///|
impl StringLike with fn is_empty(self) -> Bool {
  self.length() == 0
}

///|
pub impl StringLike for String with fn view(self, start, end) {
  self.view(start_offset=start, end_offset=end)
}

///|
pub impl StringLike for StringView with fn length(self) {
  self.char_length()
}

///|
pub impl StringLike for StringView with fn op_get(self, index) {
  self.get_char(index).unwrap()
}

///|
pub impl StringLike for StringView with fn view(self, start, end) {
  self.view(start_offset=start, end_offset=end)
}

///|
pub impl StringLike for StringView with fn to_string(self) {
  self.to_string()
}
