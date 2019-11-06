/**
 * Copyright 2019 Google LLC
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

locals {
  local_network_name = element(reverse(split("/", var.local_network)), 0)
  peer_network_name  = element(reverse(split("/", var.peer_network)), 0)
}

resource "google_compute_network_peering" "local_network_peering" {
  provider             = "google-beta"
  name                 = "${var.prefix}-${local.local_network_name}-${local.peer_network_name}"
  network              = var.local_network
  peer_network         = var.peer_network
  export_custom_routes = var.exchange_custom_routes_to_peer
  import_custom_routes = var.exchange_custom_routes_to_local
}

resource "google_compute_network_peering" "peer_network_peering" {
  provider             = "google-beta"
  name                 = "${var.prefix}-${local.peer_network_name}-${local.local_network_name}"
  network              = var.peer_network
  peer_network         = var.local_network
  export_custom_routes = var.exchange_custom_routes_to_local
  import_custom_routes = var.exchange_custom_routes_to_peer

  depends_on = ["google_compute_network_peering.local_network_peering"]
}
