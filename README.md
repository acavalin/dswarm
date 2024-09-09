# dswarm
A script to easily manage docker stacks, services, images, contexts and repositories.

## 1. Configuration
This terminal script can operate on your swarms by reading environment variables
for context, stack name, and registry url (thus shortening commands).

You can set each variable in your shell or create a `.dockerswarm` file
in your project's root folder to autoload them at runtime:

~~~yaml
DOCKER_CONTEXT:  context_name
DOCKER_STACK:    stack_name
DOCKER_REGISTRY: registry.gitlab.com/username/project_name
~~~

## 2. Usage

~~~
USAGE: dswarm <action> [params]
~~~

### 2.1 Actions for managing stacks & services
~~~
  <d|deploy>       [stack-name] [compose.yml]
  ls
  ps               [stack-name] [-u|--usage]
  rm               [stack-name] [-f|--force]
  <s|services>     [-f|--full]
  <i|inspect>      <service-id> [-p|--pretty]
  <l|logs>         <service-id> [-f|--follow]
  <r|restart>      <service-id>
  <t|top>          <service-id>
  <e|exec>         <service-id> [command [args]] [-- docker-args]
~~~

Note: The `deploy` action can run the eventual script `dswarm-deploy.hook`
passing the argument `pre`/`post` respectively before and after the deploy process.

### 2.2 Actions for managing images
~~~
  <lsi|images>     # list images
  <b|build>        <image-name>[:tag] [build-folder]
  <P|push>         <image-name>[:tag]
  <p|pull>         [<image-name>[:tag]]
  clean            [-c|--cache]
  run              <image-id>   [command [args]] [-- docker-args]
~~~

Note: The `build` action can run the eventual script `dswarm-build.hook`
passing the argument `pre`/`post` respectively before and after the build process.
The file must be inside the build folder.

### 2.3 Actions for managing contexts
~~~
  <c|context>      ls
  <c|context>      add <context-name> <ssh-user@address>
  <c|context>      rm  <context-name>
  ssh              [remote-command]
~~~

Note: Contexts will be created using by default the SSH adapter but you can always
use `docker context create` to create your own, but keep in mind that the `ssh`
action will not work when using a different adapter.

## 3. Examples

~~~shell
# create a new context
dswarm context add myvps root@myvps-address.com

# configure file for dswarm
echo "DOCKER_CONTEXT: myvps" > .dockerswarm
echo "DOCKER_STACK: awesomeapp" >> .dockerswarm
echo "DOCKER_REGISTRY: registry.gitlab.com/jonsmith/awesmeapp.com" >> .dockerswarm

# enters `docker/images/myapp` folder, runs `docker build`
# and tags the image with DOCKER_REGISTRY prefix
dswarm build myapp:v1 docker/images/myapp

# test the image by running it in a ephemeral container
# applying some docker options too (volume and port mappings)
dswarm run myapp bash -ilc screen -- -v /path/to/data:/data -p 3000:3000

# push image to registry
dswarm push myapp

# run some maintenance commands on remote machine
dswarm ssh mkdir -p /app-data
dswarm ssh chwon smith:users /app-data

# deploys the `awesomeapp` stack using `awesomeapp.yml` compose file
dswarm deploy

# show process statuses and CPU/MEM usage
dswarm ps --usage

# open a bash shell in the first container running the `myapp` image
# applying some docker options too (change process user)
dswarm exec myapp -- -u smith

# remove the `awesomeapp` stack
dswarm rm
~~~
