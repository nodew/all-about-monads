module Main where

import Text.Pandoc

transformInline (Code _ code)
  = RawInline (Format "mediawiki") $ "<code>" ++ code ++ "</code>"

transformInline x = x

transformBlock (CodeBlock _ code)
  = RawBlock (Format "mediawiki") $ "<haskell>\n" ++ code ++ "\n</haskell>"

transformBlock (Table [] [AlignLeft,AlignLeft,AlignLeft] [0.0,0.0,0.0] [] _)
  = Null

transformBlock (BulletList ([Plain [Link _ [] ('#':_,"")]]:_))
  = Null

transformBlock HorizontalRule
  = Null

transformBlock x = x

removeNull (Pandoc meta blocks)
  = Pandoc meta $ filter (/= Null) blocks

readS s = case readNative s of
            Right doc -> doc
            Left error -> Pandoc nullMeta []

main :: IO ()
main = interact $ writeNative (def WriterOptions)
                . removeNull
                . bottomUp transformInline
                . bottomUp transformBlock
                . readS
