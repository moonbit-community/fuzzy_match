///|
pub(open) trait StringLike {
  length(Self) -> Int
  op_get(Self, Int) -> Char
  is_empty(Self) -> Bool
  to_string(Self) -> String
  view(Self, Int, Int) -> @string.StringView
}

///|
pub impl StringLike for String with length(self) {
  self.length()
}

///|
pub impl StringLike for String with op_get(self, index) {
  self[index]
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

// ///|
// pub impl StringLike for @string.View with length(self) {
//   self.length()
// }

// ///|
// pub impl StringLike for @string.View with op_get(self, index) {
//   self[index]
// }
// ///|
// pub impl StringLike for @string.View with op_as_view(self, start, end) {
//   self[start:end]
// }

// ///|
// pub impl StringLike for @string.View with to_string(self) {
//   self.to_string()
// }
