ExUnit.start

Mix.Task.run "ecto.create", ["--quiet"]

# Uncomment this when ecto is handling migrations.
# Mix.Task.run "ecto.migrate", ["--quiet"]

Ecto.Adapters.SQL.begin_test_transaction(Chop.Repo)

