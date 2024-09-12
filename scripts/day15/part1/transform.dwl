%dw 2.0
output application/json
import charCode from dw::core::Strings
fun getnum(currentvalue, asciicode) = ((currentvalue + asciicode) * 17) mod 256
fun getResult(string, r=0) = do {
    @Lazy
    var newR = r getnum charCode(string)
    ---
    if (!isEmpty(string))
        string[1 to -1] getResult newR
    else r
}
---
(payload splitBy ",") map getResult($)
then sum($)