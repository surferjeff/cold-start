resource "google_service_account" "coldstart-python" {
    account_id = "coldstart-python"
    display_name = "Coldstart Python"
    description = "Service account to run the Coldstart Python application"
    project = var.project_id
}


# read and write to firestore
resource "google_project_iam_member" "coldstart-python-access" {
    project = var.project_id
    role = "roles/datastore.user"
    member = "serviceAccount:${google_service_account.coldstart-python.email}"
}

# cloudbuild trigger
resource "google_cloudbuild_trigger" "build-coldstart-python" {
    name = "build-coldstart-python"
    description = "Trigger to build the Coldstart Python application"
    trigger_template {
        repo_name = var.code_repo_name
        dir = "Python"
        tag_name = "^coldstart-python-.*$"
    }
    project = var.project_id

    filename = "Python/cloudbuild.yaml"

    depends_on = [var.build_api]
}

# deploy to cloud run
# resource "google_cloud_run_service" "coldstart-python" {
#     name = "coldstart-python"
#     project = var.project_id
#     location = var.region
#     template {
#         spec {
#             service_account_name = google_service_account.coldstart-python.account_id
#             containers {
#                 image = "gcr.io/${var.project_id}/coldstart-python:${var.tag}"
#                 env {
#                     name = "DRY_RUN"
#                     value = "no"
#                 }
#             }
#         }

#         metadata {
#             annotations = {
#                 "autoscaling.knative.dev/maxScale" = 1
#             }
#             labels = {
#               "run.googleapis.com/startupProbeType" = "Default"
#             }
#         }
#     }

#     traffic {
#         percent = 100
#         latest_revision = true
#     }

#     depends_on = [var.run_api]
# }