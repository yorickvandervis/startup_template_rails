copy_file "app/controllers/static_pages_controller.rb"
copy_file "app/assets/fonts/Inter.ttf"
copy_file "app/assets/fonts/CalSans-SemiBold.woff2"
copy_file "app/javascript/controllers/dark_mode_toggle_controller.js"
copy_file "tailwind.config.js"
copy_file "app/assets/stylesheets/application.tailwind.css"

gem "devise"
gem_group :development, :test do
  gem "standard"
  gem "faker"
  gem "rspec-rails", "~> 6.0.0"
  gem "factory_bot_rails"
  gem "rails-controller-testing"
  gem "dotenv-rails"
end

gem_group :development do
  gem "brakeman"
end

gem_group :test do
  gem "shoulda-matchers", "~> 5.0"
end

rails_command("bundle")

# Devise Setup
generate("devise:install")
environment 'config.action_mailer.default_url_options = { host: "localhost", port: 3000 }', env: "development"
generate("devise", "User")

# Rspec setup
generate("rspec:install")

# Shoulda Matchers setup
append_to_file "spec/rails_helper.rb" do
  <<~CODE
    # Shoulda Matchers Configuration
    Shoulda::Matchers.configure do |config|
        config.integrate do |with|
            with.test_framework :rspec
            with.library :rails
        end
    end
  CODE
end

append_to_file "app/javascript/controllers/index.js" do
  <<~CODE
    import DarkModeToggleController from "./dark_mode_toggle_controller"
    application.register("dark-mode-toggle", DarkModeToggleController)
  CODE
end

generate(:controller, "static_pages", "index")
remove "static_pages/index"
route "root to: 'static_pages#index'"

rails_command("db:create db:migrate")

after_bundle do
  git :init
  git add: "."
  git commit: %( -m 'Initial commit' )
end
