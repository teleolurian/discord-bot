class SisterMercy::Commands::Invite < SisterMercy::Command
  def self.name; :invite; end

  def execute(event)
    event.bot.invite_url
  end
end
