require "bundler/gem_tasks"
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

desc "Downloads maxmind free DBs if required"
task :ensure_maxmind_files do
  unless File.exist?('spec/cache/GeoLite2-City.mmdb')
    os = %x{uname}.strip
    options = os == 'Linux' ? '--wildcards' : ''
    sh "curl 'https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-City&suffix=tar.gz&license_key=#{ENV['API_KEY']}' -o spec/cache/GeoLite2-City.mmdb.tar.gz"
    sh "tar zxvf spec/cache/GeoLite2-City.mmdb.tar.gz #{options} *.mmdb"
    src = %x{tar ztf spec/cache/GeoLite2-City.mmdb.tar.gz #{options} *.mmdb}.strip
    dir = %x{dirname `tar ztf spec/cache/GeoLite2-City.mmdb.tar.gz #{options} *.mmdb`}
    fname = %x{basename `tar ztf spec/cache/GeoLite2-City.mmdb.tar.gz #{options} *.mmdb`}
    dst = ('spec/cache/' + fname).strip
    sh "mv #{src} #{dst}"
    sh "rmdir #{dir}"
    sh 'rm spec/cache/GeoLite2-City.mmdb.tar.gz'
  end

  unless File.exist?('spec/cache/GeoLite2-Country.mmdb')
    os = %x{uname}.strip
    options = os == 'Linux' ? '--wildcards' : ''
    sh "curl 'https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-Country&suffix=tar.gz&license_key=#{ENV['API_KEY']}' -o spec/cache/GeoLite2-Country.mmdb.tar.gz"
    sh "tar zxvf spec/cache/GeoLite2-Country.mmdb.tar.gz #{options} *.mmdb"
    src = %x{tar ztf spec/cache/GeoLite2-Country.mmdb.tar.gz #{options} *.mmdb}.strip
    dir = %x{dirname `tar ztf spec/cache/GeoLite2-Country.mmdb.tar.gz #{options} *.mmdb`}
    fname = %x{basename `tar ztf spec/cache/GeoLite2-Country.mmdb.tar.gz #{options} *.mmdb`}
    dst = ('spec/cache/' + fname).strip
    sh "mv #{src} #{dst}"
    sh "rmdir #{dir}"
    sh 'rm spec/cache/GeoLite2-Country.mmdb.tar.gz'
  end
end

desc "Downloads maxmind free DBs if required and runs all specs"
task ensure_maxmind_files_and_spec: [:ensure_maxmind_files, :spec]

task default: :ensure_maxmind_files_and_spec
