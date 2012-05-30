class HistogramView < UIView
  def initWithFrame(frame, andData:histogram, max:max_range )
    self.initWithFrame(frame)

    Histogram.days_of_week.each_with_index do |day, index|
      label = UILabel.alloc.initWithFrame([[10,22*index],[100,20]])
      label.backgroundColor = UIColor.colorWithWhite(1.0, alpha:0.0)
      label.font = UIFont.systemFontOfSize(14)
      label.textColor = UIColor.fromHexCode('44','44','44') #grey
      label.text = "#{day}"
      self.addSubview(label)
      
      if histogram[day] > 0
        img = UIImageView.alloc.initWithImage(UIImage.imageNamed("histogram.png"))
        max_width = 200.0
        
        bar_width = (histogram[day]*1.0)/max_range*max_width
        img.frame = [[40,22*index],[bar_width,22]]
        self.addSubview(img)
        
        
        numberLabel = UILabel.alloc.initWithFrame([[40+bar_width+3,22*index],[100,20]] )
        numberLabel.text = "#{histogram[day]}"
        numberLabel.backgroundColor = UIColor.colorWithWhite(1.0, alpha:0.0)
        numberLabel.textColor = UIColor.fromHexCode('44','44','44') #grey
        numberLabel.font = UIFont.systemFontOfSize(14)
        self.addSubview(numberLabel)
         
      end
    end
    
    self
  end
  
end