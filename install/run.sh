#!/bin/bash

cd $(dirname "$0")
cabal sandbox init
cabal install turtle
cabal exec -- ./Install.hs
