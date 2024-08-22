const days = document.querySelectorAll('.day');
days.forEach(day => {
  day.addEventListener('click', function() {
    days.forEach(d => d.classList.remove('highlighted'));
    this.classList.add('highlighted');
  });
});
