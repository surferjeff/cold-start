resource "google_service_account" "coldstart-go" {
    account_id = "coldstart-go"
    display_name = "Coldstart Go"
    description = "Service account to run the Coldstart Go application"
    project = var.project_id
}

# read and write to firestore
resource "google_project_iam_member" "coldstart-go-access" {
    project = var.project_id
    role = "roles/datastore.user"
    member = "serviceAccount:${google_service_account.coldstart-go.email}"
}

# cloudbuild trigger
resource "google_cloudbuild_trigger" "build-coldstart-go" {
    name = "build-coldstart-go"
    description = "Trigger to build the Coldstart Go application"
    trigger_template {
        repo_name = var.code_repo_name
        dir = "Go"
        tag_name = "^coldstart-go-.*$"
    }
    project = var.project_id

    filename = "Go/cloudbuild.yaml"

    depends_on = [var.build_api]
}

# deploy to cloud run
resource "google_cloud_run_service" "coldstart-go" {
    name = "coldstart-go"
    project = var.project_id
    location = var.region
    template {
        spec {
            service_account_name = google_service_account.coldstart-go.account_id
            containers {
                image = "gcr.io/${var.project_id}/coldstart-go:${var.tag}"
            }
        }

        metadata {
            annotations = {
                "autoscaling.knative.dev/maxScale" = 1
            }
            labels = {
              "run.googleapis.com/startupProbeType" = "Default"
            }
        }
    }

    traffic {
        percent = 100
        latest_revision = true
    }

    depends_on = [var.run_api]
}

data "google_iam_policy" "noauth" {
    binding {
        role = "roles/run.invoker"
        members = ["allUsers"]
    }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
    location = google_cloud_run_service.coldstart-go.location
    project = google_cloud_run_service.coldstart-go.project
    service = google_cloud_run_service.coldstart-go.name
    policy_data = data.google_iam_policy.noauth.policy_data
}