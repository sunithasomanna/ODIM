# Table of contents

- [Deploying the Lenovo plugin](#deploying-the-lenovo-plugin)
- [Adding a plugin into the Resource Aggregator for ODIM framework](#adding-a-plugin-into-the-resource-aggregator-for-odim-framework)
- [Configuring proxy server for a plugin version](#configuring-proxy-server-for-a-plugin-version)
- [Plugin configuration parameters](#plugin-configuration-parameters)

## Deploying the Lenovo plugin

**Prerequisites**

Kubernetes cluster is set up and the resource aggregator is successfully deployed.

1. Create a directory called `plugins` on the deployment node.

   ```
   $ mkdir plugins
   ```

2. In the `plugins` directory, create a directory called `lenovoplugin`.

   ```
   $ mkdir ~/plugins/lenovoplugin
   ```

3. Log in to each cluster node and run the following commands: 

   ```
   $ sudo mkdir -p /var/log/lenovoplugin_logs/
   ```

   ```
   $ sudo chown odimra:odimra /var/log/lenovoplugin_logs
   ```

4. On the deployment node, copy the Lenovo plugin configuration file to `~/plugins/lenovoplugin`:

   ```
   $ cp ~/ODIM/odim-controller/helmcharts/lenovoplugin/lenovoplugin-config.yaml ~/plugins/lenovoplugin
   ```

5. Open the Lenovo plugin configuration YAML file. 

   ```
   $ vi ~/plugins/lenovoplugin/lenovoplugin-config.yaml
   ```

   **Sample lenovoplugin-config.yaml file:**

   ```
   odimra:
    namespace: odim
    groupID: 2021
   lenovoplugin:
    hostname: knode1
    eventListenerNodePort: 30089
    lenovoPluginRootServiceUUID: 7a38b735-8b9f-48a0-b3e7-e5a180567d37
    username: admin
    password: sTfTyTZFvNj5zU5Tt0TfyDYU-ye3_ZqTMnMIj-LAeXaa8vCnBqq8Ga7zV6ZdfqQCdSAzmaO5AJxccD99UHLVlQ==
    lbHost: 10.24.1.232
    lbPort: 30089
    logPath: /var/log/lenovoplugin_logs
   
   ```

6. Update the following mandatory parameters in the plugin configuration file: 

   - **hostname**: Hostname of the cluster node where the Lenovo plugin will be installed.
   - **lbHost**: IP address of the cluster node where the Lenovo plugin will be installed.
   - **lbPort**: Default port is 30089.
   - **lenovoPluginRootServiceUUID**: RootServiceUUID to be used by the Lenovo plugin service.

   Other parameters can either be empty or have default values. Optionally, you can update them with values based on your requirements. For more information on each parameter, see [Plugin configuration parameters](#plugin-configuration-parameters).

7. Generate the Helm package for the Lenovo plugin on the deployment node.

   1. Navigate to `odim-controller/helmcharts/lenovoplugin`.

      ```
      $ cd ~/ODIM/odim-controller/helmcharts/lenovoplugin
      ```

   2. Run the following command to create `lenovoplugin` Helm package at `~/plugins/lenovoplugin`:

      ```
      $ helm package lenovoplugin -d ~/plugins/lenovoplugin
      ```

      The Helm package for the Lenovo plugin is created in the tgz format.

8. Save the Lenovo plugin Docker image on the deployment node at `~/plugins/lenovoplugin`.

   ```
    $ sudo docker save lenovoplugin:1.0 -o ~/plugins/lenovoplugin/lenovoplugin.tar
   ```

9. If it is a three-node cluster configuration, log in to each cluster node and [configure proxy server for the plugin](#configuring-proxy-server-for-a-plugin-version). 

   Skip this step if it is a one-node cluster configuration.

10. Navigate to the `/ODIM/odim-controller/scripts` directory on the deployment node.

    ```
     $ cd ~/ODIM/odim-controller/scripts
    ```

11. Run the following command to install the Lenovo plugin: 

    ```
    $ python3 odim-controller.py --config /home/${USER}/ODIM/odim-controller/scripts/kube_deploy_nodes.yaml --add plugin --plugin lenovo plugin
    ```

12. Run the following command on the cluster nodes to verify the Lenovo plugin pod is up and running: 

    `$ kubectl get pods -n odim`

    Example output of the Lenovo plugin pod details:

    | NAME                         | READY | STATUS  | RESTARTS | AGE   |
    | ---------------------------- | ----- | ------- | -------- | ----- |
    | lenovoplugin-5fc4b6788-2xx97 | 1/1   | Running | 0        | 4d22h |

13. Open the `kube_deploy_nodes.yaml` file by navigating to`~/ODIM/odim-controller/scripts`.

         $ vi kube_deploy_nodes.yaml

14. Update the following parameters in the `kube_deploy_nodes.yaml` file to their corresponding values: 

    | Parameter                    | Value                                                        |
    | ---------------------------- | ------------------------------------------------------------ |
    | connectionMethodConf         | The connection method associated with Lenovo: ConnectionMethodVariant: `Compute:BasicAuth:LENOVO_v1.0.0`<br> |
    | odimraKafkaClientCertFQDNSan | The FQDN to be included in the Kafka client certificate of Resource Aggregator for ODIM for deploying Lenovo plugin: `lenovoplugin`. |
    | odimraServerCertFQDNSan      | The FQDN to be included in the server certificate of Resource Aggregator for ODIM for deploying Lenovo: `lenovoplugin` . |
    | odimPluginPath               | The path of the directory where the Lenovo Helm package, the `lenovoplugin` image, and the modified `lenovoplugin-config.yaml` are copied. |

         Example:
         
         odimPluginPath: /home/bruce/plugins
          connectionMethodConf:
          - ConnectionMethodType: Redfish
            ConnectionMethodVariant: Compute:BasicAuth:LENOVO_v1.0.0
             odimraKafkaClientCertFQDNSan: lenovoplugin
             odimraServerCertFQDNSan: lenovoplugin

15. Run the following command: 

        $ python3 odim-controller.py --config /home/${USER}/ODIM/odim-controller/scripts/kube_deploy_nodes.yaml --upgrade odimra-config

16. [Add the Lenovo plugin into the Resource Aggregator for ODIM framework](#adding-a-plugin-into-the-resource-aggregator-for-odim-framework). 

## Adding a plugin into the Resource Aggregator for ODIM framework

After a plugin is successfully deployed, you must add the plugin into the Resource Aggregator for ODIM framework to access the plugin service.

**Prerequisites**

The plugin you want to add is successfully deployed.

1. To add a plugin, perform HTTP `POST` on the following URI: 

   `https://{odim_host}:{port}/redfish/v1/AggregationService/AggregationSources` 

   -   `{odim_host}` is the virtual IP address of the Kubernetes cluster.

   -   `{port}` is the API server port configured in Nginx. The default port is `30080`. If you have changed the default port, use that as the port.

   Provide a JSON request payload specifying:

   -   The plugin address \(the plugin name or hostname and the plugin port\)

   -   The username and password of the plugin user account

   -   A link to the connection method having the details of the plugin

   **Sample request payload for adding the Lenovo plugin:** 

   ```
   {
      "HostName":"lenovoplugin:45001",
      "UserName":"admin",
      "Password":"LenovoPlug!n12$4",
      "Links":{
              "ConnectionMethod": {
                "@odata.id": "/redfish/v1/AggregationService/ConnectionMethods/d172e66c-b4a8-437c-981b-1c07ddfeacaa"
            }
      }
   }
   ```

   **Request payload parameters** 

   | Parameter        | Type                    | Description                                                  |
   | ---------------- | ----------------------- | ------------------------------------------------------------ |
   | HostName         | String \(required\)<br> | It is the plugin service name and the port specified in the Kubernetes environment. For default plugin ports, see [Resource Aggregator for ODIM default ports](#resource-aggregator-for-odim-default-ports).<br>NOTE: If you are using a different port for a plugin, ensure that the port is greater than `45000`. |
   | UserName         | String \(required\)<br> | The plugin username. See default administrator account usernames of all the plugins in "Default plugin credentials".<br> |
   | Password         | String \(required\)<br> | The plugin password. See default administrator account passwords of all the plugins in "Default plugin credentials".<br> |
   | ConnectionMethod | Array \(required\)<br>  | Links to the connection methods that are used to communicate with this endpoint: `/redfish/v1/AggregationService/AggregationSources`.<br><blockquote>NOTE: Ensure that the connection method information for the plugin you want to add is updated in the odim-controller configuration file.<br></blockquote>To know which connection method to use, do the following:<br>    1.  Perform HTTP `GET` on: `/redfish/v1/AggregationService/ConnectionMethods`.<br>You will receive a list of links to available connection methods.<br>    2.  Perform HTTP `GET` on each link. Check the value of the `ConnectionMethodVariant` property in the JSON response. It displays the details of a plugin. Choose a connection method having the details of the plugin of your choice. For available connection method variants, see "Connection method variants" table.<br> |

   | Plugin        | Default username | Default password | Connection method variant       |
   | ------------- | ---------------- | ---------------- | ------------------------------- |
   | Lenovo plugin | admin            | LenovoPlug!n12$4 | Compute:BasicAuth:LENOVO_v1.0.0 |

   Use the following curl command to add the plugin:

   ```
   curl -i POST \
      -H 'Authorization:Basic {base64_encoded_string_of_<odim_username:odim_password>}' \
      -H "Content-Type:application/json" \
      -d \
   '{"HostName":"{plugin_host}:{port}",
     "UserName":"{plugin_userName}",
     "Password":"{plugin_password}", 
     "Links":{
         "ConnectionMethod": {
            "@odata.id": "/redfish/v1/AggregationService/ConnectionMethods/{ConnectionMethodId}"
         }
      }
   }' \
    'https://{odim_host}:30080/redfish/v1/AggregationService/AggregationSources' -k
   ```

   <blockquote>
       NOTE: To generate a base64 encoded string of `{odim_username:odim_password}`, run the following command:</blockquote>


   ```
   $ echo -n '{odim_username}:{odim_password}' | base64 -w0
   ```

   Replace `{base64_encoded_string_of_[odim_username:odim_password]}` with the generated base64 encoded string in the curl command. You will receive:

   - An HTTP `202 Accepted` status code.
   - A link to the task monitor associated with this operation in the response header.

   To know the status of this task, perform HTTP `GET` on the `taskmon` URI until the task is complete. If the plugin is added successfully, you will receive an HTTP `200 OK` status code.

   After the plugin is successfully added, it will also be available as a manager resource at:

      `/redfish/v1/Managers`.
   For more information, refer to "Adding a plugin" in the [Resource Aggregator for Open Distributed Infrastructure Management™ API Reference and User Guide](https://github.com/ODIM-Project/ODIM/tree/development/docs).

2. To verify that the added plugin is active and running, do the following: 

   1. To get the list of all available managers, perform HTTP `GET` on: 

      `/redfish/v1/Managers` 

      You will receive JSON response having a collection of links to the manager resources. You will see the following links in the collection:

      -   A link to the resource aggregator manager.

      -   Links to all the added plugin managers.

   2. To identify the plugin Id of the added plugin, perform HTTP `GET` on each manager link in the response. 

      The JSON response body for a plugin manager has `Name` as the plugin name.
      Example:
      The JSON response body for the Lenovo plugin manager has `Name` as `Lenovo`.

      **Sample response** 

      ```
      {
         "@odata.context":"/redfish/v1/$metadata#Manager.Manager",
         "@odata.etag":"W/\"AA6D42B0\"",
         "@odata.id":"/redfish/v1/Managers/536cee48-84b2-43dd-b6e2-2459ac0eeac6",
         "@odata.type":"#Manager.v1_3_3.Manager",
         "FirmwareVersion":"1.0",
         "Id":"a9cf0e1e-c36d-4d5b-9a31-cc07b611c01b",
         "ManagerType":"Service",
         "Name":"Lenovo",
         "Status":{
            "Health":"OK",
            "State":"Enabled"
         },
         "UUID":"a9cf0e1e-c36d-4d5b-9a31-cc07b611c01b"
      }
      ```

   3. Check in the JSON response of the plugin manager, if: 

      -    `State` is `Enabled` 

      -    `Health` is `Ok` 

      For more information, refer to "Managers" in [Resource Aggregator for Open Distributed Infrastructure Management™ API Reference and User Guide](https://github.com/ODIM-Project/ODIM/tree/development/docs).

## Configuring proxy server for a plugin version

1. Log in to each cluster node and navigate to the following path: 

   ```
   $ cd /opt/nginx/servers
   ```

2. Create a plugin configuration file called `<plugin-name>_nginx_server.conf`: 

   ```
   $ vi <plugin-name>_nginx_server.conf
   ```

   Example:

   ```
   $ vi lenovoplugin_nginx_server.conf
   ```

3. Copy the following content into the `<plugin-name>_nginx_server.conf` file on each cluster node: 

   ```
   upstream <plugin_name>  {
     server <k8s_self_node_IP>:<plugin_node_port> max_fails=2 fail_timeout=10s;
     server <k8s_node2_IP>:<plugin_node_port> max_fails=2 fail_timeout=10s backup;
     server <k8s_node3_IP>:<plugin_node_port> max_fails=2 fail_timeout=10s backup;
   }
    
   server {
           listen <k8s_self_node_IP>:<nginx_plugin_port> ssl;
           listen <VIP>:<nginx_plugin_port> ssl;
           server_name odim_proxy;
           ssl_session_timeout  5m;
           ssl_prefer_server_ciphers on;
           ssl_protocols TLSv1.2;
           ssl_certificate  /opt/nginx/certs/server.crt;
           ssl_certificate_key /opt/nginx/certs/server.key;
           ssl_trusted_certificate /opt/nginx/certs/rootCA.crt;
    
           location / {
                   proxy_pass https://<plugin_name>;
                   proxy_http_version 1.1;
                   proxy_set_header X-Forwarded-For $remote_addr;
                   proxy_pass_header Server;
                   proxy_ssl_protocols TLSv1.2;
                   proxy_ssl_certificate /opt/nginx/certs/server.crt;
                   proxy_ssl_certificate_key /opt/nginx/certs/server.key;
                   proxy_ssl_trusted_certificate /opt/nginx/certs/rootCA.crt;
           }
   }
   ```

   In this content, replace the following placeholders \(highlighted in bold\) with the actual values:

   | Placeholder                      | Description                                                  |
   | -------------------------------- | ------------------------------------------------------------ |
   | <plugin_name>                    | Name of the plugin. Example: "lenovoplugin"<br>              |
   | <k8s_self_node_IP>               | The physical IP address of the cluster node.                 |
   | <k8s_node2_IP><k8s_node3_IP><br> | The physical IP addresses of the other cluster nodes.        |
   | <plugin_node_port>               | The port specified for the eventListenerNodePort configuration parameter in the `<plugin_name>-config.yaml` file. |
   | <VIP>                            | Virtual IP address specified in the keepalived.conf file.    |
   | <nginx_plugin_port>              | Any free port on the cluster node. It must be available on all the other cluster nodes. Preferred port is above 45000.<br>Ensure that this port is not used as any other service port.<br>**NOTE**: You can reach the resource aggregator API server at:<br>`https://<VIP>:<nginx_api_port>`.<br> |

4. Restart Nginx systemd service only on the leader node \(cluster node where Keepalived priority is set to a higher number\): 

   ```
   $ sudo systemctl restart nginx
   ```

   <blockquote>
   NOTE:If you restart Nginx on a follower node \(cluster node having lower Keepalived priority number\), the service fails to start with the following error:</blockquote>


   ```
   nginx: [emerg] bind() to <VIP>:<nginx_port> failed (99: Cannot assign requested address)
   ```


## Plugin configuration parameters

The following table lists all the configuration parameters required to deploy a plugin service:

| Parameter             | Description                                                  |
| --------------------- | ------------------------------------------------------------ |
| odimra                | List of configurations required for deploying the services of Resource Aggregator for ODIM and third-party services.<br> **NOTE**: Ensure that the values of the parameters listed under odimra are same as the ones specified in the `kube_deploy_nodes.yaml` file. |
| namespace             | Namespace to be used for creating the service pods of Resource Aggregator for ODIM. The default value is "odim". You can optionally change it to a different value. |
| groupID               | Group ID to be used for creating the odimra group.The default value is 2021. You can optionally change it to a different value.<br>**NOTE**: Ensure that the group id is not already in use on any of the nodes. |
| haDeploymentEnabled   | When set to true, it deploys third-party services as a three-instance cluster. By default, it is set to true. Before setting it to false, ensure that there are at least three nodes in the Kubernetes cluster. |
| eventListenerNodePort | The port used for listening to plugin events. Refer to the sample plugin yaml configuration file to view the sample port information. |
| RootServiceUUID       | RootServiceUUID to be used by the plugin service. To generate an UUID, run the following command:<br> ```$ uuidgen```<br> Copy the output and paste it as the value for rootServiceUUID. |
| username              | Username of the plugin.                                      |
| password              | The encrypted password of the plugin.                        |
| lbHost                | If there is only one cluster node, the lbHost is the IP address of the cluster node. If there is more than one cluster node \( haDeploymentEnabled is true\), lbHost is the virtual IP address configured in Nginx and Keepalived. |
| lbPort                | If it is a one-cluster configuration, the lbPort must be same as eventListenerNodePort.<br>If there is more than one cluster node \(haDeploymentEnabled is true\), lbPort is the Nginx API node port configured in the Nginx plugin configuration file. |
| logPath               | The path where the plugin logs are stored. The default path is `/var/log/<plugin_name>_logs`<br />**Example**: `/var/log/lenovoplugin\_logs` |

 