terraform {
    backend "gcs" {
        bucket  = "coldstart-terraform-state"
        prefix  = "terraform/state"
    }
}

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

module "python" {
    source         = "./modules/python"
    project_id     = var.project_id
    region         = var.region
    code_repo_name = google_sourcerepo_repository.github_rennieglen_code_repo.name
    build_api      = google_project_service.build_api
    run_api        = google_project_service.run_api
    tag           = "coldstart_python_1.00"
}

