resource "google_service_account" "coldstart-nodejs" {
    account_id = "coldstart-nodejs"
    display_name = "Coldstart Node.js"
    description = "Service account to run the Coldstart Node.js application"
    project = var.project_id
}

# read and write to firestore
resource "google_project_iam_member" "coldstart-nodejs-access" {
    project = var.project_id
    role = "roles/datastore.user"
    member = "serviceAccount:${google_service_account.coldstart-nodejs.email}"
}

# cloudbuild trigger
resource "google_cloudbuild_trigger" "build-coldstart-nodejs" {
    name = "build-coldstart-nodejs"
    description = "Trigger to build the Coldstart Node.js application"
    trigger_template {
        repo_name = var.code_repo_name
        dir = "NodeJS"
        tag_name = "^coldstart-nodejs-.*$"
    }
    project = var.project_id

    filename = "NodeJS/cloudbuild.yaml"

    depends_on = [var.build_api]
}

# deploy to cloud run
resource "google_cloud_run_service" "coldstart-nodejs" {
    name = "coldstart-nodejs"
    project = var.project_id
    location = var.region
    template {
        spec {
            service_account_name = google_service_account.coldstart-nodejs.account_id
            containers {
                image = "gcr.io/${var.project_id}/coldstart-nodejs:${var.tag}"
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
    location = google_cloud_run_service.coldstart-nodejs.location
    project = google_cloud_run_service.coldstart-nodejs.project
    service = google_cloud_run_service.coldstart-nodejs.name

    policy_data = data.google_iam_policy.noauth.policy_data
}