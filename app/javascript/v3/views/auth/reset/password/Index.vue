<script>
import { useVuelidate } from '@vuelidate/core';
import { useAlert } from 'dashboard/composables';
import { required, minLength, email } from '@vuelidate/validators';
import { useBranding } from 'shared/composables/useBranding';
import FormInput from '../../../../components/Form/Input.vue';
import { resetPassword } from '../../../../api/auth';
import NextButton from 'dashboard/components-next/button/Button.vue';

export default {
  components: { FormInput, NextButton },
  setup() {
    const { replaceInstallationName } = useBranding();
    return { v$: useVuelidate(), replaceInstallationName };
  },
  data() {
    return {
      credentials: { email: '' },
      resetPassword: {
        message: '',
        showLoading: false,
      },
      error: '',
    };
  },
  validations() {
    return {
      credentials: {
        email: {
          required,
          email,
          minLength: minLength(4),
        },
      },
    };
  },
  methods: {
    showAlertMessage(message) {
      // Reset loading, current selected agent
      this.resetPassword.showLoading = false;
      useAlert(message);
    },
    submit() {
      this.resetPassword.showLoading = true;
      resetPassword(this.credentials)
        .then(res => {
          let successMessage = this.$t('RESET_PASSWORD.API.SUCCESS_MESSAGE');
          if (res.data && res.data.message) {
            successMessage = res.data.message;
          }
          this.showAlertMessage(successMessage);
        })
        .catch(error => {
          let errorMessage = this.$t('RESET_PASSWORD.API.ERROR_MESSAGE');
          if (error?.response?.data?.message) {
            errorMessage = error.response.data.message;
          }
          this.showAlertMessage(errorMessage);
        });
    },
  },
};
</script>

<template>
  <div
    class="relative flex flex-col justify-center w-full min-h-screen py-10 bg-transparent sm:px-6 lg:px-8"
  >
    <img
      :src="'/brand-assets/digilink-topright-logo.png'"
      alt="Digilink"
      class="absolute top-3 left-4 h-11 w-auto object-contain"
    />
    <form
      class="digilink-auth-glass-panel mx-auto w-full"
      @submit.prevent="submit"
    >
      <h1 class="digilink-glass-card-title mb-1 !text-2xl">
        {{ $t('RESET_PASSWORD.TITLE') }}
      </h1>
      <p class="digilink-glass-card-subtitle mb-6 !text-sm">
        {{ replaceInstallationName($t('RESET_PASSWORD.DESCRIPTION')) }}
      </p>
      <div class="space-y-5">
        <FormInput
          v-model="credentials.email"
          name="email_address"
          appearance="glass"
          :label="$t('LOGIN.EMAIL.LABEL')"
          :has-error="v$.credentials.email.$error"
          :error-message="$t('RESET_PASSWORD.EMAIL.ERROR')"
          :placeholder="$t('RESET_PASSWORD.EMAIL.PLACEHOLDER')"
          @input="v$.credentials.email.$touch"
        />
        <NextButton
          lg
          type="submit"
          data-testid="submit_button"
          class="digilink-auth-primary-btn w-full !outline-none"
          :label="$t('RESET_PASSWORD.SUBMIT')"
          :disabled="v$.credentials.email.$invalid || resetPassword.showLoading"
          :is-loading="resetPassword.showLoading"
        />
      </div>
      <p class="digilink-auth-footer-muted mt-6 text-sm">
        {{ $t('RESET_PASSWORD.GO_BACK_TO_LOGIN') }}
        <router-link :to="{ name: 'login' }" class="text-link text-n-brand">
          {{ $t('COMMON.CLICK_HERE') }}.
        </router-link>
      </p>
    </form>
  </div>
</template>
