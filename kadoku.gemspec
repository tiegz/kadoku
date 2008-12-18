Gem::Specification.new do |s|
  s.name     = "kadoku"
  s.version  = "0.1.2"
  s.date     = "2008-12-17"
  s.summary  = "Uses Hpricot to clean up your unreadable HTML (ie ERB-generated html) [use with caution]"
  s.email    = "tieg.zaharia+kadoku@gmail.com"
  s.homepage = "http://github.com/tiegz/kadoku"
  s.description = "Kadoku is a Ruby library that uses Hpricot to clean up your unreadable HTML (ie ERB-generated html) [use with caution]"
  s.has_rdoc = true
  s.authors  = ["Tieg Zaharia"]
  s.files    = ["kadoku.gemspec", 
    "MIT-LICENSE", 
    "Rakefile", 
    "README", 
    "TODO",
    "lib/kadoku.rb", 
    "lib/kadoku/markup.rb", 
    "lib/kadoku/markup_after_filter.rb"]
  s.test_files = ["test/test_helper.rb",
    "test/kadoku_markup_test.rb"]
  s.rdoc_options = ["--main", "README"]
  s.extra_rdoc_files = ["README", "MIT-LICENSE", "TODO"]
#  s.add_dependency("hpricot", ["> 0.6.164"])
end
