<!-- 
 Copyright (c) 2020 Intel Corporation

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
-->

# Unmanaged Racks Plugin (URP) 

This folder contains implementation of URP for Resource Aggregator for ODIM. 
The plugin exposes narrowed obligatory REST APIs described by *[Redfish Plugin Developer's Readme](https://github.com/ODIM-Project/ODIM/blob/development/plugin-redfish/README.md)*.
In addition, URP exposes following REST endpoints:

* `GET` on `/ODIM/v1/Chassis`—Returns collection of unmanaged Chassis (RackGroups/Racks)
* `GET` on `/ODIM/v1/Chassis/{id}`—Returns instance of unmanaged Chassis (RackGroups/Racks)
* `POST` on `/ODIM/v1/Chassis`—Creates new unmanaged Chassis (RackGroups/Racks) 
* `DELETE` on `/ODIM/v1/Chassis/{id}` —Deletes existing unmanaged Chassis (RackGroups/Racks)
* `PATCH` on `/ODIM/v1/Chassis/{id}` —Updates existing unmanaged Chassis (RackGroups/Racks)

Full specification of URP is available at https://wiki.odim.io/display/HOME/Plugin+for+Unmanaged+Racks.

> **NOTE**: This plugin is still under development, and some features might be missing.



## URP deployment 

For deploying URP and adding the plugin to the Resource Aggregator for ODIM framework, see the *Deploying the Unmanaged Rack Plugin* section in *[Resource Aggregator for Open Distributed Infrastructure Management™ Getting Started Readme](https://github.com/ODIM-Project/ODIM/blob/development/README.md)*.



## Create rack group

For instructions, see the *Creating a rack group* section in *[Resource Aggregator for Open Distributed Infrastructure Management™ API Reference Readme](https://github.com/ODIM-Project/ODIM/blob/development/docs/README.md)*.



## Create rack

For instructions, see the *Creating a rack* section in *[Resource Aggregator for Open Distributed Infrastructure Management™ API Reference Readme](https://github.com/ODIM-Project/ODIM/blob/development/docs/README.md)*.



## Attach selected Chassis under Rack
For instructions, see the *Attaching chassis to a rack* section in *[Resource Aggregator for Open Distributed Infrastructure Management™ API Reference Readme](https://github.com/ODIM-Project/ODIM/blob/development/docs/README.md)*.



## Detach Chassis from Rack

For instructions, see the *Detaching chassis from a rack* section in *[Resource Aggregator for Open Distributed Infrastructure Management™ API Reference Readme](https://github.com/ODIM-Project/ODIM/blob/development/docs/README.md)*.



## Delete Rack

For instructions, see the *Deleting a rack* section in *[Resource Aggregator for Open Distributed Infrastructure Management™ API Reference Readme](https://github.com/ODIM-Project/ODIM/blob/development/docs/README.md)*.



## Delete RackGroup

For instructions, see the *Deleting a rack group* section in *[Resource Aggregator for Open Distributed Infrastructure Management™ API Reference Readme](https://github.com/ODIM-Project/ODIM/blob/development/docs/README.md)*.