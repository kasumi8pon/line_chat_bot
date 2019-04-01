# frozen_string_literal: true

class ReplyMessage
  include ActiveModel::Model
  attr_accessor :text, :original_image, :preview_image

  def initialize(received_message)
    @message_type = message_type
    @text = message(received_message.reply_type, received_message.keywords)
  end

  def message_type
    "text"
  end

  def message(type, keywords)
    case type
    when :remind_item
      items = keywords
      add_item_to_list(items)
      "#{items.join("\n")}\nを買うのを覚えておくね！"
    when :notify_item
      items = Item.all.map(&:name)
      if items[0]
        "#{items.join("\n")}\nを買ってね！"
      else
        "買うものはないよ"
      end
    when :destroy_item
      items = keywords
      bought_list = buy_items(items)
      if bought_list[0]
        "#{bought_list.join("\n")}\nを買ったんだね！ありがとう！"
      else
        "それは買うものリストにないよ"
      end
    when :destroy_all_item
      bought_list = buy_all_items
      if bought_list[0]
        "#{bought_list.join("\n")}\nを買ったんだね！ありがとう"
      else
        "買うものリストには何もないよ"
      end
    when :suggest_gohan
      meals = Meal.all.map(&:name)
      "今日は#{meals.sample}がオススメ！"
    when :which
      option = keywords
      "#{option.sample}にしよう！"
    when :say
      statement = keywords
      statement.join(" ")
    when :good_morning
      "おはよう！"
    when :good_night
      "おやすみ！"
    when :youre_welcome
      if choose(20)
        "ぃえぃえ"
      else
        "どういたしまして！"
      end
    when :yoshiyoshi
      "よしよし"
    when :praise
      "えらい！"
    when :cheer
      "がんばれ！"
    when :kora
      "こら！"
    when :otsukare
      "おつかれさま！"
    end
  end

  def add_item_to_list(items)
    items.map { |item| Item.create(name: item).name }
  end

  def buy_items(items)
    items.map! do |item|
      if bought_item = Item.find_by(name: item)
        bought_item.destroy.name
      else
        nil
      end
    end
    items.compact
  end

  def buy_all_items
    Item.all.map { |item| item.destroy.name }
  end

  def choose(weight = 50)
    rand(0..100) < weight
  end
end
