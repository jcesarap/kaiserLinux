return {
    s({ trig = "ff", regTrig = true, wordTrig = false },
        fmt(
            "\\frac{<>}{<>}",
            {
                i(1),
                i(2)
            },
            { delimiters = "<>" } -- manually specifying angle bracket delimiters
        )
    ),
    s({ trig = "sq", regTrig = true, wordTrig = false },
        fmt(
            "\\sqrt{<>}{<>}",
            {
                i(1),
                i(2)
            },
            { delimiters = "<>" } -- manually specifying angle bracket delimiters
        )
    ),
    s({ trig = "rr", regTrig = true, wordTrig = false },
        fmt(
            "\\sqrt[<>]{<>}",
            {
                i(1),
                i(2)
            },
            { delimiters = "<>" } -- manually specifying angle bracket delimiters
        )
    ),
    s({ trig = "sp", regTrig = true, wordTrig = false },
        fmt(
            "^{<>}",
            {
                i(1)
            },
            { delimiters = "<>" } -- manually specifying angle bracket delimiters
        )
    ),
    s({ trig = "sb", regTrig = true, wordTrig = false },
        fmt(
            "_{<>}",
            {
                i(1)
            },
            { delimiters = "<>" } -- manually specifying angle bracket delimiters
        )
    ),
    s({ trig = "lx", regTrig = true, wordTrig = false },
        fmt(
            "$<>$",
            {
                i(1)
            },
            { delimiters = "<>" } -- manually specifying angle bracket delimiters
        )
    ),
}
