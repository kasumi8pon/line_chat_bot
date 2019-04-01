# frozen_string_literal: true

class ItemsController < ApplicationController
  before_action :set_item, only: [:destroy]

  def index
    @items = Item.all
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    @item.save
    redirect_to items_url
  end

  def destroy
    @item.destroy
    redirect_to items_url, notice: "#{@item.name}を買ったんだね、ありがとう！"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:name)
    end
end
