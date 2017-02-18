require_relative '../api'

module VendorAPI
  module Microsoft
    class Face < API
        @@KEY = Rails.application.secrets.microsoft_face_api_key1
        @@ROOT = 'https://westus.api.cognitive.microsoft.com'

      class << self
        def face_attributes(image_url)
          path = '/face/v1.0/detect'
          body = b url: image_url
          post path, body: body
        end

        # 'Host': 'westus.api.cognitive.microsoft.com',
        # ,
        def default_headers
          {
            'Content-Type' => 'application/json',
            'Accept' => 'application/json',
            'Ocp-Apim-Subscription-Key' => @@KEY
          }
        end

        def default_body
          { returnFaceId: true, returnFaceLandmarks: true }
        end
      end
    end
  end
end
