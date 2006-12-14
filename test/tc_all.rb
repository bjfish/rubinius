ENV['TESTING'] = '1'
DONT_TEST = %w(test_extractors.rb test_rbs_translate.rb test_typer.rb test_instructions.rb test_memory.rb)

if dir = ARGV.shift
    Dir["#{dir}/test_*"].each do |f|
        next if DONT_TEST.include? File.basename(f)
        require f 
    end
else
    dir = File.dirname(File.expand_path(__FILE__))
    Dir["#{dir}/**/test_*"].each do |f|
        next if DONT_TEST.include? File.basename(f)
        require f 
    end
end
