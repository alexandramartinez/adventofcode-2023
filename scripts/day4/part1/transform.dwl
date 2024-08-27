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