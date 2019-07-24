#Variables initialization

#Common variables
app_name = "jdld"

env_name = "apps"

#Below tag variable is no more used as this data is now probed trhough the data source module "Get-AzureRmResourceGroup"
default_tags = {
  ENV = "sand1"
  APP = "JDLD"
  BUD = "FR_BXXXXX"
  CTC = "j.dumont@veebaze.com"
}

rg_apps_name = "apps-jdld-sand1-rg1"

rg_infr_name = "infr-jdld-noprd-rg1"

#Storage
sa_infr_name = "infrsand1vpcjdld1"

#Backup
bck_rsv_name = "infra-jdld-infr-rsv1"

#Network

apps_snets = [
  {
    name              = "frontend"
    cidr_block        = "198.18.2.224/28"
    nsg_id            = "0" #Id of the Network Security Group, set to 777 if there is no Network Security Groups
    route_table_id    = "0" #Id of the Route table, set to 777 if there is no Route table
    vnet_name_id      = "1" #Id of the vnet
    service_endpoints = ""  #Service Endpoints list sperated by an espace, if you don't need to set it to "" or "777"
  },
  {
    name              = "backend"
    cidr_block        = "198.18.2.240/28"
    nsg_id            = "0" #Id of the Network Security Group, set to 777 if there is no Network Security Groups
    route_table_id    = "0" #Id of the Route table, set to 777 if there is no Route table
    vnet_name_id      = "1" #Id of the vnet
    service_endpoints = ""  #Service Endpoints list sperated by an espace, if you don't need to set it to "" or "777"
  },
]

apps_nsgs = [
  {
    id = "1"
    security_rules = [
      {
        description                = "Demo1"
        direction                  = "Inbound"
        name                       = "ALL_to_NIC_tcp-3389"
        access                     = "Allow"
        priority                   = "2000"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
        destination_port_range     = "3389"
        protocol                   = "tcp"
        source_port_range          = "*"
        source_port_ranges         = ""
      },
      {
        direction                  = "Inbound"
        name                       = "ALL_to_NIC_tcp-80-443"
        access                     = "Allow"
        priority                   = "2001"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
        destination_port_range     = "80"
        protocol                   = "tcp"
        source_port_range          = "*"
      },
      {
        direction                  = "Outbound"
        name                       = "ALL_to_GoogleDns_udp-53"
        access                     = "Allow"
        priority                   = "2001"
        source_address_prefix      = "*"
        destination_address_prefix = "8.8.8.8"
        destination_port_range     = "53"
        protocol                   = "*"
        source_port_range          = "*"
        source_port_ranges         = ""
      },
    ]
  },
]

# Virtual Machines components : Load Balancer & Availability Set & Nic & VM
Lb_sku = "Standard" #"Basic" 

Lbs = [
  {
    suffix_name = "ssh"
    Id_Subnet   = "0" #Id of the Subnet
    static_ip   = "198.18.2.238"
  },
  {
    suffix_name = "gfs"
    Id_Subnet   = "1" #Id of the Subnet
    static_ip   = "198.18.2.254"
  },
  {
    suffix_name = "rds"
    Id_Subnet   = "1" #Id of the Subnet
    static_ip   = "198.18.2.253"
  },
]

LbRules = [
  {
    Id                = "1"   #Id of a the rule within the Load Balancer 
    Id_Lb             = "0"   #Id of the Load Balancer
    suffix_name       = "ssh" #MUST match the Lbs suffix_name
    lb_port           = "80"
    backend_port      = "80"
    probe_port        = "80"
    probe_protocol    = "Http"
    request_path      = "/"
    load_distribution = "Default"
  },
  {
    Id                = "2"   #Id of a the rule within the Load Balancer 
    Id_Lb             = "0"   #Id of the Load Balancer
    suffix_name       = "ssh" #MUST match the Lbs suffix_name
    lb_port           = "22"
    backend_port      = "22"
    probe_port        = "22"
    probe_protocol    = "Tcp"
    request_path      = ""
    load_distribution = "Default"
  },
  {
    Id                = "1"   #Id of a the rule within the Load Balancer 
    Id_Lb             = "1"   #Id of the Load Balancer
    suffix_name       = "gfs" #MUST match the Lbs suffix_name
    lb_port           = "22"
    backend_port      = "22"
    probe_port        = "22"
    probe_protocol    = "Tcp"
    request_path      = ""
    load_distribution = "Default"
  },
  {
    Id                = "1"   #Id of a the rule within the Load Balancer 
    Id_Lb             = "2"   #Id of the Load Balancer
    suffix_name       = "rds" #MUST match the Lbs suffix_name
    lb_port           = "3389"
    backend_port      = "3389"
    probe_port        = "3389"
    probe_protocol    = "Tcp"
    request_path      = ""
    load_distribution = "Default"
  },
]

linux_storage_image_reference = {
  publisher = "Canonical"
  offer     = "UbuntuServer"
  sku       = "18.04-LTS"
  version   = "Latest"
}

vms = [
  {
    suffix_name              = "rdg"             #(Mandatory) suffix of the vm
    id                       = "1"               #(Mandatory) Id of the VM
    os_type                  = "windows"         #(Mandatory) Support "linux" or "windows"
    storage_data_disks       = []                #(Mandatory) For no data disks set []
    subnet_iteration         = "0"               #(Mandatory) Id of the Subnet
    security_group_iteration = "1"               #(Optional) Id of the Network Security Group
    static_ip                = "198.18.2.228"    #(Optional) Set null to get dynamic IP or delete this line
    zones                    = ["1"]             #Availability Zone id, could be 1, 2 or 3, if you don't need to set it to "", WARNING you could not have Availabilitysets and AvailabilityZones
    vm_size                  = "Standard_DS1_v2" #(Mandatory) 
    managed_disk_type        = "Premium_LRS"     #(Mandatory) 
  },
  {
    suffix_name              = "rdg"             #(Mandatory) suffix of the vm
    id                       = "2"               #(Mandatory) Id of the VM
    os_type                  = "windows"         #(Mandatory) Support "linux" or "windows"
    storage_data_disks       = []                #(Mandatory) For no data disks set []
    subnet_iteration         = "1"               #(Mandatory) Id of the Subnet
    security_group_iteration = "1"               #(Optional) Id of the Network Security Group
    static_ip                = "198.18.2.244"    #(Optional) Set null to get dynamic IP or delete this line
    zones                    = ["2"]             #Availability Zone id, could be 1, 2 or 3, if you don't need to set it to "", WARNING you could not have Availabilitysets and AvailabilityZones
    vm_size                  = "Standard_DS1_v2" #(Mandatory) 
    managed_disk_type        = "Premium_LRS"     #(Mandatory) 
  },
  {
    suffix_name = "ssh"   #(Mandatory) suffix of the vm
    id          = "1"     #(Mandatory) Id of the VM
    os_type     = "linux" #(Mandatory) Support "linux" or "windows"
    storage_data_disks = [
      {
        id                = "1" #Disk id
        lun               = "0"
        disk_size_gb      = "32"
        managed_disk_type = "Premium_LRS"
        caching           = "ReadWrite"
        create_option     = "Empty"
      },
    ]                                                   #(Mandatory) For no data disks set []
    internal_lb_iteration    = "0"                      #(Optional) Id of the Internal Load Balancer, set to null or delete the line if there is no Load Balancer
    subnet_iteration         = "0"                      #(Mandatory) Id of the Subnet
    security_group_iteration = "1"                      #(Optional) Id of the Network Security Group
    static_ip                = "198.18.2.229"           #(Optional) Set null to get dynamic IP or delete this line
    zones                    = ["1"]                    #Availability Zone id, could be 1, 2 or 3, if you don't need to set it to "", WARNING you could not have Availabilitysets and AvailabilityZones
    BackupPolicyName         = "BackupPolicy-Schedule1" #(Optional) Set null to disable backup (WARNING, this will delete previous backup) otherwise set a backup policy like BackupPolicy-Schedule1
    vm_size                  = "Standard_DS1_v2"        #(Mandatory) 
    managed_disk_type        = "Premium_LRS"            #(Mandatory) 
  },
  {
    suffix_name              = "ssh"                    #(Mandatory) suffix of the vm
    id                       = "2"                      #(Mandatory) Id of the VM
    os_type                  = "linux"                  #(Mandatory) Support "linux" or "windows"
    storage_data_disks       = []                       #(Mandatory) For no data disks set []
    internal_lb_iteration    = "0"                      #(Optional) Id of the Internal Load Balancer, set to null or delete the line if there is no Load Balancer
    subnet_iteration         = "1"                      #(Mandatory) Id of the Subnet
    security_group_iteration = "1"                      #(Optional) Id of the Network Security Group
    static_ip                = "198.18.2.245"           #(Optional) Set null to get dynamic IP or delete this line
    zones                    = ["2"]                    #Availability Zone id, could be 1, 2 or 3, if you don't need to set it to "", WARNING you could not have Availabilitysets and AvailabilityZones
    BackupPolicyName         = "BackupPolicy-Schedule1" #(Optional) Set null to disable backup (WARNING, this will delete previous backup) otherwise set a backup policy like BackupPolicy-Schedule1
    vm_size                  = "Standard_DS1_v2"        #(Mandatory) 
    managed_disk_type        = "Premium_LRS"            #(Mandatory) 
  },
]

windows_storage_image_reference = {
  publisher = "MicrosoftWindowsServer"
  offer     = "WindowsServer"
  sku       = "2019-Datacenter"
  version   = "Latest"
}

## Infra common services
#Automation account
auto_sku = "Basic"
