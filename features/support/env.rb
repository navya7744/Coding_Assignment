require 'webdriver_manager'
require 'cucumber'
require 'require_all'
require 'pathname'
require 'fileutils'
require_rel "../locators/"
require_rel "../libraries/"
require_rel "../pages/"
require "time"
require 'rest-client'
require 'json'

include Libraries
$VERBOSE = nil

if File.exist?('features/global-data/global.yml')
    $conf =  YAML.load_file('features/global-data/global.yml')
else
    puts "features/global-data/global.yml is not found !!!"
end

Before do |scenario|
    # Have the test data corresponding to a feature in the path `/features/test-data/` in the .conf format
    # The below code will parse that file and have the variables in $param
    # Test data can be accessed with $param in that step definition file.
    feature = scenario.location
    feature_file_name = feature.to_s.rpartition('/').last.split('.feature')[0]
    test_variables_file_location = Dir.pwd + "/features/test-data/testdata.yml"
    if File.exists?("#{test_variables_file_location}")
      $param = YAML.load_file(test_variables_file_location)
    end
end
  
After do |scenario|
    if scenario.failed?
        begin
            drivers = Driver.get_all_drivers
            drivers.each do |l,m|
              Driver.switch_to(l)
              scenario.attach_file(m,l.save_screenshot)
            end
        rescue Exception => e
            puts e.message
            puts e.backtrace
        end
        # to quit the test run if any one of the scenario is failed
    end
end