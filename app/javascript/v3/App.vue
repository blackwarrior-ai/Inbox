<script>
import SnackbarContainer from './components/SnackBar/Container.vue';

const PUBLIC_AUTH_ROUTE_NAMES = [
  'login',
  'sso_login',
  'auth_signup',
  'auth_confirmation',
  'auth_verify_email',
  'auth_password_edit',
  'auth_reset_password',
];

export default {
  components: { SnackbarContainer },
  data() {
    return { theme: 'light' };
  },
  computed: {
    usesLoginBackground() {
      return PUBLIC_AUTH_ROUTE_NAMES.includes(this.$route.name);
    },
  },
  mounted() {
    this.setColorTheme();
    this.listenToThemeChanges();
    this.setLocale(window.chatwootConfig.selectedLocale);
  },
  methods: {
    setColorTheme() {
      if (window.matchMedia('(prefers-color-scheme: dark)').matches) {
        this.theme = 'dark';
        document.documentElement.classList.add('dark');
      } else {
        this.theme = 'light';
        document.documentElement.classList.remove('dark');
      }
    },
    listenToThemeChanges() {
      const mql = window.matchMedia('(prefers-color-scheme: dark)');

      mql.onchange = e => {
        if (e.matches) {
          this.theme = 'dark';
          document.documentElement.classList.add('dark');
        } else {
          this.theme = 'light';
          document.documentElement.classList.remove('dark');
        }
      };
    },
    setLocale(locale) {
      if (locale) {
        this.$root.$i18n.locale = locale;
      }
    },
  },
};
</script>

<template>
  <div
    class="h-full min-h-screen w-full antialiased"
    :class="[theme, { 'digilink-login-bg': usesLoginBackground }]"
  >
    <router-view />
    <SnackbarContainer />
  </div>
</template>

<style lang="scss">
@tailwind base;
@tailwind components;
@tailwind utilities;

@import '../dashboard/assets/scss/next-colors';

html,
body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto,
    Oxygen-Sans, Ubuntu, Cantarell, 'Helvetica Neue', sans-serif;
  @apply h-full w-full;

  input,
  select {
    outline: none;
  }
}

.text-link {
  @apply text-n-brand font-medium hover:text-n-blue-10;
}

.digilink-login-bg {
  background-image: url('/brand-assets/digilink-login-bg.jpeg');
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  background-attachment: fixed;
}

/* Readable hero (logo/title above the frosted panel on photo bg) */
.digilink-login-bg .digilink-auth-hero img {
  filter: drop-shadow(0 2px 10px rgb(0 0 0 / 0.3));
}

.digilink-login-bg .digilink-auth-hero h2 {
  color: #fff;
  text-shadow:
    0 2px 4px rgb(0 0 0 / 0.28),
    0 12px 36px rgb(0 0 0 / 0.45);
}

.digilink-login-bg .digilink-auth-hero p {
  color: rgb(255 255 255 / 0.92);
  text-shadow: 0 2px 14px rgb(0 0 0 / 0.38);
}

.digilink-login-bg .digilink-auth-hero a.text-link,
.digilink-login-bg .digilink-auth-hero .text-link {
  color: rgb(255 252 248);
  font-weight: 600;
  text-decoration: underline;
  text-decoration-color: rgb(255 255 255 / 0.45);
  text-underline-offset: 3px;
}

.digilink-login-bg .digilink-auth-hero a.text-link:hover,
.digilink-login-bg .digilink-auth-hero .text-link:hover {
  color: #fff;
  text-decoration-color: rgb(255 255 255 / 0.9);
}

.digilink-login-bg .digilink-auth-footer-muted,
.digilink-login-bg .digilink-auth-footer-muted p {
  color: rgb(255 255 255 / 0.9);
  text-shadow: 0 2px 12px rgb(0 0 0 / 0.35);
}

.digilink-login-bg .digilink-auth-footer-muted a.text-link,
.digilink-login-bg .digilink-auth-footer-muted .text-link {
  color: rgb(255 252 248);
  font-weight: 600;
  text-decoration: underline;
  text-decoration-color: rgb(255 255 255 / 0.5);
}

.digilink-login-bg .digilink-auth-footer-muted a.text-link:hover,
.digilink-login-bg .digilink-auth-footer-muted .text-link:hover {
  color: #fff;
  text-decoration-color: rgb(255 255 255 / 0.95);
}

/* OAuth / SSO row buttons — match frosted chrome */
.digilink-login-bg a.digilink-auth-social-btn {
  background: rgb(255 255 255 / 0.4);
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  border-radius: 0.75rem;
  box-shadow: 0 1px 2px rgb(15 23 42 / 0.06);
  --tw-ring-color: rgb(255 255 255 / 0.55);
}

.digilink-login-bg.dark a.digilink-auth-social-btn {
  background: rgb(30 41 59 / 0.45);
  --tw-ring-color: rgb(148 163 184 / 0.28);
}

.digilink-login-bg a.digilink-auth-social-btn:hover {
  background: rgb(255 255 255 / 0.52);
}

.digilink-login-bg.dark a.digilink-auth-social-btn:hover {
  background: rgb(51 65 85 / 0.55);
}

/* Frosted glass sign-in / auth panels — transparent, sharp corners */
.digilink-login-bg .digilink-auth-glass-panel {
  position: relative;
  isolation: isolate;
  margin-left: auto;
  margin-right: auto;
  width: 100%;
  max-width: 31rem;
  padding: 2rem 2rem 1.75rem;
  border-radius: 1rem;
  background: rgb(0 0 0 / 0.05);
  border: 1px solid rgb(255 255 255 / 0.20);
  box-shadow: none;
  backdrop-filter: blur(6px);
  -webkit-backdrop-filter: blur(6px);
}

.digilink-login-bg.dark .digilink-auth-glass-panel {
  background: rgb(0 0 0 / 0.22);
  border-color: rgb(255 255 255 / 0.18);
}

.digilink-login-bg .digilink-glass-card-title {
  margin: 0;
  font-size: 1.75rem;
  font-weight: 700;
  line-height: 1.2;
  letter-spacing: -0.02em;
  color: #fff;
  text-align: left;
  text-shadow: 0 2px 16px rgb(0 0 0 / 0.25);
}

.digilink-login-bg .digilink-glass-card-subtitle {
  margin: 0.5rem 0 0;
  font-size: 0.875rem;
  font-weight: 400;
  line-height: 1.45;
  color: rgb(255 255 255 / 0.88);
  text-align: left;
  text-shadow: 0 1px 10px rgb(0 0 0 / 0.28);
}

.digilink-login-bg .digilink-auth-primary-btn {
  border-radius: 0.6rem !important;
  background: #9a6a6a !important;
  color: #fff !important;
  outline: none !important;
  font-weight: 600 !important;
  box-shadow: 0 8px 24px rgb(0 0 0 / 0.2);
}

.digilink-login-bg .digilink-auth-primary-btn:hover:enabled {
  filter: brightness(1.07);
}

.digilink-login-bg .digilink-auth-primary-btn:focus-visible {
  outline: 2px solid rgb(255 255 255 / 0.65) !important;
  outline-offset: 2px;
}

.digilink-login-bg .digilink-auth-glass-panel a.digilink-auth-social-btn,
.digilink-login-bg .digilink-auth-glass-panel a.digilink-auth-social-btn span {
  color: rgb(255 255 255 / 0.95);
}

.digilink-login-bg .digilink-auth-glass-panel a.digilink-auth-social-btn svg,
.digilink-login-bg .digilink-auth-glass-panel a.digilink-auth-social-btn [class*='icon'] {
  color: rgb(255 255 255 / 0.9);
}

.digilink-login-bg .digilink-glass-checkbox {
  width: 1.125rem;
  height: 1.125rem;
  flex-shrink: 0;
  border-radius: 0.35rem;
  border: 1px solid rgb(255 255 255 / 0.85);
  background: rgb(255 255 255 / 0.18);
  accent-color: #9a6a6a;
  cursor: pointer;
}

.digilink-login-bg .digilink-glass-or-divider [aria-hidden='true'] .border-t {
  border-color: rgb(255 255 255 / 0.32);
}

.digilink-login-bg .digilink-glass-or-divider span {
  color: rgb(255 255 255 / 0.88);
  background: transparent !important;
}

.digilink-login-bg .digilink-auth-glass-panel label:not(.sr-only),
.digilink-login-bg .digilink-auth-glass-signup-panel label:not(.sr-only) {
  color: rgb(255 255 255 / 0.95);
  font-size: 0.875rem;
  font-weight: 500;
}

.digilink-login-bg .digilink-auth-glass-panel .text-n-ruby-9,
.digilink-login-bg .digilink-auth-glass-signup-panel .text-n-ruby-9 {
  color: rgb(254 202 202 / 0.98);
}

.digilink-login-bg .digilink-auth-glass-signup-panel {
  position: relative;
  isolation: isolate;
  overflow: hidden;
  border-radius: 1.85rem;
  width: auto;
  max-width: 960px;
  background: linear-gradient(
    165deg,
    rgb(255 255 255 / 0.2) 0%,
    rgb(255 255 255 / 0.07) 100%
  );
  border: 1px solid rgb(255 255 255 / 0.82);
  box-shadow:
    0 4px 32px rgb(0 0 0 / 0.16),
    inset 0 1px 0 rgb(255 255 255 / 0.5);
  backdrop-filter: blur(40px) saturate(1.4);
  -webkit-backdrop-filter: blur(40px) saturate(1.4);
}

.digilink-login-bg.dark .digilink-auth-glass-signup-panel {
  background: linear-gradient(
    165deg,
    rgb(51 65 85 / 0.42) 0%,
    rgb(15 23 42 / 0.48) 100%
  );
  border-color: rgb(255 255 255 / 0.18);
  box-shadow:
    0 8px 40px rgb(0 0 0 / 0.42),
    inset 0 1px 0 rgb(255 255 255 / 0.06);
}

.v-popper--theme-tooltip .v-popper__inner {
  background: black !important;
  font-size: 0.75rem;
  padding: 4px 8px !important;
  border-radius: 6px;
  font-weight: 400;
}

.v-popper--theme-tooltip .v-popper__arrow-container {
  display: none;
}
</style>
