# Regex

An example for working with capture groups using [Text.RE.Replace](https://hackage.haskell.org/package/regex-1.0.2.0/docs/Text-RE-Replace.html)

    module Main where

    import Data.Text
    import Text.RE.Replace
    import Text.RE.TDFA.String

    needle :: CaptureID
    needle = IsCaptureName . CaptureName . pack $ "needle"

    main :: IO ()
    main = do
        re <- compileRegex "-${needle}([a-z]+)-"
        let match = "haystack contains the -word- you want" ?=~ re
        if matched match
        then print $ captureText needle match
        else print "(no match)"


Another approach would be to use [Data.List.Split](https://hackage.haskell.org/package/split-0.2.3.4/docs/Data-List-Split.html)

    > splitOn "x" "axbxc"
    ["a","b","c"]

    > splitOn "x" "axbxcx"
    ["a","b","c",""]

    > endBy ";" "foo;bar;baz;"
    ["foo","bar","baz"]

    > splitWhen (<0) [1,3,-4,5,7,-9,0,2]
    [[1,3],[5,7],[0,2]]

    > splitOneOf ";.," "foo,bar;baz.glurk"
    ["foo","bar","baz","glurk"]

    > chunksOf 3 ['a'..'z']
    ["abc","def","ghi","jkl","mno","pqr","stu","vwx","yz"]

