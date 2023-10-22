---
title: Teeworlds utilities
date: "2023-07-26"
---


This idea came to me when I was looking for a Teeworlds skin renderer.
&nbsp;
The ones that existed didn't suit me, as they didn't really respect the in-game rendering. Either the feet were too far out or the colors were wrong.
&nbsp;
So I decided to make my own toolbox to manipulate Teeworlds assets, which we use on [teedata.net](https://teedata.net) and for the Teedata Discord bot. 
&nbsp;
Indirectly, other people use it, for example, to render skins in a Discord channel that displays messages in real time (fokkonaut's Discord server) or in other projects like [TeeAssembler 2.0](https://teeassembler.developer.li/) that used some part of the **`teeworlds-utilites`** code.
&nbsp;
<p align="center" width="100%">
  <img src="/fokkonaut_bridge.png">
</p>
&nbsp;

## Use cases
&nbsp;
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
  <img src="/render_color.png" width="30%" style="margin-right: 40px">
  <img src="/render_default.png" width="30%" style="margin-left: 40px">
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
  <img src="/teedata_skin.png" style="margin-right: 20px">
  <img src="/alien_skin.png" style="margin-left: 20px">
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
  <img src="/render_new_skin.png" style="margin-right: 40px">
  <img src="/new_skin.png" style="margin-left: 40px">
</p>

### Other result

<p align="center" width="100%">
  <img src="/board.png">
</p>

&nbsp;

[*Source*](https://github.com/teeworlds-utilities/teeworlds-utilities)
