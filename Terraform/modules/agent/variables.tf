variable "project_id" {
    description = "the name of the project"
    type = string
}

variable "region" {
    description = "The default compute region"
    type = string
}

variable "code_repo_name" {
    description = "The name of the code repository"
    type = string
}

variable "build_api" {
    description = "The resource that turns on the Cloud Build API"
}

variable "run_api" {
    description = "The resource that turns on the Cloud Run API"
}

variable "tag" {
    description = "docker image tag"
}