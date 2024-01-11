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