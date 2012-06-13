class AlertViewDelegate
  def initialize(&block)
    @block = block
  end
  
  def alertView(av, clickedButtonAtIndex:idx)
    unless idx == av.cancelButtonIndex
      if !@block.nil?
        @block.call(av, idx)
      end
    end
  end
end