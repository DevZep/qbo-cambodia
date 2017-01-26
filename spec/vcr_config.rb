VCR.configure do |c|
  c.configure_rspec_metadata!
  c.cassette_library_dir = "#{Rails.root}/spec/vcr_cassettes"
  c.allow_http_connections_when_no_cassette = true

  
end