---
title: Teeworlds utilities
date: "2023-07-26"
---

<style nonce="Fg4i6piWbxQWdgGv66UX1V1B5zwNWL4Om8vSTS4QG4I">
  .mr-40 {
    margin-right: 40px;
  }
  .ml-40 {
    margin-left: 40px;
  }
  .mr-20 {
    margin-right: 20px;
  }
  .ml-20 {
    margin-left: 20px;
  }
</style>

This idea came to me when I was looking for a Teeworlds skin renderer.
&nbsp;
The ones that existed didn't suit me, as they didn't really respect the in-game rendering. Either the feet were too far out or the colors were wrong.
&nbsp;
So I decided to make my own toolbox to manipulate Teeworlds assets, which we use on [teedata.net](https://teedata.net) and for the Teedata Discord bot. 
&nbsp;
Indirectly, other people use it, for example, to render skins in a Discord channel that displays messages in real time (fokkonaut's Discord server) or in other projects like [TeeAssembler 2.0](https://teeassembler.developer.li/) that used some part of the Teeworlds utilities code.
&nbsp;
<p align="center" width="100%">
  <img src="/fokkonaut_bridge.png">
</p>
&nbsp;

## Use case examples
### Teeworlds skin rendering

Render a Teeworlds 4K skin with default and custom colors.

```typescript
import {
  Skin,
  ColorCode,
  ColorRGB
} from 'teeworlds-utilities';

const renderTest = async () => {
  const skin = new Skin();

  await skin.load('https://api.skins.tw/database/skins/96AATxN3DEzcGww4QhmduFCsPzaxhZO7Tq6Lh9OI.png');

  skin
    .render()
    .saveRenderAs('default.png', true)
    .colorTee(
      new ColorCode(6619008),
      new ColorRGB(136, 113, 255),
    )
    .render()
    .saveRenderAs('color.png', true);
}

try {
  renderTest();
} catch (err) {
  console.error(err);
}
```

&nbsp;

### Result (4K)

<p align="center" width="100%">
  <img src="/render_default.png" width="30%" class="mr-20" >
  <img src="/render_color.png" width="30%" class="ml-20" >
</p>

&nbsp;

### Scene

A custom scene including a rendered skin.

```typescript
import { Scene } from 'teeworlds-utilities';

const sceneTest = async () => {
  const scene = new Scene(
    'data/scenes/schemes/example.json'
  ).preprocess();

  await scene.renderScene();
  scene.saveScene('scene.png')
}

sceneTest();
```

&nbsp;

### Result

<p align="center" width="100%">
  <img src="/scene.png" width="80%">
</p>

&nbsp;

### Merge asset parts

Here we are going to merge specific parts from a skin (right) to another (left).
Any Teeworlds asset should works.

<p align="center" width="100%">
  <img src="/teedata_skin.png" class="mr-20" >
  <img src="/alien_skin.png" class="ml-20" >
</p>


```typescript
import {
  Skin,
  SkinPart
} from 'teeworlds-utilities';

const mergeTest = async () => {
  const teedata = new Skin();
  await teedata.load('https://teedata.net/databasev2/skins/teedata/teedata.png');

  const sunny = new Skin();
  await sunny.load('https://teedata.net/databasev2/skins/irradiated%20sunny/irradiated%20sunny.png');

  teedata
    .copyParts(
      sunny,
      SkinPart.FOOT,
      SkinPart.FOOT_SHADOW,
      SkinPart.DEFAULT_EYE,
      SkinPart.ANGRY_EYE,
      SkinPart.BLINK_EYE,
      SkinPart.CROSS_EYE,
      SkinPart.HAPPY_EYE,
      SkinPart.SCARY_EYE,
      SkinPart.HAND_SHADOW,
      SkinPart.HAND,
    )
    .setEyeAssetPart(SkinPart.ANGRY_EYE)
    .render()
    .saveAs('skin.png')
    .saveRenderAs('rendered_skin.png', true)
}

try {
  mergeTest();
} catch (err) {
  console.error(err);
}
```

### Result

<p align="center" width="100%">
  <img src="/render_new_skin.png" class="mr-40" >
  <img src="/new_skin.png" class="ml-40" >
</p>

&nbsp;

### More skin configuration

Here we are using the `SkinFull` object to render some in-game feature like the weapon, hands and emote.

```typescript
import {
  Skin,
  Gameskin,
  ColorRGB,
  Emoticon,
  SkinFull,
  GameskinPart,
  EmoticonPart
} from 'teeworlds-utilities';

const fullSkinRenderConfiguration = async () => {
  const teedataSunny = new Skin();
  await teedataSunny.load('skin.png');

  const napolitano = new Gameskin();
  await napolitano.load('https://teedata.net/databasev2/gameskins/napolitano/napolitano.png');

  const emoticon = new Emoticon();
  await emoticon.load('https://teedata.net/databasev2/emoticons/default/default.png');

  teedataSunny
    .colorTee(
      new ColorRGB(255, 255, 255),
      new ColorRGB(255, 255, 255),
    )
    .setOrientation(345);
    
  new SkinFull()
    .setSkin(teedataSunny)
    .setGameskin(napolitano, GameskinPart.HAMMER)
    .setEmoticon(emoticon, EmoticonPart.PART_1_2)
    .process()
    .saveAs('skin_with_weapon_and_emote.png', true);
}

try {
  fullSkinRenderConfiguration();
} catch (err) {
  console.error(err);
}
```

### Result

<p align="center" width="100%">
  <img src="/skin_with_weapon_and_emote.png" >
</p>

&nbsp;

### Other possible result

<p align="center" width="100%">
  <img src="/board.png">
</p>

&nbsp;

## Links

[https://github.com/teeworlds-utilities/teeworlds-utilities](https://github.com/teeworlds-utilities/teeworlds-utilities)

&nbsp;
