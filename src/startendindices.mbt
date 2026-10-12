///|
priv struct StartEndIndices {
  mut found : Bool
  mut start_idx : Int32
  mut end_idx : Int32
}

///|
let the_one_and_only : StartEndIndices = {
  found: false,
  start_idx: 0,
  end_idx: 0,
}
