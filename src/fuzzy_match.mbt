///|
/// fuzzy match
/// 
/// This implementation refers to 
/// [Ocaml janestreet fuzzy_match](https://github.com/janestreet/fuzzy_match/blob/master/match/src/fuzzy_match.ml)
pub fn[Pattern : StringLike, Text : StringLike] is_match(
  char_equal? : (Char, Char) -> Bool = Char::equal,
  pattern~ : Pattern,
  text~ : Text,
) -> Bool {
  let mut pattern_idx = 0
  let mut text_idx = 0
  for {
    if pattern_idx == pattern.length() {
      break true
    }
    if text_idx == text.length() {
      break false
    }
    if char_equal(pattern[pattern_idx], text[text_idx]) {
      pattern_idx += 1
      text_idx += 1
    } else {
      text_idx += 1
    }
  }
}
