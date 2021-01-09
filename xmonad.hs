-- Peppe's desktop configuration 

import System.Posix.Env (getEnv)
import Data.Maybe (maybe)

import XMonad
import XMonad.Config.Desktop
import XMonad.Config.Gnome
import XMonad.Config.Kde
import XMonad.Config.Xfce
import XMonad.Hooks.DynamicLog
import XMonad.Util.Run -- spawnPipe and hPutStrLn
import XMonad.Prompt.Pass
import XMonad.Hooks.ManageDocks
import qualified XMonad.StackSet as W
import XMonad.Util.EZConfig
import Graphics.X11.ExtraTypes.XF86

main = do
      h <- spawnPipe "xmobar"
      session <- getEnv "DESKTOP_SESSION"
      xmonad $ ( maybe desktopConfig desktop session )
        { modMask = mod4Mask
        , terminal = myTerminal
        , logHook = dynamicLogWithPP $ defaultPP { ppOutput = hPutStrLn h }
        }
        `additionalKeysP`
        [ ("M-<Up>", windows W.swapUp)
        , ("M-f", spawn "firefox")
        , ("<XF86AudioMute>", spawn "amixer set Master toggle && amixer set Headphone toggle")
        , ("<XF86XK_AudioRaiseVolume>", spawn "amixer -D pulse sset Master 5%+")
        , ("<XF86XK_AudioLowerVolume>", spawn "amixer -D pulse sset Master 5%-")
        ]


--desktop :: String ->  
desktop "gnome" = gnomeConfig
desktop "kde" = kde4Config
desktop "xfce" = xfceConfig
desktop "xmonad-mate" = gnomeConfig
desktop _ = desktopConfig

myTerminal = "gnome-terminal"

myManageHook = composeAll . concat $
  [ [ (className =? "Firefox" <&&> resource =? "Dialog") --> doFloat],
    [ (className =? "Google-chrome-stable") --> doFloat]
  ]
