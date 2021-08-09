[![build_deploy_test Actions Status](https://github.com/ODIM-Project/ODIM/workflows/build_deploy_test/badge.svg)](https://github.com/ODIM-Project/ODIM/actions)
[![build_unittest Actions Status](https://github.com/ODIM-Project/ODIM/workflows/build_unittest/badge.svg)](https://github.com/ODIM-Project/ODIM/actions)



# Introduction

Today, organizations are highly dependent on the manageability of their converged infrastructure, especially as they move towards increasingly complex environments that include multiple remote servers, data storage devices, networking equipment, third-party applications and so on. 

Resource Aggregator for Open Distributed Infrastructure Management \(ODIM™\) is a modular, open framework for centralized management and simplified orchestration of your distributed physical IT infrastructure.

## About the document

This document helps you troubleshoot any common issues you might experience while deploying and using Resource Aggregator for ODIM. Along with this document, Resource Aggregator for ODIM is shipped with the following comprehensive set of electronic documentation:

- **Resource Aggregator for ODIM Getting Started Readme** — This document mainly provides instructions for deploying Resource Aggregator for ODIM and the supported plugins, and covers few typical product use cases.
- **Resource Aggregator for ODIM API Readme** — This document provides detailed information on all the supported APIs of Resource Aggregator for ODIM.

# Troubleshooting Information

This section covers issues you might experience while deploying or using Resource Aggregator for ODIM, and provides suggestions for resolving these issues. You will also find answers to some of the Frequently Asked Questions.

| Symptom/Question                                             | Possible cause/Recommendation                                |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| When you run `getent passwd <User ID>`, you get the following output:<br />`$ odimra: x:<User ID>:<User ID>::/home/odimra:/bin/bash` | The User ID in the configuration file already exists. <br />Use a unique User ID. |
| When you run `getent group <Group ID>`, you get the following output:<br />`$ odimra:x:2021:` | The Group ID in the configuration file already exists. <br />Use a unique Group ID. |
| The docker start fails with the following error during Kubernetes deployment:<br />`Error log found in journalctl -u docker:`<br />`unable to configure the Docker daemon with file /etc/docker/daemon.json: the following directives are specified both as a flag and in the configuration file: log-opts: (from flag: map[max-file:5 [max-size:50m](http://max-size:50m/)], from file: map[[max-size:100m](http://max-size:100m/)])` | 1. Create a file `/etc/systemd/system/docker.service.d/docker.conf ` and add the following content in it:<br />`$ [Service]`<br />`ExecStart=`<br />`ExecStart=/usr/bin/dockerd`<br />2. Reset and deploy Kubernetes again.<br /><br />Reference links to the issue:<br/>https://docs.docker.com/config/daemon/#troubleshoot-conflicts-between-the-daemonjson-and-startup-scripts<br/>https://docs.docker.com/config/daemon/#use-the-hosts-key-in-daemonjson-with-systemd |
| You get `500 Internal Server Error` or `503 Service Unavailable Error` upon sending HTTP requests | 1. Run the following command on the master node to verify all deployed services are running successfully:<br />`$ kubectl get pods -n odim -o wide`<br />2. Use the same command to check on which node the Resource Aggregator for ODIM service is deployed.<br />3. Navigate to the log path configured on that node to view the service log file.<br /><br />Your server encounters unexpected conditions that can prevent it from fulfilling requests due to temporary overloading, session timeout or any unforeseen reasons.<br /> |

## Other Frequently Asked Questions

**1. Which parameters in the `kube_deploy_nodes.yaml ` file are immutable after deployment?**

<blockquote> Caution: Do NOT modify the private key "odimra_rsa.private" and the public key "odimra_rsa.public". If modified, it will result in service non-recoverable data loss, unless backup of the keys are present. </blockquote>

- appsLogPath
- consulConfPath
- consulDataPath
- groupID
- haDeploymentEnabled
- hostIP
- hostname
- kafkaConfPath
- kafkaDataPath
- namespace
- pluginHelmChartsPath
- redisInmemoryDataPath
- redisOndiskDataPath
- rootServiceUUID
- userID
- zookeeperConfPath
- zookeeperDataPath

------

**2. What is the recommended value for replica count for each Resource Aggregator for ODIM service?**

For a single node deployment, recommended value is 1. 
For multi-node cluster deployment, count can be set to 1 or desired value (verified value is 3).

------

**3. How do I change the node's sudo password, which is persisted often?**

1. Delete the following file:
   `<odim-controller-cloned-path>/kubespray/inventory/k8s-cluster-<deploymentID>/.sudo_pw`. 
2. After the deletion, when you invoke odim-controller for any operation on the cluster, you are prompted to type a new password.

------

**4. How do I enable `kubectl` usage without the `sudo` command?**

Run the following commands:

```
$  -p $HOME/.kube
```

```
$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
```

```
$ sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

------

**5. How do I enable docker CLI usage without the `sudo` command?**

Run `sudo usermod -aG docker $USER`

------

**6. How do I check the logs of third party services (Kafka, Zookeeper, Redis, Consul)?**

1. On the master node, run the following command to get the name of the pod:

   ```
   $ kubectl get pods -n odim -o wide
   ```

2. Run the following command to tail the logs:
   
   ```
   $ kubectl logs -n odim -f <pod_name>
   ```
   

------

