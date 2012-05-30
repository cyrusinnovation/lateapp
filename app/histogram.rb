class Histogram
  def self.histogram
    lates = day_of_week_counts(StatisticsStore.shared.lates_this_year.collect(&:date))
    outs = day_of_week_counts(StatisticsStore.shared.outs_this_year.collect(&:date))
    
    {
      range: range_from(lates, outs),
      lates: lates,
      outs: outs
    }
  end
  
  private
  
  def self.days_of_week()
    ["Su", "M", "T", "W", "Th", "F", "S"]
  end
  
  def self.day_of_week_counts(dates)
    result = {}
    self.days_of_week.each {|d| result[d] = 0}
    
    dates.each do |date|
      key = self.days_of_week[date.wday]
      result[key] += 1
    end
    
    result
  end
  
  def self.range_from(lates, outs)
    possible_ranges = [1, 2, 3, 5, 8, 13, 20, 50, 100, 200, 366]
    maximum = [lates.values.max, outs.values.max].max
    possible_ranges.select {|u| u > maximum}.first
  end
end