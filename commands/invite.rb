class SisterMercy::Commands::Invite < SisterMercy::Command
  def self.name; :invite; end

  def execute(event)
   +"https://discord.com/oauth2/authorize?client_id=174209864309014528&scope=bot&permissions=52224"
  end
end
