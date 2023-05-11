# == Schema Information
#
# Table name: tests
#
#  id             :integer          not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  source_file_id :integer
#  user_id        :integer
#
class Test < ApplicationRecord
  has_many(:test_questions, { :class_name => "TestQuestion", :foreign_key => "test_id", :dependent => :destroy })
  has_many :questions, through: :test_questions

  belongs_to(:user, { :required => true, :class_name => "User", :foreign_key => "user_id" })

  belongs_to(:source_file, { :required => true, :class_name => "SourceFile", :foreign_key => "source_file_id" })

  after_create :create_random_test_questions

  def complete?
    # TODO:  any test_questions with correct == nil ???

  end

  private

  def create_random_test_questions
    random_questions = source_file.questions.sample(5)
    random_questions.each do |question|
      self.test_questions.create(question: question)
    end
  end
end
