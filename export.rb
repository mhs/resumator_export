#!/usr/bin/env ruby

require 'yaml'
require 'pry'
require 'resumator-client'

config_file = YAML.load_file('resumator.yml')
client = Resumator::Client.new(config_file['apikey'])

applicants = client.applicants

puts applicants
