<script setup>
import { computed } from 'vue';
import { useToggle } from '@vueuse/core';

import Button from 'dashboard/components-next/button/Button.vue';
import Icon from 'dashboard/components-next/icon/Icon.vue';
import WithLabel from './WithLabel.vue';

const props = defineProps({
  label: {
    type: String,
    required: true,
  },
  type: {
    type: String,
    default: 'text',
  },
  icon: {
    type: String,
    default: '',
  },
  name: {
    type: String,
    required: true,
  },
  hasError: Boolean,
  errorMessage: {
    type: String,
    default: '',
  },
  spacing: {
    type: String,
    default: 'base',
    validator: value => ['base', 'compact'].includes(value),
  },
  appearance: {
    type: String,
    default: 'default',
    validator: value => ['default', 'glass'].includes(value),
  },
  hideFieldLabel: {
    type: Boolean,
    default: false,
  },
  trailingDecor: {
    type: String,
    default: '',
    validator: value => ['', 'user'].includes(value),
  },
});

const FIELDS = {
  TEXT: 'text',
  PASSWORD: 'password',
};

defineOptions({
  inheritAttrs: false,
});

const model = defineModel({
  type: [String, Number],
  required: true,
});

const [isPasswordVisible, togglePasswordVisibility] = useToggle();

const isPasswordField = computed(() => props.type === FIELDS.PASSWORD);
const isGlass = computed(() => props.appearance === 'glass');

const currentInputType = computed(() => {
  if (isPasswordField.value) {
    return isPasswordVisible.value ? FIELDS.TEXT : FIELDS.PASSWORD;
  }
  return props.type;
});

const defaultInputClass = computed(() => {
  const base =
    'block w-full border-none rounded-md shadow-sm bg-n-alpha-black2 appearance-none outline outline-1 focus:outline focus:outline-1 text-n-slate-12 placeholder:text-n-slate-10 sm:text-sm sm:leading-6';
  const err = props.hasError
    ? 'error outline-n-ruby-8 dark:outline-n-ruby-8 hover:outline-n-ruby-9 dark:hover:outline-n-ruby-9 disabled:outline-n-ruby-8 dark:disabled:outline-n-ruby-8'
    : 'outline-n-weak dark:outline-n-weak hover:outline-n-slate-6 dark:hover:outline-n-slate-6 focus:outline-n-brand dark:focus:outline-n-brand';
  const pad =
    props.spacing === 'base' ? 'px-3 py-3' : 'px-3 py-2 mb-0';
  const iconPad = props.icon ? 'pl-9' : '';
  const pwPad = isPasswordField.value ? 'pr-10' : '';
  return [base, err, pad, iconPad, pwPad].filter(Boolean).join(' ');
});

const glassInputClass = computed(() => {
  const err = props.hasError
    ? '!outline-red-300/90 !ring-2 !ring-red-400/70 border-red-200/80'
    : '';
  const padRight = isPasswordField.value
    ? 'pr-12'
    : props.trailingDecor === 'user'
      ? 'pr-12'
      : 'pr-5';
  return [
    'digilink-glass-input block w-full appearance-none rounded-none border-0 border-b border-white/45',
    'bg-transparent text-white shadow-none',
    'placeholder:text-white/50',
    'focus:border-white/90 focus:outline-none',
    'disabled:opacity-60',
    props.spacing === 'compact' ? 'px-4 py-2.5 text-sm' : 'px-5 py-3.5 text-sm',
    padRight,
    err,
  ].join(' ');
});

const inputFieldClass = computed(() =>
  isGlass.value ? glassInputClass.value : defaultInputClass.value
);

const passwordToggleClass = computed(() =>
  isGlass.value
    ? 'absolute inset-y-0 right-0 pr-3 text-white/85 hover:!text-white [&_svg]:text-current'
    : 'absolute inset-y-0 right-0 pr-3'
);
</script>

<template>
  <WithLabel
    :label="label"
    :icon="icon"
    :name="name"
    :has-error="hasError"
    :error-message="errorMessage"
    :label-hidden="hideFieldLabel"
  >
    <template #rightOfLabel>
      <slot />
    </template>
    <div class="relative flex w-full items-center">
      <input
        v-bind="$attrs"
        v-model="model"
        :name="name"
        :type="currentInputType"
        :class="inputFieldClass"
      />
      <Icon
        v-if="isGlass && trailingDecor === 'user' && !isPasswordField"
        icon="i-lucide-user"
        class="pointer-events-none absolute right-3.5 top-1/2 size-5 -translate-y-1/2 text-white/65"
        aria-hidden="true"
      />
      <Button
        v-if="isPasswordField"
        type="button"
        slate
        sm
        link
        :icon="isPasswordVisible ? 'i-lucide-eye-off' : 'i-lucide-eye'"
        :class="passwordToggleClass"
        :aria-label="isPasswordVisible ? 'Hide password' : 'Show password'"
        :aria-pressed="isPasswordVisible"
        @click="togglePasswordVisibility()"
      />
    </div>
  </WithLabel>
</template>
