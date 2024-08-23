'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "7fb6b715dbb4fd8f266283683c41a75a",
"index.html": "53f94ec143d18aff30d758c6a958a866",
"/": "53f94ec143d18aff30d758c6a958a866",
"version.json": "7af4e8cfb7cd22b96b1a6a0dac3902ad",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"assets/fonts/MaterialIcons-Regular.otf": "135aef35798b47c055eac36e35134a64",
"assets/AssetManifest.json": "40188115d6f1cde1b1b1b56478cfb1ae",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "ab7e8e99c1128a0f763dfdf928f2d546",
"assets/AssetManifest.bin.json": "db370531826b69f29d0e3466935eb830",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/matches.json": "5b7f32bfaad25fe6a4a7a3c360334c76",
"assets/NOTICES": "a30dc91af9e87a84b5b9792b6a153601",
"main.dart.js": "f030ee3af6752ed04d755fce22a63627",
"flutter.js": "f31737fb005cd3a3c6bd9355efd33061",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.js": "87325e67bf77a9b483250e1fb1b54677",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/skwasm.js": "9fa2ffe90a40d062dd2343c7b84caf01",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/canvaskit.js": "5fda3f1af7d6433d53b24083e2219fa0",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
".git/HEAD": "978cf7ce582a3595b9d4daf7cc63115a",
".git/index": "40d912162e083c98034c980e0e9a6883",
".git/COMMIT_EDITMSG": "655d242e09a0059e6c1fb1b459626ad7",
".git/config": "159d8688201c0a562c14a2a7005c555a",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-commit.sample": "305eadbbcd6f6d2567e033ad12aabbc4",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/refs/remotes/origin/ghpages": "f0a9f7c37063b98f4ff63b2c2453326f",
".git/refs/remotes/origin/master": "f0f9ebb2e8aa7852eb08724423b1ad6c",
".git/refs/heads/ghpages": "f0a9f7c37063b98f4ff63b2c2453326f",
".git/FETCH_HEAD": "325806c1732be83142b167c0f15ed609",
".git/logs/HEAD": "b6060ac78ad684619e4f97763d4116bd",
".git/logs/refs/remotes/origin/ghpages": "d4e85026835633acba041c77a804f2ef",
".git/logs/refs/remotes/origin/master": "4b99bf02945b50dba6c936a1da11d23b",
".git/logs/refs/heads/ghpages": "8ed49f6146501ac1aac887f45b7b3de7",
".git/objects/02/f3594e270361895223652b6cb88561b0de24e1": "56d1ecf1a12fc5e83b0bf0b5bc9abb64",
".git/objects/17/1454ef2967d198e4aba0c6870949a5d0ae7d61": "06a3472ddd4c4b137c7f9261510d3167",
".git/objects/17/f671023aa7af5b6565cdadcfa9b67af45b0385": "44e1774f2ad2bba6ccc29400068ca54b",
".git/objects/73/24a30d5e0da72ecf7bb5272738f08395604fca": "7a55d519a63024ce2fd942f8577d610e",
".git/objects/85/6a39233232244ba2497a38bdd13b2f0db12c82": "eef4643a9711cce94f555ae60fecd388",
".git/objects/77/2653736a3348aa60b15c3a41e5a3e016d3431c": "480e98b556059c0418109eb37096f37e",
".git/objects/fb/61b2b5f7d75153834b169155198867e8b20aee": "2f60e4befc12b009c6e9ab10958cf320",
".git/objects/e7/4940e24389c921433e28e5927562e67460bd5a": "caeda771011fc98b1bc4f220a169aedf",
".git/objects/c0/4cc7ff5811179f90b4b31d87d109edd9c73184": "eeafc4dc23e11d41c8b67463815141b5",
".git/objects/8d/35303642daa0cfda394f43dde1ce8a18b07201": "a18f7c4d0271a1477522eccd1cd128d4",
".git/objects/9f/37d195db00d91d94890a7936b19ffbeea9af73": "31c5ec989879c846c8b098639327b73c",
".git/objects/5a/2319808090750a2b1a3cd78722fcde6aa2cb3d": "983f7991456b6e7be941567d3ea13482",
".git/objects/fc/27fc607c965a383434cdcecd8fc2873cf25673": "2bbc0dc0321b9eb428705b1008fe7c4b",
".git/objects/d6/9c56691fbdb0b7efa65097c7cc1edac12a6d3e": "868ce37a3a78b0606713733248a2f579",
".git/objects/eb/9b4d76e525556d5d89141648c724331630325d": "37c0954235cbe27c4d93e74fe9a578ef",
".git/objects/da/78c13ffc997c5db8ba1d073dfd260e7d84c485": "4d9f03820f8be8cd00fb246e70345191",
".git/objects/6b/e909fbf40b23748412f0ea89bf0fae827ed976": "5f118419157d9534688915220cc803f7",
".git/objects/f5/010cda95492006dae3638dfb01a8d0822a1e6a": "04eb9fcdf209b67f396e5ab84cb956e2",
".git/objects/f5/3460761423d4d3182c6be787cc0b37d46b6e30": "8e0be416f7d2687f932c60b690b1cbbf",
".git/objects/8f/e7af5a3e840b75b70e59c3ffda1b58e84a5a1c": "e3695ae5742d7e56a9c696f82745288d",
".git/objects/6a/cb99ab4bd8a8ce6f12c37d7e6bda90e6550e8c": "d5f9770838c0978956b444b3a6435648",
".git/objects/4c/fa3b668ab5f80fbaf2deaaaef382dd3af95d3d": "0600d1d4ea5555d9a8439257fbc207ad",
".git/objects/5d/3071b7c35848b7253fecc0c20815927de94632": "8a29326639d31ad55bc495332019f7e6",
".git/objects/5d/15fadf1864d70c7184fca7d3efde79cdf68af5": "79a44d8578cc18e3add64aa6a97f0da0",
".git/objects/f2/04823a42f2d890f945f70d88b8e2d921c6ae26": "6b47f314ffc35cf6a1ced3208ecc857d",
".git/objects/d2/87d83fa2a33ce391a33afc2c5629f5f10872a8": "251fd45ea56c7aad0924467a11aa51f2",
".git/objects/e2/0a72bb6d9f5a20d1c0da055344efbf3b29e320": "755d0e96206fc9ac1e57be73f3a23d62",
".git/objects/b9/c36e492c6dab39bcd83f776c8eed59a8eeb25e": "370b79e136d364d47d877306c651a26e",
".git/objects/b9/2a0d854da9a8f73216c4a0ef07a0f0a44e4373": "f62d1eb7f51165e2a6d2ef1921f976f3",
".git/objects/71/bc52f9731fe312ebb873227d93f946f95c2179": "b3b97431f85051706a32b4f168e8f271",
".git/objects/e5/edc15bb77773eec17874207066e4c431c222a4": "0d2497b180ae1f4b5e01fb41a44cafaf",
".git/objects/ba/5317db6066f0f7cfe94eec93dc654820ce848c": "9b7629bf1180798cf66df4142eb19a4e",
".git/objects/79/63f872b3e52662857add5f78b4415280ea59e9": "6b320729326c219d6667673217930cb4",
".git/objects/45/4a835029b5a3ed66488afab7d9359589cea41d": "b41e86aafdfdbc49e421b88e64edd818",
".git/objects/97/9f44bbf36fed00d8ea9b2ad6b08a0799237048": "73fb3e113b468dc1d01c2ede9506f9d0",
".git/objects/97/977740018be09e15da356db8543d0603c5f58e": "00a00c5f7953cdf204a790d241e4147f",
".git/objects/97/d3e347663a039b4ffd3601458e8f2e5dafe8f8": "8d4431c3da9ab3c3f266e096cc5ca85e",
".git/objects/ea/4d4e86740a0d03519b51abbe66e3e1bf650e80": "4d3c1f767f5159a52af47d7575110989",
".git/objects/16/5da67191b73406e15fc3e6cf7cda3c195dc735": "86cfac30d97fb45bba2f4417782645d6",
".git/objects/06/7216af57cac1506fa3b81ac53ed0b4e0a4bff8": "f8aa1c6ca07dccfabdd63be2a4ddbceb",
".git/objects/ed/ebd3f42e7cbfe43e53fd68c2b120acd1831489": "536a300272104a9fb31c8c66bfba1108",
".git/objects/a5/3efdf92300d180241adcd14d81d15a734c4e08": "cdce04155deb291d95d5b2a8a45a186e",
".git/objects/88/cfd48dff1169879ba46840804b412fe02fefd6": "e42aaae6a4cbfbc9f6326f1fa9e3380c",
".git/objects/88/f48876d5e6adb3babf7de4416fd688d423d0db": "932cb0138fe2f2160f38d600eff4b016",
".git/objects/32/aa3cae58a7432051fc105cc91fca4d95d1d011": "4f8558ca16d04c4f28116d3292ae263d",
".git/objects/9a/6698dd3f7ce862e3f7957b579af7fd63c115c8": "1b411351ed337fed39077e014a11a664",
".git/objects/fd/206a7cbafa3c9dd40c9c12fe2b60155bd514e5": "358519bf48d4c0dcfaf2e8bb272eb381",
".git/objects/41/6477eeca7290eaa780d7bb35592b9bbddf97b9": "1057c4f10266a814d6d898e1f709df68",
".git/objects/54/1d7dca51a39895e0e5b1444d5ed7458332ec59": "cdc56e16bfc71b30b1c4fcb6fc0a09d3",
".git/objects/8e/1e6021b1b221cb84b17ee874a237df24057bfc": "d3c10ea08f45999605f1d1dcc7841f65",
".git/objects/29/f2c59a5be32766142161bdb0dbde3d9d7231b3": "8fd80cefabd7687e7b983e140d93df27",
".git/objects/b7/49bfef07473333cf1dd31e9eed89862a5d52aa": "36b4020dca303986cad10924774fb5dc",
".git/objects/b7/aa59babf7c66d4927a60512faf22f1efb2067d": "d28b5e7ffde8a2983f272344cb9dbb28",
".git/objects/00/00a05b08b6db21f5da6a32bd5f25fd4e367f31": "e710332148ad6825897c3d222d3ace06",
".git/objects/25/8b3eee70f98b2ece403869d9fe41ff8d32b7e1": "05e38b9242f2ece7b4208c191bc7b258",
".git/objects/19/c78565d1665313d768bbb78fb74a10617a6783": "6fb147c02ced3e188f50c5d73031a01e",
".git/objects/2f/87a128009090f7eda32bb6f29b1ec1a965d092": "fcfcdd2886e55048e0bf1b4334516aae",
".git/objects/60/d49be65f90f59cf24bed3e7be655e95b7179ee": "b4b98f051f201b8569f890921c1cfd0b",
".git/objects/46/4ab5882a2234c39b1a4dbad5feba0954478155": "2e52a767dc04391de7b4d0beb32e7fc4",
".git/objects/b5/8e5feb2eb24d8cef11f1850d1a31372b319932": "15dd32fe660b5b1e27b8822da8e07965",
".git/objects/1d/8fd461ef163e2fa45afca9aaa78ff93fbad4ab": "3c0235d733fd7c9d159dcb978959f395",
".git/objects/1d/792dfdbb1b854ab811217193a9182524a2d8c0": "31f04d63c265915dd790c9f44a1bf1a9",
".git/objects/7b/27f678a38756557781833cbac3138e5169777e": "48e112dc858a59d48e23117e3f7c3aae",
".git/objects/03/eaddffb9c0e55fb7b5f9b378d9134d8d75dd37": "87850ce0a3dd72f458581004b58ac0d6",
".git/objects/20/1afe538261bd7f9a38bed0524669398070d046": "82a4d6c731c1d8cdc48bce3ab3c11172",
".git/objects/20/3426f2bee390f61d7f1d0ac48fcfc55cd5f419": "276894e17ccd261a656c6740f5a74921",
".git/objects/ef/1887e8d7b89c8f17c4db9e971ad634dc4301a4": "930ec00bcb73b499f4b17a1de5da8b1e",
".git/objects/1e/25fb4841dbfcbc6e4fa75d9417a4113ba250bc": "e91280155bc02e320c2a664e7fefc7b5",
".git/objects/d5/c95606efe8c479c8e8102bb8deaf1df3d23440": "a7c4e9ce08f5615017f789fce630e0a2",
".git/objects/d5/b2dece9e72727d96b64974f2c96813f66f8858": "9cc34a4fbd33dcd1f527b2a8be0b6a4f",
".git/objects/d5/641e5bdf91cddfc0eb21327119e5378be04290": "6d5dcb4a414edbbd4c523ef52c86335d",
".git/objects/f3/5de76ef92e31d052be3317ff36d8cb7e6dc5dd": "6c124c825debe7345a7d589805ddf997",
".git/objects/a0/73f42b9a113a6340cadb30691c1f6be4452f69": "d48655824b6d8971bfa48034a31868c3",
".git/objects/0b/076a2b5c4b4781701de580c297b6bedb724188": "4b58dfff198249357eb74db6cbc4ddd4",
".git/objects/52/56717a19993c83c039d383644d15b70174fcff": "6b916070ab26cb169865d463f6b1704c",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/35/1e12ea7d35f70d42defc871ccfa64377dee103": "cecfef7bc2faae54ef8206f51cc462be",
".git/objects/35/0080e10f8322d8e2e649ab47ba24aab284b5c7": "2a6f9e0b26001c74a0da89734dcdc22a",
".git/objects/1f/45b5bcaac804825befd9117111e700e8fcb782": "7a9d811fd6ce7c7455466153561fb479",
".git/objects/de/5341a41654b7043850a621b456f97ae4c2f7d3": "fabadea347580dbcbda5c6d59d8e23f9",
".git/objects/de/4cc5d9ee21f3fe8df376b88a2a1092d6c76b3b": "d0bba29edbfcbb51afae50233e9fd2cd",
".git/objects/a6/192271048ac94c5f8edc3a1ef6f8d5e7b6fa4e": "2b1ecfba1bc54af22297f548b4fd1fc9",
".git/objects/bb/78db98c089a2a1f98726b7eff0c5d98cfff38d": "c4cddf0e72ad6371c329d4ed90f84cd8",
".git/objects/bb/cec6675c9d4cf9fddd9260acad1a3187c2c988": "a46e9a3160621ca1b001154c7f450ff9",
".git/objects/90/bcfcf0a77ab618a826db0fd8b0942963b653af": "fc109675cdf1233dd6599a4c3c0a7a69",
".git/objects/90/249f2815bc3428c506bbb2853655ec6c6f6e8c": "ddd42fed4323f254f72ef5b94291ede8",
".git/objects/62/2812e183a483c769fcdd1c18c32f18d14fe4e1": "8b5920e6ff71b44a701883ff49d1801c",
".git/objects/22/8869ae0b8556a9ddb46dca86fb3ac01326d29c": "35229808a0ea1d3beac9c00b2d80d3ec",
".git/objects/72/406531dd280bb3da4ff9f8d3b883d1401c9eeb": "326f41b9ee18594d29bcdefd0c54fd88",
".git/objects/ec/2895d1b26c47d281c7df42a432bc9f77d11036": "9baaccf2f947574180a0b6eb2685a9fd",
".git/objects/a1/a48445737099b1ed5365bc4237a62dbb1236cb": "d19a21df8813f392c06b00bfe6b0681a",
".git/objects/5c/fd418dec35d20cda50d83e305188d218302f49": "d5d32f9878b89b1a3a7829a85ac69bac",
".git/objects/84/0516208d35dcb4298847ab835e2ef84ada92fa": "36a4a870d8d9c1c623d8e1be329049da",
".git/objects/15/2f15be2b080600235acb2ebf7d0d69f2fde3c8": "3fab32909080241e073ebe185873ce3f",
".git/objects/af/2c30776fde81111d53d5ed76fbc1e939bb3bfe": "430fcd108efa4dc2c642fd11edf8f964",
".git/objects/36/671300ae5c22d3b1cd13a95a7312c5d4964c30": "5cb43ce719a88997d3ec685633f7ad97",
".git/objects/36/28d4ab0177aa94c2b2192256d6cae125eb6eec": "b640a0456c722e505c9ed56d88676518",
".git/objects/69/dd618354fa4dade8a26e0fd18f5e87dd079236": "8cc17911af57a5f6dc0b9ee255bb1a93",
".git/objects/69/37d66022b62a3c040206ef6c13a625e1dc8fee": "69890cb7ac231550ea9ec4771ab26dfc",
".git/objects/a3/787c42da175a7b9709385f609a7e5b4b34fc37": "553d2bf983005b3fccc58a5b4d02aa8f",
".git/objects/a3/10fc075ee6dac4fef3a48230771d958d2c28ce": "de713081944269583e43de5025b45e11",
".git/objects/a2/c2c501d92cade4609fbff2a20d058036a0f07d": "5799cad65f96fe00122233a5625d5041",
".git/objects/a2/38247ab712eba3976bbdbcd1784d85fd8c19ff": "17086542910c8e14d65c7cc1eb85bd62",
".git/objects/a2/ed5c6b7a76a9c36255cb131ef300f68534a406": "adba628447714bccbcf644ae3c7a7791",
".git/objects/c6/2882405dbc561bce33d67b4cf7f0cffdf03897": "8a0d83d07d8f84b55712730856a55a0a",
".git/objects/b6/45cf6e3809f66745af4a9d8d5911243ed71b55": "3ea0a1dcb51d5dc104a6ad21869c7b2f",
".git/objects/78/01e6c3461d4b0180fce8e2fe4100b481828624": "8705c06974fc0c41db9c4eb836742945",
".git/objects/6e/ae82f101da43a8b3a40b2e8e53a523b0bddead": "1388f4158dd16b4cd61677219f0b0fd2",
".git/objects/pack/pack-dcff23262941fef9f68361daec8609784abe0f61.idx": "67b4129c2b54806fcf3bd2789f9756ac",
".git/objects/pack/pack-dcff23262941fef9f68361daec8609784abe0f61.pack": "42b106377c9877c4ea47368037a95a3c",
".git/objects/55/6935abce4408922bd0f137c5f9c747d059b3a4": "75392578413bae6843572c249427280e",
".git/objects/24/1ee447ab2fdb89248110c9ac2e21a0b106979e": "428f261c06f89da591f46e8d9d74ffca",
".git/objects/24/0cc42f0fb42b63ae9ce67d048309138697f314": "92046edb4be5a36774138fa5fdabe0bf",
".git/objects/c1/f5bcd105986a96173f9e19207052c295a11b87": "30f72df00d95f50ab3494f8ac02bb0db",
".git/objects/c1/4069b5f320cde1e0a2d34941c5404cbc0cb1b0": "c840c58868135020b4e6f6c29d55c718",
".git/objects/c1/6e503c6eade5dbe99ab49eea34be0dbdc2d80f": "c34daaac7b9386bd669800acde718735",
".git/objects/01/78be8bf8690c0ecef8452faa634bc2f09bf400": "d13218d4ba1a315d077ccb1e37df52a3",
".git/objects/70/66e22f9b41390776758741e03dadfaafcf5ed7": "eb883814271d4e7e15ac91d35859e2c4",
".git/objects/70/b42aeeae71fe5552fdc102bd2bdf94ed28c8ac": "94f6117afb05675b33561de9cc5afa31",
".git/objects/30/5ee3973fafb27650d5305a2663535931f0f22e": "0a6296fb40adda439110f770b27ab006",
".git/objects/8a/aa46ac1ae21512746f852a42ba87e4165dfdd1": "1d8820d345e38b30de033aa4b5a23e7b",
".git/objects/07/dc4be57bb324fbd4e432af5eeb980887c39f68": "dd740e0080174af5fa831566628f47b9",
".git/objects/3a/d2b390f0b3de3d717978a9950e429c66f9962c": "f279b3353fc94c49effeea8f020f353f",
".git/objects/3a/7525f2996a1138fe67d2a0904bf5d214bfd22c": "ab6f2f6356cba61e57d5c10c2e18739d",
".git/objects/e1/73a53823873b3b5396551cb2a4030be375a32b": "74b6772c4d7339f8f5976a99e4844797",
".git/objects/53/4b02738d9b0b80b53355edcf8a89f66bad02d1": "87b48b661bae7adcba32375438d952d1",
".git/objects/98/57c9b3b0448c92818efc5fda0f206b21914168": "ecbde07c564dabbec0f249821051b8af",
".git/objects/1c/2aab7e1b82587dce486ae6aefbc9cb13da6200": "fdc3bb36595e9483f1bca64efe780490",
".git/objects/cc/46e05440e28e698d8309743c71fd0fcdd9dab6": "9cbe80fbfd85829a7b16c668f0b6ffb6",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
"manifest.json": "f9d0789acb4352691ce0202a2a5418a6"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
