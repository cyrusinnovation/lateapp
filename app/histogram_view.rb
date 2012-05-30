class HistogramView < UIView
  def initWithFrame(frame)
    super

    ["S", "M", "T", "W", "Th", "F", "S"].each_with_index do |day, index|
      label = UILabel.alloc.initWithFrame([[10,22*index],[100,20]])
      label.backgroundColor = UIColor.colorWithWhite(1.0, alpha:0.0)
      label.font = UIFont.systemFontOfSize(14)
      label.textColor = UIColor.fromHexCode('44','44','44') #grey
      label.text = day
      self.addSubview(label)
    end
    
    @data = Histogram.histogram

    
    self
  end
  
  # def drawRect(rect)
  #   
  #   context    = UIGraphicsGetCurrentContext()
  #   CGContextSetFillColorWithColor(context, UIColor.whiteColor.CGColor)
  #   CGContextSetStrokeColorWithColor(context, UIColor.redColor.CGColor)
  #   CGContextSetLineWidth(context, 2.0)
  #   CGContextMoveToPoint(context, 0,0)
  #   CGContextAddLineToPoint(context, 20, 20)
  #   CGContextStrokePath(context)
  # end
end