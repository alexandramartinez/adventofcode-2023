# Advent of Code 2023

DataWeave scripts used in the [adventofcode.com](https://adventofcode.com/) site for 2023.

## Scripts

### Day 1

Live stream: [mulesoft_community | It's that time of the year again 🌲 Let's play Advent of Code 2023 with DataWeave ✨](https://www.twitch.tv/videos/1995939015)

#### Part 1

<details>
  <summary>Script</summary>

```dataweave
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
```
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=alexandramartinez%2Fadventofcode-2023&path=scripts%2Fday1%2Fpart1"><img width="300" src="/images/dwplayground-button.png"><a>

#### Part 2

<details>
  <summary>Script</summary>

```dataweave
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
```
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=alexandramartinez%2Fadventofcode-2023&path=scripts%2Fday1%2Fpart2"><img width="300" src="/images/dwplayground-button.png"><a>

