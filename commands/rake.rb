
class SisterMercy::Commands::Rake < SisterMercy::Command
  def self.name; :rake; end

  def execute(event, *args)
    args = ['you'] if args.empty?
    "I will fuck #{args.join ' '} with a rake!"
  end
end
