#!/bin/bash

#(C) Copyright [2020] Hewlett Packard Enterprise Development LP
#
#Licensed under the Apache License, Version 2.0 (the "License"); you may
#not use this file except in compliance with the License. You may obtain
#a copy of the License at
#
#    http:#www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#License for the specific language governing permissions and limitations
# under the License.

ETCD_USR_ID=1125
ETCD_GRP_ID=1125

# perform pre-requisites required for creating etcd docker image
etcd_pre_reqs()
{
	if [[ -n "$(getent passwd etcd 2>&1)" ]]; then
		echo "[$(date)] -- INFO  -- user etcd exists"
		sudo userdel etcd
	fi
	if [[ -n "$(getent group etcd 2>&1)" ]]; then
		echo "[$(date)] -- INFO  -- group etcd exists"
		sudo groupdel etcd
	fi
	sudo groupadd -g ${ETCD_GRP_ID} -r etcd
	sudo useradd -u ${ETCD_USR_ID} -r -M -g etcd etcd
}

##############################################
###############  MAIN  #######################
##############################################

etcd_pre_reqs
