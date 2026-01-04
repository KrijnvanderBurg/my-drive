variable "display_name" {
  description = "The display name for the named location"
  type        = string
}

variable "ip_ranges" {
  description = "List of IP addresses or CIDR ranges (e.g., ['192.168.1.1/32', '10.0.0.0/8'])"
  type        = list(string)
}

variable "trusted" {
  description = "Whether this location is trusted (affects Conditional Access risk evaluation)"
  type        = bool
  default     = true
}
