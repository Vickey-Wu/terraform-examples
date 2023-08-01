variable "region" {
  type        = string
  description = "aws default region"
  default     = "ap-east-1"
  sensitive   = false
}

variable "env_map" {
  type        = map(string)
  description = "env map var"
}
variable "env_list" {
  type        = list(string)
  description = "env list var"
}

variable "object_var" {
  type = object({
    name = string,
    tag  = string
  })
}