module Cli (CardConfig (..), defaultConfig) where

import Data.List
import Data.Char


data CardConfig = CardConfig {
    teamCount :: Int,
    questionCount :: Int,
    reserve :: Maybe Int,
    printTeams::Bool,
    printQuests :: Bool,
    printReserveTN :: Bool
}

instance Show CardConfig where
    show (CardConfig tc qc res pt pq pr) = 
        intercalate "," $ [
            "teams=" ++ show tc,
            "questions=" ++ show qc,
            "printteamsatall=" ++ lower (show pt),
            "printquestions=" ++  lower (show pq),
            "printreserveteamnumbers="++  lower (show pr)
        ]
        ++
        case res of
            Nothing -> ["printreserve=false"]
            Just x -> ["printreserve", "reserve=" ++ show x]


lower:: String -> String
lower = fmap toLower

defaultConfig :: CardConfig
defaultConfig = CardConfig {
    teamCount = 6,
    questionCount = 36,
    reserve = Just 3,
    printTeams = True,
    printQuests = True,
    printReserveTN = True}