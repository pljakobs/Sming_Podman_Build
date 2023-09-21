# Sming_Podman_Build
set of scripts to build in podman using the Sming framework

this tries to be a fully featured podman build environment for Sming projects. 
In order to not interfere with the host system, the script to call the build environment 
is called pmake. copy it to your /usr/bin directory for convenience, you could also add
alias make='/usr/bin/pmake'.
Building is then identical to the normal build process, so all the typical make commands
will just work, including hwconfig-edit if you have an x11 system running.
As part of building the container, the Containerfile runs three builds for the ESP8266, 
ESP32C3 and ESP32 architectures in order to make sure all the components are committed to the
container image. This results in a much larger image, but in shorter build times. 
