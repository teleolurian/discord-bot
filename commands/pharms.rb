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
  RX_COMMANDS = [:brands, :interactions]

  def brands(*args)
    drugs = args.join(' ').split('+').map {|x| x.trim}
    rxcs = []
    unknowns = []
    drugs.each do |drug|
      rxcui = rxcui_for(drug)
      if rxcui
        rxcs.push rxcui
      else
        unknowns.push drug
      end
    end
    return "No valid search terms found!" if rxcs.empty?
    res = get_rxnav '/Prescribe/brands.json?ingredientids=' + rxcs.join(?+)
    drug_brands = res.brandGroup.conceptProperties rescue []

    final_response = ''
    final_response += "Skipping unknown drugs: #{unknowns.join ', '}\n" unless unknonws.empty?
    final_response += "#{drug_brands.length} brands found."
    unless drug_brands.empty?
      final_response += "\n"
      final_response += drug_brands[0..49].map {|x| x.name}.join ', '
      if drug_brands.length > 50
        final_response += ", and #{drug_brands.length - 50} others."
      end
    end
    final_response
  end

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
