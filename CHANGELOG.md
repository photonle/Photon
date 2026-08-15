# Changelog

## [76.6.0](https://github.com/photonle/Photon/compare/v76.5.0...v76.6.0) (2026-08-15)


### Bug Fixes

* guard against nil bone position in GetPositionFromRE ([#250](https://github.com/photonle/Photon/issues/250)) ([3a6e2a8](https://github.com/photonle/Photon/commit/3a6e2a8dde0e84458776c2788290bda573ed3d14))
* guard GetVehicleClass and hoist class variable in vehicle name recovery ([#251](https://github.com/photonle/Photon/issues/251)) ([bbabc29](https://github.com/photonle/Photon/commit/bbabc29ab524150c16690353b3939c3a3b68d809))
* Skip lossy matrix round-trip for pure-yaw auto anchors ([#246](https://github.com/photonle/Photon/issues/246)) ([fec7910](https://github.com/photonle/Photon/commit/fec7910b525ad87255022194a02049eb3041c70b))

## [76.5.0](https://github.com/photonle/Photon/compare/v76.4.0...v76.5.0) (2026-08-14)


### Bug Fixes

* Wrap photon scans in protected calls, so we don't kill the entire timer for once broken car. ([#245](https://github.com/photonle/Photon/issues/245)) ([1d0252e](https://github.com/photonle/Photon/commit/1d0252ef09a1e848b21340ff3e48d1e517ad9b7e))

## [76.4.0](https://github.com/photonle/Photon/compare/v76.3.0...v76.4.0) (2026-08-14)


### Features

* Add a hook call when a SimpleNet value changes. ([694e3aa](https://github.com/photonle/Photon/commit/694e3aa1f71c46919833b0373fcbfe3718181e3d))
* Add serverside setters for he values. ([6930f9c](https://github.com/photonle/Photon/commit/6930f9cf3092caa51d5189c400bb3bba7653010c))
* Add shared meta for the string tables. ([98f87b9](https://github.com/photonle/Photon/commit/98f87b9a7a718a16d8b9d92230f8863adadcf2b4))
* Add the 4 strings to our map. ([673edcb](https://github.com/photonle/Photon/commit/673edcb94dfe1734eaa8389aac4a9af82688d811))


### Bug Fixes

* Add entity to hook call. ([c78de01](https://github.com/photonle/Photon/commit/c78de0141d1df30931aa9460f6716666f085f8b4))
* Add resyncing for Photon variables. ([75f4c13](https://github.com/photonle/Photon/commit/75f4c130266bb5bac03cb66b7169737030b1173b))
* capture error properly for SendChange ([95f58b4](https://github.com/photonle/Photon/commit/95f58b45a35b7815cb12da84befa6b7135e0fada))
* Corrected NEQ in Photon signalling handler. ([e134c7e](https://github.com/photonle/Photon/commit/e134c7ec23896b43c23f50294ee0d5cad676bf96))
* Default to . if there's no selections. ([96425ac](https://github.com/photonle/Photon/commit/96425ac0897c99b93ef732c0df6e2aee39a81616))
* Guard against missing or invalid preset data ([2810618](https://github.com/photonle/Photon/commit/2810618e297f33714beb6f539e4f6ba7f3510f11))
* If EMVProps are already set, recreate instead of duplicating. ([279945b](https://github.com/photonle/Photon/commit/279945b493646eac9db015e2e6217347d1e2bfad))
* IsEMV is only valid on vehicles because EMVName() is not valid otherwise ([bc2fb60](https://github.com/photonle/Photon/commit/bc2fb6092b4f0c74272f78d63bca2587fcc1284c))
* Livery ID and Unit Number were swapped, whoops. ([0b26054](https://github.com/photonle/Photon/commit/0b26054beb56cf33119cace2e1db64bb3ad2b459))
* No reason why these shouldn't be on entity. ([eeefbec](https://github.com/photonle/Photon/commit/eeefbec9d1e2a07e49728261da126cdb12701a1b))
* Off-by-one in SimpleNet mapping index bit width ([c6236f8](https://github.com/photonle/Photon/commit/c6236f81761e318d9b4c5d50323fa20bc577f80f))
* Only put vehicles in the EMV vehicle table ([2855f89](https://github.com/photonle/Photon/commit/2855f899555a35bc8dbd6660085da1d4a5037425))
* Only put vehicles in the vehicle table. ([f661b0b](https://github.com/photonle/Photon/commit/f661b0be1f916c3593c4ec5543b5a54df48a6f92))
* Preset data may not always exist. ([5f95dc5](https://github.com/photonle/Photon/commit/5f95dc5504a37d7e496e932f2c7ee7f7b1a8206f))
* Presets may be invalid. ([8c4adb2](https://github.com/photonle/Photon/commit/8c4adb2e99a13992a4d259944214f1b730b0f40a))
* Preventitive fix for off-by-one errors in the index count for mappings. ([69da146](https://github.com/photonle/Photon/commit/69da146bd6402e85efc442e124d0c7cda849a089))
* Recreate EMVProps instead of duplicating them ([89557cd](https://github.com/photonle/Photon/commit/89557cdc9e3e2bc2082a9c455f5b7163a62e50f6))
* Remove extra argument from SimpleNet Get wrappers ([85dc60c](https://github.com/photonle/Photon/commit/85dc60c4e10aa1cfddc8e69451dfe26ff7e5ceb7))
* Remove extra argument. ([7336b3e](https://github.com/photonle/Photon/commit/7336b3ebeb695a0811dcd22b7b9d0a2e3453825b))
* Several functions weren't returning properly. ([317cf61](https://github.com/photonle/Photon/commit/317cf61edc79751efa66bd6fcf3fa2217d2a5b1f))
* Spawn vehicles properly if multiple cars share the same title / name. ([9ebd4b7](https://github.com/photonle/Photon/commit/9ebd4b78394912652aaedef4c63aa5468b73e7a0))
* stop multiplying siren SoundLevel beyond Source SNDLVL ([3638e01](https://github.com/photonle/Photon/commit/3638e015f453649b7db7d3f869e8fa87c4e69e83))
* Stop multiplying siren SoundLevel beyond Source SNDLVL ([217fbcd](https://github.com/photonle/Photon/commit/217fbcd49e99907927f91504bad8c7a418b763d6))
* Suppress errors when spawning vehicles without tables ([3314b48](https://github.com/photonle/Photon/commit/3314b484a9caf276aea123d859219b22a0ac4341))
* suppress errors when spawning vehicles without tables. ([2e246ab](https://github.com/photonle/Photon/commit/2e246ab9176a899cf5f97b1a386e268a23a7f268))
* switch hot path to use GetForEdit. ([1624f3f](https://github.com/photonle/Photon/commit/1624f3fa2e898dd5bb5d8b7b359b342e8e73d7cb))
* Use EMVName as vehicle name recovery fallback ([dffaea8](https://github.com/photonle/Photon/commit/dffaea8ed38483d7e4ea598f605ce1f7a05d6986))
* Use EMVName for fallback if we have it. ([731a7d9](https://github.com/photonle/Photon/commit/731a7d98e6d4ea1ecfdfa6757e59196132962261))
* use vehiclename if it's set. ([3ea7d4b](https://github.com/photonle/Photon/commit/3ea7d4b3d36fc92bf2bedb283be0bf89e5a2e736))
* Use VehicleName in DrawCarLights when set ([f743e02](https://github.com/photonle/Photon/commit/f743e02b4c2425a73dbde46e88760a9965858f68))
* Wrong cache name for cvars.AddChangeCallback so siren stayon wasn't being set. ([e5c4d4d](https://github.com/photonle/Photon/commit/e5c4d4d12fde1360a5032aaa5d43cf66467a02d2))


### Internal Changes

* Load when we recieve the EMV name from the server. ([8723112](https://github.com/photonle/Photon/commit/8723112a39499a076e37b5cef8b25615b299e4b7))
* Network EMV string data via SimpleNet ([e4acb75](https://github.com/photonle/Photon/commit/e4acb754997380b8eaac01f6a0a7b30d143dc243))
* Rebuild the resyncing mechanic. ([78a17bf](https://github.com/photonle/Photon/commit/78a17bfdfbad8ddf1218327b90ecc4b08211cae2))
* Remove and update references to old functions. ([582f6a6](https://github.com/photonle/Photon/commit/582f6a64692a40c026cc3345a0fe391336e9c668))
