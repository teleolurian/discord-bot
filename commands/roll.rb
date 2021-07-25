
class Dice
  # todo: attr_accessor luck rolls each die (luck) times and chooses the worst option
  def initialize; end
  
  def roll(formula)
    commands = if formula.is_a?(String) then self.tokenizer(formula) else formula end
    result = 0
    raise "Invalid dice formula #{formula} passed" if commands == :error
    operation = :+
    commands.each do |command|
      when :roll
        result = result.send(operation, xdy(command[1], command[2]))
      when :constant
        result = result.send(operation, command[1])
      when :operator
        operation = command[1]
      when :sub
        result = result.send(operation, roll(command[1]))
      end
    end
    result
  end
  
  def xdy(x,y)
    x.times.inject(0) {|s,i| s + rand(y) + 1}
  end
    
  
  def tokenizer(formula, parenthesized_results = [])
    cached_result = nil
    result = []
    # extract and tokenize parentheticals
    while formula =~ /\(([^\(\)]*)\)/ # find innermost paren set
      formula[$~[0]] = "##{parenthesized_results.length}"
      parenthesized_results << self.tokenizer($1, parenthesized_results)
      return :error if parenthesized_results.last == :error
    end
    mode = :normal
    while formula.length > 0 and mode != :error
      case formula
      when /^\s/
        formula.sub!(/^\s+/, '')
      when /^(\d+)[Dd](\d+)/
        return :error if ($1.length + $2.length) > 10
        result << [:roll, $1.to_i, $2.to_i]
        formula = formula[$~[0].length..]
      when /^(\-?\d+)/
        result << [:constant, $1.to_i]
        formula = formula[$1.length..]
      when /^[\/\+\-\*xX]/
        formula[0] = ''
        operation = case $~[0]
        when ?/
          :/
        when ?+
          :+
        when ?-
          :-
        when ?x, ?X, ?*
          :*
        end
        result << [:operator, operation]
      when /^\#(\d+)/
        if parenthesized_results[$1.to_i]
          result << [:sub, parenthesized_results[$1.to_i]]
          formula[$~[0]] = ''
        else
          mode = :error
        end
      else
        mode = :error
      end
    end
    return :error if mode == :error
    result
  end
end


class SisterMercy::Commands::Roll < SisterMercy::Command
  def self.name; :roll; end

  def execute(event, xdy = '1d100')
    @roller ||= Dice.new
    begin
      return "Your roll: #{@roller.roll(xdy)}"
    rescue Exception => e
      return e.message
    end
  end
end


