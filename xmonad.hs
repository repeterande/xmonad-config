-- default desktop configuration for Fedora

import System.Posix.Env (getEnv)
import Data.Maybe (maybe)

import XMonad
import XMonad.Config.Desktop
import XMonad.Config.Gnome
import XMonad.Config.Kde
import XMonad.Config.Xfce
import XMonad.Hooks.DynamicLog
import XMonad.Util.Run -- spawnPipe and hPutStrLn
import XMonad.Hooks.ManageDocks
import XMonad.Util.EZConfig

main = do
      h <- spawnPipe "xmobar"
      session <- getEnv "DESKTOP_SESSION"
      xmonad $ ( maybe desktopConfig desktop session )
        { modMask = mod4Mask
        , terminal = myTerminal
        , logHook = dynamicLogWithPP $ defaultPP { ppOutput = hPutStrLn h }
        }

--desktop :: String ->  
desktop "gnome" = gnomeConfig
desktop "kde" = kde4Config
desktop "xfce" = xfceConfig
desktop "xmonad-mate" = gnomeConfig
desktop _ = desktopConfig

myTerminal = "gnome-terminal"

myManageHook = composeAll . concat $
  [ [ (className =? "Firefox" <&&> resource =? "Dialog") --> doFloat],
    [ (className =? "Google-chrome-unstable") --> doFloat]
  ]
