const words = [
    'Something is happening. Please wait.',
    'Please be patient. This may take a while.',
    'While you wait, please consider that this is a good time to take a break.',
    'Please wait. This is a good time to go grab a cup of coffee.',
    'Sometimes the things that are worth waiting for take time.',
    'Please wait. This is a good time to stretch your legs.',
    'Posture check! Please wait while we load the application.',
];

const loaderImageNames = [
    'accordion.png',
    'alert.png',
    'alert_dialog.png',
    'animatedvaluebuilder.png',
    'avatar.png',
    'avatar_group.png',
    'badge.png',
    'breadcrumb.png',
    'button.png',
    'calendar.png',
    'card.png',
    'carousel.png',
    'checkbox.png',
    'chip_input.png',
    'circular_progress.png',
    'codesnippet.png',
    'collapsible.png',
    'colorpicker.png',
    'command.png',
    'context_menu.png',
    'datepicker.png',
    'dialog.png',
    'divider.png',
    'drawer.png',
    'dropdown_menu.png',
    'form.png',
    'hover_card.png',
    'input.png',
    'inputotp.png',
    'menubar.png',
    'navigation_menu.png',
    'number_ticker.png',
    'pagination.png',
    'phone_input.png',
    'popover.png',
    'progress.png',
    'radiogroup.png',
    'repeatedanimationbuilder.png',
    'resizable.png',
    'select.png',
    'sheet.png',
    'skeleton.png',
    'slider.png',
    'star_rating.png',
    'stepper.png',
    'steps.png',
    'switch.png',
    'tablist.png',
    'tabs.png',
    'textarea.png',
    'time_picker.png',
    'timeline.png',
    'toast.png',
    'toggle.png',
    'tooltip.png',
    'tracker.png',
    'tree.png',
];

const titleize = (filename) =>
    filename
        .replace('.png', '')
        .split('_')
        .map((part) => part.charAt(0).toUpperCase() + part.slice(1))
        .join(' ');

const loaderItems = loaderImageNames.map((name) => {
    const title = titleize(name);
    return {
        title: title,
        description: `Loading ${title} component…`,
        src: `assets/assets/docs_images/${name}`,
    };
});

const shuffledLoaderItems = [...loaderItems];
for (let i = shuffledLoaderItems.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [shuffledLoaderItems[i], shuffledLoaderItems[j]] = [shuffledLoaderItems[j], shuffledLoaderItems[i]];
}

const loaderWidget = `
<div class="docs-loader-shell">
    <div id="docs-loader-title" class="docs-loader-title"></div>
    <div class="docs-loader-carousel">
        <div class="docs-loader-cards" id="docs-loader-cards">
            <div class="docs-loader-card docs-loader-ghost docs-loader-ghost-3"></div>
            <div class="docs-loader-card docs-loader-ghost docs-loader-ghost-2"></div>
            <div class="docs-loader-card docs-loader-ghost docs-loader-ghost-1"></div>
            <div class="docs-loader-card docs-loader-main" id="docs-loader-main"></div>
        </div>
    </div>
    <div id="docs-loader-subtitle" class="docs-loader-subtitle"></div>
</div>
`;

const shadcn_flutter_kit_config = {
    loaderWidget: loaderWidget,
    backgroundColor: '#121212',
    foregroundColor: null,
    loaderColor: null,
    loaderImages: shuffledLoaderItems.map((item) => item.src),
    loaderLayeredImages: [],
    loaderImageSize: 360,
    loaderFrameDuration: 900,
    loaderAnimationMode: 'frame',
    loaderBlur: 0,
    loaderGlassOpacity: 0.08,
    fontFamily: 'Geist Sans',
    fontSize: '24px',
    fontWeight: '400',
    mainAxisAlignment: 'center',
    crossAxisAlignment: 'center',
    transitionDuration: 500,
    externalScripts: [
        {
            src: 'https://cdn.jsdelivr.net/npm/@fontsource/geist-sans@5.0.3/400.min.css',
            type: 'stylesheet',
        },
        {
            src: 'https://cdn.jsdelivr.net/npm/@fontsource/geist-sans@5.0.3/300.min.css',
            type: 'stylesheet',
        },
    ]
};

class ShadcnAppConfig {
    backgroundColor;
    foregroundColor;
    fontFamily;
    fontSize;
    fontWeight;
    mainAxisAlignment;
    crossAxisAlignment;
    loaderWidget;
    loaderColor;
    loaderImages;
    loaderLayeredImages;
    loaderImageSize;
    loaderFrameDuration;
    loaderAnimationMode;
    loaderBlur;
    loaderGlassOpacity;
    externalScripts;
    transitionDuration;
    storagePrefix;

    constructor({ backgroundColor, foregroundColor, fontFamily, fontSize, fontWeight, mainAxisAlignment, crossAxisAlignment, loaderWidget, loaderColor, loaderImages, loaderLayeredImages, loaderImageSize, loaderFrameDuration, loaderAnimationMode, loaderBlur, loaderGlassOpacity, externalScripts, transitionDuration, storagePrefix }) {
        this.backgroundColor = backgroundColor;
        this.foregroundColor = foregroundColor;
        this.fontFamily = fontFamily;
        this.fontSize = fontSize;
        this.fontWeight = fontWeight;
        this.mainAxisAlignment = mainAxisAlignment;
        this.crossAxisAlignment = crossAxisAlignment;
        this.loaderWidget = loaderWidget;
        this.loaderColor = loaderColor;
        this.loaderImages = loaderImages;
        this.loaderLayeredImages = loaderLayeredImages;
        this.loaderImageSize = loaderImageSize;
        this.loaderFrameDuration = loaderFrameDuration;
        this.loaderAnimationMode = loaderAnimationMode || 'frame';
        this.loaderBlur = loaderBlur || 0;
        this.loaderGlassOpacity = loaderGlassOpacity ?? 0.1;
        this.externalScripts = externalScripts;
        this.storagePrefix = storagePrefix || 'shadcn_flutter_kit';

        if (this.backgroundColor == null) {
            this.backgroundColor = localStorage.getItem(`${this.storagePrefix}.background`) || '#09090b';
        }
        if (this.foregroundColor == null) {
            this.foregroundColor = localStorage.getItem(`${this.storagePrefix}.foreground`) || '#ffffff';
        }
        if (this.loaderColor == null) {
            this.loaderColor = localStorage.getItem(`${this.storagePrefix}.primary`) || '#3c83f6';
        }

        this.transitionDuration = transitionDuration || 0;
    }
}

class ShadcnAppThemeChangedEvent extends CustomEvent {
    constructor(theme) {
        super('shadcn_flutter_theme_changed', { detail: theme });
    }
}

class ShadcnAppTheme {
    background;
    foreground;
    primary;

    constructor(background, foreground, primary) {
        this.background = background;
        this.foreground = foreground;
        this.primary = primary;
    }
}

class ShadcnApp {
    config;
    #frameInterval;

    constructor(config) {
        this.config = config;
    }

    loadApp() {
        this.#initializeDocument();
        this.#mountDocsLoader();
        this.#startDocsImageLoader();
        this.#loadExternalScripts(0);
        window.addEventListener('shadcn_flutter_app_ready', () => this.onAppReady());
        window.addEventListener('shadcn_flutter_theme_changed', (event) => this.onThemeChanged(event));
        if (globalThis.shadcnAppLoaded) {
            this.onAppReady();
        }
    }

    #loadExternalScripts(index, onDone) {
        if (index >= this.config.externalScripts.length) {
            if (onDone) {
                onDone();
            }
            return;
        }
        this.#loadScriptDynamically(this.config.externalScripts[index], () => {
            this.#loadExternalScripts(index + 1, onDone);
        });
    }

    #createStyleSheet(css, id) {
        if (id) {
            const existingStyle = document.getElementById(id);
            if (existingStyle) {
                existingStyle.remove();
            }
        }
        const style = document.createElement('style');
        if (id) {
            style.id = id;
        }
        style.appendChild(document.createTextNode(css));
        document.head.appendChild(style);
    }

    #loadScriptDynamically(src, callback) {
        if (typeof src === 'string') {
            src = { src: src, type: 'script' };
        }
        if (src.type === 'script') {
            const script = document.createElement('script');
            script.src = src.src;
            script.onload = callback;
            document.body.appendChild(script);
        } else if (src.type === 'module') {
            const script = document.createElement('script');
            script.type = 'module';
            script.src = src.src;
            script.onload = callback;
            document.body.appendChild(script);
        } else if (src.type === 'stylesheet') {
            const link = document.createElement('link');
            link.rel = 'stylesheet';
            link.href = src.src;
            link.onload = callback;
            document.head.appendChild(link);
        } else {
            throw new Error('Unknown type of file to load: ' + src);
        }
    }

    #initializeDocument() {
        const loaderStyle = `
            display: flex;
            justify-content: ${this.config.mainAxisAlignment};
            align-items: ${this.config.crossAxisAlignment};
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: ${this.config.backgroundColor};
            background-image: radial-gradient(circle at center, rgba(0,0,0,0) 0%, rgba(0,0,0,0.55) 90%);
            color: ${this.config.foregroundColor};
            z-index: 9998;
            font-family: ${this.config.fontFamily};
            font-size: ${this.config.fontSize};
            font-weight: ${this.config.fontWeight};
            text-align: center;
            transition: opacity ${this.config.transitionDuration}ms;
            opacity: 1;
            pointer-events: initial;
        `;

        const loaderBarCss = `
        .docs-loader-shell {
          display: flex;
          flex-direction: column;
          align-items: center;
          gap: 18px;
          text-align: center;
          max-width: 860px;
          padding: 0 24px;
        }
        .docs-loader-title {
          font-size: 18px;
          font-weight: 500;
          color: rgba(255, 255, 255, 0.6);
          letter-spacing: 0.2px;
        }
        .docs-loader-carousel {
          display: flex;
          align-items: center;
          justify-content: center;
          width: min(420px, 90vw);
          height: 320px;
          position: relative;
        }
        .docs-loader-cards {
          position: relative;
          flex: 1;
          height: 100%;
        }
        .docs-loader-card {
          position: absolute;
          top: 50%;
          left: 50%;
          width: min(230px, 66vw);
          height: min(280px, 66vw);
          transform: translate(-50%, -50%);
          border-radius: 16px;
          background: rgba(20, 20, 20, 1);
          border: 1.2px solid rgba(255, 255, 255, 0.55);
          box-shadow: 0 22px 46px rgba(0, 0, 0, 0.55);
          background-size: cover;
          background-position: center;
          transition: transform 220ms ease-out, opacity 220ms ease-out, border-color 220ms ease-out;
        }
        .docs-loader-main {
          z-index: 4;
        }
        .docs-loader-main.swap {
          animation: loaderCardSwap 220ms ease-out;
        }
        .docs-loader-ghost {
          border-color: rgba(255, 255, 255, 0.2);
          background: rgba(20, 20, 20, 0.4);
          box-shadow: none;
          opacity: 0.5;
        }
        .docs-loader-ghost-1 {
          transform: translate(-50%, -50%) translateX(-28px) translateY(6px) rotate(-6deg) scale(0.98);
          opacity: 0.55;
        }
        .docs-loader-ghost-2 {
          transform: translate(-50%, -50%) translateX(22px) translateY(10px) rotate(6deg) scale(0.96);
          opacity: 0.4;
        }
        .docs-loader-ghost-3 {
          transform: translate(-50%, -50%) translateY(14px) scale(0.94);
          opacity: 0.28;
        }
        .docs-loader-subtitle {
          font-size: 18px;
          opacity: 0.65;
          font-weight: 400;
          max-width: 760px;
          line-height: 1.35;
        }
        @keyframes loaderCardSwap {
          0% { opacity: 0.15; transform: translate(-50%, -50%) scale(0.92); }
          100% { opacity: 1; transform: translate(-50%, -50%) scale(1); }
        }`;

        const loaderDiv = document.createElement('div');
        loaderDiv.id = 'shadcn-web-loader';
        loaderDiv.style.cssText = loaderStyle;
        loaderDiv.innerHTML = this.config.loaderWidget;

        document.body.appendChild(loaderDiv);

        document.body.style.backgroundColor = this.config.backgroundColor;

        this.#createStyleSheet(loaderBarCss, 'web-preloader-style');
    }

    #mountDocsLoader() {
        const mainCard = document.getElementById('docs-loader-main');
        if (!mainCard) {
            return;
        }
        mainCard.style.backgroundImage = `url(${this.config.loaderImages?.[0] || ''})`;
        const ghosts = Array.from(document.querySelectorAll('.docs-loader-ghost'));
        ghosts.forEach((ghost, idx) => {
            const ghostIndex = (idx + 1) % shuffledLoaderItems.length;
            ghost.style.backgroundImage = `url(${shuffledLoaderItems[ghostIndex].src})`;
        });
    }

    #startDocsImageLoader() {
        const mainCard = document.getElementById('docs-loader-main');
        const ghostCards = Array.from(document.querySelectorAll('.docs-loader-ghost'));
        const titleEl = document.getElementById('docs-loader-title');
        const subtitleEl = document.getElementById('docs-loader-subtitle');
        if (!mainCard || !this.config.loaderImages?.length) {
            return;
        }
        let index = 0;
        const duration = this.config.loaderFrameDuration || 1200;

        const applyIndex = (nextIndex) => {
            const item = shuffledLoaderItems[nextIndex];
            if (titleEl && item?.title) {
                titleEl.textContent = item.title;
            }
            if (subtitleEl && item?.description) {
                subtitleEl.textContent = item.description;
            }
            mainCard.classList.remove('swap');
            void mainCard.offsetWidth;
            mainCard.classList.add('swap');
            mainCard.style.backgroundImage = `url(${item.src})`;

            if (ghostCards.length) {
                const ghostIndices = [
                    (nextIndex - 1 + shuffledLoaderItems.length) % shuffledLoaderItems.length,
                    (nextIndex + 1) % shuffledLoaderItems.length,
                    (nextIndex + 2) % shuffledLoaderItems.length,
                ];
                ghostCards.forEach((ghost, ghostIdx) => {
                    ghost.style.backgroundImage = `url(${shuffledLoaderItems[ghostIndices[ghostIdx]].src})`;
                });
            }
        };

        applyIndex(index);
        this.#frameInterval = setInterval(() => {
            index = (index + 1) % this.config.loaderImages.length;
            applyIndex(index);
        }, duration);
    }

    #stopDocsImageLoader() {
        if (this.#frameInterval) {
            clearInterval(this.#frameInterval);
            this.#frameInterval = null;
        }
    }

    onAppReady() {
        const loaderDiv = document.getElementById('shadcn-web-loader');
        if (!loaderDiv) {
            return;
        }
        this.#stopDocsImageLoader();
        loaderDiv.style.opacity = 0;
        loaderDiv.style.pointerEvents = 'none';

        setTimeout(() => {
            loaderDiv.remove();
        }, this.config.transitionDuration + 50);
    }

    onThemeChanged(event) {
        let theme = event.detail;
        let background = theme['background'];
        let foreground = theme['foreground'];
        let primary = theme['primary'];
        localStorage.setItem(`${this.config.storagePrefix}.background`, background);
        localStorage.setItem(`${this.config.storagePrefix}.foreground`, foreground);
        localStorage.setItem(`${this.config.storagePrefix}.primary`, primary);
    }
}

globalThis.ShadcnApp = ShadcnApp;
globalThis.ShadcnAppConfig = ShadcnAppConfig;
globalThis.ShadcnAppThemeChangedEvent = ShadcnAppThemeChangedEvent;
globalThis.ShadcnAppTheme = ShadcnAppTheme;

const shadcn_flutter = new ShadcnApp(new ShadcnAppConfig(shadcn_flutter_kit_config));
document.addEventListener('DOMContentLoaded', () => {
    shadcn_flutter.loadApp();
});
