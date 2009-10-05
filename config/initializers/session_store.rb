# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_mustachetest_session',
  :secret      => 'c0beebd8cf22afcb097b368aadc87ef83471829c228753e669f90bb90ac8c0a96025c7aee89ba601be47c3255575ae1975151a0025ce844e68f312ccde32b8b0'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
