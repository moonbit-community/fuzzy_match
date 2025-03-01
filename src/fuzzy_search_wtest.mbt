///|
test "score" {
  inspect!(score(Query::new("foo"), item="bar"), content="0")
  inspect!(score(Query::new("abc"), item="bbb bbb bbb abc bbb"), content="7")
  inspect!(score(Query::new("abc"), item="zz   zabc   zz"), content="967")
  inspect!(score(Query::new("abc"), item="__a__b__c__"), content="1447")
  inspect!(score(Query::new("ghi abc"), item="abc def ghi jkl"), content="969")
  inspect!(score(Query::new("ghi pqr"), item="abc def ghi jkl"), content="0")
}

///|
test "matching_indices" {
  inspect!(
    matching_indices(Query::new("abc"), item="a__abb____c_c"),
    content="Some([3, 4, 10])",
  )
  inspect!(
    matching_indices(Query::new("no_match"), item="can't match this"),
    content="None",
  )
  inspect!(
    matching_indices(Query::new("abc ab"), item="a__abb____c_c"),
    content="Some([3, 4, 10])",
  )
}

///|
test "search" {
  let items = ["___abc___", "aBc", "Abc_defgh", "abc", "foof"]
  inspect!(
    search(Query::new("abc"), items~),
    content=
      $|[\"aBc\", \"abc\", \"Abc_defgh\", \"___abc___\"]
    ,
  )
}

///|
test "split_by_matching_sections" {
  inspect!(
    split_by_matching_sections(Query::new("foo"), item="foo bar baz"),
    content=
      $|Some([(true, \"foo\"), (false, \" bar baz\")])
    ,
  )
  inspect!(
    split_by_matching_sections(Query::new("abc"), item="____abc____"),
    content=
      $|Some([(false, \"____\"), (true, \"abc\"), (false, \"____\")])
    ,
  )
  inspect!(
    split_by_matching_sections(Query::new("a ab"), item="a b"),
    content=
      $|Some([(true, \"a\"), (false, \" \"), (true, \"b\")])
    ,
  )
}
