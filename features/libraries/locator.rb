# frozen_string_literal: true

module Libraries
  class Locator
    attr_accessor :how, :what, :options

    def initialize(
      how,
      what,
      options = {
        'hidden' => false,
        'ajax_load' => false
      }
    )
      @how = how
      @what = what
      @options = options
    end

    # #Highlight the element##
    def highlight(driver = $focus_driver)
      element = driver.find_element(self)
      attr = element.attribute('backgroundColor')
      driver.execute_script "arguments[0].style.backgroundColor = 'red';", element
      driver.execute_script 'arguments[0].style.backgroundColor = arguments[1];', element, attr
      driver.execute_script "arguments[0].style.backgroundColor = 'red';", element
      driver.execute_script 'arguments[0].style.backgroundColor = arguments[1];', element, attr
    end

    ##################################################
    # Methods inherited and overriden from Selenium  #
    ##################################################
    # #Custom Click method with exception handling##
    def click(driver = $focus_driver)
      driver.find_element(self).click
      puts "Clicked - #{how} => #{what}"
    rescue Exception => e
      puts "Not clicked at - #{how} => #{what}"
      puts e.message
    end

    # #Get Text of an element##
    def text(driver = $focus_driver)
      driver.find_element(self).text
    end

    # #Get texts of similar elements##
    def texts(driver = $focus_driver)
      elements_text = []
      driver.find_elements(self).each do |element|
        elements_text.push(element.text)
      end
      elements_text
    end

    # #Get particular attribute value of an element##
    def attribute(name, driver = $focus_driver)
      driver.find_element(self).attribute(name)
    end

    # #Get CSS values of an element##
    def css_value(prop, driver = $focus_driver)
      driver.find_element(self).css_value(prop)
    end

    # #Verify Element displayed or not##
    def displayed?(driver = $focus_driver)
      driver.find_element(self).displayed?
    end

    # #Verify Element enabled or not##
    def enabled?(driver = $focus_driver)
      driver.find_element(self).enabled?
    end

    # #Verify Element enabled or not, if not enabled then wait and retry##
    def is_enabled_with_wait?(timeout = $conf['implicit_wait'], driver = $focus_driver)
      index = 0
      while driver.find_element(self).enabled? == false
        break if index == timeout

        index += 1
      end
    end

    # #Verify Element displayed or not##
    def selected?(driver = $focus_driver)
      driver.find_element(self).selected?
    end

    # #Get the element location after scrolling into element's view##
    def location_once_scrolled_into_view(driver = $focus_driver)
      driver.find_element(self).location_once_scrolled_into_view
    end

    def is_present?(driver = $focus_driver)
      driver.driver.manage.timeouts.implicit_wait = 0
      begin
        driver.driver.find_element(how, what).displayed?
      rescue Exception => e
        driver.driver.manage.timeouts.implicit_wait = $conf['implicit_wait']
        false
      ensure
        driver.driver.manage.timeouts.implicit_wait = $conf['implicit_wait']
      end
    end

    def is_not_present?(driver = $focus_driver)
      !is_present?(driver)
    end

    def is_present_with_wait?(timeout = $conf['implicit_wait'], driver = $focus_driver)
      Wait.wait_for_element(self, timeout, driver)
      is_present?(driver)
    end

    def is_not_present_with_wait?(timeout = $conf['implicit_wait'], driver = $focus_driver)
      Wait.wait_for_element_hide(self, timeout, driver)
      !is_present?(driver)
    end

    def click_if_present(driver = $focus_driver)
      click(driver) if is_present?(driver)
    end

    def scroll_to_locator(_driver = $focus_driver)
      $focus_driver.scroll_to_locator(self)
    end

    def click_if_present_with_wait(timeout = $conf['implicit_wait'], driver = $focus_driver)
      click(driver) if is_present_with_wait?(timeout, driver)
    end

    def to_s
      "How ===> #{@how}\nWhat ===> #{@what}\nOptions ===> #{@options}"
    end

    def move_and_click(driver = $focus_driver)
      element = driver.find_element(self)
      driver.action.move_to(element).click.perform
    end

    def get_element(driver = $focus_driver)
      driver.find_element(self)
    end


    ##############################
    # Text box methods
    ##############################

    def clear(driver = $focus_driver)
      driver.find_element(self).clear
    end

    def send_keys(*args)
      $focus_driver.find_element(self).send_keys(*args)
    end

    def clear_and_send_keys(*args)
      clear($focus_driver)
      send_keys(*args)
    end

    def get_value(driver = $focus_driver)
      driver.find_element(self).attribute('value')
    end


  end
end
