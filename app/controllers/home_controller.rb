class HomeController < ApplicationController
  def index
    unless current_user
      redirect_to root_path
    else
      @tl = case @current_user.provider
            when 'twitter'
              timeline_from_twitter
            when 'facebook'
              timeline_from_facebook
            end
    end
  end

  def tweet
    post_twitter(params[:message]) if params[:message]
    redirect_to root_path
  end

  private

  def twitter_client
    Twitter.configure do |config|
      config.consumer_key       = ENV['TWITTER_KEY']
      config.consumer_secret    = ENV['TWITTER_SECRET']
      config.oauth_token        = current_user.token
      config.oauth_token_secret = current_user.secret
    end
  end

  def timeline_from_twitter
    twitter_client.home_timeline(count: 20, include_rts: 'true').map{|tl|
      {
        :id => tl.user.id,
        :name => tl.user.name,
        :screen_name => tl.user.screen_name,
        :profile_url => tl.user.profile_image_url,
        #:background_url => tl.user.profile_background_image_url,
        :text => tl.text
      }
    }
  end

  def post_twitter(message)
    twitter_client.update("test #{message}")
  end

  def facebook_client
  end

  def timeline_from_facebook
  end
end
