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

  def self.matrix
		@@matrix
  end
end
