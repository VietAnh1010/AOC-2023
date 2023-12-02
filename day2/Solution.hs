{-# LANGUAGE OverloadedStrings #-}

import Data.Function (on) 
import Data.List (groupBy, sortOn)
import Data.Maybe (fromJust)
import Data.Text (Text)
import Data.Text.IO (readFile)
import Prelude hiding (readFile)

import qualified Data.Text as T

type Draw = (Int, Text)

handleLine :: (Text -> Text -> a) -> Text -> a
handleLine handler line =
  let [str, info] = T.splitOn ": " line
  in handler str info

getId :: Text -> Int
getId = read . T.unpack . fromJust . T.stripPrefix "Game "

parseDraw :: Text -> Draw
parseDraw draw =
  let [str, color] = T.splitOn " " draw
  in (read $ T.unpack str, color)

parseDraws :: Text -> [Draw]
parseDraws = map parseDraw . concatMap (T.splitOn ", ") . T.splitOn "; "

possibleGame :: Text -> Bool
possibleGame = all valid . parseDraws
  where
    valid :: Draw -> Bool
    valid (num, color) = num <= case color of
      "red"   -> 12
      "green" -> 13
      "blue"  -> 14

minimumSet :: Text -> Int
minimumSet = product . map (maximum . map fst) . groupBy ((==) `on` snd) . sortOn snd . parseDraws

part1 :: [Text] -> Int
part1 = sum . (map $ handleLine handler)
  where
    handler :: Text -> Text -> Int
    handler str info = if possibleGame info then getId str else 0

part2 :: [Text] -> Int
part2 = sum . (map $ handleLine handler)
  where
    handler :: Text -> Text -> Int
    handler _ info = minimumSet info

main :: IO ()
main = do
  content <- readFile "input"
  let lines = T.lines content
  print $ "part 1: " ++ show (part1 lines)
  print $ "part 2: " ++ show (part2 lines)
  return ()

