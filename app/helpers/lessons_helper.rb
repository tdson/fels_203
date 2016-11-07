module LessonsHelper
  def total_time lesson
    distance_of_time_in_words lesson.updated_at, lesson.created_at
  end

  def count_correct results
    correct_result = 0;
    results.each do |result|
      meaning = result.meaning
      if meaning && meaning.is_correct?
        correct_result += 1
      end
    end
    correct_result
  end

  def count_words_in_lesson results
    results.size
  end

  def humanize_scores results
    "#{count_correct results}/#{count_words_in_lesson results}"
  end
end
