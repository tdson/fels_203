module LessonsHelper
  def total_time lesson
    distance_of_time_in_words lesson.updated_at, lesson.created_at
  end
end
