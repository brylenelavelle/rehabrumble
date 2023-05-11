class TestQuestionsController < ApplicationController
  def index
    matching_test_questions = TestQuestion.all

    @list_of_test_questions = matching_test_questions.order({ :created_at => :desc })

    render({ :template => "test_questions/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_test_questions = TestQuestion.where({ :id => the_id })

    @the_test_question = matching_test_questions.at(0)

    render({ :template => "test_questions/show.html.erb" })
  end

  def create
    the_test_question = TestQuestion.new
    #the_test_question.test_id = params.fetch("query_test_id")
    #the_test_question.question_id = params.fetch("query_question_id")
    #the_test_question.correct = params.fetch("query_correct", false)

    if the_test_question.valid?
      the_test_question.save
      redirect_to("/test_questions", { :notice => "Test question created successfully." })
    else
      redirect_to("/test_questions", { :alert => the_test_question.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_test_question = TestQuestion.where({ :id => the_id }).at(0)

    the_test_question.test_id = params.fetch("query_test_id")
    the_test_question.question_id = params.fetch("query_question_id")
    the_test_question.correct = params.fetch("query_correct", false)

    if the_test_question.valid?
      the_test_question.save
      redirect_to("/test_questions/#{the_test_question.id}", { :notice => "Test question updated successfully." })
    else
      redirect_to("/test_questions/#{the_test_question.id}", { :alert => the_test_question.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_test_question = TestQuestion.where({ :id => the_id }).at(0)

    the_test_question.destroy

    redirect_to("/test_questions", { :notice => "Test question deleted successfully." })
  end
end
