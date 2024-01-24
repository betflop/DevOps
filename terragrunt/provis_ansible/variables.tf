variable "image_id" {
  description = "ID of the image"
  type        = string
}

variable "cloud_id" {
  description = "ID of the cloud"
  type        = string
}

variable "folder_id" {
  description = "ID of the folder"
  type        = string
}

variable "zone" {
  description = "ID of the zone"
  type        = string
}

variable "pvt_key" {
 description = "Path to the private key file"
 type       = string
 default    = "~/.ssh/id_rsa"
}
