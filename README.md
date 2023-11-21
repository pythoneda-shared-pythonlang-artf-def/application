# Definition for pythoneda-shared-pythoneda-artifact/domain-application

Definition of [pythoneda-shared-pythoneda-artifact](https://github.com/pythoneda-shared-pythoneda-artifact "pythoneda-shared-pythoneda-artifact")/[domain-application](https://github.com/pythoneda-shared-pythoneda-artifact/domain-application "domain-application").

## How to declare it in your flake

Annotate the latest version of this repository and use it instead of the `[version]` placeholder below:

```nix
{
  description = "[..]";
  inputs = rec {
    [..]
    pythoneda-shared-pythoneda-artifact-domain-application = {
      [optional follows]
      url =
        "github:pythoneda-shared-pythoneda-artifact-def/domain-application/[version]";
    };
  };
  outputs = [..]
};
```

Should you use another PythonEDA modules, you might want to pin those also used by this project. The same applies to [nixpkgs](https://github.com/nixos/nixpkgs "nixpkgs") and [flake-utils](https://github.com/numtide/flake-utils "flake-utils").

Use the specific package depending on your system (one of `flake-utils.lib.defaultSystems`) and Python version:

- `#packages.[system].pythoneda-shared-pythoneda-artifact-domain-application-python38` 
- `#packages.[system].pythoneda-shared-pythoneda-artifact-domain-application-python39` 
- `#packages.[system].pythoneda-shared-pythoneda-artifact-domain-application-python310` 
- `#packages.[system].pythoneda-shared-pythoneda-artifact-domain-application-python311` 


## How to run pythoneda-shared-pythoneda-artifact/domain

``` sh
nix run 'https://github.com/pythoneda-shared-pythoneda-artifact-def/domain-application/[version]'
```

### Usage

``` sh
nix run https://github.com/pythoneda-shared-pythoneda-artifact-def/domain-application/[version] [-h|--help] [-r|--repository-folder folder] [-e|--event event] [-t|--tag tag]
```
- `-h|--help`: Prints the usage.
- `-r|--repository-folder`: The folder where <https://github.com/pythoneda-shared-pythoneda-artifact/domain> is cloned.
- `-e|--event`: The event to send. See <https://github.com/pythoneda-shared-artifact/events>.
- `-t|--tag`: If the event is `TagPushed`, specify the tag.
