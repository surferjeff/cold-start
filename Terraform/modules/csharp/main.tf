resource "google_service_account" "coldstart-csharp" {
    account_id = "coldstart-csharp"
    display_name = "Coldstart C#"
    description = "Service account to run the Coldstart C# application"
    project = var.project_id
}

# read and write to firestore
resource "google_project_iam_member" "coldstart-csharp-access" {
    project = var.project_id
    role = "roles/datastore.user"
    member = "serviceAccount:${google_service_account.coldstart-csharp.email}"
}

# cloudbuild trigger
resource "google_cloudbuild_trigger" "build-coldstart-csharp" {
    name = "build-coldstart-csharp"
    description = "Trigger to build the Coldstart C# application"
    trigger_template {
        repo_name = var.code_repo_name
        dir = "CSharp/App"
        tag_name = "^coldstart-csharp-.*$"
    }
    project = var.project_id

    filename = "CSharp/App/cloudbuild.yaml"

    depends_on = [var.build_api]
}

# deploy to cloud run
resource "google_cloud_run_service" "coldstart-csharp" {
    name = "coldstart-csharp"
    project = var.project_id
    location = var.region
    template {
        spec {
            service_account_name = google_service_account.coldstart-csharp.account_id
            containers {
                image = "gcr.io/${var.project_id}/coldstart-csharp:${var.tag}"
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
    location    = google_cloud_run_service.coldstart-csharp.location
    project     = google_cloud_run_service.coldstart-csharp.project
    service     = google_cloud_run_service.coldstart-csharp.name

    policy_data = data.google_iam_policy.noauth.policy_data
}