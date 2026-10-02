///|
test "Query::score" {
  inspect(Query::score(Query::new("foo"), item="bar"), content="0")
  inspect(
    Query::score(Query::new("abc"), item="bbb bbb bbb abc bbb"),
    content="7",
  )
  inspect(Query::score(Query::new("abc"), item="zz   zabc   zz"), content="967")
  inspect(Query::score(Query::new("abc"), item="__a__b__c__"), content="1447")
  inspect(
    Query::score(Query::new("ghi abc"), item="abc def ghi jkl"),
    content="969",
  )
  inspect(
    Query::score(Query::new("ghi pqr"), item="abc def ghi jkl"),
    content="0",
  )
}

///|
test "matching_indices" {
  debug_inspect(
    Query::matching_indices(Query::new("abc"), item="a__abb____c_c"),
    content="Some([3, 4, 10])",
  )
  debug_inspect(
    Query::matching_indices(Query::new("no_match"), item="can't match this"),
    content="None",
  )
  debug_inspect(
    Query::matching_indices(Query::new("abc ab"), item="a__abb____c_c"),
    content="Some([3, 4, 10])",
  )
}

///|
test "search" {
  let items = ["___abc___", "aBc", "Abc_defgh", "abc", "foof"]
  debug_inspect(
    Query::search(Query::new("abc"), items~),
    content=(
      #|[
      #|  <StringView: "aBc">,
      #|  <StringView: "abc">,
      #|  <StringView: "Abc_defgh">,
      #|  <StringView: "___abc___">,
      #|]
    ),
  )
}

///|
test "split_by_matching_sections" {
  debug_inspect(
    Query::split_by_matching_sections(Query::new("foo"), item="foo bar baz"),
    content=(
      #|Some([(true, <StringView: "foo">), (false, <StringView: " bar baz">)])
    ),
  )
  debug_inspect(
    Query::split_by_matching_sections(Query::new("abc"), item="____abc____"),
    content=(
      #|Some(
      #|  [
      #|    (false, <StringView: "____">),
      #|    (true, <StringView: "abc">),
      #|    (false, <StringView: "____">),
      #|  ],
      #|)
    ),
  )
  debug_inspect(
    Query::split_by_matching_sections(Query::new("a ab"), item="a b"),
    content=(
      #|Some(
      #|  [
      #|    (true, <StringView: "a">),
      #|    (false, <StringView: " ">),
      #|    (true, <StringView: "b">),
      #|  ],
      #|)
    ),
  )
}
