resource "google_service_account" "coldstart-agent" {
    account_id = "coldstart-agent"
    display_name = "Coldstart Agent"
    description = "Service account to run the Coldstart Agent application"
    project = var.project_id
}

# cloudbuild trigger
resource "google_cloudbuild_trigger" "build-coldstart-agent" {
    name = "build-coldstart-agent"
    description = "Trigger to build the Coldstart Agent application"
    trigger_template {
        repo_name = var.code_repo_name
        dir = "Proctor"
        tag_name = "^coldstart-agent-.*$"
    }
    project = var.project_id

    filename = "Proctor/cloudbuild.yaml"

    depends_on = [var.build_api]
}

# deploy to cloud run
resource "google_cloud_run_service" "coldstart-agent" {
    name = "coldstart-agent"
    project = var.project_id
    location = var.region
    template {
        spec {
            service_account_name = google_service_account.coldstart-agent.account_id
            containers {
                image = "gcr.io/${var.project_id}/coldstart-agent:${var.tag}"
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
            "allUsers",
        ]
    }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
    location    = google_cloud_run_service.coldstart-agent.location
    project     = google_cloud_run_service.coldstart-agent.project
    service     = google_cloud_run_service.coldstart-agent.name
    policy_data = data.google_iam_policy.noauth.policy_data
}