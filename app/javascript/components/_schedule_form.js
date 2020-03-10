function toggleButtonDays() {
  const buttons = document.querySelectorAll('.btn-day')
  buttons.forEach((button) => {
    button.addEventListener("click", function() {
      buttons.forEach((btn) => {
        btn.classList.remove('active')
      })
      button.classList.toggle('active')
    });
  });
}
export { toggleButtonDays }
