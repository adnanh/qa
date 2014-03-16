#MAGIC
[Time, Date].map do |c|
  c::DATE_FORMATS[:ddmmyyyyhhmmss_format] = lambda { |t| t.strftime('%d.%m.%Y %H:%M:%S') }
end