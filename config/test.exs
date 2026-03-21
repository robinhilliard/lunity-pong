import Config

# Headless tests: no wx editor window; still starts Lunity.Input.SessionManager + instances.
config :lunity, mode: :runtime, default_scene: nil
config :lunity, mods_enabled: true
