///|
pub(open) trait StringLike {
  length(Self) -> Int
  op_get(Self, Int) -> Char
  is_empty(Self) -> Bool = _
  to_string(Self) -> String
  view(Self, Int, Int) -> StringView
}

///|
pub impl StringLike for String with length(self) {
  self.char_length()
}

///|
pub impl StringLike for String with op_get(self, index) {
  self.get_char(index).unwrap()
}

///|
pub impl StringLike for String with to_string(self) {
  self
}

///|
impl StringLike with is_empty(self) -> Bool {
  self.length() == 0
}

///|
pub impl StringLike for String with view(self, start, end) {
  self.view(start_offset=start, end_offset=end)
}

///|
pub impl StringLike for StringView with length(self) {
  self.char_length()
}

///|
pub impl StringLike for StringView with op_get(self, index) {
  self.get_char(index).unwrap()
}

///|
pub impl StringLike for StringView with view(self, start, end) {
  self.view(start_offset=start, end_offset=end)
}

///|
pub impl StringLike for StringView with to_string(self) {
  self.to_string()
}
