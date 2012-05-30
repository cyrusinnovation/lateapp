class HistogramView < UIView
  def initWithFrame(frame)
    super

    ["S", "M", "T", "W", "Th", "F", "S"].each_with_index do |day, index|
      label = UILabel.alloc.initWithFrame([[0,22*index],[100,20]])
      label.backgroundColor = UIColor.colorWithWhite(1.0, alpha:0.0)
      label.font = UIFont.systemFontOfSize(14)
      label.text = day
      self.addSubview(label)
      
      img = UIImageView.alloc.initWithImage(UIImage.imageNamed("histogram.png"))
      max_width = 200
      img.frame = [[40,22*index],[200,22]]
      self.addSubview(img)
    end
    
    self
  end
end