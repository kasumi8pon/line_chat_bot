# frozen_string_literal: true

class MealsController < ApplicationController
  before_action :set_meal, only: [:destroy]

  def index
    @meals = Meal.all
    @meal = Meal.new
  end

  def create
    @meal = Meal.new(meal_params)
    @meal.save
    redirect_to meals_url
  end

  def destroy
    @meal.destroy
    redirect_to meals_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_meal
      @meal = Meal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def meal_params
      params.require(:meal).permit(:name)
    end
end
