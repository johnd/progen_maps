class Helper
  class << self
    def coinflip(sides=2)
      if rand(sides) == 0
        true
      else
        false
      end
    end
  end
end
