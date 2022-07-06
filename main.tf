terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
  
   backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "bckt345"
    region     = "ru-central1-a"
    key        = "issue1/lemp.tfstate"
    access_key = "YCAJETrJcvWQXgbC1mpqkeMaJ"
    secret_key = "YCMltHkz6Q6nRD47esCJMIEqxqaNUwFKpTBfuM7F"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
  
}

provider "yandex" {
  token = "AQAAAABde8_HAATuwZGUNSHTz0xCiC097dNWpuE"
  cloud_id                 = "b1gl0ubjulr2bvmjjps3"
  folder_id                = var.folder_id
}

resource "yandex_vpc_network" "network" {
  name = "network"
}

resource "yandex_vpc_subnet" "subnet1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_vpc_subnet" "subnet2" {
  name           = "subnet2"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.11.0/24"]
}


module "ya_instance_1" {
  source                = "./modules/instance"
  netw_zone = "ru-central1-a"
  instance_family_image = "lemp"
  vpc_subnet_id         = yandex_vpc_subnet.subnet1.id
}

module "ya_instance_2" {
  source                = "./modules/instance"
  netw_zone = "ru-central1-b"
  instance_family_image = "lamp"
  vpc_subnet_id         = yandex_vpc_subnet.subnet2.id
}

resource "yandex_lb_target_group" "group1" {
name      = "group1"
target {
    subnet_id = "e9bns5hakjkn11d78opa"
    address = module.ya_instance_1.internal_ip_address_vm
}
target {
    subnet_id = "e2llobvh6id5ghp98lu1"
    address = module.ya_instance_2.internal_ip_address_vm
}
}

resource "yandex_lb_network_load_balancer" "external-lb-test" {
  name = "external-lb-test"
  type = "internal"

  listener {
    name = "my-listener1"
    port = 8080
    internal_address_spec {
    subnet_id = yandex_lb_target_group.group1.id
    }
  }
}
