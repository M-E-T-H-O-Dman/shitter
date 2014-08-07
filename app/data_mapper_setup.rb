env = ENV["RACK_ENV"] || "development"

DataMapper.setup(:default, "postgres://localhost/shitter_#{env}")

DataMapper.finalize