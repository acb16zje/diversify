/**
 * Function to show modal
 *
 * @params: url for object id
 */
function showModal(url) {
    $.ajax({
        url: url,
        type: 'get',
        contentType: 'application/json',
        success: function (result) {
            const modal = document.querySelector('.modal');  // assuming you have only 1
            const html = document.querySelector('html');

            modal.classList.add('is-active');
            html.classList.add('is-clipped');

            modal.querySelector('.modal-background')
                .addEventListener('click', function (e) {
                    e.preventDefault();
                    closeModal();
                });

            modal.querySelector('.delete')
                .addEventListener('click', function (e) {
                    e.preventDefault();
                    closeModal();
                });

            const title = document.querySelector('.modal-card-title');
            const content = document.querySelector('.modal-card-body');
            title.innerHTML = result.title;
            content.innerHTML = result.content;
        }
    });
}

/**
 * Function to close modal
 */
function closeModal() {
    document.querySelector('.modal').classList.remove('is-active');
    document.querySelector('html').classList.remove('is-clipped');
}

/**
 * Listener to close notfication
 */
$(document).on('click', '.notification > button.delete', function () {
    $(this).parent().addClass('is-hidden');
    return false;
});