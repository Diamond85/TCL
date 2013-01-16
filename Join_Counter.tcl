#-----------------------------------------------------------------------------------#
#                                                                                   #
#                                                                                   #
# Join_Counter                                                                      #
#                                                                                   #
#                                                                                   #
#                                                                                   #
# Usage:                                                                            #
#   Terminal: .chanset #channel +Join_Counter                                       #
#   Channel: !Join_Counter Help                                                     #
#                                                                                   #
#                                                                                   #
#                                                                                   #
# TODO:                                                                             #
#   - Multi Using                                                                   #
#   - Channel / Query                                                               #
#                                                                                   #
#                                                                                   #
#                                                                                   #
# ChangeLog:                                                                        #
#   - Multi Language                                                                #
#   - Mysql                                                                         #
#   - General Script                                                                #
#                                                                                   #
# Contakt:                                                                          #
# Copyright (C) 2013, Diamond85                                                     #
# E-Mail: Diamond85@gmx.de                                                          #
#                                                                                   #
#                                                                                   #
#-----------------------------------------------------------------------------------#
namespace eval Join_Counter {
 #############################################################################
 #                                                                           #
 #                                                                           #
 #                               Config Begins                               #
 #                                                                           #
 #                                                                           #
 #############################################################################
 #############################################################################
 #                             General Settings                              #
 #############################################################################
 
 # set this to the command character you want to use for the binds
  variable command_char "!"
  
 # set these to your preferred binds
  variable command_bind "counter"
  
 # number of seconds to ignoring the flooder
 # "0" - disable ignore, "180" - ignoring the flooder for 180 seconds
  variable wait_time "180"
  
 # set here the admin flags (m=Master / n=Owner / o=OP ...)
 # to enable or disable this script on channel commands
  variable admin_flags "+nmo|+nmo"
  
 # set here the channel flag (op=Operator / halfop=Half Operator / voice=Voice User ...)
 # to enable or disable this script on channel commands
  variable chan_flags "op"
  
 # set here the default language
 # "en" - english, "de" - german
  variable text_lang "de"
  
 # set here the nicks are not to be added to database
 # seperate the nicks with :
  variable no_nicks "*guest*"
  
 # number of seconds to no post after rejoin from same host
 # "0" - disable ignore, "180" - ignoring the rejoiner for 180 seconds
  variable no_rejoin "300"
  
 #############################################################################
 #                              MySQL Settings                               #
 #############################################################################
 
 # Set Here The MySQL Host
  variable sql_host "localhost"
  
 # Set Here The MySQL User
  variable sql_user "eggdrop"
  
 # Set Here The MySQL User Pass
  variable sql_password "eggdrop"
  
 # Set Here The MySQL Database
  variable sql_database "eggdrop"
  
 # Set Here The MySQL Table
  variable sql_table "Join_Counter"
  
 #############################################################################
 #                                                                           #
 #                                                                           #
 #                                Config_End                                 #
 #                                                                           #
 #                                                                           #
 #############################################################################
 
 #############################################################################
 #                               Script Info                                 #
 #############################################################################
  variable tcl_name "Join_Counter"
  variable tcl_projectname "J_C"
  variable tcl_author "Diamond85"
  variable tcl_contact "Diamond85@gmx.de"
  variable tcl_website "Coming Soon"
  variable tcl_copyright "©"
  variable tcl_year "2013"
  variable tcl_version "4.0"
  variable tcl_date "15.Jan.2013"
 #############################################################################
 #                             Setudef Settings                              #
 #############################################################################
  setudef flag Join_Counter
  setudef str Join_Counter-Wait
  setudef str Join_Counter-Admin_Flags
  setudef str Join_Counter-Chan_Flags
  setudef str Join_Counter-Lang
  setudef str Join_Counter-Nicks
  setudef str Join_Counter-Rejoin
 #############################################################################
 #                                Bind Bind                                  #
 #############################################################################
  bind evnt - prerehash Join_Counter::bb_stop
  bind evnt - rehash Join_Counter::bb_start
  bind evnt - loaded Join_Counter::bb_start
  bind evnt - rehash Join_Counter::bb_settings
  bind evnt - loaded Join_Counter::bb_settings
  proc bb_settings { args } {
   foreach chan [channels] {
    if {[channel get $chan Join_Counter-Wait] == ""} {
     channel set $chan Join_Counter-Wait $Join_Counter::wait_time
  }
    if {[channel get $chan Join_Counter-Admin_Flags] == ""} {
     channel set $chan Join_Counter-Admin_Flags $Join_Counter::admin_flags
  }
    if {[channel get $chan Join_Counter-Chan_Flags] == ""} {
     channel set $chan Join_Counter-Chan_Flags $Join_Counter::chan_flags
	}
    if {[channel get $chan Join_Counter-Lang] == ""} {
     channel set $chan Join_Counter-Lang $Join_Counter::text_lang
	}
    if {[channel get $chan Join_Counter-Nicks] == ""} {
     channel set $chan Join_Counter-Nicks $Join_Counter::no_nicks
	}
	if {[channel get $chan Join_Counter-Rejoin] == ""} {
     channel set $chan Join_Counter-Rejoin $Join_Counter::no_rejoin
	}
   }
  }
  proc bb_start { args } {
   foreach bind [split $Join_Counter::command_bind " "] {
    bind pub -|- "${Join_Counter::command_char}$bind" Join_Counter::sa_action
    bind ctcp - VERSION Join_Counter::cv_version
    bind join -|- * Join_Counter::sj_join
    bind join -|- * Join_Counter::join_settings
    bind time -|- "00 00 * * *" Join_Counter::cr_reset
   }
  }
  proc join_settings { nick host hand chan } {
   if {[isbotnick $nick]} {
    if {[channel get $chan Join_Counter-Wait] == ""} {
     channel set $chan Join_Counter-Wait $Join_Counter::wait_time
	}
    if {[channel get $chan Join_Counter-Admin_Flags] == ""} {
     channel set $chan Join_Counter-Admin_Flags $Join_Counter::admin_flags
	}
    if {[channel get $chan Join_Counter-Chan_Flags] == ""} {
     channel set $chan Join_Counter-Chan_Flags $Join_Counter::chan_flags
	}
    if {[channel get $chan Join_Counter-Lang] == ""} {
     channel set $chan Join_Counter-Lang $Join_Counter::text_lang
	}
    if {[channel get $chan Join_Counter-Nicks] == ""} {
     channel set $chan Join_Counter-Nicks $Join_Counter::no_nicks
	}
	if {[channel get $chan Join_Counter-Rejoin] == ""} {
     channel set $chan Join_Counter-Rejoin $Join_Counter::no_rejoin
	}
   }
  }
  proc bb_stop { args } {
   foreach bind [split $Join_Counter::command_bind " "] {
    bind pub -|- "${Join_Counter::command_char}$bind" Join_Counter::sa_action
    unbind ctcp - VERSION Join_Counter::cv_version
    unbind join -|- * Join_Counter::sj_join
    unbind join -|- * Join_Counter::bb_settings
    unbind time -|- "00 00 * * *" Join_Counter::cr_reset
   }
  }
 #############################################################################
 #                              MySQL Settings                               #
 #############################################################################
  variable sql_handle ""
  variable sql_namelast ""
  package require mysqltcl 3.0
 #############################################################################
 #                               MySQL Action                                #
 #############################################################################
  bind evnt - prerehash Join_Counter::sql_stop
  bind evnt - rehash Join_Counter::sql_start
  bind evnt - loaded Join_Counter::sql_start
  bind time - "30 * * * *" Join_Counter::sql_dirtyhack
  proc sql_dirtyhack {args} {
   Join_Counter::sql_change $Join_Counter::sql_table; set xy [Join_Counter::sql_query "SELECT * from $Join_Counter::sql_table where 1=2"]
  }
  proc sql_start { args } {
   set Join_Counter::sql_handle [::mysql::connect -host $Join_Counter::sql_host -user $Join_Counter::sql_user -password $Join_Counter::sql_password -encoding binary]
  }
  proc sql_stop { args } {
   if {$Join_Counter::sql_handle != ""} { ::mysql::close $Join_Counter::sql_handle }
  }
  proc sql_change { sql_database } {
   if {$Join_Counter::sql_namelast != $Join_Counter::sql_database} {
    set Join_Counter::sql_namelast $Join_Counter::sql_database
    ::mysql::use $Join_Counter::sql_handle $Join_Counter::sql_database
   }
  }
  proc sql_query { sql } {
   if {[string toupper [lindex $sql 0]] == "SELECT"} {
    return [::mysql::sel $Join_Counter::sql_handle $sql -list]
   } else {
    ::mysql::exec $Join_Counter::sql_handle $sql
    return 0
   }
  }
 #############################################################################
 #                               Wait Action                                 #
 #############################################################################
  proc wa_action {nick host hand chan arg} {
   if {[set timeleft [Join_Counter::wa_throttled $nick $host $hand $chan [rand [channel get $chan Join_Counter-Wait]]]]} { 
    if {[channel get $chan $Join_Counter::tcl_name-Lang] == "en"} {
     return 0 
	 putnow "PRIVMSG $chan :\[14Join Counter 04Flood Protection\] 09You 14can only again in 04$timeleft 14seconds!"
    }
    if {[channel get $chan $Join_Counter::tcl_name-Lang] == "de"} {
     putnow "PRIVMSG $chan :\[14Join Counter 04Flood Protection\] 09Du 14darfst erst wieder in 04$timeleft 14Sekunden!"
     return 0 
	}
   } else { 
    Join_Counter::sa_action2 $nick $host $hand $chan $arg
   } 
  }
  proc wa_throttled {nick host hand chan arg} { 
   global Join_Counter
   if {[info exists Join_Counter($host,$chan)]} { 
    if {[lsearch [utimers] "*Join_Counter($host,$chan)*"] == 0} {
	 set change1 [split [utimers]]
	 set change2 "[lindex $change1 0]\}"
	 set change3 "[join $change2]"
	 return $change3
	}
   } {
    set Join_Counter($host,$chan) [clock sec] 
	utimer $arg [list unset Join_Counter($host,$chan)] 
    return 0 
   } 
  }
 #############################################################################
 #                               Start Action                                #
 #############################################################################
  proc sa_action {nick host hand chan arg} {
   foreach chanflags [split [channel get $chan Join_Counter-Chan_Flags] ":"] {
    set chan_flags $chanflags
   }
   set admin_flags [channel get $chan Join_Counter-Admin_Flags]
   set arg [split $arg]
   switch -exact -- [lindex $arg 0] {
    "help" {
     if {[matchattr $hand $admin_flags] || [is$chan_flags $nick $chan]} {
      if {[channel get $chan Join_Counter]} {
	   if {[lindex $arg 1] == "add"} {
        if {[channel get $chan Join_Counter-Lang] == "en"} {
         putnow "PRIVMSG $chan :\[14Join Counter\] 14available Commands:"
         putnow "PRIVMSG $chan :$Join_Counter::command_char09$Join_Counter::command_bind 14Add Table"
         putlog "\[14Join Counter\] \[07Info\] (14Help 09[lindex $arg 1] 14Command) 14from 09$nick!09$host 14on 09$chan"
        }
        if {[channel get $chan Join_Counter-Lang] == "de"} {
         putnow "PRIVMSG $chan :\[14Join Counter\] 14Verfügbare Befehle:"
         putnow "PRIVMSG $chan :$Join_Counter::command_char09$Join_Counter::command_bind 14Add Table"
         putlog "\[14Join Counter\] \[07Info\] (14Help 09[lindex $arg 1] 14Befehl) 14von 09$nick!09$host 14in 09$chan"
        }
       } elseif {[lindex $arg 1] == "set"} {
        if {[channel get $chan Join_Counter-Lang] == "en"} {
         putnow "PRIVMSG $chan :\[14Join Counter\] 14available Commands:"
         putnow "PRIVMSG $chan :$Join_Counter::command_char09$Join_Counter::command_bind 14Set 04Off"
         putnow "PRIVMSG $chan :$Join_Counter::command_char09$Join_Counter::command_bind 14Set Wait (0960 14or 09120 ...)"
         putnow "PRIVMSG $chan :$Join_Counter::command_char09$Join_Counter::command_bind 14Set Admin Flags (+09mno|+09mno 14or +09o|+09o ...)"
         putnow "PRIVMSG $chan :$Join_Counter::command_char09$Join_Counter::command_bind 14Set Chan Flags (09Op 14or 09HalfOp ...)"
         putnow "PRIVMSG $chan :$Join_Counter::command_char09$Join_Counter::command_bind 14Set Lang (09DE)"
         putnow "PRIVMSG $chan :$Join_Counter::command_char09$Join_Counter::command_bind 14Set Nicks (*09Guest* 14or *09User* ...)"
         putnow "PRIVMSG $chan :$Join_Counter::command_char09$Join_Counter::command_bind 14Set Rejoin (0960 14or 09120 ...)"
         putlog "\[14Join Counter\] \[07Info\] (14Help 09[lindex $arg 1] 14Command) 14from 09$nick!09$host 14on 09$chan"
        }
        if {[channel get $chan Join_Counter-Lang] == "de"} {
         putnow "PRIVMSG $chan :\[14Join Counter\] 14Verfügbare Befehle:"
         putnow "PRIVMSG $chan :$Join_Counter::command_char09$Join_Counter::command_bind 14Set 04Off"
         putnow "PRIVMSG $chan :$Join_Counter::command_char09$Join_Counter::command_bind 14Set Wait (0960 14oder 09120 ...)"
         putnow "PRIVMSG $chan :$Join_Counter::command_char09$Join_Counter::command_bind 14Set Admin Flags (+09mno|+09mno 14oder +09o|+09o ...)"
         putnow "PRIVMSG $chan :$Join_Counter::command_char09$Join_Counter::command_bind 14Set Chan Flags (09Op 14oder 09HalfOp ...)"
         putnow "PRIVMSG $chan :$Join_Counter::command_char09$Join_Counter::command_bind 14Set Lang (09EN)"
         putnow "PRIVMSG $chan :$Join_Counter::command_char09$Join_Counter::command_bind 14Set Nicks (*09Guest* 14oder *09User* ...)"
         putnow "PRIVMSG $chan :$Join_Counter::command_char09$Join_Counter::command_bind 14Set Rejoin (0960 14oder 09120 ...)"
         putlog "\[14Join Counter\] \[07Info\] (14Help 09[lindex $arg 1] 14Befehl) 14von 09$nick!09$host 14in 09$chan"
        }
       } else {
	    if {[lindex $arg 1] == ""} {
         if {[channel get $chan Join_Counter-Lang] == "en"} {
         putnow "PRIVMSG $chan :\[14Join Counter\] 14available Commands:"
         putnow "PRIVMSG $chan :$Join_Counter::command_char09$Join_Counter::command_bind 14Help Add"
         putnow "PRIVMSG $chan :$Join_Counter::command_char09$Join_Counter::command_bind 14Help Set"
         putnow "PRIVMSG $chan :$Join_Counter::command_char09$Join_Counter::command_bind 14Help (09<09Nick>)"
         putnow "PRIVMSG $chan :$Join_Counter::command_char09$Join_Counter::command_bind 14Version (09<09Nick>)"
         putnow "PRIVMSG $chan :$Join_Counter::command_char09$Join_Counter::command_bind (09<09Nick>)"
         putlog "\[14Join Counter\] \[07Info\] (14Help Command) 14from 09$nick!09$host 14on 09$chan"
        }
        if {[channel get $chan Join_Counter-Lang] == "de"} {
         putnow "PRIVMSG $chan :\[14Join Counter\] 14Verfügbare Befehle:"
         putnow "PRIVMSG $chan :$Join_Counter::command_char09$Join_Counter::command_bind 14Help Add"
         putnow "PRIVMSG $chan :$Join_Counter::command_char09$Join_Counter::command_bind 14Help Set"
         putnow "PRIVMSG $chan :$Join_Counter::command_char09$Join_Counter::command_bind 14Help (09<09Nick>)"
         putnow "PRIVMSG $chan :$Join_Counter::command_char09$Join_Counter::command_bind 14Version (09<09Nick>)"
         putnow "PRIVMSG $chan :$Join_Counter::command_char09$Join_Counter::command_bind (09<09Nick>)"
         putlog "\[14Join Counter\] \[07Info\] (14Help Befehl) 14von 09$nick!09$host 14in 09$chan"
        }
       } else {
        if {[channel get $chan Join_Counter-Lang] == "en"} {
         putnow "PRIVMSG $chan :\[14Join Counter\] 09[lindex $arg 1] 14available Commands:"
         putnow "PRIVMSG $chan :$Join_Counter::command_char09$Join_Counter::command_bind 14Version"
         putnow "PRIVMSG $chan :$Join_Counter::command_char09$Join_Counter::command_bind 14Count (09<09Nick>)"
         putlog "\[14Join Counter\] \[07Info\] (14Help 09[lindex $arg 1] 14Command) 14from 09$nick!09$host 14on 09$chan"
        }
        if {[channel get $chan Join_Counter-Lang] == "de"} {
         putnow "PRIVMSG $chan :\[14Join Counter\] 09[lindex $arg 1] 14Verfügbare Befehle:"
         putnow "PRIVMSG $chan :$Join_Counter::command_char09$Join_Counter::command_bind 14Version"
         putnow "PRIVMSG $chan :$Join_Counter::command_char09$Join_Counter::command_bind 14Count (09<09Nick>)"
         putlog "\[14Join Counter\] \[07Info\] (14Help 09[lindex $arg 1] 14Befehl) 14von 09$nick!09$host 14in 09$chan"
        }
       }
	   }
      } else {
       if {[channel get $chan Join_Counter-Lang] == "en"} {
        putnow "PRIVMSG $chan :\[14Join Counter\] 09[lindex $arg 1] 14available Commands:"
        putnow "PRIVMSG $chan :$Join_Counter::command_char09$Join_Counter::command_bind 14Set 09On"
        putlog "\[14Join Counter\] \[07Info\] (14Help Command) 14from 09$nick!09$host 14on 09$chan"
       }
       if {[channel get $chan Join_Counter-Lang] == "de"} {
        putnow "PRIVMSG $chan :\[14Join Counter\] 14Verfügbare Befehle:"
        putnow "PRIVMSG $chan :$Join_Counter::command_char09$Join_Counter::command_bind 14Set 09On"
        putlog "\[14Join Counter\] \[07Info\] (14Help Command) 14from 09$nick!09$host 14on 09$chan"
       }
	  }
	 } else {
	  if {[channel get $chan Join_Counter]} {
	   if {[lindex $arg 1] == ""} {
        if {[channel get $chan Join_Counter-Lang] == "en"} {
         putnow "PRIVMSG $chan :\[14Join Counter\] 14available Commands:"
         putnow "PRIVMSG $chan :$Join_Counter::command_char09$Join_Counter::command_bind 14Version"
         putnow "PRIVMSG $chan :$Join_Counter::command_char09$Join_Counter::command_bind 14Count (09<09Nick>)"
         putlog "\[14Join Counter\] \[07Info\] (14Help Command) 14from 09$nick!09$host 14on 09$chan"
        }
        if {[channel get $chan Join_Counter-Lang] == "de"} {
         putnow "PRIVMSG $chan :\[14Join Counter\] 14Verfügbare Befehle:"
         putnow "PRIVMSG $chan :$Join_Counter::command_char09$Join_Counter::command_bind 14Version"
         putnow "PRIVMSG $chan :$Join_Counter::command_char09$Join_Counter::command_bind 14Count (09<09Nick>)"
         putlog "\[14Join Counter\] \[07Info\] (14Help Befehl) 14von 09$nick!09$host 14in 09$chan"
        }
       } else {
        if {[channel get $chan Join_Counter-Lang] == "en"} {
         putnow "PRIVMSG $chan :\[14Join Counter\] \[07Info\] 09$nick 14You can not use this command!"
        }
        if {[channel get $chan Join_Counter-Lang] == "de"} {
         putnow "PRIVMSG $chan :\[14Join Counter\] \[07Info\] 09$nick 14Du darfst diesen Befehl nicht Benutzen!"
	    }
       }
	  }
     }
	}
	"version" {
     if {[matchattr $hand $admin_flags] || [is$chan_flags $nick $chan]} {
      if {[channel get $chan Join_Counter]} {
       if {[lindex $arg 1] == ""} {
        if {[channel get $chan Join_Counter-Lang] == "en"} {
         putnow "PRIVMSG $chan :\[14Join Counter\] 14Projekt Name: 09$Join_Counter::tcl_projectname \| 14Version: 09$Join_Counter::tcl_version \| 14Date: 09$Join_Counter::tcl_date \| 14CopyRight: 09$Join_Counter::tcl_copyright - 09$Join_Counter::tcl_year 14by 09$Join_Counter::tcl_author \| 14e-14Mail: 09$Join_Counter::tcl_contact \| 14HomePage: \03709$Join_Counter::tcl_website\037 (14Status: 09On)"
         putlog "\[14Join Counter\] \[07Info\] (14Version Command) 14from 09$nick!09$host 14on 09$chan"
        }
        if {[channel get $chan Join_Counter-Lang] == "de"} {
         putnow "PRIVMSG $chan :\[14Join Counter\] 14Projekt Name: 09$Join_Counter::tcl_projectname \| 14Version: 09$Join_Counter::tcl_version \| 14Date: 09$Join_Counter::tcl_date \| 14CopyRight: 09$Join_Counter::tcl_copyright - 09$Join_Counter::tcl_year 14by 09$Join_Counter::tcl_author \| 14e-14Mail: 09$Join_Counter::tcl_contact \| 14HomePage: \03709$Join_Counter::tcl_website\037 (14Status: 09On)"
         putlog "\[14Join Counter\] \[07Info\] (14Version Befehl) 14von 09$nick!09$host 14in 09$chan"
        }
       } else {
        if {[channel get $chan Join_Counter-Lang] == "en"} {
         putnow "PRIVMSG $chan :\[14Join Counter\] 09[lindex $arg 1] 14Projekt Name: 09$Join_Counter::tcl_projectname \| 14Version: 09$Join_Counter::tcl_version \| 14Date: 09$Join_Counter::tcl_date \| 14CopyRight: 09$Join_Counter::tcl_copyright - 09$Join_Counter::tcl_year 14by 09$Join_Counter::tcl_author \| 14e-14Mail: 09$Join_Counter::tcl_contact \| 14HomePage: \03709$Join_Counter::tcl_website\037 (14Status: 09On)"
         putlog "\[14Join Counter\] \[07Info\] (14Version 09[lindex $arg 1] 14Command) 14from 09$nick!09$host 14on 09$chan"
        }
        if {[channel get $chan Join_Counter-Lang] == "de"} {
         putnow "PRIVMSG $chan :\[14Join Counter\] 09[lindex $arg 1] 14Projekt Name: 09$Join_Counter::tcl_projectname \| 14Version: 09$Join_Counter::tcl_version \| 14Date: 09$Join_Counter::tcl_date \| 14CopyRight: 09$Join_Counter::tcl_copyright - 09$Join_Counter::tcl_year 14by 09$Join_Counter::tcl_author \| 14e-14Mail: 09$Join_Counter::tcl_contact \| 14HomePage: \03709$Join_Counter::tcl_website\037 (14Status: 09On)"
         putlog "\[14Join Counter\] \[07Info\] (14Version 09[lindex $arg 1] 14Befehl) 14von 09$nick!09$host 14in 09$chan"
        }
       }
      } else {
	   if {[lindex $arg 1] == ""} {
	    if {[channel get $chan Join_Counter-Lang] == "en"} {
         putnow "PRIVMSG $chan :\[14Join Counter\] 14Projekt Name: 09$Join_Counter::tcl_projectname \| 14Version: 09$Join_Counter::tcl_version \| 14Date: 09$Join_Counter::tcl_date \| 14CopyRight: 09$Join_Counter::tcl_copyright - 09$Join_Counter::tcl_year 14by 09$Join_Counter::tcl_author \| 14e-14Mail: 09$Join_Counter::tcl_contact \| 14HomePage: \03709$Join_Counter::tcl_website\037 (14Status: 04Off)"
         putlog "\[14Join Counter\] \[07Info\] (14Version Command) 14from 09$nick!09$host 14on 09$chan"
        }
        if {[channel get $chan Join_Counter-Lang] == "de"} {
         putnow "PRIVMSG $chan :\[14Join Counter\] 14Projekt Name: 09$Join_Counter::tcl_projectname \| 14Version: 09$Join_Counter::tcl_version \| 14Date: 09$Join_Counter::tcl_date \| 14CopyRight: 09$Join_Counter::tcl_copyright - 09$Join_Counter::tcl_year 14by 09$Join_Counter::tcl_author \| 14e-14Mail: 09$Join_Counter::tcl_contact \| 14HomePage: \03709$Join_Counter::tcl_website\037 (14Status: 04Off)"
         putlog "\[14Join Counter\] \[07Info\] (14Version Befehl) 14von 09$nick!09$host 14in 09$chan"
        }
       } else {
	    if {[channel get $chan Join_Counter-Lang] == "en"} {
         putnow "PRIVMSG $chan :\[14Join Counter\] 14is 04Off! 14Please use $Join_Counter::command_char09$Join_Counter::command_bind 14Set 09On"
        }
        if {[channel get $chan Join_Counter-Lang] == "de"} {
         putnow "PRIVMSG $chan :\[14Join Counter\] 14ist 04Aus! 14Benutze Bitte $Join_Counter::command_char09$Join_Counter::command_bind 14Set 09On"
        }
	   }
	  }
     } else {
	  if {[lindex $arg 1] == ""} {
       if {[channel get $chan Join_Counter]} {
        if {[channel get $chan Join_Counter-Lang] == "en"} {
         putnow "PRIVMSG $chan :\[14Join Counter\] 14Projekt Name: 09$Join_Counter::tcl_projectname \| 14Version: 09$Join_Counter::tcl_version \| 14Date: 09$Join_Counter::tcl_date \| 14CopyRight: 09$Join_Counter::tcl_copyright - 09$Join_Counter::tcl_year 14by 09$Join_Counter::tcl_author \| 14e-14Mail: 09$Join_Counter::tcl_contact \| 14HomePage: \03709$Join_Counter::tcl_website\037 (14Status: 09On)"
         putlog "\[14Join Counter\] \[07Info\] (14Version Command) 14from 09$nick!09$host 14on 09$chan"
        }
        if {[channel get $chan Join_Counter-Lang] == "de"} {
         putnow "PRIVMSG $chan :\[14Join Counter\] 14Projekt Name: 09$Join_Counter::tcl_projectname \| 14Version: 09$Join_Counter::tcl_version \| 14Date: 09$Join_Counter::tcl_date \| 14CopyRight: 09$Join_Counter::tcl_copyright - 09$Join_Counter::tcl_year 14by 09$Join_Counter::tcl_author \| 14e-14Mail: 09$Join_Counter::tcl_contact \| 14HomePage: \03709$Join_Counter::tcl_website\037 (14Status: 09On)"
         putlog "\[14Join Counter\] \[07Info\] (14Version Befehl) 14von 09$nick!09$host 14in 09$chan"
        }
       }
	  } else {
       if {[channel get $chan Join_Counter-Lang] == "en"} {
        putnow "PRIVMSG $chan :\[14Join Counter\] \[07Info\] 09$nick 14You can not use this command!"
       }
       if {[channel get $chan Join_Counter-Lang] == "de"} {
        putnow "PRIVMSG $chan :\[14Join Counter\] \[07Info\] 09$nick 14Du darfst diesen Befehl nicht Benutzen!"
       }
	  }
     }
	}
	"add" {
	 if {[matchattr $hand $admin_flags] || [is$chan_flags $nick $chan]} {
	  if {[channel get $chan Join_Counter]} {
	   if {[lindex $arg 1] == "table"} {
        Join_Counter::sql_change $Join_Counter::sql_database
        Join_Counter::sql_query "CREATE TABLE $Join_Counter::sql_table (Nick varchar(50), Host varchar(50), Type varchar(20), Chan varchar(50), Date DATETIME NOT NULL, Count int(10) Default 0);"
        if {[channel get $chan Join_Counter-Lang] == "en"} {
         putnow "PRIVMSG $chan :\[14Join Counter\] 14im have added the table 09$Join_Counter::sql_table (09Nick , 09Host , 09Type , 09Chan , 09Date , 09Count) 14to 09$Join_Counter::sql_database 14database."
         putlog "\[14Join Counter\] \[07Info\] (14Add 09[lindex $arg 1] 14Command) 14from 09$nick!09$host 14on 09$chan"
        }
        if {[channel get $chan Join_Counter-Lang] == "de"} {
         putnow "PRIVMSG $chan :\[14Join Counter\] 14Ich habe die Tabelle 09$Join_Counter::sql_table (09Nick , 09Host , 09Type , 09Chan , 09Date , 09Count) 14Zur 09$Join_Counter::sql_database 14Datenbank Hinzugefügt."
         putlog "\[14Join Counter\] \[07Info\] (14Add 09[lindex $arg 1] 14Befehl) 14von 09$nick!09$host 14in 09$chan"
        }
       } elseif {[lindex $arg 1] == ""} {
	    if {[channel get $chan Join_Counter-Lang] == "en"} {
	     putnow "PRIVMSG $chan :\[14Join Counter\] 14Please use $Join_Counter::command_char09$Join_Counter::command_bind 14Help Add"
        }
        if {[channel get $chan Join_Counter-Lang] == "de"} {
         putnow "PRIVMSG $chan :\[14Join Counter\] 14Benutze Bitte $Join_Counter::command_char09$Join_Counter::command_bind 14Help Add"
		}
	   }
	  }
     } else {
	  if {[channel get $chan Join_Counter]} {
	   if {[channel get $chan Join_Counter-Lang] == "en"} {
        putnow "PRIVMSG $chan :\[14Join Counter\] \[07Info\] 09$nick 14You can not use this command!"
       }
       if {[channel get $chan Join_Counter-Lang] == "de"} {
        putnow "PRIVMSG $chan :\[14Join Counter\] \[07Info\] 09$nick 14Du darfst diesen Befehl nicht Benutzen!"
       }
	  }
	 }
	}
    "set" {
	 if {[lindex $arg 1] == "on"} {
	  if {[matchattr $hand $admin_flags] || [is$chan_flags $nick $chan]} {
	   if {[channel get $chan Join_Counter]} {
        if {[channel get $chan Join_Counter-Lang] == "en"} {
         putnow "PRIVMSG $chan :\[14Join Counter\] 14Is already 09On."
         putlog "\[14Join Counter\] \[07Info\] (14Set 09[lindex $arg 1] 14Command) 14from 09$nick!09$host 14on 09$chan"
        }
        if {[channel get $chan Join_Counter-Lang] == "de"} {
         putnow "PRIVMSG $chan :\[14Join Counter\] 14Ist bereits 09An."
         putlog "\[14Join Counter\] \[07Info\] (14Set 09[lindex $arg 1] 14Befehl) 14von 09$nick!09$host 14in 09$chan"
        }
       } else {
        channel set $chan +Join_Counter
        if {[channel get $chan Join_Counter-Lang] == "en"} {
         putnow "PRIVMSG $chan :\[14Join Counter\] 14Is now 09On."
         putlog "\[14Join Counter\] \[07Info\] (14Set 09[lindex $arg 1] 14Command) 14from 09$nick!09$host 14on 09$chan"
        }
        if {[channel get $chan Join_Counter-Lang] == "de"} {
         putnow "PRIVMSG $chan :\[14Join Counter\] 14Ist nun 09An."
         putlog "\[14Join Counter\] \[07Info\] (14Set 09[lindex $arg 1] 14Befehl) 14von 09$nick!09$host 14in 09$chan"
        }
       }
	  }
	 } elseif {[lindex $arg 1] == "off"} {
	  if {[matchattr $hand $admin_flags] || [is$chan_flags $nick $chan]} {
	   if {![channel get $chan Join_Counter]} {
        if {[channel get $chan Join_Counter-Lang] == "en"} {
         putnow "PRIVMSG $chan :\[14Join Counter\] 14Is already 04off."
         putlog "\[14Join Counter\] \[07Info\] (14Set 04[lindex $arg 1] 14Command) 14from 09$nick!09$host 14on 09$chan"
        }
        if {[channel get $chan Join_Counter-Lang] == "de"} {
         putnow "PRIVMSG $chan :\[14Join Counter\] 14Ist bereits 04Aus."
         putlog "\[14Join Counter\] \[07Info\] (14Set 04[lindex $arg 1] 14Befehl) 14von 09$nick!09$host 14in 09$chan"
        }
       } else {
	    channel set $chan -Join_Counter
        if {[channel get $chan Join_Counter-Lang] == "en"} {
         putnow "PRIVMSG $chan :\[14Join Counter\] 14Is now 04Off."
         putlog "\[14Join Counter\] \[07Info\] (14Set 04[lindex $arg 1] 14Command) 14from 09$nick!09$host 14on 09$chan"
        }
        if {[channel get $chan Join_Counter-Lang] == "de"} {
         putnow "PRIVMSG $chan :\[14Join Counter\] 14Ist nun 04Aus."
         putlog "\[14Join Counter\] \[07Info\] (14Set 04[lindex $arg 1] 14Befehl) 14von 09$nick!09$host 14in 09$chan"
        }
       }
	  }
	 }
	 if {[matchattr $hand $admin_flags] || [is$chan_flags $nick $chan]} {
	  if {[channel get $chan Join_Counter]} {
	   if {[lindex $arg 1] == "wait"} {
        if {[channel get $chan Join_Counter-Lang] == "en"} {
	     if {[lindex $arg 2] == ""} {
          putnow "PRIVMSG $chan :\[14Join Counter\] \[04Error\] 14Please use $Join_Counter::command_char09$Join_Counter::command_bind 14Set Wait ( 0960 14or 09120 ... )"
         } else {
          channel set $chan Join_Counter-Wait [lindex $arg 2]
          putnow "PRIVMSG $chan :\[14Join Counter\] 14Wait was changed to 09[lindex $arg 2]."
          putlog "\[14Join Counter\] \[07Info\] (14Set [lindex $arg 1] 09[lindex $arg 2] 14Command) 14from 09$nick!09$host 14on 09$chan"
	     }
	    }
	    if {[channel get $chan Join_Counter-Lang] == "de"} {
	     if {[lindex $arg 2] == ""} {
          putnow "PRIVMSG $chan :\[14Join Counter\] \[04Error\] 14Benutze Bitte $Join_Counter::command_char09$Join_Counter::command_bind 14Set Wait ( 0960 14oder 09120 ... )"
         } else {
          channel set $chan Join_Counter-Wait [lindex $arg 2]
          putnow "PRIVMSG $chan :\[14Join Counter\] 14Wait wurde zu 09[lindex $arg 2] 14geändert."
          putlog "\[14Join Counter\] \[07Info\] (14Set [lindex $arg 1] 09[lindex $arg 2] 14Befehl) 14von 09$nick!09$host 14in 09$chan"
	     }
        }
	   } elseif {[lindex $arg 1] == "admin"} {
	    if {[lindex $arg 2] == "flags"} {
         if {[channel get $chan Join_Counter-Lang] == "en"} {
	      if {[lindex $arg 3] == ""} {
           putnow "PRIVMSG $chan :\[14Join Counter\] \[04Error\] 14Please use $Join_Counter::command_char09$Join_Counter::command_bind 14Set Flags ( +09mno|+09mno 14or +09o|+09o ... )"
          } else {
           channel set $chan Join_Counter-Admin-Flags [lindex $arg 3]
           putnow "PRIVMSG $chan :\[14Join Counter\] 14The Flags was changed to 09[lindex $arg 3]."
           putlog "\[14Join Counter\] \[07Info\] (14Set [lindex $arg 1] [lindex $arg 2] 09[lindex $arg 3] 14Command) 14from 09$nick!09$host 14on 09$chan"
	      }
	     }
	     if {[channel get $chan Join_Counter-Lang] == "de"} {
	      if {[lindex $arg 2] == ""} {
           putnow "PRIVMSG $chan :\[14Join Counter\] \[04Error\] 14Benutze Bitte $Join_Counter::command_char09$Join_Counter::command_bind 14Set Flags ( +09mno|+09mno 14oder +09o|+09o ... )"
          } else {
           channel set $chan Join_Counter-Admin-Flags [lindex $arg 3]
           putnow "PRIVMSG $chan :\[14Join Counter\] 14Der Flags wurde zu 09[lindex $arg 3] 14geändert."
           putlog "\[14Join Counter\] \[07Info\] (14Set [lindex $arg 1] [lindex $arg 2] 09[lindex $arg 3] 14Befehl) 14von 09$nick!09$host 14in 09$chan"
	      }
	     }
        }
	   } elseif {[lindex $arg 1] == "chan"} {
	    if {[lindex $arg 2] == "flags"} {
         if {[channel get $chan Join_Counter-Lang] == "en"} {
	      if {[lindex $arg 3] == ""} {
           putnow "PRIVMSG $chan :\[14Join Counter\] \[04Error\] 14Please use $Join_Counter::command_char09$Join_Counter::command_bind 14Set Chan Flags ( 09Op 14or 09HalfOp ... )"
          } else {
           channel set $chan Join_Counter-Chan-Flags [lindex $arg 3]
           putnow "PRIVMSG $chan :\[14Join Counter\] 14The Flags was changed to 09[lindex $arg 3]."
           putlog "\[14Join Counter\] \[07Info\] (14Set [lindex $arg 1] [lindex $arg 2] 09[lindex $arg 3] 14Command) 14from 09$nick!09$host 14on 09$chan"
	      }
	     }
	     if {[channel get $chan Join_Counter-Lang] == "de"} {
	      if {[lindex $arg 3] == ""} {
           putnow "PRIVMSG $chan :\[14Join Counter\] \[04Error\] 14Benutze Bitte $Join_Counter::command_char09$Join_Counter::command_bind 14Set Chan Flags ( 09Op 14oder 09HalfOp ... )"
          } else {
           channel set $chan Join_Counter-Chan-Flags [lindex $arg 3]
           putnow "PRIVMSG $chan :\[14Join Counter\] 14Der Flags wurde zu 09[lindex $arg 3] 14geändert."
           putlog "\[14Join Counter\] \[07Info\] (14Set [lindex $arg 1] [lindex $arg 2] 09[lindex $arg 3] 14Befehl) 14von 09$nick!09$host 14in 09$chan"
	      }
	     }
        }
	   } elseif {[lindex $arg 1] == "lang"} {
        if {[channel get $chan Join_Counter-Lang] == "en"} {
         if {[lindex $arg 2] == ""} {
          putnow "PRIVMSG $chan :\[14Join Counter\] \[04Error\] 14Please use $Join_Counter::command_char09$Join_Counter::command_bind 14Set Lang ( 09DE 14or 09EN )"
         } else {[lindex $arg 2] == "de"} {
          channel set $chan Join_Counter-Lang [lindex $arg 2]
          putnow "PRIVMSG $chan :\[14Join Counter\] 14Die Sprache wurde in 09[lindex $arg 2] 14geändert."
          putlog "\[14Join Counter\] \[07Info\] (14Set [lindex $arg 1] 09[lindex $arg 2] 14Command) 14from 09$nick!09$host 14on 09$chan"
         }
        }
        if {[channel get $chan Join_Counter-Lang] == "de"} {
         if {[lindex $arg 2] == ""} {
          putnow "PRIVMSG $chan :\[14Join Counter\] \[04Error\] 14Benutze Bitte $Join_Counter::command_char09$Join_Counter::command_bind 14Set Lang ( 09DE 14oder 09EN )"
         } else {[lindex $arg 2] == "en"} {
          channel set $chan Join_Counter-Lang [lindex $arg 2]
          putnow "PRIVMSG $chan :\[14Join Counter\] 14The language was changed to 09[lindex $arg 2]."
          putlog "\[14Join Counter\] \[07Info\] (14Set [lindex $arg 1] 09[lindex $arg 2] 14Befehl) 14von 09$nick!09$host 14in 09$chan"
         }
        }
       } elseif {[lindex $arg 1] == "nicks"} {
        if {[channel get $chan Join_Counter-Lang] == "en"} {
	     if {[lindex $arg 2] == ""} {
          putnow "PRIVMSG $chan :\[14Join Counter\] \[04Error\] 14Please use $Join_Counter::command_char09$Join_Counter::command_bind 14Set Nicks ( *09Guest* 14or *09User* ... )"
         } else {
          channel set $chan Join_Counter-Nicks [lindex $arg 2]
          putnow "PRIVMSG $chan :\[14Join Counter\] 14The Nicks was changed to 09[lindex $arg 2]."
          putlog "\[14Join Counter\] \[07Info\] (14Set [lindex $arg 1] 09[lindex $arg 2] 14Command) 14from 09$nick!09$host 14on 09$chan"
	     }
	    }
	    if {[channel get $chan Join_Counter-Lang] == "de"} {
	     if {[lindex $arg 2] == ""} {
          putnow "PRIVMSG $chan :\[14Join Counter\] \[04Error\] 14Benutze Bitte $Join_Counter::command_char09$Join_Counter::command_bind 14Set Nicks ( *09Guest* 14oder *09User* ... )"
         } else {
          channel set $chan Join_Counter-Nicks [lindex $arg 2]
          putnow "PRIVMSG $chan :\[14Join Counter\] 14Der Nicks wurde zu 09[lindex $arg 2] 14geändert."
          putlog "\[14Join Counter\] \[07Info\] (14Set [lindex $arg 1] 09[lindex $arg 2] 14Befehl) 14von 09$nick!09$host 14in 09$chan"
	     }
	    }
       } elseif {[lindex $arg 1] == "rejoin"} {
        if {[channel get $chan Join_Counter-Lang] == "en"} {
	     if {[lindex $arg 2] == ""} {
          putnow "PRIVMSG $chan :\[14Join Counter\] \[04Error\] 14Please use $Join_Counter::command_char09$Join_Counter::command_bind 14Set Rejoin ( 0960 14or 09120 ... )"
         } else {
          channel set $chan Join_Counter-Rejoin [lindex $arg 2]
          putnow "PRIVMSG $chan :\[14Join Counter\] 14Rejoin was changed to 09[lindex $arg 2]."
          putlog "\[14Join Counter\] \[07Info\] (14Set [lindex $arg 1] 09[lindex $arg 2] 14Command) 14from 09$nick!09$host 14on 09$chan"
	     }
	    }
	    if {[channel get $chan Join_Counter-Lang] == "de"} {
	     if {[lindex $arg 2] == ""} {
          putnow "PRIVMSG $chan :\[14Join Counter\] \[04Error\] 14Benutze Bitte $Join_Counter::command_char09$Join_Counter::command_bind 14Set Rejoin ( 0960 14oder 09120 ... )"
         } else {
          channel set $chan Join_Counter-Rejoin [lindex $arg 2]
          putnow "PRIVMSG $chan :\[14Join Counter\] 14Rejoin wurde zu 09[lindex $arg 2] 14geändert."
          putlog "\[14Join Counter\] \[07Info\] (14Set [lindex $arg 1] 09[lindex $arg 2] 14Befehl) 14von 09$nick!09$host 14in 09$chan"
	     }
        }
	   } elseif {[lindex $arg 1] == ""} {
        if {[channel get $chan Join_Counter-Lang] == "en"} {
         putnow "PRIVMSG $chan :\[14Join Counter\] 14Please use $Join_Counter::command_char09$Join_Counter::command_bind 14Help Set"
        }
        if {[channel get $chan Join_Counter-Lang] == "de"} {
         putnow "PRIVMSG $chan :\[14Join Counter\] 14Benutze Bitte $Join_Counter::command_char09$Join_Counter::command_bind 14Help Set"
	    }
	   }
	  }
	 } else {
	  if {[channel get $chan Join_Counter]} {
	   if {[channel get $chan Join_Counter-Lang] == "en"} {
        putnow "PRIVMSG $chan :\[14Join Counter\] \[07Info\] 09$nick 14You can not use this command!"
       }
       if {[channel get $chan Join_Counter-Lang] == "de"} {
        putnow "PRIVMSG $chan :\[14Join Counter\] \[07Info\] 09$nick 14Du darfst diesen Befehl nicht Benutzen!"
       }
	  }
	 }
	}
    default {
	 if {[matchattr $hand $admin_flags] || [is$chan_flags $nick $chan]} {
      if {[channel get $chan Join_Counter]} {
       Join_Counter::wa_action $nick $host $hand $chan $arg
	  } else {
	   if {[channel get $chan Join_Counter-Lang] == "en"} {
        putnow "PRIVMSG $chan :\[14Join Counter\] 14is 04Off! 14Please use $Join_Counter::command_char09$Join_Counter::command_bind 14Set 09On"
       }
       if {[channel get $chan Join_Counter-Lang] == "de"} {
        putnow "PRIVMSG $chan :\[14Join Counter\] 14ist 04Aus! 14Benutze Bitte $Join_Counter::command_char09$Join_Counter::command_bind 14Set 09On"
       }
	  }
	 } else {
	  if {[channel get $chan Join_Counter]} {
       Join_Counter::wa_action $nick $host $hand $chan $arg
	  }
     }
    }
   }
  }
  proc sa_action2 {nick host hand chan arg} {
   if {[string match -nocase [channel get $chan Join_Counter-Nicks] $nick]} {
    if {[channel get $chan Join_Counter-Lang] == "en"} {
     putnow "PRIVMSG $chan :\[14Join Counter\] \[07Info\] 09$nick 14You can not use this command!"
    }
    if {[channel get $chan Join_Counter-Lang] == "de"} {
     putnow "PRIVMSG $chan :\[14Join Counter\] \[07Info\] 09$nick 14Du darfst diesen Befehl nicht Benutzen!"
    }
   } else {
    set arg [split $arg]
    switch -exact -- [lindex $arg 0] {
     default {
      if {[channel get $chan Join_Counter]} {
       Join_Counter::sql_change $Join_Counter::sql_database
       if {$arg == ""} {
        if {[Join_Counter::sql_query "SELECT Count FROM $Join_Counter::sql_table WHERE Host = '[mysqlescape $host]' AND Type = '[mysqlescape User]' AND Chan = '[mysqlescape $chan]'"] == "" || "0"} {
         if {[channel get $chan Join_Counter-Lang] == "en"} {
          putnow "PRIVMSG $chan :\[14Join Counter\] 14Was never used by 09you."
          putlog "\[14Join Counter\] \[07Info\] (14Count Command) 14from 09$nick!09$host 14on 09$chan"
         }
         if {[channel get $chan Join_Counter-Lang] == "de"} {
          putnow "PRIVMSG $chan :\[14Join Counter\] 14Wurde noch nie von 09Dir 14benutzt."
          putlog "\[14Join Counter\] \[07Info\] (14Count Befehl) 14von 09$nick!09$host 14in 09$chan"
         }
        } else {
         set usercount [Join_Counter::sql_query "SELECT Count FROM $Join_Counter::sql_table WHERE Host = '[mysqlescape $host]' AND Type = '[mysqlescape User]' AND Chan = '[mysqlescape $chan]'"]
         if {[channel get $chan Join_Counter-Lang] == "en"} {
          set userdate [Join_Counter::sql_query "SELECT DATE_FORMAT(Date, '09%d.09%M.09%Y 14at 09%H:09%i:09%s 14a clock') FROM $Join_Counter::sql_table WHERE Host = '[mysqlescape $host]' AND Type = '[mysqlescape User]' AND Chan = '[mysqlescape $chan]'"]
          putnow "PRIVMSG $chan :\[14Join Counter\] 09You 14were already 09$usercount 14 times in 09$chan 14since: 09[join [join $userdate]]."
          putlog "\[14Join Counter\] \[07Info\] (14Count Command) 14from 09$nick!09$host 14on 09$chan"
         }
         if {[channel get $chan Join_Counter-Lang] == "de"} {
          set userdate [Join_Counter::sql_query "SELECT DATE_FORMAT(Date, '09%d.09%m.09%Y 14um 09%H:09%i:09%s 14Uhr') FROM $Join_Counter::sql_table WHERE Host = '[mysqlescape $host]' AND Type = '[mysqlescape User]' AND Chan = '[mysqlescape $chan]'"]
          putnow "PRIVMSG $chan :\[14Join Counter\] 09Du 14warst schon 09$usercount 14mal in 09$chan 14seit dem: 09[join [join $userdate]]."
          putlog "\[14Join Counter\] \[07Info\] (14Count Befehl) 14von 09$nick!09$host 14in 09$chan"
         }
        }
       } else {
        if {[Join_Counter::sql_query "SELECT Count FROM $Join_Counter::sql_table WHERE Nick = '[mysqlescape $arg]' AND Type = '[mysqlescape User]' AND Chan = '[mysqlescape $chan]'"] == "" || "0"} {
         if {[channel get $chan Join_Counter-Lang] == "en"} {
          putnow "PRIVMSG $chan :\[14Join Counter\] 14Has never been used by 09[join [join $arg]] ."
          putlog "\[14Join Counter\] \[07Info\] (14Count 09$arg 14Command) 14from 09$nick!09$host 14on 09$chan"
         }
         if {[channel get $chan Join_Counter-Lang] == "de"} {
          putnow "PRIVMSG $chan :\[14Join Counter\] 14Wurde noch nie von 09[join [join $arg]] 14benutzt."
          putlog "\[14Join Counter\] \[07Info\] (14Count 09$arg 14Befehl) 14von 09$nick!09$host 14in 09$chan"
         }
        } else {
         set usercount [Join_Counter::sql_query "SELECT Count FROM $Join_Counter::sql_table WHERE Nick = '[mysqlescape $arg]' AND Type = '[mysqlescape User]' AND Chan = '[mysqlescape $chan]'"]
         if {[channel get $chan Join_Counter-Lang] == "en"} {
          set userdate [Join_Counter::sql_query "SELECT DATE_FORMAT(Date, '09%d.09%M.09%Y 14at 09%H:09%i:09%s 14a clock') FROM $Join_Counter::sql_table WHERE Nick = '[mysqlescape $arg]' AND Type = '[mysqlescape User]' AND Chan = '[mysqlescape $chan]'"]
          putnow "PRIVMSG $chan :\[14Join Counter\] 09[join [join $arg]] 14were already 09$usercount 14 times in 09$chan 14since: 09[join [join $userdate]]."
          putlog "\[14Join Counter\] \[07Info\] (14Count 09$arg 14Command) 14from 09$nick!09$host 14on 09$chan"
         }
         if {[channel get $chan Join_Counter-Lang] == "de"} {
          set userdate [Join_Counter::sql_query "SELECT DATE_FORMAT(Date, '09%d.09%m.09%Y 14um 09%H:09%i:09%s 14Uhr') FROM $Join_Counter::sql_table WHERE Nick = '[mysqlescape $arg]' AND Type = '[mysqlescape User]' AND Chan = '[mysqlescape $chan]'"]
          putnow "PRIVMSG $chan :\[14Join Counter\] 09[join [join $arg]] 14war schon 09$usercount 14mal in 09$chan 14seit dem: 09[join [join $userdate]]."
          putlog "\[14Join Counter\] \[07Info\] (14Count 09$arg 14Befehl) 14von 09$nick!09$host 14in 09$chan"
         }
	    }
       }
      }
     }
    }
   }
  }
 #############################################################################
 #                                Start Join                                 #
 #############################################################################
  proc sj_join { nick host hand chan } {
   if {[channel get $chan Join_Counter]} {
    if {[isbotnick $nick]} { return 0 }
    Join_Counter::sql_change $Join_Counter::sql_database
    foreach nicks [split [channel get $chan Join_Counter-Nicks] " "] {
     if {[string match -nocase $nicks $nick]} {
      set day [lindex [ctime [unixtime]] 2]
      set month [lindex [ctime [unixtime]] 1]
      set year [lindex [ctime [unixtime]] 4]
      set totalcount [Join_Counter::sql_query "SELECT Count FROM $Join_Counter::sql_table WHERE Type = '[mysqlescape Join_Counter_Total]' AND Chan = '[mysqlescape $chan]'"]
      set todaycount [Join_Counter::sql_query "SELECT Count FROM $Join_Counter::sql_table WHERE Type = '[mysqlescape Join_Counter_Today]' AND Chan = '[mysqlescape $chan]'"]
      if {[Join_Counter::sql_query "SELECT Count FROM $Join_Counter::sql_table WHERE Type = '[mysqlescape Join_Counter_Total]' AND Chan = '[mysqlescape $chan]'"] == "" || "0"} {
       Join_Counter::sql_query "INSERT $Join_Counter::sql_table SET Type = '[mysqlescape Join_Counter_Total]' , Chan = '[mysqlescape $chan]' , Date = NOW() , Count = '1'"
      } else {
       Join_Counter::sql_query "UPDATE $Join_Counter::sql_table SET Count = '[expr int($totalcount + 1)]' WHERE Type = '[mysqlescape Join_Counter_Total]' AND Chan = '[mysqlescape $chan]'"
      }
      if {[Join_Counter::sql_query "SELECT Count FROM $Join_Counter::sql_table WHERE Type = '[mysqlescape Join_Counter_Today]' AND Chan = '[mysqlescape $chan]'"] == "" || "0"} {
       Join_Counter::sql_query "INSERT $Join_Counter::sql_table SET Type = '[mysqlescape Join_Counter_Today]' , Chan = '[mysqlescape $chan]', Count = '1'"
      } else {
       Join_Counter::sql_query "UPDATE $Join_Counter::sql_table SET Count = '[expr int($todaycount + 1)]' WHERE Type = '[mysqlescape Join_Counter_Today]' AND Chan = '[mysqlescape $chan]'"
      }
      if {[Join_Counter::sql_query "SELECT Date FROM $Join_Counter::sql_table WHERE Type = '[mysqlescape Join_Counter_Total]' AND Chan = '[mysqlescape $chan]'"] == ""} {
       Join_Counter::sql_query "UPDATE $Join_Counter::sql_table SET Date = NOW() WHERE Type = '[mysqlescape Join_Counter_Total]' AND Chan = '[mysqlescape $chan]'"
      }
      set totalcount [Join_Counter::sql_query "SELECT Count FROM $Join_Counter::sql_table WHERE Type = '[mysqlescape Join_Counter_Total]' AND Chan = '[mysqlescape $chan]'"]
      set todaycount [Join_Counter::sql_query "SELECT Count FROM $Join_Counter::sql_table WHERE Type = '[mysqlescape Join_Counter_Today]' AND Chan = '[mysqlescape $chan]'"]
      if {[channel get $chan Join_Counter-Lang] == "en"} {
       set totaldate [Join_Counter::sql_query "SELECT DATE_FORMAT(Date, '09%d.09%M.09%Y 14at 09%H:09%i:09%s 14a clock') FROM $Join_Counter::sql_table WHERE Type = '[mysqlescape Join_Counter_Total]' AND Chan = '[mysqlescape $chan]'"]
       set arg "\[14Join Counter\] 14Hello 09$nick 14You are the 09$totalcount. 14Visitor since: 09[join [join $totaldate]] 14here in 09$chan. 14Visitors today 09$todaycount."
       Join_Counter::sj_rejoin $nick $host $hand $chan $arg
      }
      if {[channel get $chan Join_Counter-Lang] == "de"} {
       set totaldate [Join_Counter::sql_query "SELECT DATE_FORMAT(Date, '09%d.09%m.09%Y 14um 09%H:09%i:09%s 14Uhr') FROM $Join_Counter::sql_table WHERE Type = '[mysqlescape Join_Counter_Total]' AND Chan = '[mysqlescape $chan]'"]
       set arg "\[14Join Counter\] 14Hallo 09$nick 14Du bist der 09$totalcount. 14Besucher seit dem: 09[join [join $totaldate]] 14hier in 09$chan. 14Besucher heute 09$todaycount."
       Join_Counter::sj_rejoin $nick $host $hand $chan $arg
      }
      return 0
     } else {
      set totalcount [Join_Counter::sql_query "SELECT Count FROM $Join_Counter::sql_table WHERE Type = '[mysqlescape Join_Counter_Total]' AND Chan = '[mysqlescape $chan]'"]
      set todaycount [Join_Counter::sql_query "SELECT Count FROM $Join_Counter::sql_table WHERE Type = '[mysqlescape Join_Counter_Today]' AND Chan = '[mysqlescape $chan]'"]
      set usercount [Join_Counter::sql_query "SELECT Count FROM $Join_Counter::sql_table WHERE Host = '[mysqlescape $host]' AND Type = '[mysqlescape User]' AND Chan = '[mysqlescape $chan]'"]
      if {[Join_Counter::sql_query "SELECT Count FROM $Join_Counter::sql_table WHERE Type = '[mysqlescape Join_Counter_Total]' AND Chan = '[mysqlescape $chan]'"] == "" || "0"} {
       Join_Counter::sql_query "INSERT $Join_Counter::sql_table SET Type = '[mysqlescape Join_Counter_Total]' , Chan = '[mysqlescape $chan]' , Date = NOW() , Count = '1'"
      } else {
       Join_Counter::sql_query "UPDATE $Join_Counter::sql_table SET Count = '[expr int($totalcount + 1)]' WHERE Type = '[mysqlescape Join_Counter_Total]' AND Chan = '[mysqlescape $chan]'"
      }
      if {[Join_Counter::sql_query "SELECT Count FROM $Join_Counter::sql_table WHERE Type = '[mysqlescape Join_Counter_Today]' AND Chan = '[mysqlescape $chan]'"] == "" || "0"} {
       Join_Counter::sql_query "INSERT $Join_Counter::sql_table SET Type = '[mysqlescape Join_Counter_Today]' , Chan = '[mysqlescape $chan]', Count = '1'"
      } else {
       Join_Counter::sql_query "UPDATE $Join_Counter::sql_table SET Count = '[expr int($todaycount + 1)]' WHERE Type = '[mysqlescape Join_Counter_Today]' AND Chan = '[mysqlescape $chan]'"
      }
      if {[Join_Counter::sql_query "SELECT Date FROM $Join_Counter::sql_table WHERE Type = '[mysqlescape Join_Counter_Total]' AND Chan = '[mysqlescape $chan]'"] == ""} {
       Join_Counter::sql_query "UPDATE $Join_Counter::sql_table SET Date = NOW() WHERE Type = '[mysqlescape Join_Counter_Total]' AND Chan = '[mysqlescape $chan]'"
      }
      if {[Join_Counter::sql_query "SELECT Host FROM $Join_Counter::sql_table WHERE Type = '[mysqlescape User]' AND Chan = '[mysqlescape $chan]'"] == ""} {
       Join_Counter::sql_query "UPDATE $Join_Counter::sql_table SET Host = '[mysqlescape $host]' WHERE Type = '[mysqlescape User]' AND Chan = '[mysqlescape $chan]'"
      }
      if {[Join_Counter::sql_query "SELECT Date FROM $Join_Counter::sql_table WHERE Host = '[mysqlescape $host]' AND Type = '[mysqlescape User]' AND Chan = '[mysqlescape $chan]'"] == ""} {
       Join_Counter::sql_query "UPDATE $Join_Counter::sql_table SET Date = NOW() WHERE Host = '[mysqlescape $host]' AND Type = '[mysqlescape User]' AND Chan = '[mysqlescape $chan]'"
      }
      if {[Join_Counter::sql_query "SELECT Count FROM $Join_Counter::sql_table WHERE Host = '[mysqlescape $host]' AND Type = '[mysqlescape User]' AND Chan = '[mysqlescape $chan]'"] == "" || "0"} {
       Join_Counter::sql_query "INSERT $Join_Counter::sql_table SET Nick = '[mysqlescape $nick]' , Host = '[mysqlescape $host]' , Type = '[mysqlescape User]' , Chan = '[mysqlescape $chan]' , Count = '1'"
       Join_Counter::sql_query "UPDATE $Join_Counter::sql_table SET Date = NOW() WHERE Host = '[mysqlescape $host]' AND Type = '[mysqlescape User]' AND Chan = '[mysqlescape $chan]'"
      } else {
       Join_Counter::sql_query "UPDATE $Join_Counter::sql_table SET Count = '[expr int($usercount + 1)]' WHERE Host = '[mysqlescape $host]' AND Type = '[mysqlescape User]' AND Chan = '[mysqlescape $chan]'"
      }
      set totalcount [Join_Counter::sql_query "SELECT Count FROM $Join_Counter::sql_table WHERE Type = '[mysqlescape Join_Counter_Total]' AND Chan = '[mysqlescape $chan]'"]
      set todaycount [Join_Counter::sql_query "SELECT Count FROM $Join_Counter::sql_table WHERE Type = '[mysqlescape Join_Counter_Today]' AND Chan = '[mysqlescape $chan]'"]
      set usercount [Join_Counter::sql_query "SELECT Count FROM $Join_Counter::sql_table WHERE Host = '[mysqlescape $host]' AND Type = '[mysqlescape User]' AND Chan = '[mysqlescape $chan]'"]
      if {[channel get $chan Join_Counter-Lang] == "en"} {
       set totaldate [Join_Counter::sql_query "SELECT DATE_FORMAT(Date, '09%d.09%M.09%Y 14at 09%H:09%i:09%s 14a clock') FROM $Join_Counter::sql_table WHERE Type = '[mysqlescape Join_Counter_Total]' AND Chan = '[mysqlescape $chan]'"]
       set userdate [Join_Counter::sql_query "SELECT DATE_FORMAT(Date, '09%d.09%M.09%Y 14at 09%H:09%i:09%s 14a clock') FROM $Join_Counter::sql_table WHERE Host = '[mysqlescape $host]' AND Type = '[mysqlescape User]' AND Chan = '[mysqlescape $chan]'"]
       set arg "\[14Join Counter\] 14Hello 09$nick 14You are the 09$totalcount. 14Visitor since: 09[join [join $totaldate]] 14here in 09$chan. 14Visitors today 09$todaycount. 14This is your 09$usercount. 14Visit here since: 09[join [join $userdate]]."
       Join_Counter::sj_rejoin $nick $host $hand $chan $arg
	  }
      if {[channel get $chan Join_Counter-Lang] == "de"} {
       set totaldate [Join_Counter::sql_query "SELECT DATE_FORMAT(Date, '09%d.09%m.09%Y 14um 09%H:09%i:09%s 14Uhr') FROM $Join_Counter::sql_table WHERE Type = '[mysqlescape Join_Counter_Total]' AND Chan = '[mysqlescape $chan]'"]
       set userdate [Join_Counter::sql_query "SELECT DATE_FORMAT(Date, '09%d.09%m.09%Y 14um 09%H:09%i:09%s 14Uhr') FROM $Join_Counter::sql_table WHERE Host = '[mysqlescape $host]' AND Type = '[mysqlescape User]' AND Chan = '[mysqlescape $chan]'"]
       set arg "\[14Join Counter\] 14Hallo 09$nick 14Du bist der 09$totalcount. 14Besucher seit dem: 09[join [join $totaldate]] 14hier in 09$chan. 14Besucher heute 09$todaycount. 14Dies ist dein 09$usercount. 14Besuch seit dem: 09[join [join $userdate]]."
       Join_Counter::sj_rejoin $nick $host $hand $chan $arg
      }
      return 0
     }
	}
   }
  }
  proc sj_rejoin {nick host hand chan arg} {
   global Join_Counter_Rejoin
   if {[isbotnick $nick]} {return 0}
   if {[info exists Join_Counter_Rejoin($host,$chan)]} {return 0}
   set Join_Counter_Rejoin($host,$chan) 1
   utimer [channel get $chan Join_Counter-Rejoin] "unset Join_Counter_Rejoin($host,$chan)"
   putnow "PRIVMSG $chan :$arg"
   return 0
 }
 #############################################################################
 #                               Counter Reset                               #
 #############################################################################
  proc cr_reset {args} {
   foreach chan [channels] {
    if { [channel get $chan Join_Counter] } {
	 Join_Counter::sql_change $Join_Counter::sql_database
     Join_Counter::sql_query "UPDATE $Join_Counter::sql_table SET Count = '0' WHERE Type = '[mysqlescape Join_Counter_Today]' AND Chan = '[mysqlescape $chan]'"
     if {[channel get $chan Join_Counter-Lang] == "en"} {
      putlog "\[14Join Counter\] \[07Info\] 14Clear Day Count 14on 09$chan"
     }
     if {[channel get $chan Join_Counter-Lang] == "de"} {
      putlog "\[14Join Counter\] \[07Info\] 14Lösche Tages Count 14in 09$chan"
     }
    }
   }
  }
 #############################################################################
 #                               Ctcp Version                                #
 #############################################################################
  proc cv_version {nick host hand dest key arg} {
   putnow "NOTICE $nick :\[14Join Counter\] 14Projekt Name: 09$Join_Counter::tcl_projectname \| 14Version.09$Join_Counter::tcl_version"
   putlog "\[14Join Counter\] \[07Info\] (09Ctcp Version 14Command) 14from 09$nick!09$host"
  }
 putlog "\[14Join Counter\] 14Projekt Name: 09$Join_Counter::tcl_projectname \| 14Version.09$Join_Counter::tcl_version"
 }
# EOF
