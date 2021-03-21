module Locators
  class GoogleMainPageLocators

    attr_reader :SEARCH_BOX
    attr_reader :SEARCH_BUTTON

    def initialize
      @SEARCH_BOX = Locator.new(:name, "q")
      @SEARCH_BUTTON = Locator.new(:css, "div.FPdoLc input[name='btnK']")
      @GOOGLE_IMAGE = Locator.new(:css, "img.lnXdpd")

    end

  end
end
  