///|
test "text outside the BMP neither aborts nor shifts later matches" {
  let query = @fuzzy_match.Query::new("dx")
  let item = "🚀 deploy x"
  assert_true(query.score(item~) > 0)
  debug_inspect(
    query.split_by_matching_sections(item~),
    content=(
      #|Some(
      #|  [
      #|    (false, <StringView: "🚀 ">),
      #|    (true, <StringView: "d">),
      #|    (false, <StringView: "eploy ">),
      #|    (true, <StringView: "x">),
      #|  ],
      #|)
    ),
  )
}

///|
test "a character outside the BMP matches only itself" {
  let query = @fuzzy_match.Query::new("🚀")
  assert_true(query.score(item="launch 🚀") > 0)
  assert_true(query.score(item="party 🎉") == 0)
  debug_inspect(
    query.split_by_matching_sections(item=("launch 🚀 now" : StringView)),
    content=(
      #|Some(
      #|  [
      #|    (false, <StringView: "launch ">),
      #|    (true, <StringView: "🚀">),
      #|    (false, <StringView: " now">),
      #|  ],
      #|)
    ),
  )
  assert_true(@fuzzy_match.is_match(pattern="a🚀", text="xa🎉🚀"))
}
