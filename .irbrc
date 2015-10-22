require 'irb/completion'
require 'irb/ext/save-history'

ARGV.concat [ "--readline", "--prompt-mode", "simple" ]
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb_history"
IRB.conf[:SAVE_HISTORY] = 20
IRB.conf[:USE_COLORIZE] = false
IRB.conf[:USE_MULTILINE] = false
