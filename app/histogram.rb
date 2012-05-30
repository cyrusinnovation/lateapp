class Histogram
  def self.histogram
    lates = day_of_week_counts(StatisticsStore.shared.lates_this_year.collect(&:date))
    outs = day_of_week_counts(StatisticsStore.shared.sicks_this_year.collect(&:date))
    
    {
      range: [0, range_from(lates, outs)],
      lates: lates,
      outs: outs
    }
  end
  
  private
  
  def self.day_of_week_counts(dates)
    result = {sunday:0, monday:0, tuesday:0, wednesday:0, thursday:0, friday:0,  saturday:0}
    dates.each do |date|
      symbol = [:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday][date.wday]
      result[symbol] += 1
    end
    
    result
  end
  
  def self.range_from(lates, outs)
    possible_ranges = [1, 2, 3, 5, 8, 13, 20, 50, 100, 200, 366]
    maximum = [lates.values.max, outs.values.max].max
    possible_ranges.select {|u| u > maximum}.first
  end
end