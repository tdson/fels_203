module ResultsHelper
  def is_selected? result_meaning, word_meaning
    return false unless result_meaning
    result_meaning.id == word_meaning.id
  end
end
