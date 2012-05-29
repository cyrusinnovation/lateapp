class StatisticsController < UITableViewController
  def loadView
    self.tableView = UITableView.alloc.initWithFrame([[0,44],[320,440]], style: UITableViewStyleGrouped)
  end
  
  def tableView(tv, numberOfRowsInSection:section)
    2
  end
  
  def numberOfSectionsInTableView(tv)
    2
  end
  
  def tableView(tv, cellForRowAtIndexPath:indexPath)
    cell = tv.dequeueReusableCellWithIdentifier("Statistics Cell")
    cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleValue1, reuseIdentifier:"Statistics Cell") if cell.nil?
    
    if (0 == indexPath.row && 0 == indexPath.section)              
      cell.textLabel.text = "Monthly"
      cell.detailTextLabel.text = StatisticsStore.shared.lates.count.to_s
    elsif (0 == indexPath.row && 1 == indexPath.section)     
      cell.textLabel.text = "Monthly"
      cell.detailTextLabel.text = StatisticsStore.shared.sicks.count.to_s
    elsif (1 == indexPath.row && 0 == indexPath.section)              
      cell.textLabel.text = "Yearly"
      cell.detailTextLabel.text = StatisticsStore.shared.lates.count.to_s
    elsif (1 == indexPath.row && 1 == indexPath.section)     
      cell.textLabel.text = "Yearly"
      cell.detailTextLabel.text = StatisticsStore.shared.sicks.count.to_s
    end
    
    cell
  end
end