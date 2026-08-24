variable "datastore_id" { type = string }
variable "node_name" { type = string }
variable "url" { type = string }
variable "overwrite_unmanaged" {
  type    = bool
  default = true
}
