; Join Part Quit Log v1.0 by bbqnut : bbqnut@github
; version 0.1 08.05.2024
; Set nicks to watch separated by a comma ie: nick1,nick2,nick3
alias wnicks return nick1,nick2
alias jpqlogs return $iif(%jpqlogs,%jpqlogs,0)
alias jpqnlonly return $iif(%jpqnlonly,%jpqnlonly,0)
alias openjpqlogs set %jpqlogs 1 | openjoinlog | openpartlog | openquitlog | opennicklog | openkicklog | openwnlog
alias closejpqlogs set %jpqlogs 0 | closejoinlog | closepartlog | closequitlog | closenicklog | closekicklog | closewnlog
alias closejoinlog window -c @JoinLog
alias closepartlog window -c @PartLog
alias closequitlog window -c @QuitLog
alias closenicklog window -c @NickLog
alias closekicklog window -c @KickLog
alias closewnlog window -c @WNLog
alias openjoinlog {
  if (!$window(@JoinLog)) && ($jpqnlonly != 1) {
    var %a0 = $len($timestamp) | var %a1 = $calc(%a0 + 1) | var %a2 = $calc(%a1 + 8) | window -g0k0nwzl -t $+ %a1 $+ , $+ %a2 @JoinLog $scriptdirjpqlogs.ico
  }
}
alias openpartlog {
  if (!$window(@PartLog)) && ($jpqnlonly != 1) {
    var %a0 = $len($timestamp) | var %a1 = $calc(%a0 + 1) | var %a2 = $calc(%a1 + 8) | window -g0k0nwzl -t $+ %a1 $+ , $+ %a2 @PartLog $scriptdirjpqlogs.ico
  }
}
alias openquitlog {
  if (!$window(@QuitLog)) && ($jpqnlonly != 1) {
    var %a0 = $len($timestamp) | var %a1 = $calc(%a0 + 1) | var %a2 = $calc(%a1 + 8) | window -g0k0nwzl -t $+ %a1 $+ , $+ %a2 @QuitLog $scriptdirjpqlogsq.ico
  }
}
alias opennicklog {
  if (!$window(@NickLog)) && ($jpqnlonly != 1) {
    var %a0 = $len($timestamp) | var %a1 = $calc(%a0 + 1) | var %a2 = $calc(%a1 + 8) | window -g0k0nwzl -t $+ %a1 $+ , $+ %a2 @NickLog $scriptdirjpqlogs.ico
  }
}
alias openkicklog {
  if (!$window(@KickLog)) && ($jpqnlonly != 1) {
    var %a0 = $len($timestamp) | var %a1 = $calc(%a0 + 1) | var %a2 = $calc(%a1 + 8) | window -g0k0nwzl -t $+ %a1 $+ , $+ %a2 @KickLog $scriptdirjpqlogs.ico
  }
}
alias openwnlog {
  if (!$window(@WNLog)) {
    var %a0 = $len($timestamp) | var %a1 = $calc(%a0 + 1) | var %a2 = $calc(%a1 + 8) | window -g0k0nwzl -t $+ %a1 $+ , $+ %a2 @WNLog $scriptdirjpqlogsw.ico
  }
}
on *:load:set %jpqlogs 0
on *:unload:unset %jpqlogs
on *:start:if (%jpqlogs == 1) openjpqlogs
on *:join:#:{
  if ($jpqlogs == 0) halt
  openjpqlogs
  if ($jpqnlonly == 0) aline @JoinLog $+($chr(91),$date,$chr(93),$timestamp,$chr(32),$network,$chr(32),$iif(!$nick,Null,$nick),$chr(32),joined $chan)
  if ($nick isin $wnicks) aline @WNLog $+($chr(91),$date,$chr(93),$timestamp,$chr(32),$network,$chr(32),$iif(!$nick,Null,$nick),$chr(32),joined $chan)
}
on *:part:#:{
  if ($jpqlogs == 0) halt
  openjpqlogs
  if ($jpqnlonly == 0) aline @PartLog $+($chr(91),$date,$chr(93),$timestamp,$chr(32),$network,$chr(32),$iif(!$nick,Null,$nick),$chr(32), parted $chan $+($chr(40),$1-,$chr(41)))
  if ($nick isin $wnicks) aline @WNLog $+($chr(91),$date,$chr(93),$timestamp,$chr(32),$network,$chr(32),$iif(!$nick,Null,$nick),$chr(32), parted $chan $+($chr(40),$1-,$chr(41)))
}
on *:quit:{
  if ($jpqlogs == 0) halt
  openjpqlogs
  if ($jpqnlonly == 0) aline @QuitLog $+($chr(91),$date,$chr(93),$timestamp,$chr(32),$network,$chr(32),$iif(!$nick,Null,$nick),$chr(32),quit $+($chr(40),$1-,$chr(41)))
  if ($nick isin $wnicks) aline @WNLog $+($chr(91),$date,$chr(93),$timestamp,$chr(32),$network,$chr(32),$iif(!$nick,Null,$nick),$chr(32),quit $+($chr(40),$1-,$chr(41)))
}
on *:nick:{
  if ($jpqlogs == 0) halt
  openjpqlogs
  if ($jpqnlonly == 0) aline @NickLog $+($chr(91),$date,$chr(93),$timestamp,$chr(32),$network,$chr(32),,$nick,,$chr(32),changed their nick to,$chr(32),,$newnick,) 
  if ($nick isin $wnicks) aline @WNLog $+($chr(91),$date,$chr(93),$timestamp,$chr(32),$network,$chr(32),,$nick,,$chr(32),changed their nick to,$chr(32),,$newnick,) 
}
on *:kick:{
  if ($jpqlogs == 0) halt
  openjpqlogs
  if ($jpqnlonly == 0) aline @KickLog $+($chr(91),$date,$chr(93),$timestamp,$chr(32),$network,$chr(32),,$knick,,$chr(32),was kicked from,$chr(32),,$chan,,$chr(32),by,$chr(32),,$nick,) 
  if ($nick isin $wnicks) aline @WNLog $+($chr(91),$date,$chr(93),$timestamp,$chr(32),$network,$chr(32),,$knick,,$chr(32),was kicked from,$chr(32),,$chan,,$chr(32),by,$chr(32),,$nick,) 
}
menu @JoinLog,@PartLog,@QuitLog,@NickLog,@KickLog,@WNLog {
  JPQLogs $+($chr(40),$active,$chr(41)) [Click to Clear]:clear $active
  -
  $iif($jpqlogs == 0,Disabled [Click to Enable]) :openjpqlogs
  $iif($jpqlogs == 1,$style(1) Enabled [Click to Disable]) :closejpqlogs
  -
  $iif($jpqnlonly == 0,Watched Nicks Only Mode Disabled [Click to Enable]) :set %jpqnlonly 1 | openwnlog | closejoinlog | closepartlog | closequitlog | closekicklog | closenicklog
  $iif($jpqnlonly == 1,$style(1) Watched Nicks Only Mode Enabled [Click to Disable]) :set %jpqnlonly 0 | openjpqlogs
  -
  Copy Line(s) to Clipboard: {
    if (!$sline($active,0)) halt
    var %c = 1
    clipboard
    while (%c <= $sline($active,0)) {
      if ($sline($active,0) == 1) {
        clipboard $sline($active,1)
        halt
      }
      clipboard -an $sline($active,%c)
      inc %c
    }
  }
  -
  Watched Nicks
  .$wnicks
}
menu channel,status,toolbar {
  JPQLogs
  .$iif($jpqlogs == 0,Disabled [Click to Enable]) :openjpqlogs
  .$iif($jpqlogs == 1,$style(1) Enabled [Click to Disable]) :closejpqlogs
  .-
  .$iif($jpqnlonly == 0,Watched Nicks Only Mode Disabled [Click to Enable]) :set %jpqnlonly 1 | openwnlog | closejoinlog | closepartlog | closequitlog | closekicklog | closenicklog
  .$iif($jpqnlonly == 1,$style(1) Watched Nicks Only Mode Enabled [Click to Disable]) :set %jpqnlonly 0 | openjpqlogs
  .-
  .Watched Nicks
  ..$wnicks
}
