(() => {
  const gaMeta = document.querySelector('meta[name="potube-ga-id"]');
  if (!gaMeta || !gaMeta.content.trim()) return;

  const storageKey = 'potube_analytics_consent';
  if (localStorage.getItem(storageKey)) return;

  const banner = document.createElement('div');
  banner.className = 'consent-banner';
  banner.setAttribute('role', 'dialog');
  banner.setAttribute('aria-label', 'Preferenze privacy');
  banner.innerHTML = `
    <div class="consent-copy">
      <strong>Privacy e statistiche</strong>
      <span>Usiamo Analytics solo con il tuo consenso per capire se Potube Web è utile. I file caricati non vengono inviati ad Analytics.</span>
    </div>
    <div class="consent-actions">
      <button type="button" class="consent-secondary" data-consent="denied">Solo necessari</button>
      <button type="button" class="consent-primary" data-consent="granted">Accetta Analytics</button>
    </div>
  `;

  banner.addEventListener('click', (event) => {
    const button = event.target.closest('[data-consent]');
    if (!button) return;
    const value = button.getAttribute('data-consent');
    localStorage.setItem(storageKey, value);
    window.dispatchEvent(new CustomEvent('potube-consent-changed', {detail: value}));
    banner.remove();
  });

  document.body.appendChild(banner);
})();
