Sequel.default_timezone = :utc
Sequel.extension :pg_json
Sequel.split_symbols = true
Sequel::Model.plugin :dirty
