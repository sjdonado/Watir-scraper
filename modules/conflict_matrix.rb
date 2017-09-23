module ConflictMatrix

  @@matrix = Array.new(6) { Array.new(14) }

  def self.add_schedule(schedule)
    i = 0
    schedule.each do |day|
      j = 0
      day.each do |subject|
        @@matrix[i][j] = subject.nil? ? "0" : "1"
        j += 1
      end
      i += 1
    end
  end

  def self.matrix_hour_free(day, hour)
    if(@@matrix[day(day)][hour(hour)] == 0)
      return true
    else
      return false
    end
  end

  # return hour to add
  def self.hour(time)
    hour_array = time[0].split(':')
    hour = time[1] == 'PM' && hour_array[0].to_i != 12 ? hour_array[0].to_i + 6 : hour_array[0].to_i - 6
    hour
  end

  # return day to add
  def self.day(day)
    case day
      when "L"
        return 0
      when "M"
        return 1
      when "I"
        return 2
      when "J"
        return 3
      when "V"
        return 4
      when "S"
        return 5
    end
  end

  def self.matrix
		@@matrix
  end
end
