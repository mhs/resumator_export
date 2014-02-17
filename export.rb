#!/usr/bin/env ruby

require 'yaml'
require 'pry'
require 'resumator-client'
require 'json'
require 'csv'

config_file = YAML.load_file('resumator.yml')
client = Resumator::Client.new(config_file['apikey'])
export_dir = Dir.mkdir("export") unless Dir.exists?("export")
Dir.chdir("export")

stub_applicants = client.applicants

applicants = []

puts "Fetcing #{stub_applicants.count} applicants"
puts

stub_applicants.each do |stub|
  print "#{stub.first_name} #{stub.last_name}..."
  applicant = client.applicants(id: stub.id).first
  applicants << applicant
  file_extension = applicant.resume_link.split('.').last if applicant.resume_link
  `curl -s #{applicant.resume_link} -o #{stub.first_name}_#{stub.last_name}_resume.#{file_extension}` if applicant.resume_link
  print "done!"
  puts
end

applicants_json = JSON.pretty_generate applicants

File.open "results.json", "w" do |f|
  f.write applicants_json
end

puts
puts "Wrote results.json"
