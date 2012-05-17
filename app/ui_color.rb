class UIColor
  def self.fromHexCode(r, g, b)
    self.colorWithRed((r.to_i(16) / 255.0), green:(g.to_i(16) / 255.0), blue:(b.to_i(16) / 255.0), alpha:1.0)
  end
end