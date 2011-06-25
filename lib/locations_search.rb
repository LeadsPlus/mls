class LocationsSearch
  attr_accessor :exclusions, :keywords
  def initialize(keywords='', exclusions=[])
    @keywords = sanitize(keywords.to_s)
    @exclusions = exclusions
  end

#  TODO Behavior when searching 'North County Dublin' isn't exaclty correct
  def controlled_search
    return [] if @exclusions.size > 60
#   county names are unique. Therefore only ever binary result
    return unexcluded_county(exact_county_matches).to(15) if exact_county_matches.count == 1
    return unexcluded_town(exact_town_matches).to(15) if exact_town_matches.count > 0
    fuzzy_town_matches.to(15)
  end

# TODO write this prettier
  def unexcluded_county(results)
    results.select {|result| result.class == County && !excluded_county_ids.include?(result.id) }
  end

  def unexcluded_town(results)
    results.select {|result| result.class == Town && !excluded_town_ids.include?(result.id) }
  end

  def exact_county_matches
    @exact_county_matches ||= County.search @keywords
  end

  def exact_town_matches
    @exact_town_matches ||= Town.search @keywords
  end

  def fuzzy_town_matches
    @fuzzy_town_matches ||= Town.tsearch @keywords
  end

  def sanitize keywords
    # the name for these things is 'stop words'
    keywords.gsub(/(Anywhere in Co. |, Co\.|County)/, '').strip
  end

  def excluded_county_ids
    @excluded_county_ids ||= exclusions.select {|id| id[0] == 'c'}.map {|id| id.gsub(/\D/, '').to_i }
  end

  def excluded_town_ids
    @excluded_town_ids ||= exclusions.select {|id| id[0] == 't'}.map {|id| id.gsub(/\D/, '').to_i }
  end
end
