# #Intializing the GoogleSearch Page once##
Before('@TC_Google_Search') do
  @@driver = Driver.new()
  $initialize_once ||= false  # have to define a variable before we can reference its value
  if !$initialize_once
    @@google_page = Pages::GoogleMainPage.new
    @@google_search_page = Pages::GoogleSearchPage.new
  end
  $initialize_once = true
end

After('@TC_Google_Search') do
  @@driver.quit
end

Given("I navigate to google search page") do
  @@driver.get($param["googleURL"])
end

When("I type the {string} in google search bar") do |searchText|
  @@google_page.enter_text_in_search_bar searchText
end

And("Click on search results") do
  @@google_page.click_google_search
end

Then("The page title should contain {string}") do|searchText|

  @@google_search_page.wait_for_results_page
  @@google_search_page.verify_page_title searchText
end

And("Displayed results should contain {string}") do |searchText|
  @@google_page.verify_search_text searchText
  @@google_search_page.verify_text_of_search_results searchText
  @@google_search_page.verify_text_of_people_also_ask_results searchText
  @@google_search_page.verify_text_of_videos_results searchText
  @@google_search_page.verify_side_container searchText

end
