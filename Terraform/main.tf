provider "google" {
    project = var.project_id
    region  = var.region
    zone = var.zone
}

############################################
# enable APIs
resource "google_project_service" "run_api" {
    service = "run.googleapis.com"
    project = var.project_id

    disable_on_destroy = false
}

resource "google_project_service" "pubsub_api" {
  service = "pubsub.googleapis.com"
  project = var.project_id

  disable_on_destroy = false
}

resource "google_project_service" "storage_api" {
  service = "storage.googleapis.com"
  project = var.project_id

  disable_on_destroy = false
}

resource "google_project_service" "build_api" {
  service = "cloudbuild.googleapis.com"
  project = var.project_id

  disable_on_destroy = false
}

resource "google_project_service" "kms_api" {
  service = "cloudkms.googleapis.com"
  project = var.project_id

  disable_on_destroy = false
}

resource "google_project_service" "sourcerepo_api" {
  service = "sourcerepo.googleapis.com"
  project = var.project_id

  disable_on_destroy = false
}

resource "google_project_service" "secretmanager_api" {
  service = "secretmanager.googleapis.com"
  project = var.project_id

  disable_on_destroy = false
}

resource "google_project_service" "google_cloud_firestore_api" {
  service = "firestore.googleapis.com"
  project = var.project_id

  disable_on_destroy = false
}

# resource "google_sourcerepo_repository" "cold_start" {
#   name = "cold-start"
#   project = var.project_id
# }

############################################
# create global service accounts
resource "google_service_account" "cloud_run_invoker" {
    account_id = "cloud-run-invoker"
    display_name = "Cloud Run Invoker"
    description = "used by cloud run invoker"
    project = var.project_id
}

resource "google_project_iam_member" "cloud_run_invoker" {
    project = var.project_id
    role = "roles/run.invoker"
    member = "serviceAccount:${google_service_account.cloud_run_invoker.email}"
}

############################################
# instantiate modules
# run with terraform plan -out tf.plan -var-file=gcp-coldstart-state.tfvars

module "python" {
    source         = "./modules/python"
    project_id     = var.project_id
    region         = var.region
    code_repo_name = "github_narusawa-taiga_cold-start"
    build_api      = google_project_service.build_api
    run_api        = google_project_service.run_api
    tag           = "coldstart-python-102"
}

module "csharp" {
    source         = "./modules/csharp"
    project_id     = var.project_id
    region         = var.region
    code_repo_name = "github_narusawa-taiga_cold-start"
    build_api      = google_project_service.build_api
    run_api        = google_project_service.run_api
    tag           = "coldstart-csharp-100"
}

module "java" {
    source         = "./modules/java"
    project_id     = var.project_id
    region         = var.region
    code_repo_name = "github_narusawa-taiga_cold-start"
    build_api      = google_project_service.build_api
    run_api        = google_project_service.run_api
    tag           = "coldstart-java-104"
}