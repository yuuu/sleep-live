variable "common" {
  type = map(any)
  default = {
    app_name = "sleep-live"
    env      = "dev"
    env_full = "development"
  }
}

variable "soracom" {
  type = map(any)
}

variable "slack" {
  type = map(any)
}

variable "allow_ip" {
  type = string
}