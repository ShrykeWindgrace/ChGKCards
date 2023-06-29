{-# LANGUAGE OverloadedStrings#-}

module Main where

import Cli
import Options.Applicative (Parser, ParserInfo, help, long, showDefault,
                            flag,info, value,helper,
                             header, fullDesc, progDesc, execParser, auto, option)
import           Control.Applicative (optional)
import           System.Process.Typed
import           Data.ByteString.Lazy.Char8 (pack)
import           System.Directory
import           Control.Monad (unless)
import           Text.Read
import           Data.Char

main :: IO ()
--main = execParser optionsH >>= main'
main = do
    (CardConfig <$> getTeams <*> getQuests <*> getReserve <*> getPrintTeams <*> getPrintQuests <*> getPrintReserveNumbers) >>= print

main' :: CardConfig -> IO ()
main' cc = do
    ex <- doesFileExist styleFile
    unless ex $ putStrLn $ "Warning: did not see style file " ++ styleFile ++ "; hope that pdflatex will find on itself"
    runProcess_ $ pipeConfig cc


styleFile :: FilePath
styleFile = "chgkcard.cls"


pdfLaTeXprocess :: ProcessConfig () () ()
pdfLaTeXprocess = proc "pdflatex" ["--jobname", "Cards", "--"]


pipeConfig :: CardConfig ->  ProcessConfig  () () ()
pipeConfig cc = setStdin (byteStringInput $ pack $ texGenerator cc) pdfLaTeXprocess


texGenerator :: CardConfig -> String
texGenerator cc =
    "\\documentclass" ++
    "[" ++ show cc ++ "]" ++
    "{chgkcard}\\begin{document}\\end{document}"


optionsH :: ParserInfo CardConfig
optionsH =
  info
    (helper <*> options)
    (fullDesc <>
     progDesc
       "Get cards for your teams for your number of questions" <>
     header "Get cards")



options :: Parser CardConfig
options = CardConfig <$>
    option auto (
            long "teams" <>
            value 6 <>
            help "number of teams" <>
            showDefault
            )
    <*>
    option auto (
        long "questions" <>
        value 36 <>
        help "total number of  questions" <>
        showDefault
        )
    <*>
    optional (
        option auto (
            help "reserve cards per team" <>
            value 3 <>
            long "reserve" <>
            showDefault
            )
        )
    <*>
    flag True False (
        long "noPrintTeams" <>
        help "do not print team numbers" <>
        showDefault
        )
    <*>
    flag True False  (
        long "noPrintQuests" <>
        help "do not print question numbers" <>
        showDefault
        )
    <*>
    flag False True (
        long "printReserveTN" <>
        help "print team numbers on reserve cards" <>
        showDefault
        )

getTeams :: IO Int
getTeams = do
    putStrLn "teams? [default 6]"
    resp <- getLine
    case readMaybe resp of
        Nothing -> pure 6
        Just v -> pure $ if v > 0 then v else 6
getQuests :: IO Int
getQuests = do
    putStrLn "questions? [default 36]"
    resp <- getLine
    case readMaybe resp of
        Nothing -> pure 36
        Just v -> pure $ if v > 0 then v else 36
getReserve :: IO (Maybe Int)
getReserve = do
    putStrLn "reserve cards per team? [default 3]"
    resp <- getLine
    pure $ case readMaybe resp of
        Nothing -> pure 3
        Just v -> pure $ if v > 0 then v else 3

getPrintTeams :: IO Bool
getPrintTeams = do
    putStrLn "printTeamNumbers? [Yn]"
    resp <- getLine
    pure $ case toLower <$> resp of
        "" -> True
        "y" -> True
        _ -> False
getPrintQuests :: IO Bool
getPrintQuests = do
    putStrLn "print question numbers? [Yn]"
    resp <- getLine
    pure $ case toLower <$> resp of
        "" -> True
        "y" -> True
        _ -> False

getPrintReserveNumbers :: IO Bool
getPrintReserveNumbers = do
    putStrLn "print team numbers on reserve casrds? [Yn]"
    resp <- getLine
    pure $ case toLower <$> resp of
        "" -> True
        "y" -> True
        _ -> False

