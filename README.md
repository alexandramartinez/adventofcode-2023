# Advent of Code 2023

DataWeave scripts used in the [adventofcode.com](https://adventofcode.com/) site for 2023.

## 🔹 Day 1

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

## 🔹 Day 2

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

## 🔹 Day 3

### Part 1

Live streams @ twitch.tv/mulesoft_community: 

1. [Playing Advent of Code with DataWeave once more! (Programming challenges)](https://www.twitch.tv/videos/2029366733)
2. [DataWeave, Advent of Code, reading your suggestions!](https://www.twitch.tv/videos/2034364533)

> [!CAUTION]
> I made a horrible code for this one. I'm really embarrassed about this. Check out Ignacio's code instead :'D  https://github.com/iglosiggio/aoc2023/blob/main/aoc2023day3ex1.dwl

*Bad Alex :(*

<details>
  <summary>Script</summary>

```dataweave
%dw 2.0
import update from dw::util::Values
import some from dw::core::Arrays
output application/json
var linesArr = (payload splitBy "\n")
var regexForChars = /[^\d.\s]/
var mainArray = linesArr reduce ((line, acc=[]) -> do {
    acc ++ (flatten(line scan /\d+/) map ((number) -> do {
        var regexExactNumberMatch = ("(?<!\d)$(number)(?!\d)" as Regex)
        var exactNumberMatchesIdxs = flatten(line find regexExactNumberMatch)
        var firstIndex = (line find regexExactNumberMatch)[0][0]
        var lastIndex = (firstIndex + (sizeOf(number)-1))
        var firstIndexToCheck = if ((firstIndex-1) >= 0) firstIndex-1 else firstIndex
        var lastIndexToCheck = if ((lastIndex+1) > sizeOf(line)-1) lastIndex else lastIndex+1
        var currentLineIdx = (linesArr find line)[0]
        var previousLineIdx = currentLineIdx - 1
        var nextLineIdx = currentLineIdx + 1
        var isPartAbove = if (previousLineIdx >= 0) 
                linesArr[previousLineIdx][firstIndexToCheck to lastIndexToCheck] contains regexForChars
            else false
        var isPartBelow = if (nextLineIdx > (sizeOf(linesArr)-1)) false
            else linesArr[nextLineIdx][firstIndexToCheck to lastIndexToCheck] contains regexForChars
        var isPartNext = line[firstIndexToCheck to lastIndexToCheck] contains regexForChars
        ---
        {
            line: line,
            number: number as Number,
            firstIndex: firstIndex,
            exactNumberMatchesIdxs: exactNumberMatchesIdxs,
            isDupNum: sizeOf(exactNumberMatchesIdxs) >1,
            isPart: [isPartAbove, isPartBelow, isPartNext] some $
        }
    }))
})
---
do {
    var resultWithDups = sum((mainArray filter $.isPart).number)
    var dupNums = sum((mainArray filter $.isPart and $.isDupNum).number distinctBy $)
    var duplicatesNotChecked = ((mainArray filter $.isDupNum filter ($$ mod 2) != 0) map do {
            var firstIndex = $.exactNumberMatchesIdxs[-1] // decided to assume there's only 2 matches per line :')
            var lastIndex = (firstIndex + (sizeOf($.number)-1))
            var firstIndexToCheck = if ((firstIndex-1) >= 0) firstIndex-1 else firstIndex
            var lastIndexToCheck = if ((lastIndex+1) > sizeOf($.line)-1) lastIndex else lastIndex+1
            var currentLineIdx = (linesArr find $.line)[0]
            var previousLineIdx = currentLineIdx - 1
            var nextLineIdx = currentLineIdx + 1
            var isPartAbove = if (previousLineIdx >= 0) 
                    linesArr[previousLineIdx][firstIndexToCheck to lastIndexToCheck] contains regexForChars
                else false
            var isPartBelow = if (nextLineIdx > (sizeOf(linesArr)-1)) false
                else linesArr[nextLineIdx][firstIndexToCheck to lastIndexToCheck] contains regexForChars
            var isPartNext = $.line[firstIndexToCheck to lastIndexToCheck] contains regexForChars
            ---
            {
                line: $.line,
                number: $.number as Number,
                exactNumberMatchesIdxs: $.exactNumberMatchesIdxs,
                firstIndex: firstIndex,
                isPart: [isPartAbove, isPartBelow, isPartNext] some $
            }
        }) filter $.isPart then sum($.number)
    ---
    {
        resultWithDups: resultWithDups, // suming up everything that is considered a part (even duplicates per line)
        dupNums: dupNums, // suming up the duplicate numbers that are a part (to remove them from the previous count)
        duplicatesNotChecked: duplicatesNotChecked, // suming up the duplicates that are a part that were not previously checked correctly
        finalResult: resultWithDups - dupNums + duplicatesNotChecked // final operations :')
    }
} 
```
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=alexandramartinez%2Fadventofcode-2023&path=scripts%2Fday3%2Fpart1"><img width="300" src="/images/dwplayground-button.png"><a>

## 🔹 Day 4

### Part 1

Live stream @ twitch.tv/mulesoft_community: 

- [Solving Advent of Code puzzles with DataWeave (day 4 part 1)](https://www.twitch.tv/videos/2235381320)

<details>
  <summary>Script</summary>

```dataweave
%dw 2.0
import countBy from dw::core::Arrays
import lines, substringBefore, substringAfter from dw::core::Strings
output application/json
fun getNumbers(numbers) = flatten(numbers scan /\d+/)
---
lines(payload) map ((line) -> do {
    var cardName = (line substringBefore ":")
    var numbers = (line substringAfter ":") splitBy "|"
    var winningNumbers = getNumbers(numbers[0])
    var actualNumbers = getNumbers(numbers[1])
    var matchingNumbers = winningNumbers countBy (actualNumbers contains $)
    var score = matchingNumbers match {
        case 1 -> 1
        case 0 -> 0
        else -> 2 pow matchingNumbers-1
    }
    ---
    // for debugging purposes
    // {
    //     (cardName): {
    //         winning: winningNumbers,
    //         actual: actualNumbers,
    //         matchingNumbers: matchingNumbers,
    //         score: score
    //     }
    // }

    // actual needed code
    score
})
then sum($)
```
</details>

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=alexandramartinez%2Fadventofcode-2023&path=scripts%2Fday4%2Fpart1"><img width="300" src="/images/dwplayground-button.png"><a>

---

## Other repos

- Ryan Hoegg's [adventofcode2023](https://github.com/rhoegg/adventofcode2023)
- Ignacio Esteban Losiggio's [aoc2023](https://github.com/iglosiggio/aoc2023)
