# encoding: UTF-8

def dbg(*args)
  prefix = "#{args.shift} " if [String, Symbol].include?(args.first.class)

  msg = args.map(&:inspect).join(" | ")
  msg = "[DEBUG] #{prefix}#{msg}"

  if defined?(Rails::Console) || Rails.env == "test" # STDOUT is usually available here
    puts msg
  else
    Rails.logger.debug msg
  end
end