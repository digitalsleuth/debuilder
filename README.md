# debuilder
In order to create a docker environment where pbuilder-dist would run and not have 'proc' mounting issues, I had to do a bit of a workaround.
First, I created a Dockerfile to build the desired baseline, all tools installed, but without running pbuilder-dist.
Then I enabled sshd for a couple of reasons, the first was to ensure that during the forthcoming docker-compose setup, the container didn't start, run, and stop before I could get a good working state. The second reason was because ssh in a dev docker environment can be handy to ensure you log in as the correct user with correct permissions, and have the potential for X11 forwarding for a GUI environment.

Once the baseline docker was built, I ran: `sudo docker-compose -f docker-compose.original up -d --build`

This built and brought up the SSH enabled environment with the privileges required to run pbuilder:
```sudo docker network inspect debuild_default | grep "IPv4"
ssh remnux@<ip>
pbuilder-dist bionic create
```

After pbuilder-dist finishes, I remained in the ssh session, and ran:
```sudo docker commit <container_ID> digitalsleuth/debuilder:latest
sudo docker-compose down
```

Now that I have the image I need, I can now use:
`sudo docker-compose up -d` with the docker-compose.yml file as needed and modify as needed.

The docker image in docker-hub is the completed image with pbuilder-dist already run.

