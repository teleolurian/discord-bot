class SisterMercy::Commands::Roll < SisterMercy::Command
  def self.name; :roll; end

  def execute(event, xdy = '1d100')
    t = xdy.split(/d/)
    return "Pardon?" unless t.length == 2
    rolls = t[0].to_i
    sides = t[1].to_i
    return "Sorry, I can't hold all these dice!!" unless rolls < 9001
    return "How many dice?" unless rolls > 0 && sides > 0
    sum = 0
    rolls.times {|x| sum += rand(sides + 1)}
    "Your roll: #{sum}"
  end
end


