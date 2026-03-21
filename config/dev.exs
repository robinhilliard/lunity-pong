import Config

# Player WebSocket / JWT (Lunity). `mix lunity.player --url http://127.0.0.1:<port> --token
# dev_player_ws_token` + mint; `Pong.PlayerJoin` assigns instance + paddle. Mint:
# `--mint-key dev_player_mint_key`.
config :lunity, :player_ws_token, "dev_player_ws_token"
config :lunity, :player_jwt_secret, "dev_player_jwt_secret"
config :lunity, :player_mint_secret, "dev_player_mint_key"

config :lunity, :player_join, {Pong.PlayerJoin, :assign}
