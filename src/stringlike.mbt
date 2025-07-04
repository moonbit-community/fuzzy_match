///|
pub(open) trait StringLike {
  length(Self) -> Int
  op_get(Self, Int) -> Char
  is_empty(Self) -> Bool = _
  to_string(Self) -> String
  view(Self, Int, Int) -> @string.View
}

///|
pub impl StringLike for String with length(self) {
  self.char_length()
}

///|
pub impl StringLike for String with op_get(self, index) {
  self.char_at(index)
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
pub impl StringLike for @string.View with length(self) {
  self.char_length()
}

///|
pub impl StringLike for @string.View with op_get(self, index) {
  self.char_at(index)
}

///|
pub impl StringLike for @string.View with view(self, start, end) {
  self.view(start_offset=start, end_offset=end)
}

///|
pub impl StringLike for @string.View with to_string(self) {
  self.to_string()
}
