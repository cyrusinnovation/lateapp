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

    if (0 == indexPath.row)
      cell = tv.dequeueReusableCellWithIdentifier("Monthly Statistics Cell")
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleValue1, reuseIdentifier:"Monthly Statistics Cell") if cell.nil?
      cell.textLabel.text = "This Month"

      if (0 == indexPath.section)
        cell.detailTextLabel.text = StatisticsStore.shared.lates_this_month.count.to_s
      else
        cell.detailTextLabel.text = StatisticsStore.shared.sicks_this_month.count.to_s

      end

      @detailColor = cell.detailTextLabel.textColor      
      
      cell
    else
      cell = tv.dequeueReusableCellWithIdentifier("Yearly Statistics Cell")
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:"Yearly Statistics Cell") if cell.nil?

      
      titleLabel = UILabel.alloc.initWithFrame([[10,5],[200,30]])
      titleLabel.text = "This Year"
      titleLabel.backgroundColor = UIColor.colorWithWhite(1.0, alpha:0.0)
      titleLabel.textColor = UIColor.fromHexCode('44','44','44')
      titleLabel.font = UIFont.boldSystemFontOfSize(17)
      cell.contentView.addSubview(titleLabel)
      
      countLabel = UILabel.alloc.initWithFrame([[280, 5],[40,30]])
      countLabel.text = (0 == indexPath.section) ? StatisticsStore.shared.lates_this_year.count.to_s : StatisticsStore.shared.sicks_this_year.count.to_s
      countLabel.backgroundColor = UIColor.colorWithWhite(1.0, alpha:0.0)
      countLabel.font = UIFont.systemFontOfSize(17)
      countLabel.textColor = @detailColor
      countLabel.sizeToFit
      countLabel.frame = [[290-countLabel.frame.size.width, 5],countLabel.frame.size]
      cell.contentView.addSubview(countLabel)
      

      histogram = Histogram.histogram
      histogramView = HistogramView.alloc.initWithFrame(CGRectMake(10, 40, 280, 80), andData:histogram[(0 == indexPath.section) ? :lates : :outs], max:histogram[:range] )
      cell.contentView.addSubview(histogramView)
      
      cell
    end
  end

  
  def tableView(tv, willDisplayCell: cell, forRowAtIndexPath: indexPath)
    if (indexPath.row == 0)
      cell.textLabel.textColor = UIColor.fromHexCode('44','44','44') # gray
    end
  end


  def tableView(tv, titleForHeaderInSection:section)
    return (section == 0) ? "Late" : "Sick"
  end
  
  def tableView(tv, heightForRowAtIndexPath:indexPath)
    if (indexPath.row == 1)
      200
    else
      44
    end
  end
  
  def viewDidLoad
    tableView.allowsSelection = false
    tableView.backgroundColor = UIColor.fromHexCode('5f', 'ff', '8f') # light green
  end
end