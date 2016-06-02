ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Ketobit.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Ketobit.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Ketobit.Repo)

