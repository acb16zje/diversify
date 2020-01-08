import { ToastProgrammatic as Toast } from 'buefy';

export const successToast = (message) => {
  Toast.open({
    message,
    type: 'is-success',
    position: 'is-top',
    queue: false,
  });
};

export const dangerToast = (message) => {
  Toast.open({
    message,
    type: 'is-danger',
    position: 'is-top',
    queue: false,
  });
};
