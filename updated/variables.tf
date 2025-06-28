variable "vpc_cidr" {
  default = "192.192.0.0/16"
}
variable "azs" {
  description = "List of Availability Zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
