# Nixos-Extra-Container

[nixos-containers](https://nixos.wiki/wiki/NixOS_Containers) are based on `systemd-nspawn` and can be managed by:

```bash
machinectl list
```

Classically they are defined in the configuration of the host, however there are several ways to define them independent of the host's configuration:


## nixos-container --flake

```bash
nixos-container --flake .#demo create demo
nixos-container --flake .#demo update demo
```

* nice to quickly start a container from a flake with nixosConfigurations
* however doesn't manage the network setup
* requires different commands for create and update


## extra-container

[extra-container](https://github.com/erikarvstedt/extra-container) is a usefull tool in nixpkgs, allowing to configure several containers with networking.

However it doesn't (yet) support controlling only a subset of the defined containers from the given file.

```bash
extra-container create nix/containers.nix
```


## extra-container buildContainers

[Flake support](https://github.com/erikarvstedt/extra-container/tree/master/examples/flake) of extra-container.

```bash
nix run .#buildContainers -- create
```

Of of the box it only works to manage all defined containers…


## extra-container **buildContainer_\***

… is provided by the flake of this repo.

This wrapper around `extra-container buildContainers` allows managing of single containers.


```bash
nix run .#buildContainer_demo -- create
```


|                     | machinectl | nixos-container    | extra-container   | buildContainers                    |
|---------------------|------------|--------------------|-------------------|------------------------------------|
| list                | ++         |                    |                   |                                    |
| create              |            | +                  | ++                | ++                                 |
| update              |            | +                  | ++                | ++                                 |
| create or update    |            | -                  | ++                | ++                                 |
| network config      |            | (imperativ)        | +                 | +                                  |
| flake               |            | ++                 |                   | +                                  |
| single container    |            | ++                 | -                 | (implemented in this flake)        |
| multiple containers |            |                    | +                 | +                                  |
| config format       |            | nixosConfiguration | containers-config | buildContainers(containers-config) |
