if Rails.env.development? || Rails.env.test?
  namespace :dev do
    desc "Load up sample questions from csv"
    task load_sample_questions: :environment do
      require "csv"

      csv_text = File.read(Rails.root.join("lib", "sample_data", "sample-questions-1.csv"))
      csv = CSV.parse(csv_text, :headers => true, :encoding => "ISO-8859-1")
      source_file = SourceFile.create(file_name: "sample-questions-1.csv", name: "sample-questions-1")
      csv.each do |row|
        puts row.to_hash
        # {"Category Name"=>"Neurology", "Question"=>"Which of the following contain the cerebrospinal fluid and major arteries?", "Wrong Answer 1 "=>"Dura mater", "Wrong Answer 2"=>"Pia mater", "Wrong Answer 3"=>"Arachnoid", "Correct Answer"=>"Subarachnoid space", nil=>nil}
        category = Category.find_or_create_by(name: row.fetch("Category Name"))
        question = Question.find_or_create_by(
          source_file: source_file,
          category: category,
          correct_answer: row.fetch("Correct Answer"),
          question: row.fetch("Question"),
          wrong_answer_1: row.fetch("Wrong Answer 1"),
          wrong_answer_2: row.fetch("Wrong Answer 2"),
          wrong_answer_3: row.fetch("Wrong Answer 3"),
        )
      end
    end
  end
end
