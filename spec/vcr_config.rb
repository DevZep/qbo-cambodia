VCR.configure do |c|
  c.configure_rspec_metadata!
  c.cassette_library_dir = "#{Rails.root}/spec/vcr_cassettes"
  c.stub_with :fakeweb
  c.allow_http_connections_when_no_cassette = true

  
end

RSpec.configure do |c|
  c.extend VCR::RSpec::Macros
end

# RSpec.configure do |c|
#   c.treat_symbols_as_metadata_keys_with_true_values = true
#   c.around(:each, :vcr) do |example|
#   	# name = example.metadata[:full_description].split(/\s+/,2).join("/").underscore.gsub(/[^\w\]/]+/,) { |match|  }
#   	VCR.use_cassette(name) {example.call}
# end