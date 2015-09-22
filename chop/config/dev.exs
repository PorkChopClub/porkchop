use Mix.Config

sass_args = [
  "--include-path bower_components",
  "--include-path node_modules/bourbon/app/assets/stylesheets",
  "--watch --recursive",
  "web/static/css/pork.scss",
  "priv/static/css/pork.css"
] |> Enum.join(" ")

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :chop, Chop.Endpoint,
  http: [port: 2278],
  debug_errors: true,
  code_reloader: true,
  cache_static_lookup: false,
  check_origin: false,
  watchers: [node: ~w(node_modules/.bin/webpack --watch --colors --progress),
             node: ~w(node_modules/.bin/node-sass #{sass_args})]

# Watch static and templates for browser reloading.
config :chop, Chop.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

config :chop, :legacy_app, url: "http://localhost:2277"

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development.
# Do not configure such in production as keeping
# and calculating stacktraces is usually expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :chop, Chop.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "porkchop",
  database: "porkchop_development",
  pool_size: 10
