<script setup>
import { ref, nextTick, computed, onMounted } from 'vue';
import { useStore } from 'vuex';
import { required, email } from '@vuelidate/validators';
import { useVuelidate } from '@vuelidate/core';
import { useI18n } from 'vue-i18n';
import { useAlert } from 'dashboard/composables';

// components
import FormInput from '../../components/Form/Input.vue';
import NextButton from 'dashboard/components-next/button/Button.vue';

const props = defineProps({
  authError: {
    type: String,
    default: '',
  },
  target: {
    type: String,
    default: 'web',
  },
});

const store = useStore();
const { t } = useI18n();

const credentials = ref({
  email: '',
});

const loginApi = ref({
  showLoading: false,
  hasErrored: false,
});

const handleAuthError = () => {
  if (!props.authError) {
    return;
  }

  const translatedMessage = t('LOGIN.SAML.API.ERROR_MESSAGE');
  useAlert(translatedMessage);
  loginApi.value.hasErrored = true;
};

const validations = {
  credentials: {
    email: {
      required,
      email,
    },
  },
};

const v$ = useVuelidate(validations, { credentials });

const globalConfig = computed(() => store.getters['globalConfig/get']);
const csrfToken = ref('');

onMounted(async () => {
  csrfToken.value =
    document
      .querySelector('meta[name="csrf-token"]')
      ?.getAttribute('content') || '';

  await nextTick(handleAuthError);
});
</script>

<template>
  <main
    class="relative flex flex-col justify-center w-full min-h-screen py-10 bg-transparent sm:px-6 lg:px-8"
  >
    <img
      :src="'/brand-assets/digilink-topright-logo.png'"
      alt="Digilink"
      class="absolute top-3 left-4 h-11 w-auto object-contain"
    />
    <section
      class="digilink-auth-glass-panel mx-auto w-full"
      :class="{
        'animate-wiggle': loginApi.hasErrored,
      }"
    >
      <form
        class="space-y-5"
        method="POST"
        action="/api/v1/auth/saml_login"
      >
        <FormInput
          v-model="credentials.email"
          name="email"
          type="text"
          appearance="glass"
          hide-field-label
          trailing-decor="user"
          :tabindex="1"
          required
          :label="t('LOGIN.SAML.WORK_EMAIL.LABEL')"
          :placeholder="t('LOGIN.SAML.WORK_EMAIL.PLACEHOLDER')"
          :has-error="v$.credentials.email.$error"
          @input="v$.credentials.email.$touch"
        />
        <input
          type="hidden"
          class="h-0"
          name="authenticity_token"
          :value="csrfToken"
        />
        <input type="hidden" class="h-0" name="target" :value="target" />
        <NextButton
          lg
          type="submit"
          class="digilink-auth-primary-btn w-full !outline-none"
          :tabindex="2"
          :label="t('LOGIN.SAML.SUBMIT')"
          :disabled="loginApi.showLoading"
          :is-loading="loginApi.showLoading"
        />
      </form>
    </section>
    <p class="mt-6 text-sm text-center digilink-auth-footer-muted">
      <router-link to="/app/login" class="text-link text-n-brand">
        {{ t('LOGIN.SAML.BACK_TO_LOGIN') }}
      </router-link>
    </p>
  </main>
</template>
