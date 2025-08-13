///|
fn[Query : StringLike, Item : StringLike] find_start_end_indices(
  query~ : Query,
  item~ : Item,
) -> StartEndIndices {
  let dst = the_one_and_only
  let mut item_idx = 0
  let mut query_idx = 0
  while item_idx < item.length() && query_idx < query.length() {
    if equal_ignore_case(item[item_idx], query[query_idx]) {
      query_idx += 1
    }
    item_idx += 1
  }
  if query_idx < query.length() {
    dst.found = false
  } else {
    let end_idx = item_idx
    let mut item_idx = end_idx - 1
    let mut query_idx = query.length() - 1
    while query_idx >= 0 {
      if equal_ignore_case(item[item_idx], query[query_idx]) {
        query_idx -= 1
      }
      item_idx -= 1
    }
    let start_idx = item_idx + 1
    dst.found = true
    dst.start_idx = start_idx
    dst.end_idx = end_idx
  }
  dst
}

///|
fn[A, Query : StringLike, Item : StringLike] fold_matching_indices_single_query(
  query : Query,
  item~ : Item,
  init~ : A,
  f~ : (A, Int) -> A,
) -> A {
  let { start_idx, end_idx, found } = find_start_end_indices(query~, item~)
  let mut acc = init
  if found {
    let mut query_idx = 0
    for item_idx in start_idx..<end_idx {
      if equal_ignore_case(item[item_idx], query[query_idx]) {
        acc = f(acc, item_idx)
        query_idx += 1
      }
    }
  }
  acc
}

///|
fn[Query : StringLike, Item : StringLike] score_single_query(
  query : Query,
  item~ : Item,
  case_sensitive~ : Bool,
) -> Int {
  let { found, start_idx, end_idx } = find_start_end_indices(query~, item~)
  if not(found) {
    0
  } else {
    let start_char_class = if start_idx == 0 {
      NonWord
    } else {
      CharClass::from_char(item[start_idx - 1])
    }
    let mut query_idx = 0
    let mut score = 0
    let mut in_gap = false
    let mut prev_char_class = start_char_class
    let mut prev_char_score = 0
    for item_idx in start_idx..<end_idx {
      let item_char = item[item_idx]
      let query_char = query[query_idx]
      if equal_ignore_case(item_char, query_char) {
        let char_class = CharClass::from_char(item_char)
        let this_char_score = {
          let base_score = match (prev_char_class, char_class) {
            (NonWord, Upper | Lower | Digit) => start_of_word_bonus
            (Lower, Upper) | (_, Digit) => camel_case_bonus
            (_, NonWord) => non_word_bonus
            _ => match_bonus
          }
          let with_start_of_item_bonus = if item_idx == 0 {
            base_score + start_of_item_bonus
          } else {
            base_score
          }
          let with_consecutive_bonus = if in_gap {
            with_start_of_item_bonus
          } else {
            max(with_start_of_item_bonus, prev_char_score)
          }
          let with_wrong_case_penalty = if item_char == query_char ||
            not(case_sensitive) {
            with_consecutive_bonus
          } else {
            with_consecutive_bonus - wrong_case_penalty
          }
          if query_idx == 0 {
            first_char_multiplier * with_wrong_case_penalty
          } else {
            with_wrong_case_penalty
          }
        }
        query_idx += 1
        score += this_char_score
        prev_char_class = char_class
        prev_char_score = this_char_score
        in_gap = false
      } else {
        let this_char_score = if not(in_gap) {
          -continue_gap_penalty
        } else {
          -start_gap_penalty
        }
        score += this_char_score
        in_gap = true
      }
    }
    score
  }
}
