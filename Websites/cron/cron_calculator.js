function updateCron() {
  const second = document.getElementById('second').value || '*';
  const minute = document.getElementById('minute').value || '*';
  const hour = document.getElementById('hour').value || '*';
  const dayOfMonth = document.getElementById('dayOfMonth').value || '*';
  const month = document.getElementById('month').value || '*';
  const dayOfWeek = document.getElementById('dayOfWeek').value || '*';

  // Generate the cron expression
  const cronExpression = `${second} ${minute} ${hour} ${dayOfMonth} ${month} ${dayOfWeek}`;
  document.getElementById('cronResult').value = cronExpression;

  // Convert to human-readable format
  const humanReadableText = cronToHumanReadable(second, minute, hour, dayOfMonth, month, dayOfWeek);
  document.getElementById('humanReadable').innerText = humanReadableText;
}

function cronToHumanReadable(second, minute, hour, dayOfMonth, month, dayOfWeek) {
  const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
  const daysOfWeek = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

  let readableString = `Every second `;

  if (minute !== '*') {
      readableString += `at ${minute} minute(s) `;
  }

  if (hour !== '*') {
      readableString += `at ${hour}:00 hour(s) `;
  }

  if (dayOfMonth !== '*') {
      readableString += `on day ${dayOfMonth} `;
  }

  if (month !== '*') {
      readableString += `in ${months[parseInt(month, 10) - 1]} `;
  }

  if (dayOfWeek !== '*') {
      readableString += `on ${daysOfWeek[parseInt(dayOfWeek, 10)]}`;
  }

  return readableString.trim();
}

function setCronExample(type) {
  switch (type) {
      case 'runOnce':
          document.getElementById('second').value = '0';
          document.getElementById('minute').value = '0';
          document.getElementById('hour').value = '0';
          document.getElementById('dayOfMonth').value = '1';
          document.getElementById('month').value = '1';
          document.getElementById('dayOfWeek').value = '*';
          break;
      case 'everyMorning':
          document.getElementById('second').value = '0';
          document.getElementById('minute').value = '0';
          document.getElementById('hour').value = '6';
          document.getElementById('dayOfMonth').value = '*';
          document.getElementById('month').value = '*';
          document.getElementById('dayOfWeek').value = '*';
          break;
      case 'onceAYear':
          document.getElementById('second').value = '0';
          document.getElementById('minute').value = '0';
          document.getElementById('hour').value = '0';
          document.getElementById('dayOfMonth').value = '1';
          document.getElementById('month').value = '1';
          document.getElementById('dayOfWeek').value = '*';
          break;
      case 'startup':
          document.getElementById('cronResult').value = '@reboot';  // Run on startup
          document.getElementById('humanReadable').innerText = "Run at system startup";
          clearInputFields();
          return;
      case 'yearly':
          document.getElementById('second').value = '0';
          document.getElementById('minute').value = '0';
          document.getElementById('hour').value = '0';
          document.getElementById('dayOfMonth').value = '1';
          document.getElementById('month').value = '1';
          document.getElementById('dayOfWeek').value = '*';
          break;
      case 'monthly':
          document.getElementById('second').value = '0';
          document.getElementById('minute').value = '0';
          document.getElementById('hour').value = '0';
          document.getElementById('dayOfMonth').value = '1';
          document.getElementById('month').value = '*';
          document.getElementById('dayOfWeek').value = '*';
          break;
      case 'weekly':
          document.getElementById('second').value = '0';
          document.getElementById('minute').value = '0';
          document.getElementById('hour').value = '0';
          document.getElementById('dayOfMonth').value = '*';
          document.getElementById('month').value = '*';
          document.getElementById('dayOfWeek').value = '0';
          break;
      case 'daily':
          document.getElementById('second').value = '0';
          document.getElementById('minute').value = '0';
          document.getElementById('hour').value = '0';
          document.getElementById('dayOfMonth').value = '*';
          document.getElementById('month').value = '*';
          document.getElementById('dayOfWeek').value = '*';
          break;
      case 'hourly':
          document.getElementById('second').value = '0';
          document.getElementById('minute').value = '0';
          document.getElementById('hour').value = '*';
          document.getElementById('dayOfMonth').value = '*';
          document.getElementById('month').value = '*';
          document.getElementById('dayOfWeek').value = '*';
          break;
  }
  updateCron();
}

function clearInputFields() {
  document.getElementById('second').value = '';
  document.getElementById('minute').value = '';
  document.getElementById('hour').value = '';
  document.getElementById('dayOfMonth').value = '';
  document.getElementById('month').value = '';
  document.getElementById('dayOfWeek').value = '';
}
