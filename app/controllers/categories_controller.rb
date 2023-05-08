class CategoriesController < ApplicationController
  def index
    matching_categories = Category.all

    @list_of_categories = matching_categories.order({ :created_at => :desc })

    render({ :template => "categories/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")

    @the_category = Category.where({ :id => the_id }).first
    @questions = Question.where({ :category_id => the_id }).shuffle
    @questions_total = @questions.length
    @questions_answered = params.fetch(:questions_answered, 0).to_i
    @current_question = @questions[@questions_answered]

    if session[:score].nil?
      session[:score] = 0
    end

    if @questions_answered == @questions_total
      # All questions have been answered, show the final score
      @result = "Final Score: #{session[:score]}/#{@questions_total}"
      session[:score] = 0
    elsif params[:answer]
      # A question was answered, check if the chosen answer is correct
      chosen_answer = params[:answer]
      if chosen_answer == @current_question.correct_answer
        session[:score] += 1
        @result = "Correct!"
      else
        @result = "Incorrect!"
      end
      @questions_answered += 1
      @current_question = @questions[@questions_answered]
    end
    render({ :template => "categories/show.html.erb" })
  end

  def create
    the_category = Category.new
    the_category.name = params.fetch("query_name")

    if the_category.valid?
      the_category.save
      redirect_to("/categories", { :notice => "Category created successfully." })
    else
      redirect_to("/categories", { :alert => the_category.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_category = Category.where({ :id => the_id }).at(0)

    the_category.name = params.fetch("query_name")

    if the_category.valid?
      the_category.save
      redirect_to("/categories/#{the_category.id}", { :notice => "Category updated successfully."} )
    else
      redirect_to("/categories/#{the_category.id}", { :alert => the_category.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_category = Category.where({ :id => the_id }).at(0)

    the_category.destroy

    redirect_to("/categories", { :notice => "Category deleted successfully."} )
  end
end
