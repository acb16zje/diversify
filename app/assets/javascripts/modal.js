/**
 * Function to close modal
 */
function closeModal() {
  document.querySelector('.modal').classList.remove('is-active');
}

/**
 * Function to show modal
 *
 * @params: url for object id
 */
function showModal(url) {
  $.ajax({
    url,
    type: 'get',
    contentType: 'application/json',
    success(result) {
      const modal = document.querySelector('.modal'); // assuming you have only 1
      const html = document.querySelector('html');

      modal.classList.add('is-active');

      modal.querySelector('.modal-background')
        .addEventListener('click', (e) => {
          e.preventDefault();
          closeModal();
        });

      modal.querySelector('.delete').addEventListener('click', (e) => {
        e.preventDefault();
        closeModal();
      });

      const title = document.querySelector('.modal-card-title');
      const content = document.querySelector('.modal-card-body');
      title.textContent = result.title;
      content.innerHTML = DOMPurify.sanitize(result.content);
    },
  });
}
