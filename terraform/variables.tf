variable "awsKey" {
  default = "keywptest"
}
variable "keyPath" {
  default = "credential"
}
variable "region" {
  default = "eu-central-1"
}
variable "dbName" {
  default = "wpmysql"
}
variable "dbUname" {
  default = "horse"
}
variable "dbPass" {
  default = "hi_horse"
}
variable "vpcCidr" {
  default = "192.168.131.0/27"
}
variable "privateSubnetCidr" {
  default = "192.168.131.0/28"
}
variable "publicSubnetCidr" {
  default = "192.168.131.16/28"
}
variable "anyCidr" {
  default = "0.0.0.0/0"
}

output "dbUname" {
  value = "${var.dbUname}"
}
output "dbPass" {
  value = "${var.dbPass}"
}
