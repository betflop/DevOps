variable "networks" {
 description = "List of network names"
 type       = list(string)
 default    = ["network1", "network2"]
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
  default     = "-subnet"
}

variable "folder_id" {
  description = "ID of the folder"
  type        = string
}
