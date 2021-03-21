module Locators
  class GoogleSerachPageLocators

    attr_reader :SEARCH_GROUPS
    attr_reader :RESULTS_PAGE
    attr_reader :PEOPLE_ALSO_ASK
    attr_reader :YOUTUBE_VIDEOS
    attr_reader :SIDE_CONTAINER

    def initialize
      @RESULTS_PAGE = Locator.new(:id, "rcnt")
      @SEARCH_GROUPS = Locator.new(:css, "div.D6j0vc div.hlcw0c>div.g")
      @PEOPLE_ALSO_ASK = Locator.new(:css, "div.ifM9O div.mWyH1d.UgLoB")
      @YOUTUBE_VIDEOS = Locator.new(:css, "div.I78iTc.nNwWze")
      @SIDE_CONTAINER = Locator.new(:id, "wp-tabs-container")
    end
  end
end
  