/**
 * Copyright 2020 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "project_id" {
  type        = string
  description = "The project id to deploy Github Runner"
}

variable "region" {
  type        = string
  description = "The GCP region to deploy instances into"
  default     = "us-east4"
}

variable "network_name" {
  type        = string
  description = "Name for the VPC network"
  default     = "gh-runner-network"
}

variable "create_network" {
  type        = bool
  description = "When set to true, VPC,router and NAT will be auto created"
  default     = true
}

variable "subnetwork_project" {
  type        = string
  description = "The ID of the project in which the subnetwork belongs. If it is not provided, the project_id is used."
  default     = ""
}

variable "subnet_ip" {
  type        = string
  description = "IP range for the subnet"
  default     = "10.10.10.0/24"
}

variable "subnet_name" {
  type        = string
  description = "Name for the subnet"
  default     = "gh-runner-subnet"
}

variable "subnet_enable_flow_logs" {
  type        = bool
  description = "When set to true, flow logs will be enabled for the subnet"
  default     = false
}

variable "subnet_flow_logs_aggregation_interval" {
  type        = string
  description = "Can only be specified if subnet_enable_flow_logs is true. Toggles the aggregation interval for collecting flow logs."
  default     = "INTERVAL_5_SEC"

  validation {
    condition     = contains(["INTERVAL_5_SEC", "INTERVAL_30_SEC", "INTERVAL_1_MIN", "INTERVAL_5_MIN", "INTERVAL_10_MIN", "INTERVAL_15_MIN"], var.subnet_flow_logs_aggregation_interval)
    error_message = "Must be either \"INTERVAL_5_SEC\", \"INTERVAL_30_SEC\", \"INTERVAL_1_MIN\", \"INTERVAL_5_MIN\", \"INTERVAL_10_MIN\", or \"INTERVAL_15_MIN\"."
  }
}

variable "subnet_flow_logs_flow_sampling" {
  type        = number
  description = "Can only be specified if subnet_enable_flow_logs is true. Sets the sampling rate of VPC flow logs within the subnetwork."
  default     = 0.5

  validation {
    condition     = var.subnet_flow_logs_flow_sampling > 0 && var.subnet_flow_logs_flow_sampling <= 1
    error_message = "Must be in the range (0, 1]."
  }
}

variable "subnet_flow_logs_metadata" {
  type        = string
  description = "Can only be specified if subnet_enable_flow_logs is true. Configures whether metadata fields should be added to the reported VPC flow logs."
  default     = "INCLUDE_ALL_METADATA"

  validation {
    condition     = contains(["EXCLUDE_ALL_METADATA", "INCLUDE_ALL_METADATA", "CUSTOM_METADATA"], var.subnet_flow_logs_metadata)
    error_message = "Must be either \"EXCLUDE_ALL_METADATA\", \"INCLUDE_ALL_METADATA\", or \"CUSTOM_METADATA\"."
  }
}

variable "subnet_flow_logs_metadata_fields" {
  type        = list(string)
  description = "Can only be specified if subnet_enable_flow_logs is true and subnet_flow_logs_metadata is set to CUSTOM_METADATA. List of metadata fields that should be added to reported logs."
  default     = []
}

variable "subnet_flow_logs_filter_expr" {
  type        = string
  description = "Can only be specified if subnet_enable_flow_logs is true. Export filter used to define which VPC flow logs should be logged, as an CEL expression."
  default     = "true"
}

variable "restart_policy" {
  type        = string
  description = "The desired Docker restart policy for the runner image"
  default     = "Always"
}

variable "image" {
  type        = string
  description = "The github runner image"
}

variable "repo_url" {
  type        = string
  description = "Repo URL for the Github Action"
}

variable "repo_name" {
  type        = string
  description = "Name of the repo for the Github Action"
}

variable "repo_owner" {
  type        = string
  description = "Owner of the repo for the Github Action"
}

variable "gh_token" {
  type        = string
  description = "Github token that is used for generating Self Hosted Runner Token"
}

variable "instance_name" {
  type        = string
  description = "The gce instance name"
  default     = "gh-runner"
}

variable "target_size" {
  type        = number
  description = "The number of runner instances"
  default     = 2
}

variable "service_account" {
  description = "Service account email address"
  type        = string
  default     = ""
}

variable "machine_type" {
  type        = string
  description = "The GCP machine type to deploy"
  default     = "n1-standard-1"
}

variable "source_image_family" {
  type        = string
  description = "Source image family. If neither source_image nor source_image_family is specified, defaults to the latest public Ubuntu image."
  default     = "cos-stable"

  validation {
    condition     = startswith(var.source_image_family, "cos-")
    error_message = "Must start with \"cos-\"."
  }
}

variable "additional_metadata" {
  type        = map(any)
  description = "Additional metadata to attach to the instance"
  default     = {}
}

variable "dind" {
  type        = bool
  description = "Flag to determine whether to expose dockersock "
  default     = false
}

variable "cooldown_period" {
  description = "The number of seconds that the autoscaler should wait before it starts collecting information from a new instance."
  type        = number
  default     = 60
}
