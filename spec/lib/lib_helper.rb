Dir['./lib/vendor_api/*'].each{ |file| require file }

def fixture(file)
  root = "./spec/fixtures"
  File.open "#{root}/#{file}", 'r'
end
