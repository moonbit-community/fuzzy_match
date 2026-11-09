///|
pub(open) trait StringLike {
  fn length(Self) -> Int32
  fn op_get(Self, Int32) -> Char
  fn is_empty(Self) -> Bool = _
  fn to_string(Self) -> String
  fn view(Self, Int32, Int32) -> StringView
}

///|
/// The character at UTF-16 offset `index`. `String` and `StringView` are
/// indexed by UTF-16 offset, the unit `view` slices by, so `length`, `op_get`
/// and `view` agree. Both halves of a surrogate pair read as the whole
/// character: text outside the Basic Multilingual Plane takes two positions
/// that each compare as that character, and a pair is matched or skipped as a
/// unit. An unpaired surrogate reads as U+FFFD.
fn char_at_offset(text : StringView, index : Int32) -> Char {
  if text.get_char(index) is Some(ch) {
    ch
  } else if index > 0 &&
    text.get_char(index - 1) is Some(ch) &&
    ch.to_int() > 0xFFFF {
    ch
  } else {
    '\u{FFFD}'
  }
}

///|
pub impl StringLike for String with fn length(self) {
  self.length()
}

///|
pub impl StringLike for String with fn op_get(self, index) {
  char_at_offset(self[:], index)
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
  self.length()
}

///|
pub impl StringLike for StringView with fn op_get(self, index) {
  char_at_offset(self, index)
}

///|
pub impl StringLike for StringView with fn view(self, start, end) {
  self.view(start_offset=start, end_offset=end)
}

///|
pub impl StringLike for StringView with fn to_string(self) {
  self.to_owned()
}
