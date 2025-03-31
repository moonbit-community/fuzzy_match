///|
test "is_match/basic" {
  inspect!(is_match(pattern="abc", text="abcdef"), content="true")
  inspect!(is_match(pattern="ace", text="abcdef"), content="true")
  inspect!(is_match(pattern="xyz", text="abcdef"), content="false")
}

///|
test "is_match/empty" {
  inspect!(is_match(pattern="", text="abc"), content="true")
  inspect!(is_match(pattern="abc", text=""), content="false")
  inspect!(is_match(pattern="", text=""), content="true")
}

///|
test "is_match/case_sensitive" {
  // Default char_equal should be case sensitive
  inspect!(is_match(pattern="ABC", text="abc"), content="false")
  // Custom char_equal for case insensitive matching
  let case_insensitive = fn(a : Char, b : Char) -> Bool {
    a.to_string().to_upper() == b.to_string().to_upper()
  }
  inspect!(
    is_match(char_equal=case_insensitive, pattern="ABC", text="abc"),
    content="true",
  )
}

///|
test "is_match" {
  inspect!(is_match(pattern="ab", text="abadwefe"), content="true")
}

// ///|
// test "@string.View" {
//   inspect!(is_match(pattern="ab", text="abadwefe"[0:-1]), content="true")
// }
