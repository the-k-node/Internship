* Download or Install `Packer` from [here](https://www.packer.io/downloads) or install using `brew` (you need 'homebrew' package manager from 
```bash 
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
for using 'brew' command)
```bash
brew install packer
```

* Check that Packer has installed by running any Packer command like
```bash
packer version
```
if this command returns some version number of packer, then Packer has installed properly else try redoing the above step.

* Once verified, make a directory structure and create files as
    ```
    build.json
    http --> preseed.cfg
    ```

* Create `build.json` file with basic 3 fields that can be used by Packer, they are 
    1. builders
    2. provisioners
    3. post-processers
these are used for respective specifications for creating template automatically by Packer.

* Other than those basic 3 fields, we can also have `variables` field to have user defined variables and later can access using
```bash
{{user `<user-variable-name>`}}
```

* We need a `preseed.cfg` file with required configuration commands to automate the complete installation of the ubuntu-server for this task.

* `debian-installer` is the available manager to automate the fields / screens that we intend in installing our server operating system on a new VM.

* We can use`d-i` to access the required files defined in debian repository and the required configuration commands are specified in [here](./Packer/http/preseed.cfg) .

* After configuring all required commands, we need to use `build` option in packer to start building the scripts we put together
```bash
packer build build.json
```

* This will create the vm with specified `vm_name` in build file and all specifications specified in the [this](./Packer/build.json) file.

* Once installation is done, we can verify all the specifictions and settings specified in the config files, and that's the automation task done using HashiCorp's Packer.

* References :

    1. http://cloud-images-archive.ubuntu.com/releases/focal/release-20200423/
    2. https://help.ubuntu.com/lts/installation-guide/s390x/apbs02.html
    3. https://computingforgeeks.com/how-to-install-and-use-packer/
