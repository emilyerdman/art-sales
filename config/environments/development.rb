Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.
  config.S3_URL = 'https://s3.us-east-2.amazonaws.com/works-images/'
  config.read_encrypted_secrets = true

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false
  config.force_ssl = true

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true


  config.assets.unknown_asset_fallback = false

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.seconds.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = false

  # Suppress logger output for asset requests.
  config.assets.quiet = false

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  config.action_controller.action_on_unpermitted_parameters = :raise

  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_options = {from: 'do-not-reply@erdman-art-group.com'}
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
  address:              'mail.hover.com',
  port:                 587,
  domain:               'erdman-art-group.com',
  user_name:            'do-not-reply@erdman-art-group.com',
  password:             'jikcyp-fojwaS-hamby9',
  authentication:       'plain',
  enable_starttls_auto: true  }
  config.action_mailer.default_url_options = {host: 'localhost:3000'}

end
