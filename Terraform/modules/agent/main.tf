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

# scheduler
resource "google_cloud_scheduler_job" "coldstart-agent" {
    name        = "coldstart-agent"
    description = "Scheduler to run the Coldstart Agent application every 30 minutes"
    schedule   = "*/30 * * * *"
    time_zone  = "America/Los_Angeles"
    
    http_target {
        http_method = "GET"
        uri = "${google_cloud_run_service.coldstart-agent.status[0].url}/query_firestore"

        oidc_token {
            service_account_email = google_service_account.coldstart-agent.email
        }
    }

    project = var.project_id
    region = var.region

    depends_on = [ google_project_service.cloudscheduler ]
}

resource "google_project_service" "cloudscheduler" {
    service = "cloudscheduler.googleapis.com"
    project = var.project_id

    disable_on_destroy = false
}

output "url" {
    value = "${google_cloud_run_service.coldstart-agent.status[0].url}/query_firestore"
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