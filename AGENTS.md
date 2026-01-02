# AGENTS.md - Development Guidelines for rngesus

## Build/Lint/Test Commands

### Running Tests
```bash
# Run all tests
bin/rails test

# Run tests for a specific file
bin/rails test test/models/example_test.rb
bin/rails test test/controllers/examples_controller_test.rb

# Run tests for a specific test method
bin/rails test test/models/example_test.rb -n test_method_name

# Run tests with verbose output
bin/rails test -v

# Run tests in parallel (faster)
bin/rails test -p

# Run system tests only
bin/rails test:system

# Run integration tests only
bin/rails test:integration

# Run with Guard (auto-rerun on file changes)
bundle exec guard
```

### Code Quality & Linting
```bash
# Run RuboCop (linting)
bin/rubocop

# Run RuboCop with auto-fix
bin/rubocop -a

# Run RuboCop on specific files
bin/rubocop app/models/example.rb

# Run ERB linting
bundle exec erb_lint app/views/**/*.html.erb --autocorrect

# Security scanning with Brakeman
bin/brakeman --no-pager

# Check gem security vulnerabilities
bin/bundler-audit

# Run all quality checks (CI equivalent)
bin/ci
```

### Development Server
```bash
# Start development server with all dependencies
bin/dev

# Start Rails server only
bin/rails server

# Start Rails console
bin/rails console

# Database operations
bin/rails db:migrate
bin/rails db:rollback
bin/rails db:seed
bin/rails db:reset
```

## Code Style Guidelines

### Ruby/Rails Conventions

#### File Structure
- Models: `app/models/` - ActiveRecord models
- Controllers: `app/controllers/` - Rails controllers
- Views: `app/views/` - ERB templates
- Services: `app/services/` - Business logic services (e.g., `ResultsCsvProcessor`)
- Concerns: `app/models/concerns/` and `app/controllers/concerns/` - Shared functionality
- Lib: `lib/` - Custom libraries (e.g., `Dice`, `DiceNotations`)
- Tests: `test/` - Minitest test files

#### Naming Conventions
```ruby
# Classes/Modules
class ExamplesController < ApplicationController  # PascalCase
class ResultsCsvProcessor                        # PascalCase, descriptive
module DiceNotations                            # PascalCase

# Methods
def create_with_img_upload  # snake_case, descriptive
def toggle_like            # snake_case, action_describing
def set_example           # snake_case, imperative

# Variables/Attributes
@roll_results  # snake_case, descriptive
current_user   # snake_case, clear meaning
params         # Rails standard

# Files
results_csv_processor.rb    # snake_case, matches class name
examples_controller.rb      # snake_case, matches class name
```

#### Code Structure
```ruby
# frozen_string_literal: true

class ExamplesController < ApplicationController
  before_action :set_example, only: %i[show edit update destroy]

  # GET /examples
  def index
    @examples = Example.all
  end

  # POST /examples
  def create
    @example = Example.new(example_params)

    if @example.save
      redirect_to @example, notice: t('.success')
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  def set_example
    @example = Example.find(params.expect(:id))
  end

  def example_params
    params.expect(example: %i[name value])
  end
end
```

### Service Objects Pattern
```ruby
# app/services/results_csv_processor.rb
class ResultsCsvProcessor
  attr_reader :roll, :file

  def initialize(roll, file)
    @roll = roll
    @file = file
  end

  def call
    CSV.foreach(file.path, headers: false) do |line|
      value = line[0]
      name  = line[1]
      roll.results.create(value: value, name: name)
    end
  end
end
```

### Model Patterns
```ruby
# app/models/example.rb
class Example < ApplicationRecord
  # Keep models minimal - business logic in services
end

# With validations and associations
class Roll < ApplicationRecord
  has_many :results
  belongs_to :user

  validates :name, presence: true
  validates :dice_notation, presence: true
end
```

### Controller Patterns
```ruby
class RollsController < ApplicationController
  before_action :set_roll, only: %i[show edit update destroy]

  def create
    @roll = current_user.rolls.build(roll_params)

    if @roll.save
      redirect_to @roll, notice: t('.success')
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  def set_roll
    @roll = Roll.find(params.expect(:id))
  end

  def roll_params
    params.expect(roll: %i[name dice_notation description])
  end
end
```

### Error Handling
```ruby
# Controller error handling
def create
  @roll = Roll.new(roll_params)

  if @roll.save
    redirect_to @roll, notice: t('.success')
  else
    render :new, status: :unprocessable_content  # 422 for validation errors
  end
end

# Service error handling
class ResultsCsvProcessor
  def call
    # Handle file processing errors
    CSV.foreach(file.path, headers: false) do |line|
      next if line.blank?  # Skip empty lines gracefully
      # Process line...
    rescue CSV::MalformedCSVError => e
      Rails.logger.error "CSV parsing error: #{e.message}"
      next
    end
  end
end
```

### Testing Patterns
```ruby
# test/models/roll_test.rb
class RollTest < ActiveSupport::TestCase
  test "should create valid roll" do
    roll = Roll.new(name: "Test Roll", dice_notation: "d6")
    assert roll.valid?
  end

  test "should validate presence of name" do
    roll = Roll.new(dice_notation: "d6")
    assert_not roll.valid?
    assert_includes roll.errors[:name], "can't be blank"
  end
end

# test/controllers/rolls_controller_test.rb
class RollsControllerTest < ActionDispatch::IntegrationTest
  test "should create roll" do
    assert_difference('Roll.count') do
      post rolls_url, params: { roll: { name: 'Test Roll', dice_notation: 'd6' } }
    end

    assert_redirected_to roll_url(Roll.last)
  end
end
```

### Import/Require Patterns
```ruby
# At top of files
# frozen_string_literal: true

# Rails automatically loads everything in app/
# No manual requires needed for app classes

# For lib classes, use explicit requires if needed
require_relative 'dice_notations/dice_notation'

# Gem requires handled by Bundler
# No manual requires for gems in Gemfile
```

### Internationalization (I18n)
```ruby
# In controllers
redirect_to @roll, notice: t('.success')
redirect_to @roll, notice: t('rolls.create.success')

# In views
<%= t('rolls.show.title') %>

# config/locales/en.yml
en:
  rolls:
    create:
      success: "Roll created successfully"
    show:
      title: "Roll Details"
```

### Security Best Practices
- Use strong parameters: `params.expect(roll: %i[name dice_notation])`
- Authenticate users via Omniauth (no passwords stored)
- Use Rails content security policy
- Brakeman scans for security vulnerabilities
- Bundle audit checks gem vulnerabilities
- Soft deletes with `discard` gem instead of hard deletes

### Performance Considerations
- Use `parallelize(workers: :number_of_processors)` in tests
- Eager loading in CI: `config.eager_load = ENV['CI'].present?`
- Cache store: `config.cache_store = :solid_cache` in production
- Database-backed job queue: Solid Queue
- Jemalloc for memory optimization in production

### Deployment
- Use Kamal for deployment: `kamal deploy`
- Docker containerization
- Environment variables for secrets (SMTP, OAuth keys)
- SSL termination at proxy level
- Persistent volumes for data

### Git Workflow
- Feature branches for development
- Pull requests with CI checks
- Conventional commit messages
- No secrets committed (use .kamal/secrets or ENV)

Remember: This is a Rails application focused on TTRPG dice rolling tables. Keep code clean, well-tested, and user-friendly.