%dw 2.0
import lines, isNumeric from dw::core::Strings

output application/json
---
lines(payload) map ((line) -> do {
    var nums = line filter (isNumeric($))
    ---
    (nums[0] ++ nums[-1]) as Number
})
then sum($)