class LookoutsController < ApplicationController
  require 'net/http'
  require 'json'

  def cover
    case
      when params[:subscription_id].present?&&User.find_by(subscription_id:params[:subscription_id]).member?||params[:subscription_id]=="free"
        if params[:mode]=="image"
          result=checking_image?(params[:image])
          user=User.find_by(subscription_id:params[:subscription_id])
          called_count=user.api_called_count
          user.update(api_called_count:called_count+1)
          render json:result
        elsif params[:mode]=="message"
          params[:option]=true unless params[:option].present?
          result=message_judgment?(params[:message],params[:targets],params[:option])
          user=User.find_by(subscription_id:params[:subscription_id])
          called_count=user.api_called_count
          user.update(api_called_count:called_count+1)
          render json:result
        else
          render json: 'You need to specify available option.'
        end
      when params[:subscription_id]. present?&&User.find_by(subscription_id:params[:subscription_id]).member? == false
        render json:'Your subscription has already ended.'
      when params[:subscription_id].present? == false
        render json: 'You need to specify your subscription_id.'
    end
  end

  private

  def message_judgment?(message,targets,option=true)
    unless option==true
      targets.each do|target|
        message.slice!(target) if message.include?(target)
      end
    else
      message.gsub!(/(#{targets.join('|')})/) do |target|
        '*' * target.length
      end
    end
    return {:checked_message=>message}
  end

  def checking_image?(image)
    uri = URI('https://westus.api.cognitive.microsoft.com/vision/v1.0/analyze')
    uri.query = URI.encode_www_form({
                                        # Request parameters
                                        'visualFeatures' => 'Adult',
                                        'details' => '',
                                        'language' => 'en'
                                    })

    request = Net::HTTP::Post.new(uri.request_uri)
    # Request headers
    request['Content-Type'] = 'application/json'
    # Request headers
    request['Ocp-Apim-Subscription-Key'] = "caa91ca062cb44e09e583f9e39b8f530"
    # Request body
    request_body = Hash.new
    request_body[:url] = image
    request.body = request_body.to_json
    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      http.request(request)
    end
    response=response.body
    response= JSON.parse(response)
    response=response["adult"]
    isadult=response["isAdultContent"]
    adult_score=response["adultScore"]
    if isadult == true
      checked_image = nil
    else
      checked_image = image
    end
    return {:checked_image=>checked_image,:isadult=>isadult,:adult_score=>adult_score}
  end
end
