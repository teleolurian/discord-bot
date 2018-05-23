class SisterMercy::Commands::Rx < SisterMercy::Command
  RXNAV_BASE = 'https://rxnav.nlm.nih.gov/REST'

  def get_rxnav(path)
    get_json_from RXNAV_BASE + path
  end

  def rxcui_for(drugname)
    result = get_rxnav '/rxcui.json?name=' + drugname.trim
    result.idGroup.rxnormId[0] rescue nil
  end

  def self.name; :rx; end

  def description
    'Rx Info'
  end

  # commands
  RX_COMMANDS = [:interactions]

  def interactions(*args)
    drug1, drug2 = args.join(' ').split('+')
    return "Syntax: interactions :drug1 + :drug2" unless drug1 && drug2
    return "Unknown drug #{drug1}" unless rc1 = rxcui_for(drug1)
    return "Unknown drug #{drug2}" unless rc2 = rxcui_for(drug2)
    res = get_rxnav '/interaction/interaction.json?sources=drugbank&rxcui=' + rc1
    ssp = res.interactionTypeGroup.first.interactionType.first.interactionPair rescue []
    result = ssp.find {|ip| (ip.interactionConcept.last.minConceptItem.rxcui rescue FalseClass) == rc2 }
    return "No interactions found" unless result
    "[Severity: #{result.severity}] #{result.description}"
  end


  def execute(event, command, *args)
    cmd = command.downcase.to_sym
    if RX_COMMANDS.include?(cmd)
      self.send(cmd, *args)
    else
      "I don't have that power yet... but I'm studying!"
    end
  end
end
