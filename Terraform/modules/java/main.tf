resource "google_service_account" "coldstart-java" {
    account_id = "coldstart-java"
    display_name = "Coldstart Java"
    description = "Service account to run the Coldstart Java application"
    project = var.project_id
}

# read and write to firestore
resource "google_project_iam_member" "coldstart-java-access" {
    project = var.project_id
    role = "roles/datastore.user"
    member = "serviceAccount:${google_service_account.coldstart-java.email}"
}

# cloudbuild trigger
resource "google_cloudbuild_trigger" "build-coldstart-java" {
    name = "build-coldstart-java"
    description = "Trigger to build the Coldstart Java application"
    trigger_template {
        repo_name = var.code_repo_name
        dir = "Java/java-app"
        tag_name = "^coldstart-java-.*$"
    }
    project = var.project_id

    filename = "Java/java-app/cloudbuild.yaml"

    depends_on = [var.build_api]
}

# deploy to cloud run
resource "google_cloud_run_service" "coldstart-java" {
    name = "coldstart-java"
    project = var.project_id
    location = var.region
    template {
        spec {
            service_account_name = google_service_account.coldstart-java.account_id
            containers {
                image = "gcr.io/${var.project_id}/coldstart-java:${var.tag}"
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
        members = [
            "allUsers"
        ]
    }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
    location    = google_cloud_run_service.coldstart-java.location
    project     = google_cloud_run_service.coldstart-java.project
    service     = google_cloud_run_service.coldstart-java.name

    policy_data = data.google_iam_policy.noauth.policy_data
}