module MeaningsHelper
  def correct_meaning? meaning
    meaning && meaning.is_correct?
  end

  def get_result_class meaning
    correct_meaning?(meaning) ? "correct-result" : "wrong-result"
  end

  def get_meaning_class meaning
    correct_meaning?(meaning) ? "correct-meaning" : "wrong-meaning"
  end
end
