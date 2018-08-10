module Main where

import Cli 
import Options.Applicative (Parser, ParserInfo, help, long, showDefault,
                            flag,info, value,helper,
                             header, fullDesc, progDesc, execParser, auto, option)
import           Control.Applicative (optional)
import           System.Process.Typed       (runProcess_, shell)

main :: IO ()
main = 
    execParser optionsH >>= main'

main' :: CardConfig -> IO ()
main' cc = runProcess_ $ shell $ unwords ["echo", texGenerator cc, "|", "pdflatex", "--jobname", "Cards", "--"]


-- echoProcess :: [String] -> ProcessConfig () () ()
-- echoProcess = shell "echo" 



texGenerator :: CardConfig -> String
texGenerator cc = 
    "\\\\\\\\documentclass" ++
    "[" ++ show cc ++ "]" ++
    "{chgkcard}\\\\\\\\begin{document}\\\\\\\\end{document}"


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
