<script setup>
import { ref, computed, onBeforeMount } from 'vue';
import { useStore } from 'vuex';
import SignupForm from './components/Signup/Form.vue';
import Testimonials from './components/Testimonials/Index.vue';
import Spinner from 'shared/components/Spinner.vue';
const store = useStore();

const isLoading = ref(false);
const globalConfig = computed(() => store.getters['globalConfig/get']);
const isAChatwootInstance = computed(
  () => globalConfig.value.installationName === 'Chatwoot'
);

onBeforeMount(() => {
  isLoading.value = isAChatwootInstance.value;
});

const resizeContainers = () => {
  isLoading.value = false;
};
</script>

<template>
  <div
    class="relative w-full h-full min-h-screen flex items-center justify-center bg-transparent p-4 sm:px-6 lg:px-8"
  >
    <img
      :src="'/brand-assets/digilink-topright-logo.png'"
      alt="Digilink"
      class="absolute top-3 left-4 h-11 w-auto object-contain z-10"
    />
    <div
      v-show="!isLoading"
      class="relative flex max-w-[960px] digilink-auth-glass-signup-panel rounded-lg"
      :class="{ 'w-auto xl:w-full': isAChatwootInstance }"
    >
      <div class="flex-1 flex items-center justify-center py-10 px-10">
        <div class="max-w-[420px] w-full">
          <div class="mb-6">
            <img
              :src="globalConfig.logo"
              :alt="globalConfig.installationName"
              class="block w-auto h-7 dark:hidden"
            />
            <img
              v-if="globalConfig.logoDark"
              :src="globalConfig.logoDark"
              :alt="globalConfig.installationName"
              class="hidden w-auto h-7 dark:block"
            />
            <h2 class="digilink-glass-card-title mt-6 !text-2xl">
              {{
                isAChatwootInstance
                  ? $t('REGISTER.GET_STARTED')
                  : $t('REGISTER.TRY_WOOT')
              }}
            </h2>
            <p class="digilink-glass-card-subtitle mt-2 !text-sm">
              {{ $t('REGISTER.HAVE_AN_ACCOUNT') }}{{ ' '
              }}<router-link
                class="font-semibold text-white underline decoration-white/45 underline-offset-2 hover:text-white hover:decoration-white"
                to="/app/login"
              >
                {{ $t('LOGIN.SUBMIT') }}
              </router-link>
            </p>
          </div>
          <SignupForm />
        </div>
      </div>
      <Testimonials
        v-if="isAChatwootInstance"
        class="flex-1 hidden xl:flex"
        @resize-containers="resizeContainers"
      />
    </div>
    <div
      v-show="isLoading"
      class="relative flex items-center justify-center w-full h-full"
    >
      <Spinner color-scheme="primary" size="" />
    </div>
  </div>
</template>
