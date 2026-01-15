{ inputs }:
{
  extraModules ? [ ],
  user,
}:
inputs.home-manager.lib.homeManagerConfiguration {
  pkgs = inputs.nixpkgs.legacyPackages.${user.system};
  modules = [ ../modules/home ] ++ extraModules;
  extraSpecialArgs = { inherit inputs user; };
}
