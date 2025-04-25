///|
struct Query {
  queries : Array[String]
  raw : String
  case_sensitive : Bool
}

///|
fn Query::is_empty(self : Query) -> Bool {
  self.raw.is_empty()
}

///|
pub fn Query::new(query : String) -> Query {
  let queries = query
    .split(" ")
    .filter_map(fn(s) {
      if not(s.is_empty()) {
        Some(s.to_string())
      } else {
        None
      }
    })
    .collect()
  let case_sensitive = query.iter().any(@char.is_ascii_uppercase)
  { queries, raw: query, case_sensitive }
}

///|
pub fn split_by_matching_sections[Item : StringLike](
  self : Query,
  item~ : Item
) -> Array[(Bool, @string.View)]? {
  match matching_indices(self, item~) {
    None => None
    Some([]) => Some([(not_matching, item.view(0, item.length()))])
    Some(matches) => {
      let sections = @deque.new()
      fn add_section(matching, start, end_inclusive) {
        sections.push_back((matching, item.view(start, end_inclusive + 1)))
      }

      let first = matches[0]
      if first > 0 {
        add_section(not_matching, 0, first - 1)
      }
      let mut matching_range_start = first
      let mut matching_range_end = first
      matches.each(fn(idx) {
        if idx > matching_range_end + 1 {
          add_section(matching, matching_range_start, matching_range_end)
          add_section(not_matching, matching_range_end + 1, idx - 1)
          matching_range_start = idx
        }
        matching_range_end = idx
      })
      add_section(matching, matching_range_start, matching_range_end)
      if matching_range_end < item.length() - 1 {
        add_section(not_matching, matching_range_end + 1, item.length() - 1)
      }
      Some(sections.to_array())
    }
  }
}

///| fuzzy_search
///   
/// This implementation refers to 
/// [Ocaml janestreet fuzzy_match](https://github.com/janestreet/fuzzy_match/blob/master/search/src/fuzzy_search.ml)
pub fn search[Item : StringLike + Compare](
  self : Query,
  items~ : Array[Item]
) -> Array[@string.View] {
  let items_by_score = items.filter_map(fn(item) {
    match score(self, item~) {
      0 => None
      score => Some((score, item.length(), item))
    }
  })
  items_by_score.sort()
  items_by_score.map(fn(t) {
    let item = t.2
    item.view(0, item.length())
  })
}

///|
pub fn matching_indices[Item : StringLike](
  self : Query,
  item~ : Item
) -> Array[Int]? {
  if self.is_empty() {
    Some([])
  } else {
    let indices = self.queries.fold(init=Set::new(), fn(set, query) {
      fold_matching_indices_single_query(query, item~, init=set, f=fn(
        set,
        query
      ) {
        set..add(query)
      })
    })
    if indices.is_empty() {
      None
    } else {
      Some(indices.to_array())
    }
  }
}

///|
pub fn score[Item : StringLike](self : Query, item~ : Item) -> Int {
  match (item.is_empty(), self.is_empty()) {
    (true, _) => 0
    (_, true) => 1
    _ => {
      let { queries, raw, case_sensitive } = self
      let mut raw_score = 0
      let mut any_mismatch = false
      for query in queries {
        let score = score_single_query(query, item~, case_sensitive~)
        if score == 0 {
          any_mismatch = true
        }
        raw_score += score
      }
      if raw_score == 0 || any_mismatch {
        0
      } else {
        score_upper_bound(query_length=raw.length()) - raw_score
      }
    }
  }
}

///|
pub fn score_upper_bound(query_length~ : Int) -> Int {
  (start_of_item_bonus + start_of_word_bonus) *
  first_char_multiplier *
  query_length +
  1
}
