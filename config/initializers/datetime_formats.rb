#MAGIC
[Time, Date].map do |c|
  c::DATE_FORMATS[:ddmmyyyyhhmmss_format] = lambda { |t| t.strftime('%d.%m.%Y %H:%M:%S') }
  c::DATE_FORMATS[:ddmmyyyyhhmm_format] = lambda { |t| t.strftime('%d.%m.%Y %H:%M')}
  c::DATE_FORMATS[:momentjs_format] = lambda { |t| t.strftime('%Y-%m-%d %H:%M:%S') }
end