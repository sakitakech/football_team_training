require "omniauth-oauth2"
require "jwt"

module OmniAuth
  module Strategies
    class Line < OmniAuth::Strategies::OAuth2
      option :name, "line"  # 忘れずに
      # ここでメール取得スコープを指定
      option :scope, "email profile openid"

      uid { raw_info["userId"] }

      info do
        email = nil

        # id_tokenからメールを復号
        if access_token.params["id_token"]
          begin
            payload, = JWT.decode(
              access_token.params["id_token"],
              ENV["LINE_CHANNEL_SECRET"],
              true,
              algorithm: "HS256"
            )
            email = payload["email"]
          rescue => e
            email = nil
          end
        end

        {
          name:        raw_info["displayName"],
          image:       raw_info["pictureUrl"],
          description: raw_info["statusMessage"],
          email:       email
        }
      end

      def raw_info
        @raw_info ||= access_token.get("https://api.line.me/v2/profile").parsed
      end
    end
  end
end
