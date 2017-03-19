namespace :OAuth do
  task create_providers: :enivornment do
    providers = [
      { id: 1, name: "twitter" },
      { id: 2, name: "facebook" },
      { id: 3, name: "google_oauth2" }
    }
    AuthenticationProvider.create! providers
  end
end
