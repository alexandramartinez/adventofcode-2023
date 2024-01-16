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