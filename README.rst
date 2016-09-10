pomoutils
==============================================================================

Tools for reporting time spent on tasks.  Using a variant of the
`Pomodoro Technique`__, the user keeps simple text files
recording tasks worked on during each interval.

`Task Records`_ are kept in individual files per day, with
weekly and monthly symlink dirs generated during
`Initialization`_ so shell globs can be used to feed appropriate
record intervals to the report generation script, `pomoreport`.

Time spent, relevance and execution metrics per-task over the
input intervals (concatenated on stdin) are reported on stdout
in a colored table (see `Examples`_).

.. contents::

__ https://en.wikipedia.org/wiki/Pomodoro_Technique


Task Records
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Each records file is a list of tasks, one per line (see `task
format`).  Tasks are marked as reads (learning) or as writes
(doing) to keep execution metrics, and the task's name is
registered in a configuration file `~/.ptaskrc` as being
directly, indirectly, or irrelevant towards the project goal.


Initialization
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The bootstrap script `pomostrap` makes empty files for recording
each day's tasks, one per Gregorian day for all supplied ISO
years.  It then makes symlinks to the day-files for all
component ISO weeks in each year, and all component Gregorian
month-days.

Supply the four-digit ISO years to initialize as arguments.  The
hardcoded base directory for record files is in `~/todo/log/`
(modify `$basedir` in the script to change, or we can make a
parameter if anyone else ever uses this!).

After initialization, the structure looks like so:

============= =======================================================
`d/YYYYMMDD`  canonical per-day record files named in Gregorian
              (makes it easy to know which file to edit for "today")
`w/YYYYWW/N`  per ISO week WW (01 through 52 or 53 depending on year)
              symlinks to corresponding `d/` files, where N is 1-7
              for Monday through Sunday (ISO weeks are always full)
`m/YYYYMM/DD` per-Gregorian month-days, alternative means of globbing
              (`m/201601/* ` is same as `d/201601*`)
============= =======================================================

within `$basedir`.

To be clear, one full ISO year is covered by the data files and
symlinks.  Gregorian days in the same calendar year, but falling
outside the ISO year, will not be initialized.  ISO weeks are
used as the loop iterator and then all corresponding Gregorian
dates in the range are linked.


Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The system tracks relevance towards a certain goal.  Only one
goal is used: that of the entire project


Description
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The pomodoro technique is basically like so:

- work on tasks by fixed, static intervals (conventionally 25 minutes)
- at beginning of interval, record (roughly) what is to be accomplished
- work through interval on **only** those things and nothing else
- early finish: use rest of interval only for closely related or child tasks
- any distractions -- new ideas, ancillary work, todos -- are queued for later
- no interruptions allowed (for emergencies, obviously, stop your timer!)

#. 

- work on tasks by intervals (see 'pomotimer') (25m, alter in p2h())
- enter tasks in simple text files (see 'format:')
- organize files in dir tree by days, weeks, etc (see 'pomoinit')
- tell preport how relevant each task is (see '.ptaskrc')
- feed entered log files to pomoreport on stdin (see 'usage:')
- pomoreport generates metrics on stdout


Metrics
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- time spent on tasks (how many pomodoro intervals spent on named tasks)
- relevance (break down time as *direct*, *indirect*, or *unrelated* to goals)
- execution ratio: track tasks as *reads* ("learning") or *writes*
  ("doing"), and calculate execution ratio as nreads/nwrites

usage:
  - supply concatenated pomoreport file content on stdin, eg:
      "cat ~/todo/log/w/`lastweek`/* | pomoreport"
  - assumes input is well-formed pomoreport data (see 'format:')
  - TODO: other examples here
  - TODO: `lastweek` was moved to utilsh

format:
  - text file with successive pomoreport descriptor lines, like so:
      tasklabel/intervals
      + description of a read subtask (learning)
      - description of a write subtask (doing)
      \ description of an unfinished subtask
  - tasklabel = string label for task, must be [a-z]+ (see match() to change)
  - intervals = ordinal describing how many pomo intervals spent on task
  - description = anystrings, recommend 78 col in subject-line commit style

example:
  housing/8
  - TODO
#
