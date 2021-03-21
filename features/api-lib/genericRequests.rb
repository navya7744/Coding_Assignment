require 'rest-client'

module ApiLib
	class ApiBase
	
	@@schema = {
					"userId" => "integer",
					"id" => "integer",
					"title" => "String",
					"body" => "String"
				}

	#GET method with base_url parameter
		def get(base_url)
			begin
				response = RestClient.get base_url
			rescue => e
				return e.response
			end
		end

	#GET method to set header with base_url and header parameters and then call API
		def get_setheader(base_url,header)
			begin
				hdr = JSON.parse header
				response=RestClient.get base_url,hdr
				return response
			rescue =>e
				return e.response
			end
		end

	#Returns count for records containing the keyName in the response
	def returnCountOfrecords keyName, response
		keyCount = 0;
		count = returnKeyValues keyName, response
		return count.size
	end

	#Returns key values of the given keyName in the response
	def returnKeyValues keyName,response
		responseBody = JSON.parse(response.body)
		keyValuesArray = []
		if(responseBody.kind_of?(Array))
			arraySize = responseBody.size
			responseBody.each do |hash|
				keyValuesArray.append(hash[keyName])
			end
		else
			keyValuesArray.append(responseBody[keyName])
		end
		return keyValuesArray
	end

	#Verify that each value in the input responseArray is equals to expectedValue
	def verifyResponseArray responseArray,expectedValue
		flag =0
		responseArray.each { |actualID|
			flag = 1
			return false if(actualID.to_s!=expectedValue)
		}
		if(flag == 0)
			return false
		else
			return true
		end
	end

	end
end
