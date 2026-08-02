(() => {
  const meta = document.querySelector('meta[name="potube-ga-id"]');
  const measurementId = meta?.content?.trim();
  if (!measurementId || !/^G-[A-Z0-9]+$/i.test(measurementId)) return;

  const storageKey = 'potube_analytics_consent';
  let loaded = false;

  function loadAnalytics() {
    if (loaded || localStorage.getItem(storageKey) !== 'granted') return;
    loaded = true;

    window.dataLayer = window.dataLayer || [];
    window.gtag = function gtag() {
      window.dataLayer.push(arguments);
    };

    const script = document.createElement('script');
    script.async = true;
    script.src = `https://www.googletagmanager.com/gtag/js?id=${encodeURIComponent(measurementId)}`;
    document.head.appendChild(script);

    window.gtag('js', new Date());
    window.gtag('config', measurementId, {
      anonymize_ip: true,
      allow_google_signals: false,
      allow_ad_personalization_signals: false,
    });
  }

  window.addEventListener('potube-consent-changed', (event) => {
    if (event.detail === 'granted') loadAnalytics();
  });

  loadAnalytics();
})();
