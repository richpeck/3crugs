########################################
########################################
##     _____                          ##
##    | ___ \                         ##
##    | |_/ /   _ _ __ ___   __ _     ##
##    |  __/ | | | '_ ` _ \ / _` |    ##
##    | |  | |_| | | | | | | (_| |    ##
##    \_|   \__,_|_| |_| |_|\__,_|    ##
##                                    ##
########################################
########################################

threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads threads_count, threads_count

preload_app!

port        ENV.fetch("PORT")      { 3000 }
environment ENV.fetch("RAILS_ENV") { "development" }

# Plugins
plugin :tmp_restart
