module Libraries
    module Wait

        # avoid defining self in def self.some_method -> def some_method
        class << self

            def wait_for_element(locator, timeout=$conf["implicit_wait"], focus_driver = $focus_driver)
                index=0
                while locator.is_present?(focus_driver) == false
                    if index == timeout
                        break
                    end
                    index+=1
                end
            end

            def wait_for_element_hide(locator, timeout=$conf["implicit_wait"], focus_driver = $focus_driver)
                index=0
                while locator.is_present?(focus_driver) == true
                    if index == timeout
                        break
                    end
                    index+=1
                end
            end
        end
    end
end
  