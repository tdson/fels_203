# Users
User.create!
  name: "Son Tran",
  email: "sontd.it@gmail.com",
  password: "123456",
  password_confirmation: "123456",
  is_admin: true,
  created_at: 1.year.ago

30.times do |n|
  name = Faker::Name.name
  email = "user_#{n + 1}@elearning.com"
  password = "123456"
  number = rand 1..11
  User.create!
    name: name,
    email: email,
    password: password,
    password_confirmation: password,
    is_admin: false,
    created_at: number.months.ago
end

# Categories, words and meanings
7.times do |n|
  name = Faker::Educator.course
  category = Category.create! name: name
  15.times do
    word = Word.create!
      category_id: category.id,
      content: Faker::Hipster.sentence(5, true)
    (1..4).each_with_index do |index|
      is_correct = index == 1 ? true : false
      Meaning.create!
        word_id: word.id,
        content: Faker::Hipster.sentence(3, true),
        is_correct: is_correct
    end
  end
end

# Lessons
users = User.take 5
users.each do |user|
  5.times do
    category = Category.order("RANDOM()").take(1).first
    lesson = Lesson.create!
      user_id: user.id,
      category_id: category.id,
      scores: rand(1..5),
      is_finished: true
      
    5.times do
      word_id = Word.order("RANDOM()").take(1).first.id
      meaning = Meaning.find_by word_id: word_id
      Result.create!
        lesson_id: lesson.id,
        word_id: word_id,
        meaning_id: meaning.id
    end
  end
end
