class ReviewsController < ApplicationController
  before_action :set_list

  def create
    @review = @list.reviews.new(review_params)
    if @review.save
      redirect_to list_path(@list)
    else
      redirect_to list_path(@list), alert: @review.errors.full_messages.to_sentence
    end
  end

  private

  def set_list
    @list = List.find(params[:list_id])
  end

  def review_params
    params.require(:review).permit(:content)
  end
end
