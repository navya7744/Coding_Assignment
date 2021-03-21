module Pages
    class GoogleMainPage < Locators::GoogleMainPageLocators
  
      def initialize
        super()
      end

      def enter_text_in_search_bar(searchText)
        @SEARCH_BOX.is_present_with_wait?
        @SEARCH_BOX.clear_and_send_keys(searchText)
        puts "Entered search text: "+searchText
      end

      def click_google_search
        @SEARCH_BUTTON.scroll_to_locator
        @GOOGLE_IMAGE.move_and_click
        @SEARCH_BUTTON.move_and_click
        puts "Clicked on Google Search"
      end

      def verify_search_text(string)
        search_text = @SEARCH_BOX.get_value
        text = search_text.include? string
        text.should == true
        puts "Search text "+string+" is verified in search box"
      end
    end
  end