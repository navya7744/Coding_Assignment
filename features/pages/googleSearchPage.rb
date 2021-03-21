module Pages
    class GoogleSearchPage < Locators::GoogleSerachPageLocators
  
      def initialize
        super()
      end

      def verify_page_title(string)
        p @@driver.get_title

        result = @@driver.get_title.downcase.include? string
        result.should == true
        puts "Page title contains "+string
      end

      def wait_for_results_page
        @RESULTS_PAGE.is_present_with_wait?
        puts "Google search results page is displayed"
      end

      def verify_side_container(string)
        search_result_texts = @SIDE_CONTAINER.texts
        verify_results search_result_texts, string
        puts "Side container in result page contains "+string
      end

      def verify_text_of_search_results(string)
        search_result_texts = @SEARCH_GROUPS.texts
        verify_results search_result_texts, string
        puts "Search results in result page contains "+string
      end

      def verify_text_of_people_also_ask_results(string)
        search_result_texts = @PEOPLE_ALSO_ASK.texts
        verify_results search_result_texts, string
        puts "People also ask questions in result page contains "+string
      end

      def verify_text_of_videos_results(string)
        search_result_texts = @YOUTUBE_VIDEOS.texts
        verify_results search_result_texts, string
        puts "Video results in result page contains "+string
      end

      def verify_results(search_result_texts, string)
        search_result_texts.each do |result_text|
          result = result_text.downcase.include? string
          result.should == true
        end
      end
    end
   end