variable "folder_id" {
  description = "Default folder ID in yandex cloud"
  type        = string
  default     = "b1ges0jv3sroc0j8n3qv"
}
variable "instance_family_image" {
  description = "Instance image"
  type        = string
  default     = "lamp"
}
variable "netw_zone" {
  description = "Netwok zone"
  type        = string
  default     = ""
}
variable "vpc_subnet_id" {
  description = "VPC subnet network id"
  type        = string
}
