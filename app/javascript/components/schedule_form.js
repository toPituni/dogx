const toggleButtonDays = () => {
  const buttons = document.querySelectorAll('.btn-day');
  const checkboxes = document.querySelectorAll('.form-check-input');
  if (checkboxes) {
    checkboxes.forEach((checkbox) => {
      if (checkbox.checked) {
        const label = checkbox.nextElementSibling;
        label.classList.add('active');
      }
    });
    buttons.forEach((button) => {
      button.addEventListener("click", function() {
        button.classList.toggle('active');
      });
    });
  }
}
export { toggleButtonDays };
