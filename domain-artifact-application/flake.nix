# domain-artifact-application/flake.nix
#
# This file packages pythoneda-shared-pythoneda/domain-artifact-application as a Nix flake.
#
# Copyright (C) 2023-today rydnr's pythoneda-shared-pythoneda/domain-artifact-application-artifact
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
{
  description =
    "Application layer for pythoneda-shared-pythoneda/domain-artifact";
  inputs = rec {
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    nixos.url = "github:NixOS/nixpkgs/nixos-23.05";
    pythoneda-shared-pythoneda-application = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      inputs.pythoneda-shared-pythoneda-banner.follows =
        "pythoneda-shared-pythoneda-banner";
      inputs.pythoneda-shared-pythoneda-domain.follows =
        "pythoneda-shared-pythoneda-domain";
      inputs.pythoneda-shared-pythoneda-infrastructure.follows =
        "pythoneda-shared-pythoneda-infrastructure";
      url =
        "github:pythoneda-shared-pythoneda/application-artifact/0.0.2?dir=application";
    };
    pythoneda-shared-pythoneda-banner = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      url = "github:pythoneda-shared-pythoneda/banner/0.0.6";
    };
    pythoneda-shared-pythoneda-domain = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      inputs.pythoneda-shared-pythoneda-banner.follows =
        "pythoneda-shared-pythoneda-banner";
      url =
        "github:pythoneda-shared-pythoneda/domain-artifact/0.0.7?dir=domain";
    };
    pythoneda-shared-pythoneda-domain-artifact = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      inputs.pythoneda-shared-pythoneda-banner.follows =
        "pythoneda-shared-pythoneda-banner";
      inputs.pythoneda-shared-pythoneda-domain.follows =
        "pythoneda-shared-pythoneda-domain";
      url =
        "github:pythoneda-shared-pythoneda/domain-artifact-artifact/0.0.9?dir=domain-artifact";
    };
    pythoneda-shared-pythoneda-domain-artifact-infrastructure = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      inputs.pythoneda-shared-pythoneda-banner.follows =
        "pythoneda-shared-pythoneda-banner";
      inputs.pythoneda-shared-pythoneda-domain.follows =
        "pythoneda-shared-pythoneda-domain";
      inputs.pythoneda-shared-pythoneda-domain-artifact.follows =
        "pythoneda-shared-pythoneda-domain-artifact";
      inputs.pythoneda-shared-pythoneda-infrastructure.follows =
        "pythoneda-shared-pythoneda-infrastructure";
      url =
        "github:pythoneda-shared-pythoneda/domain-artifact-infrastructure-artifact/0.0.6?dir=domain-artifact-infrastructure";
    };
    pythoneda-shared-pythoneda-infrastructure = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      inputs.pythoneda-shared-pythoneda-banner.follows =
        "pythoneda-shared-pythoneda-banner";
      inputs.pythoneda-shared-pythoneda-domain.follows =
        "pythoneda-shared-pythoneda-domain";
      url =
        "github:pythoneda-shared-pythoneda/infrastructure-artifact/0.0.2?dir=infrastructure";
    };
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        org = "pythoneda-shared-pythoneda";
        repo = "domain-artifact-application";
        version = "0.0.3";
        sha256 = "sha256-g9bDMI4LfOyaIEPVvrkH8BZm2kH15HOUSo4QtG4gAQo=";
        pname = "${org}-${repo}";
        pythonpackage = "pythoneda.artifact.application";
        package = builtins.replaceStrings [ "." ] [ "/" ] pythonpackage;
        entrypoint = "artifact_app";
        description =
          "Application layer for pythoneda-shared-pythoneda/domain-artifact";
        license = pkgs.lib.licenses.gpl3;
        homepage = "https://github.com/${org}/${repo}";
        maintainers = with pkgs.lib.maintainers;
          [ "rydnr <github@acm-sl.org>" ];
        archRole = "B";
        space = "D";
        layer = "A";
        nixosVersion = builtins.readFile "${nixos}/.version";
        nixpkgsRelease =
          builtins.replaceStrings [ "\n" ] [ "" ] "nixos-${nixosVersion}";
        shared = import "${pythoneda-shared-pythoneda-banner}/nix/shared.nix";
        pkgs = import nixos { inherit system; };
        pythoneda-shared-pythoneda-domain-artifact-application-for = { python
          , pythoneda-shared-pythoneda-domain-artifact
          , pythoneda-shared-pythoneda-domain-artifact-infrastructure
          , pythoneda-shared-pythoneda-application
          , pythoneda-shared-pythoneda-banner, pythoneda-shared-pythoneda-domain
          }:
          let
            pnameWithUnderscores =
              builtins.replaceStrings [ "-" ] [ "_" ] pname;
            pythonVersionParts = builtins.splitVersion python.version;
            pythonMajorVersion = builtins.head pythonVersionParts;
            pythonMajorMinorVersion =
              "${pythonMajorVersion}.${builtins.elemAt pythonVersionParts 1}";
            wheelName =
              "${pnameWithUnderscores}-${version}-py${pythonMajorVersion}-none-any.whl";
            banner_file = "${package}/artifact_banner.py";
            banner_class = "ArtifactBanner";
          in python.pkgs.buildPythonPackage rec {
            inherit pname version;
            projectDir = ./.;
            pyprojectTemplateFile = ./pyprojecttoml.template;
            pyprojectTemplate = pkgs.substituteAll {
              authors = builtins.concatStringsSep ","
                (map (item: ''"${item}"'') maintainers);
              desc = description;
              inherit homepage package pname pythonMajorMinorVersion
                pythonpackage version;
              pythonedaSharedPythonedaDomainArtifactInfrastructure =
                pythoneda-shared-pythoneda-domain-artifact-infrastructure.version;
              pythonedaSharedPythonedaDomainArtifact =
                pythoneda-shared-pythoneda-domain-artifact.version;
              pythonedaSharedPythonedaApplication =
                pythoneda-shared-pythoneda-application.version;
              pythonedaSharedPythonedaBanner =
                pythoneda-shared-pythoneda-banner.version;
              pythonedaSharedPythonedaDomain =
                pythoneda-shared-pythoneda-domain.version;
              src = pyprojectTemplateFile;
            };
            bannerTemplateFile =
              "${pythoneda-shared-pythoneda-banner}/templates/banner.py.template";
            bannerTemplate = pkgs.substituteAll {
              project_name = pname;
              file_path = banner_file;
              inherit banner_class org repo;
              tag = version;
              pescio_space = space;
              arch_role = archRole;
              hexagonal_layer = layer;
              python_version = pythonMajorMinorVersion;
              nixpkgs_release = nixpkgsRelease;
              src = bannerTemplateFile;
            };

            entrypointTemplateFile =
              "${pythoneda-shared-pythoneda-banner}/templates/entrypoint.sh.template";
            entrypointTemplate = pkgs.substituteAll {
              arch_role = archRole;
              hexagonal_layer = layer;
              nixpkgs_release = nixpkgsRelease;
              inherit homepage maintainers org python repo version;
              pescio_space = space;
              python_version = pythonMajorMinorVersion;
              pythoneda_shared_pythoneda_banner =
                pythoneda-shared-pythoneda-banner;
              pythoneda_shared_pythoneda_domain =
                pythoneda-shared-pythoneda-domain;
              src = entrypointTemplateFile;
            };
            src = pkgs.fetchFromGitHub {
              owner = org;
              rev = version;
              inherit repo sha256;
            };

            format = "pyproject";

            nativeBuildInputs = with python.pkgs; [ pip pkgs.jq poetry-core ];
            propagatedBuildInputs = with python.pkgs; [
              pythoneda-shared-pythoneda-domain-artifact
              pythoneda-shared-pythoneda-domain-artifact-infrastructure
              pythoneda-shared-pythoneda-application
              pythoneda-shared-pythoneda-banner
              pythoneda-shared-pythoneda-domain
            ];

            pythonImportsCheck = [ pythonpackage ];

            unpackPhase = ''
              cp -r ${src} .
              sourceRoot=$(ls | grep -v env-vars)
              chmod -R +w $sourceRoot
              cp ${pyprojectTemplate} $sourceRoot/pyproject.toml
              cp ${bannerTemplate} $sourceRoot/${banner_file}
              cp ${entrypointTemplate} $sourceRoot/entrypoint.sh
            '';

            postPatch = ''
              substituteInPlace /build/$sourceRoot/entrypoint.sh \
                --replace "@SOURCE@" "$out/bin/${entrypoint}.sh" \
                --replace "@PYTHONPATH@" "$PYTHONPATH" \
                --replace "@ENTRYPOINT@" "$out/lib/python${pythonMajorMinorVersion}/site-packages/${package}/${entrypoint}.py"
            '';

            postInstall = ''
              pushd /build/$sourceRoot
              for f in $(find . -name '__init__.py'); do
                if [[ ! -e $out/lib/python${pythonMajorMinorVersion}/site-packages/$f ]]; then
                  cp $f $out/lib/python${pythonMajorMinorVersion}/site-packages/$f;
                fi
              done
              popd
              mkdir $out/dist $out/bin
              cp dist/${wheelName} $out/dist
              jq ".url = \"$out/dist/${wheelName}\"" $out/lib/python${pythonMajorMinorVersion}/site-packages/${pnameWithUnderscores}-${version}.dist-info/direct_url.json > temp.json && mv temp.json $out/lib/python${pythonMajorMinorVersion}/site-packages/${pnameWithUnderscores}-${version}.dist-info/direct_url.json
              cp /build/$sourceRoot/entrypoint.sh $out/bin/${entrypoint}.sh
              chmod +x $out/bin/${entrypoint}.sh
            '';

            meta = with pkgs.lib; {
              inherit description homepage license maintainers;
            };
          };
      in rec {
        apps = rec {
          default =
            pythoneda-shared-pythoneda-domain-artifact-application-default;
          pythoneda-shared-pythoneda-domain-artifact-application-default =
            pythoneda-shared-pythoneda-domain-artifact-application-python311;
          pythoneda-shared-pythoneda-domain-artifact-application-python38 =
            shared.app-for {
              package =
                self.packages.${system}.pythoneda-shared-pythoneda-domain-artifact-application-python38;
              inherit entrypoint;
            };
          pythoneda-shared-pythoneda-domain-artifact-application-python39 =
            shared.app-for {
              package =
                self.packages.${system}.pythoneda-shared-pythoneda-domain-artifact-application-python39;
              inherit entrypoint;
            };
          pythoneda-shared-pythoneda-domain-artifact-application-python310 =
            shared.app-for {
              package =
                self.packages.${system}.pythoneda-shared-pythoneda-domain-artifact-application-python310;
              inherit entrypoint;
            };
          pythoneda-shared-pythoneda-domain-artifact-application-python311 =
            shared.app-for {
              package =
                self.packages.${system}.pythoneda-shared-pythoneda-domain-artifact-application-python311;
              inherit entrypoint;
            };
        };
        defaultApp = apps.default;
        defaultPackage = packages.default;
        devShells = rec {
          default =
            pythoneda-shared-pythoneda-domain-artifact-application-default;
          pythoneda-shared-pythoneda-domain-artifact-application-default =
            pythoneda-shared-pythoneda-domain-artifact-application-python311;
          pythoneda-shared-pythoneda-domain-artifact-application-python38 =
            shared.devShell-for {
              package =
                packages.pythoneda-shared-pythoneda-domain-artifact-application-python38;
              python = pkgs.python38;
              pythoneda-shared-pythoneda-domain =
                pythoneda-shared-pythoneda-domain.packages.${system}.pythoneda-shared-pythoneda-domain-python38;
              pythoneda-shared-pythoneda-banner =
                pythoneda-shared-pythoneda-banner.packages.${system}.pythoneda-shared-pythoneda-banner-python38;
              inherit archRole layer nixpkgsRelease org pkgs repo space;
            };
          pythoneda-shared-pythoneda-domain-artifact-application-python39 =
            shared.devShell-for {
              package =
                packages.pythoneda-shared-pythoneda-domain-artifact-application-python39;
              python = pkgs.python39;
              pythoneda-shared-pythoneda-domain =
                pythoneda-shared-pythoneda-domain.packages.${system}.pythoneda-shared-pythoneda-domain-python39;
              pythoneda-shared-pythoneda-banner =
                pythoneda-shared-pythoneda-banner.packages.${system}.pythoneda-shared-pythoneda-banner-python39;
              inherit archRole layer nixpkgsRelease org pkgs repo space;
            };
          pythoneda-shared-pythoneda-domain-artifact-application-python310 =
            shared.devShell-for {
              package =
                packages.pythoneda-shared-pythoneda-domain-artifact-application-python310;
              python = pkgs.python310;
              pythoneda-shared-pythoneda-domain =
                pythoneda-shared-pythoneda-domain.packages.${system}.pythoneda-shared-pythoneda-domain-python310;
              pythoneda-shared-pythoneda-banner =
                pythoneda-shared-pythoneda-banner.packages.${system}.pythoneda-shared-pythoneda-banner-python310;
              inherit archRole layer nixpkgsRelease org pkgs repo space;
            };
          pythoneda-shared-pythoneda-domain-artifact-application-python311 =
            shared.devShell-for {
              package =
                packages.pythoneda-shared-pythoneda-domain-artifact-application-python311;
              python = pkgs.python311;
              pythoneda-shared-pythoneda-domain =
                pythoneda-shared-pythoneda-domain.packages.${system}.pythoneda-shared-pythoneda-domain-python311;
              pythoneda-shared-pythoneda-banner =
                pythoneda-shared-pythoneda-banner.packages.${system}.pythoneda-shared-pythoneda-banner-python311;
              inherit archRole layer nixpkgsRelease org pkgs repo space;
            };
        };
        packages = rec {
          default =
            pythoneda-shared-pythoneda-domain-artifact-application-default;
          pythoneda-shared-pythoneda-domain-artifact-application-default =
            pythoneda-shared-pythoneda-domain-artifact-application-python311;
          pythoneda-shared-pythoneda-domain-artifact-application-python38 =
            pythoneda-shared-pythoneda-domain-artifact-application-for {
              python = pkgs.python38;
              pythoneda-shared-pythoneda-application =
                pythoneda-shared-pythoneda-application.packages.${system}.pythoneda-shared-pythoneda-application-python38;
              pythoneda-shared-pythoneda-banner =
                pythoneda-shared-pythoneda-banner.packages.${system}.pythoneda-shared-pythoneda-banner-python38;
              pythoneda-shared-pythoneda-domain =
                pythoneda-shared-pythoneda-domain.packages.${system}.pythoneda-shared-pythoneda-domain-python38;
              pythoneda-shared-pythoneda-domain-artifact =
                pythoneda-shared-pythoneda-domain-artifact.packages.${system}.pythoneda-shared-pythoneda-domain-artifact-python38;
              pythoneda-shared-pythoneda-domain-artifact-infrastructure =
                pythoneda-shared-pythoneda-domain-artifact-infrastructure.packages.${system}.pythoneda-shared-pythoneda-domain-artifact-infrastructure-python38;
            };
          pythoneda-shared-pythoneda-domain-artifact-application-python39 =
            pythoneda-shared-pythoneda-domain-artifact-application-for {
              python = pkgs.python39;
              pythoneda-shared-pythoneda-application =
                pythoneda-shared-pythoneda-application.packages.${system}.pythoneda-shared-pythoneda-application-python39;
              pythoneda-shared-pythoneda-banner =
                pythoneda-shared-pythoneda-banner.packages.${system}.pythoneda-shared-pythoneda-banner-python39;
              pythoneda-shared-pythoneda-domain =
                pythoneda-shared-pythoneda-domain.packages.${system}.pythoneda-shared-pythoneda-domain-python39;
              pythoneda-shared-pythoneda-domain-artifact =
                pythoneda-shared-pythoneda-domain-artifact.packages.${system}.pythoneda-shared-pythoneda-domain-artifact-python39;
              pythoneda-shared-pythoneda-domain-artifact-infrastructure =
                pythoneda-shared-pythoneda-domain-artifact-infrastructure.packages.${system}.pythoneda-shared-pythoneda-domain-artifact-infrastructure-python39;
            };
          pythoneda-shared-pythoneda-domain-artifact-application-python310 =
            pythoneda-shared-pythoneda-domain-artifact-application-for {
              python = pkgs.python310;
              pythoneda-shared-pythoneda-application =
                pythoneda-shared-pythoneda-application.packages.${system}.pythoneda-shared-pythoneda-application-python310;
              pythoneda-shared-pythoneda-banner =
                pythoneda-shared-pythoneda-banner.packages.${system}.pythoneda-shared-pythoneda-banner-python310;
              pythoneda-shared-pythoneda-domain =
                pythoneda-shared-pythoneda-domain.packages.${system}.pythoneda-shared-pythoneda-domain-python310;
              pythoneda-shared-pythoneda-domain-artifact-infrastructure =
                pythoneda-shared-pythoneda-domain-artifact-infrastructure.packages.${system}.pythoneda-shared-pythoneda-domain-artifact-infrastructure-python310;
              pythoneda-shared-pythoneda-domain-artifact =
                pythoneda-shared-pythoneda-domain-artifact.packages.${system}.pythoneda-shared-pythoneda-domain-artifact-python310;
            };
          pythoneda-shared-pythoneda-domain-artifact-application-python311 =
            pythoneda-shared-pythoneda-domain-artifact-application-for {
              python = pkgs.python311;
              pythoneda-shared-pythoneda-application =
                pythoneda-shared-pythoneda-application.packages.${system}.pythoneda-shared-pythoneda-application-python311;
              pythoneda-shared-pythoneda-banner =
                pythoneda-shared-pythoneda-banner.packages.${system}.pythoneda-shared-pythoneda-banner-python311;
              pythoneda-shared-pythoneda-domain =
                pythoneda-shared-pythoneda-domain.packages.${system}.pythoneda-shared-pythoneda-domain-python311;
              pythoneda-shared-pythoneda-domain-artifact-infrastructure =
                pythoneda-shared-pythoneda-domain-artifact-infrastructure.packages.${system}.pythoneda-shared-pythoneda-domain-artifact-infrastructure-python311;
              pythoneda-shared-pythoneda-domain-artifact =
                pythoneda-shared-pythoneda-domain-artifact.packages.${system}.pythoneda-shared-pythoneda-domain-artifact-python311;
            };
        };
      });
}
