%dw 2.0
import lines, isNumeric from dw::core::Strings
output application/json
var regex = /one|two|three|four|five|six|seven|eight|nine|ten|\d/
var numbers = {
    one: "1",
    two: "2",
    three: "3",
    four: "4",
    five: "5",
    six: "6",
    seven: "7",
    eight: "8",
    nine: "9"
}
---
lines(payload) map ((line) -> do {
    var cleanLine = line
        replace "one" with "onee"
        replace "two" with "twoo"
        replace "three" with "threee"
        replace "five" with "fivee"
        replace "seven" with "sevenn"
        replace "eight" with "eightt"
        replace "nine" with "ninee"
    var nums = flatten(cleanLine scan regex) map ((n) -> 
        if (isNumeric(n)) n
        else numbers[n]
    )
    ---
    (nums[0] ++ nums[-1]) as Number
})
then sum($)