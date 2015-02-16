#!/usr/bin/env runhaskell

{-# LANGUAGE OverloadedStrings #-}

import Turtle as T
import qualified Data.Text as Te
import qualified Data.Text.IO as Te
import qualified Data.Map as M
import Data.Traversable
import Data.Maybe
import Data.List

-- The installation directory.
installDir :: IO T.FilePath
installDir = home

-- Pairs of the files to install and their symbolic link targets.
fileSrcTarget :: IO [(T.FilePath, T.FilePath)]
fileSrcTarget = do
	h <- installDir
	dotfilesBase <- parent <$> pwd
	return  [(dotfilesBase </> ".bash_custom", h),
			 (dotfilesBase </> ".gitconfig", h),
			 (dotfilesBase </> ".screenrc", h),
			 (dotfilesBase </> ".vimrc", h),
			 (dotfilesBase </> ".vim", h),
			 (dotfilesBase </> "irm/irm.sh", h </> ".irm"),
			 (dotfilesBase </> "bin/colors", h </> "bin/colors"),
			 (dotfilesBase </> "unbox", h </> "bin/unbox")]

-- Get the textual representation of the FilePath. If the FilePath
-- cannot be represented, die with error message.
showFilePath :: T.FilePath -> IO Text
showFilePath fp =
	case T.toText fp of
		Left err -> die $ format ("Cannot show path: "%s%"\n\t"%s) ((Te.pack . show) fp) err
		Right textFp -> return textFp

-- Creates a symbolic link pointing from src to target.
link :: T.FilePath -> T.FilePath -> IO ExitCode
link src target = do
	srcText <- showFilePath src
	targetText <- showFilePath target
	proc "ln" ["-s", srcText, targetText] empty

matchesPattern :: T.Pattern Text -> Text -> Bool
matchesPattern p = not . null . match p

isNo :: Maybe Text -> Bool
isNo (Just n) = matchesPattern ("no" <|> "n") n
isNo Nothing = False

isFailure :: ExitCode -> Bool
isFailure (ExitFailure _) = True
isFailure (ExitSuccess) = False

main :: IO ()
main = do
	b <- showFilePath =<< installDir
	Te.putStr $ format ("Installing files into: "%s%". Is this correct? [y/n] ") b
	isNotCorrectPath <- isNo <$> readline
	when isNotCorrectPath (die "Aborting.")
	srcTarget <- fileSrcTarget
	retCodes <- traverse (uncurry link) srcTarget
	if any isFailure retCodes then exit 1 else exit 0