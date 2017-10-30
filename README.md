# IP Performance Container

This container tests the network performance between two endpoints. Both sides must have the same container with the TX and RX parameters. Once they are up, test will begin taking up as much bandwidth as they can. Results will be shown in stdout.

# How it works

You launch two containers based on the same image and they both will start to test their connection. These containers can be in the same host (in a single `docker-compose` file) or in different hosts. Environment variables can be set to specify a `DESTINATION` ip address to start testing.

  - Launche the RX container.
  - Launche the TX container.

### Basic Test

With the `docker-compose.yml` file you can test the connectivity between two containers inside the same host. This file creates one single network and puts both the `rx` and `tx` in the same segment. To launch the initial test:

``` sh
docker-compose up
```

### Environment variables

The following options can be set in the `tx` container:

| ENV Variable | Values | Description |
| ------ | ------ | ------ |
|`ROLE` | tx/rx | Defines if the container will transmit or receive test data |
| `DESTINATION` | rx/<IP> | Defines the destination (where `rx` is). Uses port `5001` |
|`MIN_MTU` | number | Before the test the `tx` container will test a range of MTUs. It will start here |
| `MAX_MTU` | number | And it will finish here. By default goes from 1450 to 1600 |
| `L4P` | TCP/UDP | Defines the Layer 4 Protocol to use at testing. This is set only in the Receiver |

### Live Monitoring

After you launch the container, you can monitor the network traffic by executing `bmon` in the container. To test this, you can launch the test as deamon with:

``` sh
docker-compose up -d
```
And right after it creates the containers, you can see the traffic with:
``` sh 
docker-compose exec tx bmon
```

All the results are shown in the `stdout`.