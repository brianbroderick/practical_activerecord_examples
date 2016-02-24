# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


require 'active_record/fixtures'
if Rails.env.development?
  fixtures_dir = ::ActiveRecord::Tasks::DatabaseTasks.fixtures_path
  fixture_files = Dir["#{fixtures_dir}/**/*.yml"].map {|f| f[(fixtures_dir.size + 1)..-5] }

  puts "\aWARNING!"
  puts "This will reset your development database by loading these fixtures:"
  fixture_files.each do |file|
    puts "  #{file}"
  end
  puts "Press ENTER to continue..."

  STDIN.gets
  ::ActiveRecord::Fixtures.create_fixtures(fixtures_dir, fixture_files)
end