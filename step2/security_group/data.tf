data "terraform_remote_state" "vpc_data" {
    backend = "local"
    config = {
        path = "${path.module}/../vpc/terraform.tfstate"
    }
}
