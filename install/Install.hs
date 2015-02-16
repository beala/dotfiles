#!/usr/bin/env runhaskell

{-# LANGUAGE OverloadedStrings #-}

import Turtle as T
import Prelude hiding (FilePath)
import qualified Data.Text as Te
import qualified Data.Text.IO as Te
import qualified Filesystem.Path.CurrentOS as Fs
import qualified System.IO as Sys
import Data.Traversable (traverse)
import System.Environment (getProgName)

-- The installation directory.
installDir :: IO FilePath
installDir = home

-- The directory containing the dotfiles to install.
dotfilesDir :: IO FilePath
dotfilesDir = parent <$> scriptDir

-- Directory containing this script.
scriptDir :: IO FilePath
scriptDir = do
  relativePath <- Fs.decodeString <$> getProgName
  fullPath <- realpath relativePath
  return $ directory fullPath

data LinkDescription = LinkDescription {linkSource :: FilePath, linkTargetDir :: FilePath, linkTargetName :: FilePath}
            deriving Show

-- Get the full target path from a LinkDescription
fullTarget :: LinkDescription -> FilePath
fullTarget = (</>) <$> linkTargetDir <*> linkTargetName

-- List of all the symlinks to make.
getInstallInfo :: FilePath -> FilePath -> [LinkDescription]
getInstallInfo dotfilesBase installBase =
  [LinkDescription (dotfilesBase </> ".bash_custom")  installBase             ".bash_custom",
   LinkDescription (dotfilesBase </> ".gitconfig")    installBase             ".gitconfig",
   LinkDescription (dotfilesBase </> ".screenrc")     installBase             ".screenrc",
   LinkDescription (dotfilesBase </> ".vimrc")        installBase             ".vimrc",
   LinkDescription (dotfilesBase </> ".vim")          installBase             ".vim",
   LinkDescription (dotfilesBase </> "irm/irm.sh")    installBase             ".irm",
   LinkDescription (dotfilesBase </> "bin/colors")    (installBase </> "bin") "colors",
   LinkDescription (dotfilesBase </> "bin/unbox")     (installBase </> "bin") "unbox"]

-- Show a Showable as Text
showText :: Show a => a -> Text
showText = Te.pack . show

-- Get the textual representation of the FilePath. If the FilePath
-- cannot be represented, die with error message.
showFilePath :: FilePath -> IO Text
showFilePath fp =
  case T.toText fp of
    Left errMsg -> die $ format ("Error processing path: "%s%"\n\t"%s) (showText fp) errMsg
    Right textFp -> return textFp

-- Creates a symbolic link pointing from src to target.
symLink :: FilePath -> FilePath -> IO ExitCode
symLink src target = do
  srcText <- showFilePath src
  targetText <- showFilePath target
  echo $ format ("Linking "%s%" to "%s) srcText targetText
  proc "ln" ["-s", srcText, targetText] empty

-- True iff the pattern matches.
matchesPattern :: T.Pattern Text -> Text -> Bool
matchesPattern p = not . null . match p

-- True iff the text is "n" or "no"
isNo :: Maybe Text -> Bool
isNo (Just n) = matchesPattern ("no" <|> "n") n
isNo Nothing = False

-- True iff ExitFailure
isFailure :: ExitCode -> Bool
isFailure (ExitFailure _) = True
isFailure (ExitSuccess) = False

-- Echo without printing a newline after the output text.
echoNoNewline :: Text -> IO ()
echoNoNewline msg = do
  Te.putStr msg
  Sys.hFlush Sys.stdout

main :: IO ()
main = do
  installPath <- installDir
  dotFilesPath <- dotfilesDir

  confirmMessage <- format ("Installing files from ["%s%"] to ["%s%"]. Is this correct? [y/n] ")
                    <$> showFilePath dotFilesPath
                    <*> showFilePath installPath
  echoNoNewline confirmMessage
  incorrectCorrectPath <- isNo <$> readline
  when incorrectCorrectPath (die "Aborting.")

  let installInfo = getInstallInfo dotFilesPath installPath
  retCodes <- traverse (symLink <$> linkSource <*> fullTarget) installInfo
  if any isFailure retCodes then exit 1 else exit 0