module ConflictMatrix
  @@matrix = Array.new(6) { Array.new(14) }

  def self.add_schedule(schedule, credentials)
    i = 0
    schedule.each do |day|
      j = 0
      day.each do |subject|
        @@matrix[i][j] = credentials[:user] unless subject.nil?
        j += 1
      end
      i += 1
    end
  end

  def self.matrix_hour_free(day, hour)
    @@matrix[day(day)][hour(hour)] == 0
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
    when 'L'
      0
    when 'M'
      1
    when 'I'
      2
    when 'J'
      3
    when 'V'
      4
    when 'S'
      5
    end
  end

  def self.matrix
    @@matrix
  end
end
