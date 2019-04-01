# frozen_string_literal: true

class ReceivedMessage
  include ActiveModel::Model
  attr_accessor :message, :reply_type, :keywords

  def initialize(message)
    @message = message
    @reply_type = type(@message)
    @keywords = pick_keyword_from(@message)
  end

  def type(message)
    bot_name = ENV["BOT_NAME"]
    case message
    when /^#{bot_name}.*\s.*\s(?=.*買う)(?=.*覚え)/
      :remind_item
    when /^(?=.*#{bot_name})(?=.*買うもの)/
      :notify_item
    when /^#{bot_name}.*\s.*\s(?=.*買った)/
      :destroy_item
    when /(?=.*#{bot_name})(?=.*全部)(?=.*買った)/
      :destroy_all_item
    when "ごはん"
      :suggest_gohan
    when /.*\s.*\sどっち|.*\s.*\sどれ/
      if (message =~ /.*どれ.*言って.*|.*どっち.*言って.*/) == nil
        :which
      else
        :none
      end
    when /^#{bot_name}.*\s.*\sって言って.*/
      :say
    when /.*おはよ.*/
      :good_morning
    when /.*おやすみ.*/
      :good_night
    when /^(?=.*#{bot_name})(?=.*ありがと)/
      :youre_welcome
    when /^(?=.*#{bot_name})(?=.*慰めて)/
      :yoshiyoshi
    when /^(?=.*#{bot_name})(?=.*褒めて)/
      :praise
    when /^(?=.*#{bot_name})(?=.*応援して)/
      :cheer
    when /^(?=.*#{bot_name})(?=.*叱って)/
      :kora
    when /^.*つかれた.*|^.*疲れた.*/
      :otsukare
    else
      :none
    end
  end

  def pick_keyword_from(message)
    case @reply_type
    when :remind_item, :notify_item, :destroy_item, :destroy_all_item, :which, :say
      keywords = message.split(" ")
      keywords.shift
      keywords.pop
      keywords
    end
  end
end
