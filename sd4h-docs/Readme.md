# Elastic-HPC

Elastic HPC is the deployment of multiple Magic Castle cluster on the SD4H infrastructure.

It stays as close as possible to the upstream project for both the terrafrom repos (this repo) and its accompanying  [puppet configuration](https://github.com/c3g/puppet-magic_castle)


## The deployment

The HPC are deployed in a single OpenStack Project or tenant: `Elastic-HPC`. It is managed by the SD4H team.   

Every deployment has it own private network for Slurm communication, however there is a shared network for the CephFS file system, that also needs to be mounted on all the Magic Castle nodes. The presence and mounting of the CephFS network on all the hosts is the main difference between this version of Magic Castle and the upstream.

### Current deployment

The current deployment allocation is maintained here [this spreadsheets](https://docs.google.com/spreadsheets/d/15T0ea7qq-4mbekLgbJNQ0GMcPukT-wFqBYuNZ5VHv5w/edit#gid=0
). You can see how much resources is available for every deployed clusters. Right now that part is manual.


Then there is the terraform state of the clusters stored in the Elastic-HPC object store's `git-repos` bucket. The repo itself is `elastic-hpc.git`. It can be copied locally a and then clone to main. Here the clunky procedure. Hopefully it will get better.





### Adding a new project.

* Find a name for the new cluster (right now we ask Marieke for a new bird name :) )
* Update the [this spreadsheets](https://docs.google.com/spreadsheets/d/15T0ea7qq-4mbekLgbJNQ0GMcPukT-wFqBYuNZ5VHv5w/edit#gid=0) with the new project.
* Clone and configure the Elastic HPC terraform template

```bash
NEW_CLUSTER=corbeau
TEMPLATE_V=1.0.1
wget -qO- https://github.com/c3g/elastic-HPC/archive/refs/tags/$TEMPLATE_V.tar.gz | tar xvz  --transform "s/^elastic-HPC-TEMPLATE_V/$NEW_CLUSTER/"
```  

Set the cluster name and resources in the $NEW_CLUSTER/main.tf file. You will also want to add your public ssh key to the public_keys list. Right now Pierre-Olivier Quirion, from the C3G, it there by default






## Adding a new project

## Scaling

## Future
### Auto Scaling
### Easy Onboarding
