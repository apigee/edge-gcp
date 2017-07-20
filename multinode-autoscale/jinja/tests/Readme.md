# edge-gcp
This section provides the test cases to test resilience, HA and Scalibility.

## Support
This is an open-source project of the Apigee Corporation. It is not covered by Apigee support contracts. However, we will support you as best we can. For help, please open an issue in this GitHub project. You are also always welcome to submit a pull request.


## Prerequisite

### gcloud 
Install gcloud sdk from https://cloud.google.com/sdk/downloads
Initialize your account

## Getting Started
- Please copy the generated key pair file apigee.key and apigee.key.pub in this tests folder.
- For reslience testing please run following command 
```sh
./resilience_testing.sh "RESOURCE_NAME"
```
e.g :
```sh
./resilience_testing.sh edgescale
```
- For HA testing please run following command 
```sh
./ha.sh "RESOURCE_NAME"
```
e.g :
```sh
./ha.sh edgescale
```



## License

Apache 2.0 - See [LICENSE](LICENSE) for more information.
