module Cli (CardConfig (..), defaultConfig, possibleConfigs, toFName) where

import Data.List
import Data.Char
import Data.Maybe


data CardConfig = CardConfig {
    teamCount :: Int,
    questionCount :: Int,
    reserve :: Maybe Int,
    printTeams::Bool,
    printQuests :: Bool,
    printReserveTN :: Bool
}

data SubConf = SubConf {
    countQ :: Int,
    printT :: Bool
}

data Conf = Conf {
    logo :: Bool,
    printQ :: Bool,
    tCount :: Int,
    m :: SubConf,
    s :: SubConf
}

convert :: Conf -> CardConfig
convert (Conf _ printQ_ tCount_ (SubConf mqc mpt) (SubConf sqc spt)) = 
    CardConfig tCount_ mqc (if sqc <= 0 then Nothing else Just sqc) mpt printQ_ spt


convert' :: CardConfig -> Conf
convert' (CardConfig tc qc res pt pq pr) = Conf
    True
    pq
    tc
    (SubConf qc pt)
    (SubConf (fromMaybe 0 res) pr)



defaultMain :: SubConf
defaultMain = SubConf 36 True

defaultSupp :: SubConf
defaultSupp = SubConf 3 True

deafultC :: Conf
deafultC = Conf True True 1 defaultMain defaultSupp


instance Show Conf where
    show (Conf logo_ printQ_ tCount_ (SubConf mqc mpt) (SubConf sqc spt)) = 
        intercalate "," $ [
            "teams=" ++ show tCount_,
            "questions=" ++ show mqc,
            "printteamsatall=" ++ lower mpt,
            "printquestions=" ++  lower printQ_,
            "printreserveteamnumbers="++ lower spt,
            "printlogo=" ++ lower logo_
        ]
        ++
        case sqc of
            0 -> ["printreserve=false"]
            _ -> ["printreserve", "reserve=" ++ show sqc]



instance Show CardConfig where
    show (CardConfig tc qc res pt pq pr) = 
        intercalate "," $ [
            "teams=" ++ show tc,
            "questions=" ++ show qc,
            "printteamsatall=" ++ lower pt,
            "printquestions=" ++  lower pq,
            "printreserveteamnumbers="++  lower pr
        ]
        ++
        case res of
            Nothing -> ["printreserve=false"]
            Just x -> ["printreserve", "reserve=" ++ show x]


lower:: Bool -> String
lower b = fmap toLower (show b)

defaultConfig :: CardConfig
defaultConfig = CardConfig {
    teamCount = 6,
    questionCount = 36,
    reserve = Just 3,
    printTeams = True,
    printQuests = True,
    printReserveTN = True}


possibleConfigs :: [CardConfig]
possibleConfigs =
    pure CardConfig <*>
    [1..6] <*>
    [36, 45] <*>
    [Just 3, Nothing] <*>
    [True, False] <*>
    [True] <*>
    [True]

toFName :: CardConfig -> String
toFName (CardConfig tc qc res pt _ _) =
    "cards" <>
    "T" <> show tc <>
    "Q" <> show qc <>
    maybe "R0" (\r -> "R" <> show r) res <>
    if pt then "T" else "N" <>
    ".pdf"