# extension for base string class
# enables some conveniance string content validations
class String
  def is_integer?
    true if Integer(self) rescue false
  end

  def is_double?
    true if Double(self) rescue false
  end
end