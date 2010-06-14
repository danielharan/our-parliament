# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_citizen-factory_session',
  :secret      => 'd0618044691febfb6eef01ad5bc0206c149823bc6f2f3c1f66bf73b99441ba7b7d476b1ed12e91fa4b3233ee6b12907c2de5abd63cfd84a405005aa8bfc0d48e'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
