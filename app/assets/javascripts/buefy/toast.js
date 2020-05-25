import { ToastProgrammatic as Toast } from 'buefy';

const launchToast = (message, options) => {
  if (Array.isArray(message) && message.length > 0) {
    message.forEach((msg) => Toast.open({ message: msg, ...options }));
  } else {
    Toast.open({ message, ...options });
  }
};

export const successToast = (message) => {
  launchToast(message, { type: 'is-success', position: 'is-top', queue: false });
};

export const dangerToast = (message) => {
  launchToast(message, { type: 'is-danger', position: 'is-top', queue: false });
};
