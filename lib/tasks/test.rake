require 'jettywrapper'

namespace :tufts do

  desc 'Load fixture data'
  task :fixtures => :environment do
    FIXTURES = %w(
      tufts:WP0001
      tufts:UA069.001.DO.UP029
      tufts:UA069.005.DO.00272
      tufts:UA069.005.DO.00239
      tufts:UA069.005.DO.00339
      tufts:UP022.001.001.00001.00003
      tufts:UP022.001.001.00001.00004
      tufts:UP022.001.001.00001.00005
      tufts:UP029.003.003.00014
      tufts:UP029.003.003.00012
      tufts:UP029.020.031.00108

      tufts:MS054.003.DO.02108
      tufts:MS115.003.001.00001
      tufts:MS115.003.001.00002
      tufts:MS115.003.001.00003
      tufts:MS122.002.001.00130
      tufts:MS122.002.004.00025
      tufts:MS122.002.021.00084
      tufts:MS124.001.001.00002
      tufts:MS124.001.001.00003
      tufts:MS124.001.001.00006
      tufts:PB.002.001.00001
      tufts:PB.005.001.00001
      tufts:RCR00001
      tufts:RCR00613
      tufts:RCR00728
      tufts:TBS.VW0001.000113
      tufts:TBS.VW0001.000386
      tufts:TBS.VW0001.002493

      tufts:UA015.012.DO.00104
      tufts:UA069.001.DO.MS019
      tufts:UA069.001.DO.MS043
      tufts:UA069.001.DO.MS056
      tufts:UA069.001.DO.MS134
      tufts:UA069.001.DO.UA001
      tufts:UA069.001.DO.UA015
      tufts:UA069.005.DO.00001
      tufts:UA069.005.DO.00002
      tufts:UA069.005.DO.00015
      tufts:UA069.005.DO.00020
      tufts:UA069.005.DO.00026
      tufts:UA069.005.DO.00090
      tufts:UA069.005.DO.00094
      tufts:ky.clerkofthehouse.1813
      tufts:la.speakerofthehouse.1820
      tufts:me.uscongress3.second.1825
      tufts:sample001
      tufts:sample002
      )

    loader = ActiveFedora::FixtureLoader.new("#{TuftsModels::Engine.root}/spec/fixtures")
    FIXTURES.each do |pid|
      puts("Refreshing #{pid}")
      ActiveFedora::FixtureLoader.delete(pid)
      loader.import_and_index(pid)
    end

  end

end
