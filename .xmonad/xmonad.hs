import XMonad
import System.IO
import System.Exit
import Control.Monad (liftM2)

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

import XMonad.Actions.CycleWS

import XMonad.Config.Gnome
import XMonad.Config.Desktop (desktopLayoutModifiers)

import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops

import XMonad.Layout.Gaps
import XMonad.Layout.IM
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Reflect
import XMonad.Layout.Tabbed
import XMonad.Layout.LayoutHints

import XMonad.Util.EZConfig
import XMonad.Util.Scratchpad
import XMonad.Util.NamedScratchpad

import XMonad.Config.Desktop
import XMonad.Layout.Tabbed
import XMonad.Util.EZConfig (additionalKeys)

import XMonad.Prompt
import XMonad.Prompt.RunOrRaise
 
main = do
 xmonad $ desktopConfig {
    terminal     = myTerminal
    , modMask    = myModMask
    , layoutHook = myLayouts
    , manageHook = namedScratchpadManageHook scratchpads <+> myManageHook <+> manageHook desktopConfig
    , workspaces = myWorkspaces
    , keys       = myKeys

    -- colours
    , normalBorderColor  = myNormalBorderColor
    , focusedBorderColor = myFocusedBorderColor
    , borderWidth        = myBorderWidth

    , handleEventHook    = fullscreenEventHook
 }


myModMask            = mod4Mask
myTerminal           = "gnome-terminal"
myNormalBorderColor  = "#000000"
myFocusedBorderColor = "#888888"
myBorderWidth        = 1

myLayouts = gaps [(U, 24)] $ desktopLayoutModifiers $ smartBorders 
    $ (stabbed ||| tiled ||| mirror)
    where 
        tiled = Tall 1 0.03 0.5
        mirror = Mirror tiled
        stabbed = simpleTabbed


myManageHook = composeAll 
  [ scratchpadManageHookDefault
  , isFullscreen                       --> doFullFloat
  , isDialog                           --> doCenterFloat
  , resource   =? "unity-2d-launcher"  --> doIgnore
  , resource   =? "unity-2d-panel"     --> doIgnore
  , resource   =? "synapse"            --> doIgnore
  , title      =? "kupfer"             --> doCenterFloat
  , title      =? "Deskbar Applet"     --> doCenterFloat
  , className  =? "gloobus-preview"    --> doCenterFloat
  , className  =? "Gloobus-preview"    --> doCenterFloat
  , className  =? "Do"                 --> doIgnore
  , className  =? "Smplayer"           --> doCenterFloat
  , className  =? "Thunderbird"        --> viewShift "2:mail"
  , className  =? "Google-chrome"      --> viewShift "3:web"
  , className  =? "Firefox"            --> viewShift "3:web"
  , className  =? "Pidgin"             --> viewShift "9:chat"
  , className  =? "Rhythmbox"          --> viewShift "5:music"
  , className  =? "Totem"              --> viewShift "4:video"
  ] 
  where viewShift = doF . liftM2 (.) W.greedyView W.shift

scratchpads = [ 
    NS "term" "gnome-terminal --role term"                                (role =? "term") (customFloating $ W.RationalRect (1/6) (1/6) (2/3) (2/3))
  , NS "dash" "gnome-terminal --role dash -x vim ~/Documents/docs/file-o" (role =? "dash") (customFloating $ W.RationalRect (1/6) (1/6) (2/3) (2/3))
  , NS "pass" "gnome-terminal --role pass -x vim ~/Documents/docs/file-p" (role =? "pass") (customFloating $ W.RationalRect (1/6) (1/6) (2/3) (2/3))
    ] where role = stringProperty "WM_WINDOW_ROLE"


myWorkspaces = ["1:dev", "2:mail", "3:web", "4:video", "5:music", "6", "7", "8:servers", "9:chat", "0"]

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
 
    -- launch a terminal
    [ ((modm,               xK_Return), spawn $ XMonad.terminal conf)
 
    -- launcher
    --, ((modm,               xK_r     ), spawn "synapse")

    , ((modm,               xK_backslash), runOrRaisePrompt defaultXPConfig)

    -- lock screen
    , ((controlMask .|. mod1Mask,    xK_l     ), spawn "gnome-screensaver-command -l")
 
    -- close focused window 
    , ((modm .|. shiftMask, xK_c     ), kill)
 
     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)
 
    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
 
    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)
 
    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)
 
    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)
 
    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )
 
    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )
 
    -- Swap the focused window and the master window
    , ((modm .|. shiftMask, xK_Return), windows W.swapMaster)
 
    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )
 
    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )
 
    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)
 
    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Remove docks
    , ((modm              , xK_b     ), sendMessage $ ToggleStruts)
 
    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)
 
    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))
 
    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))
 
    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))
 
    -- Restart xmonad
    , ((modm              , xK_q     ), restart "xmonad" True)

    -- Screenshot
    ,  ((controlMask, xK_Print), spawn "scrot -s")
       
    -- Screenshot   
    ,  ((0, xK_Print), spawn "scrot")

    -- Scratchpads

    , ((modm              , xK_i     ), namedScratchpadAction scratchpads "term")
    , ((modm              , xK_o     ), namedScratchpadAction scratchpads "dash")
    , ((modm              , xK_u     ), namedScratchpadAction scratchpads "pass")

    ]
    ++
 
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) ([xK_1 .. xK_9] ++ [xK_0])
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
 
    -- mod-{[,]}, Switch to physical screens 1, 2
    -- mod-shift-{[,]}, Move client to screen 1, 2
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_bracketleft, xK_bracketright] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
 

