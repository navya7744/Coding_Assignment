Before('@apiTest') do
  @@api_test = ApiLib::ApiBase.new
end

Given('I set GET request api endpoint') do
  @@apiUrl= $param['apiUrl']
end

When('I set HEADER before sending get request') do |header|
	@@response = @@api_test.get_setheader @@apiUrl,header
end

Then("I receive HTTP response code {int}") do|responseCode|
  expect(@@response.code==responseCode).to be_truthy,"Expected response code #{responseCode}, but got #{@@response.code}"
end

Then("Non-Empty Response Body is returned") do
  count = @@api_test.returnCountOfrecords 'userId', @@response
  expect(count>0).to be_truthy,"Expected that response body should not be empty, but found empty"
end

Given("I set GET request api endpoint {string}") do|queryParamater|
  @@apiUrl = $param['apiUrl']+'/'+queryParamater
end

Then("Response count is {string}") do|responseObjectCount|
  count =  @@api_test.returnCountOfrecords 'id', @@response
  expect(count==responseObjectCount.to_i).to eql true
end

And("response body should contain id as {string}") do |id|
  idValues = @@api_test.returnKeyValues 'id',@@response
  expect(@@api_test.verifyResponseArray idValues,id).to eql true
end

And("Response Message is") do |responseMessage|
  expect(@@response.description.include? responseMessage).to eql true
end

When("I send the GET request") do
  @@response = @@api_test.get @@apiUrl
end

When("I set param userId as {string} before sending the GET request") do |userID|
  @@response =  @@api_test.get @@apiUrl+"?userId="+userID
end

And("Response should contain only userId {string} results") do |userID|
  actualUserIDs = @@api_test.returnKeyValues("userId", @@response).to_set
  expect(@@api_test.verifyResponseArray actualUserIDs,userID).to eql true
end

And("Empty response body is returned") do
  count = @@api_test.returnCountOfrecords 'userId', @@response
  expect(count==0).to eql true
end

And("Title field is Not-Empty in all the JSON Object") do
  actualTitles = @@api_test.returnKeyValues("title", @@response)
  expect(@@api_test.verifyResponseArray actualTitles,"").to eql false
end