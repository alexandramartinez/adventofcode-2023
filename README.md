# Advent of Code 2023

DataWeave scripts used in the [adventofcode.com](https://adventofcode.com/) site for 2023.

## Day 1

Live stream @ twitch.tv/mulesoft_community: [It's that time of the year again 🌲 Let's play Advent of Code 2023 with DataWeave ✨](https://www.twitch.tv/videos/1995939015)

### Part 1

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

### Part 2

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

## Day 2

### Part 1

Live stream @ twitch.tv/mulesoft_community: [First stream of the year!! ~ Advent of Code 2023 Day 2](https://www.twitch.tv/videos/2027472277)

<details>
  <summary>Script</summary>

```dataweave
%dw 2.0
import every from dw::core::Arrays
import lines from dw::core::Strings
output application/json
var maxRed = 12
var maxGreen = 13
var maxBlue = 14
---
lines(payload) map ((game, gameidx) -> do {
    var sets = game[8 to -1] splitBy ";" map (
        trim($) splitBy "," reduce ((item, acc={}) -> 
            acc ++ {
                ((item scan /red|green|blue/)[0][0]): (item scan /\d+/)[0][0] as Number
            }
        )
    )
    ---
    {
        game: gameidx+1,
        sets: sets,
        isPossible: (sets reduce (set, acc=[]) -> (
            acc 
            + ((set.red default 0) <= maxRed)
            + ((set.green default 0) <= maxGreen)
            + ((set.blue default 0) <= maxBlue)
        )) every $
    }
}) 
filter $.isPossible
then $.game
then sum($)
```
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=alexandramartinez%2Fadventofcode-2023&path=scripts%2Fday2%2Fpart1"><img width="300" src="/images/dwplayground-button.png"><a>

### Part 2

Live stream @ twitch.tv/mulesoft_community: [Playing Advent of Code with DataWeave once more! (Programming challenges)](https://www.twitch.tv/videos/2029366733)

<details>
  <summary>Script</summary>

```dataweave
%dw 2.0
import lines from dw::core::Strings
output application/json
---
lines(payload) map ((game, gameidx) -> do {
    var sets = game[8 to -1] splitBy ";" map (
        trim($) splitBy "," reduce ((item, acc={}) -> 
            acc ++ {
                ((item scan /red|green|blue/)[0][0]): (item scan /\d+/)[0][0] as Number
            }
        )
    )
    fun getMaxNumber(color:String): Number = (
        max(sets[color] default []) default 1
    )
    ---
    getMaxNumber("red") 
    * getMaxNumber("green") 
    * getMaxNumber("blue")
})
then sum($)
```
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=alexandramartinez%2Fadventofcode-2023&path=scripts%2Fday2%2Fpart2"><img width="300" src="/images/dwplayground-button.png"><a>

## Day 3

### Part 1

Live stream @ twitch.tv/mulesoft_community: [Playing Advent of Code with DataWeave once more! (Programming challenges)](https://www.twitch.tv/videos/2029366733)

---

## Other repos

- Ryan Hoegg's [adventofcode2023](https://github.com/rhoegg/adventofcode2023)
- Ignacio Esteban Losiggio's [aoc2023](https://github.com/iglosiggio/aoc2023)