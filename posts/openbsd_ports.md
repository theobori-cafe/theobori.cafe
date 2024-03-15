---
title: Porting X11 apps to OpenBSD
date: "2024-03-15"
---

I was getting interested in BSD systems, more specifically OpenBSD, its firewall (`pf`) and more generally its security. Then I wanted to use some programs with a graphical interface such as `xclicker`. But it doesn't exist on the distribution, so I wanted to integrate it.

*By the way, there's a site that explains why OpenBSD is great ([why-openbsd.rocks](https://why-openbsd.rocks/fact)).*

I thought it could be interesting to port/package some games I've played during my childhood such as [Super Mario War](http://smwstuff.net) or [VVVVVV](https://thelettervsixtim.es/index.html).

Before making the game compatible with the distribution, it's best to fetch the port tree ([doc](https://www.openbsd.org/faq/ports/ports.html)) and read the official documentation ([doc](https://www.openbsd.org/faq/ports/guide.html)) to get the essentials.

## OpenBSD environment
&nbsp;

My test environment is just a virtual machine managed by VirtualBox on which [OpenBSD 7.4](https://www.openbsd.org/74.html) has been installed, following the steps [here](https://www.openbsdhandbook.com/installation/).

&nbsp;

To manage X displays, I used `xenodm` which is installed by default on OpenBSD. You can activate its system service with the following command.

```bash
rcctl enable xenodm
```
&nbsp;

And for the windows manager, there's a basic one (cwm) but I opted for i3wm anyway.

## Porting VVVVVV

Few years ago, VVVVVV has released an open source version (engine + levels). The game binary requires a **`data.zip`** file which must be in the same folder, luckily there are options to specify in which folders to look for the fonts and languages.

So that the user doesn't have to fill in all this information himself, I've created a shell script with the appropriate values.

&nbsp;
```bash
#!/bin/sh

NAME=VVVVVV
GAMES_DIR=${TRUEPREFIX}/games/${NAME}
SHARE_DIR=${TRUEPREFIX}/share/${NAME}

cd ${GAMES_DIR}

exec ./${NAME} \
     -fontsdir ${SHARE_DIR}/fonts \
     -langdir ${SHARE_DIR}/lang \
     ${@}
```

&nbsp;

Note that `${TRUEPREFIX}` is not defined in the script, this is normal, it will be replaced by `${SUBST_CMD}` defined in **`/usr/ports/infrastructure/mk/bsd.port.mk`**.

&nbsp;

This is what the game's makefile looks like.

```makefile
COMMENT=	puzzle-platform game

V=		2.4.1
NAME=		VVVVVV
PKGNAME= 	${NAME}-${V}

CATEGORIES=	games

HOMEPAGE=	http://thelettervsixtim.es

MAINTAINER=	Theo Bori <nagi@tilde.team>

EXTRACT_SUFX=	.zip

WRKSRC=		${WRKDIST}/${NAME}/desktop_version

SITES= 		https://github.com/terrycavanagh/${NAME}/releases/download/${V}/
SITES.a=	${HOMEPAGE}/makeandplay/

DISTFILES=	${PKGNAME}${EXTRACT_SUFX}
DISTFILES.a=	vvvvvv-mp-linux-02132024${EXTRACT_SUFX}

# Bsd-like
PERMIT_PACKAGE=	Yes

WANTLIB+=	c SDL2 physfs tinyxml2 FAudio

LIB_DEPENDS=	devel/sdl2 \
		devel/physfs \
		audio/faudio \
		textproc/tinyxml2

CXXFLAGS+= 	-I${PREFIX}/include

MODULES=	devel/cmake

CONFIGURE_ARGS=		-DBUNDLE_DEPENDENCIES="OFF"

do-extract:
	unzip ${FULLDISTDIR}/${PKGNAME}${EXTRACT_SUFX} -d ${WRKDIR}/
	unzip ${FULLDISTDIR}/vvvvvv-mp-linux-02132024${EXTRACT_SUFX} -d ${WRKDIR}/${PKGNAME}-data

do-install:
	${INSTALL_DATA_DIR} ${PREFIX}/games/${NAME}
	${INSTALL_PROGRAM} ${WRKBUILD}/${NAME} ${PREFIX}/games/${NAME}/${NAME}

	${SUBST_CMD} -c -m 755 ${FILESDIR}/${NAME} ${PREFIX}/bin/${NAME}

post-install:
	${INSTALL_DATA} ${WRKDIR}/${PKGNAME}-data/data.zip ${PREFIX}/games/${NAME}

	${INSTALL_DATA_DIR} ${PREFIX}/share/${NAME}

.for d in lang licenses fonts
	cp -r ${WRKDIR}/${PKGNAME}-data/${d} ${PREFIX}/share/${NAME}
.endfor

.include <bsd.port.mk>
```

&nbsp;

As you can see, I had to override some of the BSD port makefile targets, because, actually this ports is a little bit special. It must download multiple distfiles from different sites (see below).

```makefile
SITES= 		https://github.com/terrycavanagh/${NAME}/releases/download/${V}/
SITES.a=	${HOMEPAGE}/makeandplay/

DISTFILES=	${PKGNAME}${EXTRACT_SUFX}
DISTFILES.a=	vvvvvv-mp-linux-02132024${EXTRACT_SUFX}
```

&nbsp;

Moreover, there were conflicts with the extracted files names, so I had to rename the directory containing **`data.zip`**.

```makefile
do-extract:
	unzip ${FULLDISTDIR}/${PKGNAME}${EXTRACT_SUFX} -d ${WRKDIR}/
	unzip ${FULLDISTDIR}/vvvvvv-mp-linux-02132024${EXTRACT_SUFX} -d ${WRKDIR}/${PKGNAME}-data
```

&nbsp;

Also, we didn't want to build the dependencies using the github modules, because obviously, the released zip file doesn't have a **`.git`** folder inside.

&nbsp;

I've also patched a few source files, the full port is available  [here](https://github.com/theobori/openbsd-ports/tree/main/games/VVVVVV).

&nbsp;

## Links

[My OpenBSD ports](https://github.com/theobori/openbsd-ports)

&nbsp;
