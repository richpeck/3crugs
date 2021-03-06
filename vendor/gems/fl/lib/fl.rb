########################################
########################################
##             _____ _                ##
##            |  ___| |               ##
##            | |_  | |               ##
##            |  _| | |               ##
##            | |   | |____           ##
##            \_|   \_____/           ##
########################################
########################################

# => Dependencies
# => http://stackoverflow.com/a/24768678/1143732
Gem.loaded_specs['fl'].dependencies.each do |d|
 require d.name
end

########################################
########################################

# => Files
require_relative 'fl/constants'
require_relative 'fl/hash'
require_relative 'fl/engine' if defined? Rails

########################################
########################################
########################################
