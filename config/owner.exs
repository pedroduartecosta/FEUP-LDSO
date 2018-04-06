use Mix.Config

# For production, we often load configuration from external
# sources, such as your system environment. For this reason,
# you won't find the :http configuration below, but set inside
# CocuWeb.Endpoint.init/2 when load_from_system_env is
# true. Any dynamic configuration should be done there.
#
# Don't forget to configure the url host to something meaningful,
# Phoenix uses this information when generating URLs.
#
# Finally, we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the mix phx.digest task
# which you typically run after static files are built.
if System.get_env("OWNER_DB_PASS") do
  config :cocu, CocuWeb.Endpoint,
    load_from_system_env: true,
    server: true,
    root: ".",
    url: [scheme: "https", host: "co-creative-universe.herokuapp.com", port: System.get_env("PORT") || 443],
    force_ssl: [rewrite_on: [:x_forwarded_proto]],
    cache_static_manifest: "priv/static/cache_manifest.json",
    secret_key_base: Map.fetch!(System.get_env(), "SECRET_KEY_BASE"),
    debug_errors: false 
else
  config :cocu, CocuWeb.Endpoint,
   http: [port: System.get_env("PORT") || 4000],
   debug_errors: false,
   code_reloader: false,
   check_origin: false,
   server: true,
   watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin",
                    cd: Path.expand("../assets", __DIR__)]]
end

# Do not print debug messages in production
config :logger, level: :info

# ## SSL Support
#
# To get SSL working, you will need to add the `https` key
# to the previous section and set your `:url` port to 443:
#
#     config :cocu, CocuWeb.Endpoint,
#       ...
#       url: [host: "example.com", port: 443],
#       https: [:inet6,
#               port: 443,
#               keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#               certfile: System.get_env("SOME_APP_SSL_CERT_PATH")]
#
# Where those two env variables return an absolute path to
# the key and cert in disk or a relative path inside priv,
# for example "priv/ssl/server.key".
#
# We also recommend setting `force_ssl`, ensuring no data is
# ever sent via http, always redirecting to https:
#
#     config :cocu, CocuWeb.Endpoint,
#       force_ssl: [hsts: true]
#
# Check `Plug.SSL` for all available options in `force_ssl`.

# ## Using releases
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start the server for all endpoints:
#
#     config :phoenix, :serve_endpoints, true
#
# Alternatively, you can configure exactly which server to
# start per endpoint:
#
#     config :cocu, CocuWeb.Endpoint, server: true
#

# Finally import the config/prod.secret.exs
# which should be versioned separately.
if System.get_env("OWNER_DB_PASS") do
  
  config :cocu,
         stripe_secret_key: System.get_env("STRIPE_SECRET_KEY")

  config :stripity_stripe, platform_client_id: System.get_env("STRIPE_PLATFORM_CLIENT_ID")
  config :stripity_stripe, secret_key: System.get_env("STRIPE_SECRET_KEY")

  config :cocu, Cocu.Repo,
    adapter: Ecto.Adapters.Postgres,
    username: "cocu",
    password: System.get_env("OWNER_DB_PASS"),
    database: "cocu_prod",
    hostname: "cocu-prod.cd4c4pieuyih.eu-central-1.rds.amazonaws.com",
    ssl: true,
    pool_size: 15
    
  config :ex_aws,
    access_key_id: System.get_env("S3_OWNER_ACCESS_KEY"),
    secret_access_key: System.get_env("S3_OWNER_SECRET_KEY"),
    region: "eu-central-1",
    host: "s3.eu-central-1.amazonaws.com",
    s3: [
      scheme: "https://",
      host: "s3.eu-central-1.amazonaws.com",
      region: "eu-central-1"
    ]
    
    
else
  import_config "owner.secret.exs"
end