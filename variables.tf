variable "vmName" {
  description = "Provide VM name"
  default = "qatodhsub123"
}

variable "location" {
  description = "Provide location where the resource will be created"
  default = "Australia Southeast"
}

variable "resource_group_name" {
  description = "Provdie the resource group name"
  default = "Testpoc"
}

variable "existingVirtualNetworkName" {
  description = "Provide existing VNet Name"
  default = "vnet01qaodhsub"
}

variable "existingSubnetName" {
  description = "Provide existing Subnet Name"
  default = "vnet01-qaodhsub"
}

variable "vmSize" {
  description = "Provide VM size required"
  default = "Standard_B2ms"
}

variable "poolName" {
  description = "Provide PoolName where the agent will be created"
  default = "linuxpool"
}

variable "PersonalAccessToken" {
  description = "Provide Personal Access Token"
  default = "u3ymofhtrfgfurt3456gr78uthxtb4dlcue6er3qq55zqq"
}

variable "VSTSAccount" {
  description = "Provide Name of VSTS account"
  default = "teeeeest"
}

variable "vmAdminUserName" {
  description = "Provide the admin user to login into VM"
  default = "testadmin"
}

variable "vmAdminPassword" {
  description = "Provide password for the admin of VM"
  default = "abc123"
}

variable "imagePublisher" {
  description = "image publisher"
  default = "Canonical"
}

variable "imageOffer" {
  description = "Image offer"
  default = "UbuntuServer"
}

variable "ubuntuOSVersion" {
  description = "Provide the  OS version"
  default = "16.04.0-LTS"
}

variable "dockerVersion" {
  description = "Provide Dcoker version to be installed"
  default = "19.03.5"
}

