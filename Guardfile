guard 'rspec', all_on_start: false, cmd: 'bundle exec rspec' do
  notification :tmux, display_message: true

  watch(/^spec\/.+_spec\.rb/)
  watch(/^lib\/(.+)\.rb/)     { |m| "spec/#{m[1]}_spec.rb"  }
  watch('spec/spec_helper.rb') { 'spec'  }
end
