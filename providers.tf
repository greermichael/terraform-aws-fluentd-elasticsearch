provider "helm" {
  alias           = "logging"
  install_tiller  = false
  service_account = "${var.tiller_service_account}"

  kubernetes {
    config_context = "${var.config_context}"
  }
}
