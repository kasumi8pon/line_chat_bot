# frozen_string_literal: true

require "line/bot"

class WebhookController < ApplicationController
  protect_from_forgery except: :callback

  def callback
    body = request.body.read

    signature = request.env["HTTP_X_LINE_SIGNATURE"]
    unless client.validate_signature(body, signature)
      error 400 do "Bad Request" end
    end

    events = client.parse_events_from(body)
    events.each { |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          received_message = ReceivedMessage.new(event.message["text"])
          if received_message.reply_type != :none
            reply = ReplyMessage.new(received_message)
            message = {
              type: reply.message_type,
              text: reply.text
            }
            client.reply_message(event["replyToken"], message)
          end
        end
      end
    }

    head :ok
  end

  private

    def client
      @client ||= Line::Bot::Client.new { |config|
        config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
        config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
      }
    end
end
