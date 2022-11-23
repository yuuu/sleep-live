require 'json'
require 'faraday'
require 'slack-ruby-client'
require 'aws-sdk-s3'

Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN']
end

def lambda_handler(event)
  puts 'start'

  auth_client = Faraday.new(
    url: 'https://api.soracom.io/',
    headers: { 'Content-Type': 'application/json' }
  )
  api_key, token = auth(auth_client)

  client = Faraday.new(
    url: 'https://api.soracom.io/',
    headers: {
      'Content-Type': 'application/json',
      'X-Soracom-API-Key': api_key,
      'X-Soracom-Token': token,
    }
  )
  device = sora_cam_device(client)
  return unless device['connected']

  stream = sora_cam_stream(client)
  start_live(stream['playList'].first['url'])

  puts 'end'
rescue StandardError => e
  puts e.full_message
end

private

def auth(client)
  res = client.post(
    '/v1/auth',
    {
      authKeyId: ENV.fetch('SORACOM_AUTH_KEY_ID', ''),
      authKey: ENV.fetch('SORACOM_AUTH_KEY_SECRET', '')
    }.to_json
  )
  json = JSON.parse(res.body)
  [json['apiKey'], json['token']]
end

def sora_cam_device(client)
  res = client.get("/v1/sora_cam/devices/#{ENV.fetch('SORACOM_SORACAM_DEVICE_ID', '')}")
  JSON.parse(res.body)
end

def sora_cam_stream(client)
  res = client.get("/v1/sora_cam/devices/#{ENV.fetch('SORACOM_SORACAM_DEVICE_ID', '')}/stream")
  puts res.body
  JSON.parse(res.body)
end

def start_live(url)
  s3_bucket.put_object(key: 'url.json', body: { url: url }.to_json)

  client = Slack::Web::Client.new
  client.chat_postMessage(channel: ENV['SLACK_CHANNEL'], attachments: attachments, as_user: true)
end

def attachments
  [
    {
      color: '#1e2cc9',
      blocks: [
        {
          type: :section,
          text: { type: :mrkdwn, text: "LIVEがはじまるよ！\nhttps://#{ENV.fetch('AWS_CLOUDFRONT_DOMAIN', '')}\n※社内IPからのみ視聴可能です" }
        }
      ]
    }
  ]
end

def s3_bucket
  Aws::S3::Resource.new(region: 'ap-northeast-1')
                   .bucket(ENV.fetch('AWS_S3_HOSTING_BUCKET_NAME'))
end