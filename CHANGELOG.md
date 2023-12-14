# Changelog

## [1.3.0](https://github.com/blake-lucas/BakeOS/compare/v1.2.0...v1.3.0) (2023-12-14)


### Features

* recommended containers to distrobox with assemble ([4e9687e](https://github.com/blake-lucas/BakeOS/commit/4e9687e0983cf4f658be6fe33840fa9c540de9ec))
* start building kde and xfce images ([c3030c0](https://github.com/blake-lucas/BakeOS/commit/c3030c0fecaf1f3278d969434343be5eadbab291))
* update rustdesk to v1.2.3 ([331c5fa](https://github.com/blake-lucas/BakeOS/commit/331c5faac1e65ff307e5294c797efd744433cc21))


### Bug Fixes

* add missing var in build.yml ([0b5ece7](https://github.com/blake-lucas/BakeOS/commit/0b5ece7666b73f87d1042425f27d01e8bd9f1e55))
* add nextshot deps for wayland ([7a163bd](https://github.com/blake-lucas/BakeOS/commit/7a163bd648d007f9a05a15a5e3b972c1a1a93dab))
* another maybe fix for terminal open thing ([361112f](https://github.com/blake-lucas/BakeOS/commit/361112f96e644e99234d8db76fb0a4b3d36724c4))
* disable firmware git ([e7b2902](https://github.com/blake-lucas/BakeOS/commit/e7b290269610f5e208fa9542670b56adf9349598))
* fix missing packages from build.sh ([f3335dd](https://github.com/blake-lucas/BakeOS/commit/f3335dd76193a0d2696b763e9d81e1c7497fcac1))
* grab host nvidia version for apx-nvidia ([60d104a](https://github.com/blake-lucas/BakeOS/commit/60d104a20fc6cfa426599feada9cde8468c7dbee))
* maybe fix bakeos-lts image tagging ([a3f8c47](https://github.com/blake-lucas/BakeOS/commit/a3f8c4763db4043f7541a2146e804c42f6117880))
* maybe fix final image names ([7381f66](https://github.com/blake-lucas/BakeOS/commit/7381f665e523aa698b9407c83fd8f692611367ea))
* maybe fix silverblue builds ([7c52580](https://github.com/blake-lucas/BakeOS/commit/7c525800f3a02b0c1e5609dbc7aa50df8abdb653))
* maybe fix terminal schema error ([732259d](https://github.com/blake-lucas/BakeOS/commit/732259d09ef7646e9b263e7ec348c02c1010f811))
* more fixes for new images ([f4ad1a9](https://github.com/blake-lucas/BakeOS/commit/f4ad1a9f4ad4596fa62d6b68e89c580ea2a39650))
* nautilus terminal pkg system install broken ([5d1b81b](https://github.com/blake-lucas/BakeOS/commit/5d1b81b56d4fcef994751f4de0a01051c6e3efd7))
* only run gnome ext copy when gnome-shell exists ([f2339ce](https://github.com/blake-lucas/BakeOS/commit/f2339ce4d07ce8a7fe267d875cf8ba80da9e5b98))
* oops forgot about existing image_name var ([e7c1993](https://github.com/blake-lucas/BakeOS/commit/e7c199318434903a0967ec06dabbafc71d862335))
* rename var in containerfile for new images ([19e5d76](https://github.com/blake-lucas/BakeOS/commit/19e5d766bb97bd0f15ef00de861ead782abc4598))
* retry firmware download up to 3 times ([a8f2844](https://github.com/blake-lucas/BakeOS/commit/a8f2844848bd5e77376719511a99c0758fa09053))
* try switching to nvidia 530 ([a5f1af4](https://github.com/blake-lucas/BakeOS/commit/a5f1af492108e6ff3a3f62d47f66841deaa7945f))
* update rustdesk rpm download url ([45f3806](https://github.com/blake-lucas/BakeOS/commit/45f3806d62130f4f7bac1a0e32d2ac3f393cef64))

## [1.2.0](https://github.com/blake-lucas/BakeOS/compare/v1.1.1...v1.2.0) (2023-06-12)


### Features

* add apx init to apx-init just entry ([4f05785](https://github.com/blake-lucas/BakeOS/commit/4f0578538284c38dccb17e1241152cd0e8fb5bb6))
* add duperemove package ([653071d](https://github.com/blake-lucas/BakeOS/commit/653071d7b30c964f96f797e78238a31c97a3e6f6))
* add lm_sensors package ([4eadde9](https://github.com/blake-lucas/BakeOS/commit/4eadde9635eeb24d7290993ee9a81f2b67b87715))
* add pavucontrol package ([ebd77a8](https://github.com/blake-lucas/BakeOS/commit/ebd77a869935f24a5acf33c867b9db52090bd13c))
* add tailscale VPN ([64b3083](https://github.com/blake-lucas/BakeOS/commit/64b308370554851de494953ba37ae91f101ccb14))
* Disable Wayland on Nvidia image by default ([61b85a7](https://github.com/blake-lucas/BakeOS/commit/61b85a7a18dbf91116b4624b6d0f37566b384f47))
* Set new default theme for black box ([7b8aa45](https://github.com/blake-lucas/BakeOS/commit/7b8aa45e49084c8c028bbdc2f426d62cd164c5b6))
* Use Mesa git ([be08889](https://github.com/blake-lucas/BakeOS/commit/be08889e84c0e16ad0f1039368b5f577d5d6b655))


### Bug Fixes

* Disable kernel LTS repo and maybe fix mesa-git install ([43799d3](https://github.com/blake-lucas/BakeOS/commit/43799d3f94ce5a84c57454c1d70e71767f44ad5c))
* fix oh-my-zsh check on boot script ([61d131e](https://github.com/blake-lucas/BakeOS/commit/61d131e9217928d11154d7559abab0f8ff02c3b2))
* maybe fix zsh check ([b7c87ed](https://github.com/blake-lucas/BakeOS/commit/b7c87edaa88260c5601fa9be418071c08c55a037))
* update justfile to grab current fedora version ([63460ce](https://github.com/blake-lucas/BakeOS/commit/63460ce0e7dee9a4f1bcb252b4a0dd4304b90d56))
* use apx run instead of install to avoid export questions ([1d0220b](https://github.com/blake-lucas/BakeOS/commit/1d0220b66677977807e24e1adbd9ed0607da21d6))
* Yafti needs empty quotes for descriptions ([4fc23ae](https://github.com/blake-lucas/BakeOS/commit/4fc23aee7499f05da7ffe62abcc1a15945b6249b))

## [1.1.1](https://github.com/blake-lucas/BakeOS/compare/v1.1.0...v1.1.1) (2023-05-17)


### Bug Fixes

* Separate LTS builds in ISO boot menu to pull correct imageurl ([c901592](https://github.com/blake-lucas/BakeOS/commit/c901592f08f0bdcbc64e0161e0f0d295047bf1d1))

## [1.1.0](https://github.com/blake-lucas/BakeOS/compare/v1.0.2...v1.1.0) (2023-05-17)


### Features

* Add LTS image to ISO ([b5d0d00](https://github.com/blake-lucas/BakeOS/commit/b5d0d00ab67808d7b159c025ae867d86b8426496))

## [1.0.2](https://github.com/blake-lucas/BakeOS/compare/v1.0.1...v1.0.2) (2023-05-17)


### Bug Fixes

* use custom isogenerator repo ([220f377](https://github.com/blake-lucas/BakeOS/commit/220f3774572515f9cd53555cfdd82e5b3909061d))

## [1.0.1](https://github.com/blake-lucas/BakeOS/compare/v1.0.0...v1.0.1) (2023-05-17)


### Bug Fixes

* surely pushing a new build will generate a working ISO ([aea8c8c](https://github.com/blake-lucas/BakeOS/commit/aea8c8c6382c1e674077074f55df2473f4bba648))

## 1.0.0 (2023-05-17)


### Features

* add a justfile for convenience ([#38](https://github.com/blake-lucas/BakeOS/issues/38)) ([bd8e1ad](https://github.com/blake-lucas/BakeOS/commit/bd8e1ad74c4b29cbc247f932a6cf834b2ed5df3e))
* add apx ([#37](https://github.com/blake-lucas/BakeOS/issues/37)) ([a54b693](https://github.com/blake-lucas/BakeOS/commit/a54b693b65ddce8ac31068686769d2b08759cd06))
* add distrobox and blackbox config ([#18](https://github.com/blake-lucas/BakeOS/issues/18)) ([86167f8](https://github.com/blake-lucas/BakeOS/commit/86167f84db4983a54135c602bd6a4b85aeda2c06))
* add distrobox config ([#21](https://github.com/blake-lucas/BakeOS/issues/21)) ([2ab4a79](https://github.com/blake-lucas/BakeOS/commit/2ab4a7997302c732372ff0993fc2250c66c2bce8))
* add dynamic transparency to the dock ([0e1375d](https://github.com/blake-lucas/BakeOS/commit/0e1375d14c1ec5f3a55f84c4c45964487ebe02e5))
* add fleek man page ([#59](https://github.com/blake-lucas/BakeOS/issues/59)) ([625e3d5](https://github.com/blake-lucas/BakeOS/commit/625e3d50631f2580975415c09c55f7f9332c1623))
* add nix ([#45](https://github.com/blake-lucas/BakeOS/issues/45)) ([142feba](https://github.com/blake-lucas/BakeOS/commit/142feba483417e6adccd8abce4720a8de7754bda))
* add podman-compose ([4d2213b](https://github.com/blake-lucas/BakeOS/commit/4d2213be75764a49953ea9c4955b848a49a41a7d))
* add vanilla bling ([#35](https://github.com/blake-lucas/BakeOS/issues/35)) ([d5a5e25](https://github.com/blake-lucas/BakeOS/commit/d5a5e2577ac97703556fbe27db7b0efde48e35cd))
* add xprop ([#36](https://github.com/blake-lucas/BakeOS/issues/36)) ([461e648](https://github.com/blake-lucas/BakeOS/commit/461e648c492e6851e033d35b603d89703b892f43))
* add yafti for first boot ([#39](https://github.com/blake-lucas/BakeOS/issues/39)) ([121a212](https://github.com/blake-lucas/BakeOS/commit/121a212b541f89af699857461ad5a0f3bd7efa1a))
* add yafti to justfile ([#49](https://github.com/blake-lucas/BakeOS/issues/49)) ([c7a5777](https://github.com/blake-lucas/BakeOS/commit/c7a5777644c8d657c3ccd15a0e49aec6ce04dd35))
* Bling for everyone ([#56](https://github.com/blake-lucas/BakeOS/issues/56)) ([dadaa70](https://github.com/blake-lucas/BakeOS/commit/dadaa70e4b567ebee6254b44f5ba735dd68033a2))
* change kb shortcut to flatpak blackbox ([#34](https://github.com/blake-lucas/BakeOS/issues/34)) ([83e3897](https://github.com/blake-lucas/BakeOS/commit/83e38977e179616da8f1fdd87e6aa398aa970345))
* enable F38 builds ([#30](https://github.com/blake-lucas/BakeOS/issues/30)) ([2e4e6fb](https://github.com/blake-lucas/BakeOS/commit/2e4e6fbfb25c88ff231e9ef098facbe0d630165d))
* initial commit ([f8c0432](https://github.com/blake-lucas/BakeOS/commit/f8c04326f357f7a34b8f3dc37bbb4732b81b346c))
* split off browsers into their own section ([#44](https://github.com/blake-lucas/BakeOS/issues/44)) ([2d30ec4](https://github.com/blake-lucas/BakeOS/commit/2d30ec41c3d8db219588b987402e5a7363ee4487))
* switch over to determinate nix installer ([#48](https://github.com/blake-lucas/BakeOS/issues/48)) ([2261f57](https://github.com/blake-lucas/BakeOS/commit/2261f577c897ab833aba36feb38e9d0bdd83d486))
* template out COPRs better, add bootc ([3f0a4fc](https://github.com/blake-lucas/BakeOS/commit/3f0a4fcea6cdca485549059b7ac2abc2b0dc6683))


### Bug Fixes

* add attribution ([#47](https://github.com/blake-lucas/BakeOS/issues/47)) ([e16ae0a](https://github.com/blake-lucas/BakeOS/commit/e16ae0a86f75d7693dd33469a8b29bb6aa721c43))
* add back gnome-software-ostree ([#13](https://github.com/blake-lucas/BakeOS/issues/13)) ([89edab0](https://github.com/blake-lucas/BakeOS/commit/89edab04913ce6765ba64a8f5cd067ac688ab989))
* add tailscale repo ([36f12fd](https://github.com/blake-lucas/BakeOS/commit/36f12fd4fbf1f1309e28cc4011cd8243b293c259))
* clarify gpu instructions ([#16](https://github.com/blake-lucas/BakeOS/issues/16)) ([da2a5e3](https://github.com/blake-lucas/BakeOS/commit/da2a5e334030a81ca8fcc71f840b672a36ffb543))
* default app updates ([#41](https://github.com/blake-lucas/BakeOS/issues/41)) ([82f7a33](https://github.com/blake-lucas/BakeOS/commit/82f7a331004e21414d8ae6254e7b771662dd30f2))
* disable 38 builds for now ([279c4d7](https://github.com/blake-lucas/BakeOS/commit/279c4d733d869460c48e7dd687e6be6460551d29))
* fix typo ([#19](https://github.com/blake-lucas/BakeOS/issues/19)) ([e87b447](https://github.com/blake-lucas/BakeOS/commit/e87b44779c3d038b16f4f927bbb749288486999f))
* formatting for values ([#20](https://github.com/blake-lucas/BakeOS/issues/20)) ([e07ae1a](https://github.com/blake-lucas/BakeOS/commit/e07ae1a4e176d5d0b84f067a659dbaf5d526cb05))
* leave dock on the bottom ([b5fd5a8](https://github.com/blake-lucas/BakeOS/commit/b5fd5a8cc0b805cde2a03ceb5b9324a7a26a1861))
* man location ([#61](https://github.com/blake-lucas/BakeOS/issues/61)) ([3370953](https://github.com/blake-lucas/BakeOS/commit/3370953bcc33c29ba6be2836d63307da05f8ea6d))
* mangohud needs 22.08 explicitly ([#40](https://github.com/blake-lucas/BakeOS/issues/40)) ([a1b7890](https://github.com/blake-lucas/BakeOS/commit/a1b78906c4c02c17ae9787225dac94c046e80833))
* move distrobox config to proper directory ([#22](https://github.com/blake-lucas/BakeOS/issues/22)) ([3e288a6](https://github.com/blake-lucas/BakeOS/commit/3e288a661786d610a63cbc900291475aa0fb16bc))
* move to blackbox terminal in distro ([#31](https://github.com/blake-lucas/BakeOS/issues/31)) ([3e66068](https://github.com/blake-lucas/BakeOS/commit/3e66068c3ce05e114b910a55e4ec01769717295f))
* name image by flavor ([b16e011](https://github.com/blake-lucas/BakeOS/commit/b16e0118053853862c6a379f863a6678f1b13ab4))
* reenable gsconnect and blur ([8fc688b](https://github.com/blake-lucas/BakeOS/commit/8fc688b1291e688528fcfc36e20f90d50c1857ee))
* remove blackbox ([#33](https://github.com/blake-lucas/BakeOS/issues/33)) ([dbc3c62](https://github.com/blake-lucas/BakeOS/commit/dbc3c626c2fb66d5087b06220a0b426a16471995))
* remove bootc copr for now ([70764ae](https://github.com/blake-lucas/BakeOS/commit/70764ae70d68c7392308ae81348f42995c9f77a8))
* remove extra dashes ([9254d10](https://github.com/blake-lucas/BakeOS/commit/9254d100a7c2b20bf2bfb68deeae8fd28944eb5b))
* remove input keymapper ([5af05ec](https://github.com/blake-lucas/BakeOS/commit/5af05ec190b0bb86e104cb0b41f50c0a85b8aa03))
* remove post-install from containerfile ([6116d0f](https://github.com/blake-lucas/BakeOS/commit/6116d0fe0e7b317b17fd93b87bca59ec6bce48a7))
* remove rpmfusion install ([588ef2f](https://github.com/blake-lucas/BakeOS/commit/588ef2ff1e08a7c9ddba2085a09d9b49dac98e48))
* remove webapp-manager ([7d24137](https://github.com/blake-lucas/BakeOS/commit/7d241371d2b8d097ffa75ec98eeb0927d684210e))
* remove webapp-manager ([cc77988](https://github.com/blake-lucas/BakeOS/commit/cc7798881d3bed420337fe75728f0268e2f97e4e))
* rename nix installer to ublue-nix-installer ([#51](https://github.com/blake-lucas/BakeOS/issues/51)) ([703becd](https://github.com/blake-lucas/BakeOS/commit/703becd701f3b9400fceba64a7b1bb16e6f7171c))
* template repo version ([ab55681](https://github.com/blake-lucas/BakeOS/commit/ab55681cf9a0236265cf2ba8b89be59f6bbe2dfc))
* temporarily turn off gnome-vrr ([#29](https://github.com/blake-lucas/BakeOS/issues/29)) ([43603f5](https://github.com/blake-lucas/BakeOS/commit/43603f52c4b6463d333f872de0660ec04a58d0b3))
* turn off hotcorners and set 4 desktops ([#42](https://github.com/blake-lucas/BakeOS/issues/42)) ([549fdd5](https://github.com/blake-lucas/BakeOS/commit/549fdd50bfa4030cecf858441074b5b5668197a3))
* type in descriptions ([#50](https://github.com/blake-lucas/BakeOS/issues/50)) ([f26e074](https://github.com/blake-lucas/BakeOS/commit/f26e0742add1dcdf8d4f2a492333aba180e075a6))
* update action to build bluefin ([cebc564](https://github.com/blake-lucas/BakeOS/commit/cebc564651398d13b725dd191133cc6ca61e3347))
* update docs ([#57](https://github.com/blake-lucas/BakeOS/issues/57)) ([82e7319](https://github.com/blake-lucas/BakeOS/commit/82e7319907179256aa1d2606773679f02d9cea3e))
* update readme ([#15](https://github.com/blake-lucas/BakeOS/issues/15)) ([c149f41](https://github.com/blake-lucas/BakeOS/commit/c149f416bdc67c380b1c008fc27bed1d85424159))
* Update Super-E shortcut isn't working ([#60](https://github.com/blake-lucas/BakeOS/issues/60)) ([e56b5d8](https://github.com/blake-lucas/BakeOS/commit/e56b5d82cbfc68e359161b4155c7b6326b998312))
* use correct name for font downloader ([#55](https://github.com/blake-lucas/BakeOS/issues/55)) ([6bde682](https://github.com/blake-lucas/BakeOS/commit/6bde6824484da72381179862162575feccd3fab6))
* use image flavor to name tags ([c3b061f](https://github.com/blake-lucas/BakeOS/commit/c3b061fad4806ca8e90392fe0f1fbd0b9f92468b))
