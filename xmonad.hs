-- Peppe's desktop configuration 

import System.Posix.Env (getEnv)
import Data.Maybe (maybe)

import XMonad
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Util.Run -- spawnPipe and hPutStrLn
import XMonad.Prompt.Pass
import qualified XMonad.StackSet as W
import XMonad.Util.EZConfig
import Graphics.X11.ExtraTypes.XF86
import XMonad.Hooks.ManageHelpers (composeOne, isFullscreen, isDialog,  doFullFloat, doCenterFloat)
import Data.Ratio ((%))

-- Hooks
import XMonad.Hooks.ManageDocks

-- Layouts
import XMonad.Layout.NoBorders
import XMonad.Layout.Fullscreen
import XMonad.Layout.LayoutCombinators hiding ((|||))
import XMonad.Layout.Grid
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import XMonad.Layout.Spacing
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.Gaps

main = do
      h <- spawnPipe "xmobar"
      session <- getEnv "DESKTOP_SESSION"
      xmonad $ docks $ fullscreenSupport $ defaultConfig
        { modMask = mod4Mask
        , terminal = myTerminal
        , logHook = dynamicLogWithPP $ defaultPP { ppOutput = hPutStrLn h }
        , layoutHook = myLayouts
        , workspaces = myWorkspaces
        , handleEventHook = fullscreenEventHook
        , manageHook = myManageHook <+> manageHook defaultConfig
        }
        `additionalKeysP`
        [ ("M-<Up>", windows W.swapUp)
        , ("M-<Down>", windows W.swapDown)
        , ("<XF86AudioMute>", spawn "amixer set Master toggle && amixer set Headphone toggle")
        , ("<XF86XK_AudioRaiseVolume>", spawn "amixer -D pulse sset Master 5%+ && amixer sset Master 5%+")
        , ("<XF86XK_AudioLowerVolume>", spawn "amixer -D pulse sset Master 5%-")
        , ("M-f", sendMessage ToggleLayout)       -- Toggle full-screen layout.
        ]


--desktop :: String ->  
desktop _ = desktopConfig

myTerminal = "gnome-terminal"
myWorkspaces = ["1: web","2: term","3: im","4: media"] ++ map show [5..6]
myLayouts =
    avoidStruts $
    spacing 2 $
    toggleLayouts (noBorders Full) $
    smartBorders $ Grid ||| spiral (6/7) ||| tabbedAlways shrinkText defaultTheme 

myManageHook = composeAll
   [ appName =? "slack" --> doShift "3: im"
   , className =? "Gnome-terminal" --> doShift "2: term"
   , className =? "Xmessage" --> doFloat
   , className =? "Google-chrome" --> doShift "1: web"  
   , className =? "Org.gnome.Nautilus" --> doShift "5"  
   , className =? "Microsoft Teams - Preview" --> doShift "3: im"  
   , className =? "Tor Browser" --> doShift "1: web"  
   , className =? "Virt-viewer" --> doShift "4: media"  
   , title   =? "Add New Items"	--> doFloat --- Xfce4-panel add new items
   , isFullscreen --> doFullFloat
   , isDialog --> doFloat
   ]

