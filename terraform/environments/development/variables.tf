variable "common" {
  type = map(any)
  default = {
    app_name = "sleep-live"
    env      = "dev"
    env_full = "development"
  }
}