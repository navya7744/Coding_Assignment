Google Page Search Project and JSON placeholder API Testing Project

## Stack used for automation
```
Selenium WebDriver + Cucumber + Ruby +Page Object Modal
```

## Project Setup
* Clone project
* Open in an IDE or CLI from the project folder
* Execute command to install bundler using `gem install bundler`
* Execute commands to install the dependencies by `bundle install`

## To Run Test from CLI
```
Open terminal from project folder 
bundle exec cucumber [path of feature file]
```

### Adding Locators 
* Locators identified in the project are added to features\locators module
* For each new page in the application add a new class inside the module features\locators
```
module Locators
  class TestPage

    # All the Locators in the initialize block need to be declared here for read write permission.
    attr_accessor :TEST_LOCATOR

    def initialize
      # Locators can be declared here by mentioning {how?(xpath,css,id) and what?(identifier)}
      @TEST_LOCATOR = Locator.new(:id, "")
    end

    # Dynamic locators can be declared here as a seperate method (This method doesnot need to be declared with attr_accessor)
    def TEST_DYNAMIC_LOCATOR(variable)
      @TEST_DYNAMIC_LOCATOR = Locator.new(:css,"tagName.class")
    end

  end
end
```

###Page Objects
* features/pages modules inherits Locators Class of same page to identify all the elements before performing actions
* Classes in this module contains the actions that a user can perform on an application in the form of methods

1. Add page specific methods inside the `Pages` module.

```
module Pages
  # add the page class here
end
```

2. For each page add a new class inside `Pages` module and each page class should inherit the locators class of the same page

```
module Pages
  class TestPage < Locators::TestPage

    def initialize()
      super()
    end

    def test_method(attribute_text)
    	puts "#{attribute_text}"
    end

  end
end
```
### Creating a new feature file in the project from which is the trigger point to run test

1. Define the tests in the feature file in gherkin language.

```
Feature: Sample project setup
  To get to know the sample cucumber project

  Scenario: This test will pass
    Given true eql true
    When false eql false
    Then string eql string

  Scenario Outline: This test will pass
    Given true eql true
    When false eql "<term>"
    Then string eql string

  Example:
  |term|
  |1|
  |2|
```

### Step Definitions
* Declare the feature steps inside the step definitions file.
```
Before('@test_tag') do
  puts "before each "
end

After('@test_tag') do |s|
   puts "after each "
end

Given("true eql true") do
  expect(true).to eql true
end

When("false eql false") do
  expect(false).to eql false
end

Then("string eql string") do
  expect("test").to eql "test"
end
```

### Global Data
* In features/global-data modules hardcoded values are saved like browser, run mode and screenshot path

### Driver instantiation
* Driver trigger methods are written in features/libraries modules in driver class 

### Wait Handling functions
* Wait Handling functions are written in features/libraries/wait.rb class 

### API AUTOMATION
* Used the same underlying framework described above and created a module features/api-lib to write the api tests

### Test Data
* Test data is present in features/test-data module
* It contains the api end point and UI application link