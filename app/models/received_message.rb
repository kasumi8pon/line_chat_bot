# frozen_string_literal: true

class ReceivedMessage
  include ActiveModel::Model
  attr_accessor :message, :reply_type, :keywords

  def initialize(message)
    @message = message
    @reply_type = type(@message)
  end

  def type(message)
    bot_name = ENV["BOT_NAME"]
    team_names = %w(広島 ヤクルト 巨人 ＤｅＮＡ 中日 阪神 西武 ソフトバンク 日本ハム オリックス ロッテ 楽天)
    team_list = team_names.join("|")

    case message
    when /^#{bot_name}.*\s.*\s(?=.*買う)(?=.*覚え)/
      @keywords = pick_keyword_from(@message)
      :remind_item
    when /^(?=.*#{bot_name})(?=.*買うもの)/
      @keywords = pick_keyword_from(@message)
      :notify_item
    when /^#{bot_name}.*\s.*\s(?=.*買った)/
      @keywords = pick_keyword_from(@message)
      :destroy_item
    when /(?=.*#{bot_name})(?=.*全部)(?=.*買った)/
      @keywords = pick_keyword_from(@message)
      :destroy_all_item
    when "ごはん"
      :suggest_gohan
    when /.*\s.*\sどっち|.*\s.*\sどれ/
      if (message =~ /.*どれ.*言って.*|.*どっち.*言って.*/) == nil
        @keywords = pick_keyword_from(@message)
        :which
      else
        :none
      end
    when /^#{bot_name}.*\s.*\sって言って.*/
      :say
    when /^(?=.*(#{team_list}))(?=.*試合)/
      @keywords = [ $1 ]
      :today_npb_result
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
